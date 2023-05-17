import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_dashboard/home/home.dart';
import 'package:notes_dashboard/l10n/l10n.dart';
import 'package:notes_dashboard/theme/theme.dart';
import 'package:notes_repository/notes_repository.dart';

class App extends StatelessWidget {
  const App({super.key, required this.notesRepository});

  final NotesRepository notesRepository;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: notesRepository,
      child: const AppView(),
    );
  }
}

class AppView extends StatelessWidget {
  const AppView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: FlutterNotesTheme.light,
      darkTheme: FlutterNotesTheme.dark,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: const HomePage(),
    );
  }
}