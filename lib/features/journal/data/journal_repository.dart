import 'package:sembast/sembast.dart';

class JournalRepository {
  JournalRepository(this.database, {String? accountId})
    : objects = intMapStoreFactory.store(
        accountId == null ? 'objects' : 'account-$accountId-objects',
      ),
      issues = intMapStoreFactory.store(
        accountId == null ? 'issues' : 'account-$accountId-issues',
      );

  JournalRepository inAccount(String? accountId) =>
      JournalRepository(database, accountId: accountId);
  Future<void> clearAccount(String accountId) async {
    final scope = inAccount(accountId);
    await database.transaction((txn) async {
      await scope.issues.delete(txn);
      await scope.objects.delete(txn);
    });
  }

  final Database database;
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
