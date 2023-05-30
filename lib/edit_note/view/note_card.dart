import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_dashboard/edit_note/bloc/note_card_bloc.dart';
import 'package:notes_dashboard/l10n/l10n.dart';
import 'package:notes_repository/notes_repository.dart';

class NoteCard extends StatefulWidget {
  NoteCard({super.key, required this.note, this.onDismissed});

  final Note note;
  final DismissDirectionCallback? onDismissed;

  @override
  State<NoteCard> createState() => _NoteCardState();
}

class _NoteCardState extends State<NoteCard> {
  FocusNode titleFocusNode = FocusNode();
  FocusNode descriptionFocusNode = FocusNode();

  bool paletteOpened = false;

  @override
  void initState() {
    super.initState();
    titleFocusNode.addListener(_onFocusChanged);
    descriptionFocusNode.addListener(_onFocusChanged);
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    titleFocusNode.removeListener(_onFocusChanged);
    descriptionFocusNode.removeListener(_onFocusChanged);
    titleFocusNode.dispose();
    descriptionFocusNode.dispose();
    super.dispose();
  }

  void _submitInput() {
    context.read<NoteCardBloc>().add(NoteCardSubmitted(
          titleController.text,
          descriptionController.text,
          context.read<NoteCardBloc>().state.savedColor,
        ));
  }

  void _onFocusChanged() {
    if (!titleFocusNode.hasFocus) {
      _submitInput();
    }
    if (!descriptionFocusNode.hasFocus) {
      _submitInput();
      descriptionFocusNode.unfocus();
    }
  }

  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final noteCardColorPickerOpened = context
        .select((NoteCardBloc bloc) => bloc.state.noteCardColorPickerOpened);
    final colorSelected =
        context.select((NoteCardBloc bloc) => bloc.state.savedColor);

    titleController.text = widget.note.title;
    descriptionController.text = widget.note.description;

    return Builder(
      builder: (context) {
        return Dismissible(
          onDismissed: widget.onDismissed,
          key: Key('noteCard_dismissible_${widget.note.id}'),
          direction: DismissDirection.endToStart,
          background: ColoredBox(
            color: theme.colorScheme.error,
            child: const Icon(
              Icons.delete,
              color: Color(0xAAFFFFFF),
            ),
          ),
          child: Material(
            elevation: 5,
            color: colorSelected,
            child: Card(
              color: colorSelected,
              elevation: 0,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  children: [
                    TextFormField(
                      focusNode: titleFocusNode,
                      controller: titleController,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      style: TextStyle(fontWeight: FontWeight.bold),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: l10n.editNoteTitleLabel,
                      ),
                    ),
                    Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        BlocConsumer<NoteCardBloc, NoteCardState>(
                          listenWhen: (previous, current) =>
                              (previous.status == NoteCardStatus.loading &&
                                  current.status == NoteCardStatus.success) ||
                              current.status == NoteCardStatus.loading,
                          listener: (context, state) {
                            //
                          },
                          builder: (context, state) {
                            if (state.status == NoteCardStatus.loading) {
                              return const CircularProgressIndicator(
                                strokeWidth: 2,
                              );
                            }
                            if (state.status == NoteCardStatus.showGreenCheck) {
                              return const Icon(
                                Icons.check,
                                color: Colors.lightGreen,
                              );
                            } else {
                              return Container();
                            }
                          },
                        ),
                        TextFormField(
                          controller: descriptionController,
                          focusNode: descriptionFocusNode,
                          textInputAction: TextInputAction.done,
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: l10n.editNoteDescriptionLabel,
                          ),
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (noteCardColorPickerOpened)
                          BlocListener<NoteCardBloc, NoteCardState>(
                            listenWhen: (previous, current) =>
                                previous.savedColor != current.savedColor,
                            listener: (context, state) {
                              _submitInput();
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ChangeColorButton(color: Colors.green),
                                ChangeColorButton(color: Colors.amber),
                                ChangeColorButton(color: Colors.purple),
                              ],
                            ),
                          )
                        else
                          const SizedBox.shrink(),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: IconButton(
                              padding: const EdgeInsets.symmetric(vertical: 20),
                              onPressed: () {
                                setState(() {
                                  context
                                      .read<NoteCardBloc>()
                                      .add(const NoteCardColorPickerOpened());
                                  _submitInput();
                                });
                              },
                              icon: Icon(Icons.palette)),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class ChangeColorButton extends StatelessWidget {
  const ChangeColorButton({
    super.key,
    required this.color,
  });

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(1.5),
      child: SizedBox(
        width: MediaQuery.of(context).size.width / 12,
        child: RawMaterialButton(
          shape: CircleBorder(),
          onPressed: () {
            context.read<NoteCardBloc>().add(NoteCardColorPicked(color));
          },
          fillColor: color,
        ),
      ),
    );
  }
}
