import 'models/note.dart';

/// The interface and models for an API providing access to notes.
abstract class NotesApi {
  /// NotesApi.
  const NotesApi();

  /// Provides a [Stream] of all 'notes'.
  Stream<List<Note>> getNotes();

  /// Saves a [note];
  ///
  /// If [note] with the same id already exists, it will be replaced.
  Future<void> saveNote(Note note);

  /// Deletes a 'note' with the given [id].
  ///
  /// If no 'note' with the given [id] exists, a [NoteNotFoundException] error
  /// is thrown.
  Future<void> deleteNote(String id);
}

/// Error thrown when a [Note] with a given id is not found.
class NoteNotFoundException implements Exception {}
