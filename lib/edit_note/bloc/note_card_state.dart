part of 'note_card_bloc.dart';

enum NoteCardStatus { initial, loading, showGreenCheck, success, failure }

class NoteCardState extends Equatable {
  const NoteCardState(
      {this.noteCardColorPickerOpened = false,
      this.status = NoteCardStatus.initial,
      this.initialNote,
      this.title = '',
      this.description = '',
      this.savedColor = Colors.white,});

  final bool noteCardColorPickerOpened;
  final NoteCardStatus status;
  final String title;
  final String description;
  final Note? initialNote;
  final Color savedColor;

  NoteCardState copyWith({
    bool? noteCardColorPickerOpened,
    NoteCardStatus? status,
    Note? initialNote,
    String? title,
    String? description,
    Color? savedColor,
  }) {
    return NoteCardState(
      noteCardColorPickerOpened:
          noteCardColorPickerOpened ?? this.noteCardColorPickerOpened,
      status: status ?? this.status,
      initialNote: initialNote ?? this.initialNote,
      title: title ?? this.title,
      description: description ?? this.description,
      savedColor: savedColor ?? this.savedColor,
    );
  }

  @override
  List<Object?> get props => [
        noteCardColorPickerOpened,
        status,
        initialNote,
        title,
        description,
        savedColor
      ];
}
