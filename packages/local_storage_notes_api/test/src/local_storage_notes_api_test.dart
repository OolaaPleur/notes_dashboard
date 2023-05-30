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
      Note(id: '1', title: 'title 1', description: 'description 1', savedColor: 0xFF00FF00),
      Note(id: '2', title: 'title 2', description: 'description 2', savedColor: 0xFFFFFF00),
      Note(title: 'title 3'),
    ];

    setUp(() {
      plugin = MockSharedPreferences();
      when(() => plugin.getString(any())).thenReturn(json.encode(notes));
      when(() => plugin.setString(any(), any())).thenAnswer((_) async => true);
    });

    LocalStorageNotesApi createSubject() {
      return LocalStorageNotesApi(plugin: plugin);
    }
  });
}
