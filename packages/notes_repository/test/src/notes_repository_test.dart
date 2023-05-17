// ignore_for_file: prefer_const_constructors
import 'package:notes_repository/notes_repository.dart';
import 'package:test/test.dart';

void main() {
  group('NotesRepository', () {
    test('can be instantiated', () {
      expect(NotesRepository(), isNotNull);
    });
  });
}
