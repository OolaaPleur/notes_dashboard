part of 'notes_overview_bloc.dart';

abstract class NotesOverviewEvent extends Equatable {
  const NotesOverviewEvent();

  @override
  List<Object> get props => [];
}

class NotesOverviewSubscriptionRequested extends NotesOverviewEvent {
  const NotesOverviewSubscriptionRequested();
}

class NotesOverviewNoteDeleted extends NotesOverviewEvent {
  const NotesOverviewNoteDeleted(this.note);

  final Note note;

  @override
  List<Object> get props => [note];
}
class NotesOverviewUndoDeletionRequested extends NotesOverviewEvent {
  const NotesOverviewUndoDeletionRequested();
}