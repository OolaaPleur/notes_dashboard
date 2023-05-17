part of 'notes_overview_bloc.dart';

enum NotesOverviewStatus { initial, loading, success, failure }

class NotesOverviewState extends Equatable {
  const NotesOverviewState({
    this.status = NotesOverviewStatus.initial,
    this.notes = const [],
    this.lastDeletedNote,
  });

  final NotesOverviewStatus status;
  final List<Note> notes;
  final Note? lastDeletedNote;

  NotesOverviewState copyWith({
    NotesOverviewStatus Function()? status,
    List<Note> Function()? notes,
    Note? Function()? lastDeletedNote,
  }) {
    return NotesOverviewState(
      status: status != null ? status() : this.status,
      notes: notes != null ? notes() : this.notes,
      lastDeletedNote:
          lastDeletedNote != null ? lastDeletedNote() : this.lastDeletedNote,
    );
  }

  @override
  List<Object?> get props => [status, notes, lastDeletedNote];
}
