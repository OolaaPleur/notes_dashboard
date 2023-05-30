import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:notes_dashboard/edit_note/view/note_card.dart';
import 'package:notes_dashboard/l10n/l10n.dart';
import 'package:notes_dashboard/notes_overview/bloc/notes_overview_bloc.dart';
import 'package:notes_repository/notes_repository.dart';

import '../../edit_note/bloc/note_card_bloc.dart';

class NotesOverviewView extends StatelessWidget {
  const NotesOverviewView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return MultiBlocListener(
      listeners: [
        BlocListener<NotesOverviewBloc, NotesOverviewState>(
          listenWhen: (previous, current) => previous.status != current.status,
          listener: (context, state) {
            if (state.status == NotesOverviewStatus.failure) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(
                    content: Text(l10n.notesOverviewErrorSnackbarText),
                  ),
                );
            }
          },
        ),
        BlocListener<NotesOverviewBloc, NotesOverviewState>(
          listenWhen: (previous, current) =>
              previous.lastDeletedNote != current.lastDeletedNote &&
              current.lastDeletedNote != null,
          listener: (context, state) {
            final deletedNote = state.lastDeletedNote!;
            final messenger = ScaffoldMessenger.of(context);
            messenger
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text(
                    l10n.notesOverviewNoteDeletedSnackbarText(
                      deletedNote.title,
                    ),
                  ),
                  action: SnackBarAction(
                    label: l10n.notesOverviewUndoDeletionButtonText,
                    onPressed: () {
                      messenger.hideCurrentSnackBar();
                      context
                          .read<NotesOverviewBloc>()
                          .add(const NotesOverviewUndoDeletionRequested());
                    },
                  ),
                ),
              );
          },
        ),
      ],
      child: BlocBuilder<NotesOverviewBloc, NotesOverviewState>(
        builder: (context, state) {
          if (state.notes.isEmpty) {
            if (state.status == NotesOverviewStatus.loading) {
              return const Center(child: CupertinoActivityIndicator());
            } else if (state.status != NotesOverviewStatus.success) {
              return const SizedBox();
            } else {
              return Center(
                child: Text(
                  l10n.notesOverviewEmptyText,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              );
            }
          }
          return SingleChildScrollView(
            child: StaggeredGrid.count(
              crossAxisCount: 2,
              mainAxisSpacing: 4,
              crossAxisSpacing: 4,
              children: List<Widget>.generate(state.notes.length, (index) {
                return BlocProvider(
                  create: (context) => NoteCardBloc(
                    notesRepository: context.read<NotesRepository>(),
                    initialNote: state.notes[index],
                  ),
                  child: NoteCard(
                    key: Key(
                      'notesOverviewView_noteCard_${state.notes[index].id}',
                    ),
                    note: state.notes[index],
                    onDismissed: (_) {
                      context
                          .read<NotesOverviewBloc>()
                          .add(NotesOverviewNoteDeleted(state.notes[index]));
                    },
                  ),
                );
              }),
            ),
          );
        },
      ),
    );
  }
}
