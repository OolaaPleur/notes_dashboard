part of 'note_card_bloc.dart';

abstract class NoteCardEvent extends Equatable {
  const NoteCardEvent();

  @override
  List<Object> get props => [];
}

class NoteCardSubmitted extends NoteCardEvent {
  const NoteCardSubmitted(this.title, this.description, this.savedColor);

  final String title;
  final String description;
  final Color savedColor;

  @override
  List<Object> get props => [title, description, savedColor];
}

class NoteCardColorPickerOpened extends NoteCardEvent{
  const NoteCardColorPickerOpened();
}

class NoteCardColorPicked extends NoteCardEvent{
  const NoteCardColorPicked(this.savedColor);

  final Color savedColor;
}
