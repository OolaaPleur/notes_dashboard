import 'package:flutter/widgets.dart';
import 'package:local_storage_notes_api/local_storage_notes_api.dart';
import 'package:notes_dashboard/bootstrap.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final notesApi = LocalStorageNotesApi(
    plugin: await SharedPreferences.getInstance(),
  );

  bootstrap(notesApi: notesApi);
}
