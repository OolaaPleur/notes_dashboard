import 'dart:convert';

import 'package:meta/meta.dart';
import 'package:notes_api/notes_api.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// {@template local_storage_notes_api}
/// A Flutter implementation of the NotesApi that uses local storage.
/// {@endtemplate}
class LocalStorageNotesApi extends NotesApi {
  /// {@macro local_storage_notes_api}
  LocalStorageNotesApi({required SharedPreferences plugin}) : _plugin = plugin {
    _init();
  }

  final SharedPreferences _plugin;

  final _noteStreamController = BehaviorSubject<List<Note>>.seeded(const []);

  /// Key used for storing the notes locally.
  ///
  /// This is only exposed for testing and shouldn't be used by consumers of
  /// this library.
  @visibleForTesting
  static const kNotesCollectionKey = '__notes_collection_key__';

  String? _getValue(String key) => _plugin.getString(key);

  Future<void> _setValue(String key, String value) =>
      _plugin.setString(key, value);

  void _init() {
    final notesJson = _getValue(kNotesCollectionKey);
    if (notesJson != null) {
      final notes = List<Map<dynamic, dynamic>>.from(
        json.decode(notesJson) as List,
      )
          .map(
            (jsonMap) => Note.fromJson(
              Map<String, dynamic>.from(jsonMap),
            ),
          )
          .toList();
      _noteStreamController.add(notes);
    }
    else {
      _noteStreamController.add(const []);
    }
  }

  @override
  Future<void> deleteNote(String id) async {
    final notes = [..._noteStreamController.value];
    final noteIndex = notes.indexWhere((element) => element.id == id);
    if (noteIndex == -1) {
      throw NoteNotFoundException();
    } else {
      notes.removeAt(noteIndex);
      _noteStreamController.add(notes);
      return _setValue(kNotesCollectionKey, json.encode(notes));
    }
  }

  @override
  Stream<List<Note>> getNotes() {
    return _noteStreamController.asBroadcastStream();
  }

  @override
  Future<void> saveNote(Note note) {
    final notes = [..._noteStreamController.value];
    final noteIndex = notes.indexWhere((element) => element.id == note.id);
    if (noteIndex >= 0) {
      notes[noteIndex] = note;
    } else {
      notes.add(note);
    }
    _noteStreamController.add(notes);
    return _setValue(kNotesCollectionKey, json.encode(notes));
  }
}
