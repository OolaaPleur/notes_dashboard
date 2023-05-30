import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:notes_repository/notes_repository.dart';

part 'notes_overview_event.dart';

part 'notes_overview_state.dart';

class NotesOverviewBloc extends Bloc<NotesOverviewEvent, NotesOverviewState> {
  NotesOverviewBloc({required NotesRepository notesRepository})
      : _notesRepository = notesRepository,
        super(const NotesOverviewState()) {
    on<NotesOverviewSubscriptionRequested>(_onSubscriptionRequested);
    on<NotesOverviewNoteDeleted>(_onNoteDeleted);
    on<NotesOverviewUndoDeletionRequested>(_onUndoDeletionRequested);
  }

  final NotesRepository _notesRepository;

  Future<void> _onSubscriptionRequested(
    NotesOverviewSubscriptionRequested event,
    Emitter<NotesOverviewState> emit,
  ) async {
    emit(state.copyWith(status: () => NotesOverviewStatus.loading));
    await emit.forEach<List<Note>>(
      _notesRepository.getNotes(),
      onData: (notes) => state.copyWith(
        status: () => NotesOverviewStatus.success,
        notes: () => notes,
      ),
      onError: (_, __) =>
          state.copyWith(status: () => NotesOverviewStatus.failure),
    );
  }

  Future<void> _onNoteDeleted(
      NotesOverviewNoteDeleted event, Emitter<NotesOverviewState> emit) async {
    emit(state.copyWith(lastDeletedNote: () => event.note));
    await _notesRepository.deleteNote(event.note.id);
  }

  Future<void> _onUndoDeletionRequested(
      NotesOverviewUndoDeletionRequested event,
      Emitter<NotesOverviewState> emit) async {
    assert(state.lastDeletedNote != null, 'Last deleted note can not be null.');

    final note = state.lastDeletedNote!;
    emit(state.copyWith(lastDeletedNote: () => null));
    await _notesRepository.saveNote(note);
  }
}
