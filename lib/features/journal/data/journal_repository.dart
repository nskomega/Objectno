import '../../renovation/domain/rectangular_room.dart';
import '../../renovation/data/analysis_result.dart' show AnalysisResult;
import 'dart:convert';
import '../../renovation/domain/quantity_calculator.dart';
import 'package:sembast/sembast.dart';

class JournalRepository {
  JournalRepository(this.database, {String? accountId})
    : _profileKey = accountId == null
          ? 'guest-profile'
          : 'account-$accountId-profile',
      objects = intMapStoreFactory.store(
        accountId == null ? 'objects' : 'account-$accountId-objects',
      ),
      history = intMapStoreFactory.store(
        accountId == null ? 'history' : 'account-$accountId-history',
      ),
      rooms = intMapStoreFactory.store(
        accountId == null ? 'rooms' : 'account-$accountId-rooms',
      ),
      issues = intMapStoreFactory.store(
        accountId == null ? 'issues' : 'account-$accountId-issues',
      );

  JournalRepository inAccount(String? accountId) =>
      JournalRepository(database, accountId: accountId);
  Future<void> clearAccount(String accountId) async {
    final scope = inAccount(accountId);
    await database.transaction((txn) async {
      await settings.record(scope._profileKey).delete(txn);
      await scope.history.delete(txn);
      await scope.rooms.delete(txn);
      await scope.issues.delete(txn);
      await scope.objects.delete(txn);
    });
  }

  final String _profileKey;
  Future<String?> readProfileName() async =>
      (await settings.record(_profileKey).get(database))?['name'] as String?;
  Future<void> saveProfileName(String name) async {
    if (name.trim().isEmpty || name.runes.length > 120) {
      throw ArgumentError('Invalid profile name');
    }
    await settings.record(_profileKey).put(database, {'name': name.trim()});
  }

  final StoreRef<int, Map<String, Object?>> history;
  final Database database;
  final StoreRef<int, Map<String, Object?>> rooms;
  final StoreRef<int, Map<String, Object?>> objects;
  final StoreRef<int, Map<String, Object?>> issues;
  final settings = stringMapStoreFactory.store('settings');

  Stream<List<RecordSnapshot<int, Map<String, Object?>>>> watchObjects() =>
      objects
          .query(finder: Finder(sortOrders: [SortOrder('createdAt', false)]))
          .onSnapshots(database);

  Stream<List<RecordSnapshot<int, Map<String, Object?>>>> watchIssues(
    int objectId,
  ) => issues
      .query(
        finder: Finder(
          filter: Filter.equals('objectId', objectId),
          sortOrders: [SortOrder('createdAt', false)],
        ),
      )
      .onSnapshots(database);

  Stream<List<RecordSnapshot<int, Map<String, Object?>>>> watchRooms(
    int objectId,
  ) => rooms
      .query(
        finder: Finder(
          filter: Filter.equals('objectId', objectId),
          sortOrders: [SortOrder('createdAt', false)],
        ),
      )
      .onSnapshots(database);

  Future<int> addRoom(
    int objectId, {
    required String name,
    required RoomKind kind,
    required int lengthMm,
    required int widthMm,
    required int heightMm,
    required String wish,
  }) async {
    if (name.trim().isEmpty) {
      throw ArgumentError('Missing room description');
    }
    for (final size in [lengthMm, widthMm, heightMm]) {
      if (size <= 0 || size > 1000000) {
        throw ArgumentError('Invalid room dimensions');
      }
    }
    return database.transaction((txn) async {
      if (!await objects.record(objectId).exists(txn)) {
        throw StateError('Object not found');
      }
      return rooms.add(txn, {
        'objectId': objectId,
        'name': name.trim(),
        'kind': kind.name,
        'lengthMm': lengthMm,
        'widthMm': widthMm,
        'heightMm': heightMm,
        'wish': wish.trim(),
        'geometry': 'rectangular',
        'schemaVersion': 1,
        'createdAt': DateTime.now().toUtc().toIso8601String(),
      });
    });
  }

  Future<void> addRoomOpening(int objectId, int roomId, RoomOpening opening) =>
      database.transaction((txn) async {
        final room = await rooms.record(roomId).get(txn);
        if (room == null ||
            room['objectId'] != objectId ||
            !await objects.record(objectId).exists(txn)) {
          throw StateError('Room not found');
        }
        final openings = [
          ...(room['openings'] as List? ?? []),
          opening.toJson(),
        ];
        final updated = {...room, 'openings': openings, 'schemaVersion': 2};
        roomFromRecord(
          updated,
        ); // Reject intersections and out-of-bounds openings before writing.
        await rooms.record(roomId).put(txn, updated);
      });

