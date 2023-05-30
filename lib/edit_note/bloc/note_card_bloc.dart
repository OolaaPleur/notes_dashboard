import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:notes_repository/notes_repository.dart';

part 'note_card_event.dart';

part 'note_card_state.dart';

class NoteCardBloc extends Bloc<NoteCardEvent, NoteCardState> {
  NoteCardBloc({
    required NotesRepository notesRepository,
    required Note initialNote,
  })  : _notesRepository = notesRepository,
        super(NoteCardState(
          initialNote: initialNote,
          title: initialNote.title ?? '', // TODO DELETE IF NOT NECESSARY
          description: initialNote.description ?? '',
          savedColor: Color(initialNote.savedColor) ??
              Colors.white, // TODO DELETE IF NOT NECESSARY
        )) {
    on<NoteCardSubmitted>(_onSubmitted);
    on<NoteCardColorPickerOpened>(_onColorPickerStatusChanged);
    on<NoteCardColorPicked>(_onNoteCardColorPicked);
  }

  final NotesRepository _notesRepository;

  void _onNoteCardColorPicked(
      NoteCardColorPicked event, Emitter<NoteCardState> emitter) {
    emit(
      state.copyWith(savedColor: event.savedColor),
    );
  }

  void _onColorPickerStatusChanged(
      NoteCardColorPickerOpened event, Emitter<NoteCardState> emitter) {
    emit(
      state.copyWith(
          noteCardColorPickerOpened: !state.noteCardColorPickerOpened),
    );
  }

  Future<void> _onSubmitted(
      NoteCardSubmitted event, Emitter<NoteCardState> emitter) async {
    emit(
      state.copyWith(
        status: NoteCardStatus.loading,
        title: event.title,
        description: event.description,
        savedColor: event.savedColor,
      ),
    );
    final note = state.initialNote!.copyWith(
      title: state.title,
      description: state.description,
      savedColor: state.savedColor.value,
    );
    try {
      await _notesRepository.saveNote(note);
      emit(state.copyWith(status: NoteCardStatus.showGreenCheck));
      await Future.delayed(Duration(seconds: 2));
      emit(state.copyWith(status: NoteCardStatus.success));
    } catch (e) {
      emit(state.copyWith(status: NoteCardStatus.failure));
    }
  }
}
