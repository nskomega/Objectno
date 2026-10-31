import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast_io.dart';

Future<Database> openJournalDatabase() async {
  final dir = await getApplicationSupportDirectory();
  await dir.create(recursive: true);
  return databaseFactoryIo.openDatabase('${dir.path}/objectno.db');
}