  Future<void> removeRoomOpening(int objectId, int roomId, int index) =>
      database.transaction((txn) async {
        final room = await rooms.record(roomId).get(txn);
        if (room == null ||
            room['objectId'] != objectId ||
            !await objects.record(objectId).exists(txn)) {
          throw StateError('Room not found');
        }
        final openings = [...(room['openings'] as List? ?? [])];
        if (index < 0 || index >= openings.length) {
          throw ArgumentError('Opening not found');
        }
        openings.removeAt(index);
        await rooms.record(roomId).put(txn, {
          ...room,
          'openings': openings,
          'schemaVersion': 2,
        });
      });

  Stream<List<RecordSnapshot<int, Map<String, Object?>>>> watchHistory(
    int objectId,
  ) => history
      .query(
        finder: Finder(
          filter: Filter.equals('objectId', objectId),
          sortOrders: [SortOrder('createdAt')],
        ),
      )
      .onSnapshots(database);

  Future<int> addProposal(int objectId, int sourceId, AnalysisResult result) {
    if (!result.matches) throw ArgumentError('Not an interior');
    return database.transaction((txn) async {
      final source = await history.record(sourceId).get(txn);
      if (!await objects.record(objectId).exists(txn) ||
          source == null ||
          source['objectId'] != objectId ||
          source['phase'] != 'before' ||
          source['photo'] == null) {
        throw StateError('Source no longer exists');
      }
      return history.add(txn, {
        'objectId': objectId,
        'sourceHistoryId': sourceId,
        'phase': 'proposal',
        'origin': 'local_model',
        'description': result.concept,
        'analysis': result.json,
        'createdAt': DateTime.now().toUtc().toIso8601String(),
      });
    });
  }

  Map<String, Object?> _historyValue(
    int objectId,
    String description,
    String phase,
    String? photo,
  ) {
    if (description.trim().isEmpty ||
        !['before', 'progress', 'result'].contains(phase)) {
      throw ArgumentError('Invalid history entry');
    }
    if (phase == 'before' && (photo == null || photo.isEmpty)) {
      throw ArgumentError('Initial photo required');
    }
    if (photo != null && base64Decode(photo).length > 8 * 1024 * 1024) {
      throw ArgumentError('Photo too large');
    }
    return {
      'objectId': objectId,
      'description': description.trim(),
      'phase': phase,
      'photo': photo,
      'origin': 'user',
      'createdAt': DateTime.now().toUtc().toIso8601String(),
    };
  }

  Future<int> createRenovation(String name, String wish, String photo) async {
    if (name.trim().isEmpty) throw ArgumentError('Empty name');
    final value = _historyValue(0, wish, 'before', photo);
    return database.transaction((txn) async {
      final id = await objects.add(txn, {
        'name': name.trim(),
        'createdAt': value['createdAt'],
      });
      await history.add(txn, {...value, 'objectId': id});
      return id;
    });
  }

  Future<int> addHistory(
    int objectId,
    String description, {
    required String phase,
    String? photo,
  }) async {
    final value = _historyValue(objectId, description, phase, photo);
    return database.transaction((txn) async {
      if (!await objects.record(objectId).exists(txn)) {
        throw StateError('Object not found');
      }
      return history.add(txn, value);
    });
  }

  Future<int> addObject(String name) {
    if (name.trim().isEmpty) throw ArgumentError('Empty object name');
    return objects.add(database, {
      'name': name.trim(),
      'createdAt': DateTime.now().toUtc().toIso8601String(),
    });
  }

  Future<int> addIssue(
    int objectId,
    String description, {
    String? photo,
  }) async {
    if (description.trim().isEmpty) throw ArgumentError('Empty description');
    return database.transaction((txn) async {
      if (!await objects.record(objectId).exists(txn)) {
        throw StateError('Object not found');
      }
      return issues.add(txn, {
        'objectId': objectId,
        'description': description.trim(),
        'done': false,
        'photo': photo,
        'createdAt': DateTime.now().toUtc().toIso8601String(),
      });
    });
  }

  Future<void> setDone(int id, bool done) async {
    await database.transaction((txn) async {
      if (!await issues.record(id).exists(txn)) {
        throw StateError('Issue not found');
      }
      await issues.record(id).update(txn, {'done': done});
    });
  }

  Future<void> deleteIssue(int id) async {
    await issues.record(id).delete(database);
  }

  Future<void> deleteObject(int id) => database.transaction((txn) async {
    await history.delete(
      txn,
      finder: Finder(filter: Filter.equals('objectId', id)),
    );
    await rooms.delete(
      txn,
      finder: Finder(filter: Filter.equals('objectId', id)),
    );
    await issues.delete(
      txn,
      finder: Finder(filter: Filter.equals('objectId', id)),
    );
    await objects.record(id).delete(txn);
  });
  Future<String> readTheme() async =>
      (await settings.record('appearance').get(database))?['mode'] as String? ??
      'system';
  Future<void> saveTheme(String mode) async {
    await settings.record('appearance').put(database, {'mode': mode});
  }

  Future<String> readLanguage() async =>
      (await settings.record('language').get(database))?['code'] as String? ??
      'system';
  Future<void> saveLanguage(String code) async {
    await settings.record('language').put(database, {'code': code});
  }
}
