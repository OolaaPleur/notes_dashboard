// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:local_storage_notes_api/local_storage_notes_api.dart';
import 'package:mocktail/mocktail.dart';
import 'package:notes_api/notes_api.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  group('LocalStorageNotesApi', () {
    late SharedPreferences plugin;

    final notes = [
      Note(
          id: '1',
          title: 'title 1',
          description: 'description 1',
          savedColor: 0xFF00FF00),
      Note(
          id: '2',
          title: 'title 2',
          description: 'description 2',
          savedColor: 0xFFFFFF00),
      Note(title: 'title 3'),
    ];

    setUp(() {
      plugin = MockSharedPreferences();
      when(() => plugin.getString(any())).thenReturn(json.encode(notes));
      when(() => plugin.setString(any(), any())).thenAnswer((_) async => true);
    });

    LocalStorageNotesApi createSubject() {
      return LocalStorageNotesApi(
        plugin: plugin,
      );
    }

    group('constructor', () {
      test('works properly', () {
        expect(
          createSubject,
          returnsNormally,
        );
      });

      group('initializes the notes stream', () {
        test('with existing notes if present', () {
          final subject = createSubject();

          expect(subject.getNotes(), emits(notes));
          verify(
            () => plugin.getString(
              LocalStorageNotesApi.kNotesCollectionKey,
            ),
          ).called(1);
        });
        test('with empty list if no notes present', () {
          when(() => plugin.getString(any())).thenReturn(null);

          final subject = createSubject();

          expect(subject.getNotes(), emits(const <Note>[]));
          verify(
            () => plugin.getString(
              LocalStorageNotesApi.kNotesCollectionKey,
            ),
          ).called(1);
        });
      });
    });
    test('getNotes returns stream of current list notes', () {
      expect(createSubject().getNotes(), emits(notes));
    });
    group(
      'saveNote',
      () {
        test('saves new notes', () {
          final newNote = Note(
            id: '4',
            title: 'title 4',
            description: 'description 4',
          );
          final newNotes = [...notes, newNote];

          final subject = createSubject();

          expect(subject.saveNote(newNote), completes);
          expect(subject.getNotes(), emits(newNotes));

          verify(
            () => plugin.setString(
              LocalStorageNotesApi.kNotesCollectionKey,
              json.encode(newNotes),
            ),
          ).called(1);
        });
        test('updates existing notes', () {
          final updatedNote = Note(
              id: '1',
              title: 'new title 1',
              description: 'new description 1',
              savedColor: 0xFFFFFF00);
          final newNotes = [updatedNote, ...notes.sublist(1)];

          final subject = createSubject();

          expect(subject.saveNote(updatedNote), completes);
          expect(subject.getNotes(), emits(newNotes));

          verify(
            () => plugin.setString(
              LocalStorageNotesApi.kNotesCollectionKey,
              json.encode(newNotes),
            ),
          ).called(1);
        });
      },
    );
    group('deleteNote', () {
      test('deletes existing notes', () {
        final newNotes = notes.sublist(1);

        final subject = createSubject();

        expect(subject.deleteNote(notes[0].id), completes);
        expect(subject.getNotes(), emits(newNotes));

        verify(
          () => plugin.setString(
            LocalStorageNotesApi.kNotesCollectionKey,
            json.encode(newNotes),
          ),
        ).called(1);
      });
      test(
        'throws NoteNotFoundException if note with provided id is not found',
        () {
          final subject = createSubject();

          expect(
            () => subject.deleteNote('not-existing-id'),
            throwsA(isA<NoteNotFoundException>()),
          );
        },
      );
    });
  });
}
