import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:notes_dashboard/home/home.dart';
import 'package:notes_dashboard/l10n/l10n.dart';
import 'package:notes_dashboard/notes_overview/bloc/notes_overview_bloc.dart';
import 'package:notes_repository/notes_repository.dart';

import '../../notes_overview/view/view.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(providers: [
      BlocProvider(
        create: (_) => HomeCubit(),
        child: const HomeView(),
      ),
      BlocProvider(
        create: (context) => NotesOverviewBloc(
          notesRepository: context.read<NotesRepository>(),
        )..add(const NotesOverviewSubscriptionRequested()),
        child: const NotesOverviewView(),
      )
    ], child: HomeView());
  }
}

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView>
    with SingleTickerProviderStateMixin {
  static List<Widget> myTabs = <Widget>[
    NotesOverviewView(),
    Text('RIGHT'),
  ];

  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: myTabs.length, vsync: this);
    tabController.addListener(() {
      tabControllerChanged(tabController.index);
    });
  }

  void tabControllerChanged(int value) {
    switch (value) {
      case 0:
        context.read<HomeCubit>().setTab(HomeTab.mainScreen);
        break;
      case 1:
        context.read<HomeCubit>().setTab(HomeTab.secondaryNotes);
        break;
    }
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return GestureDetector(
      //onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
          appBar: AppBar(
            title: Container(
                padding: EdgeInsets.only(left: 15, top: 30),
                child: Text(
                  l10n.notesOverviewAppBarTitle,
                  textScaleFactor: 1.5,
                  style: TextStyle(color: Colors.black45),
                )),
            backgroundColor: Colors.white60,
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(60),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: TabBar(
                    tabs: [
                      Text(
                        l10n.notesOverviewMainScreen,
                        style: TextStyle(color: Colors.black26),
                      ),
                      Text(
                        l10n.notesOverviewSecondaryNotes,
                        style: TextStyle(color: Colors.black26),
                      )
                    ],
                    indicatorColor: Colors.amber,
                    isScrollable: true,
                    labelPadding: const EdgeInsets.all(10),
                    controller: tabController,
                    onTap: tabControllerChanged,
                  ),
                ),
              ),
            ),
          ),
          body: TabBarView(
            controller: tabController,
            children: myTabs,
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          floatingActionButton: BlocBuilder<HomeCubit, HomeState>(
            builder: (context, state) {
              if (context.read<HomeCubit>().state.tab == HomeTab.mainScreen) {
                return FloatingActionButton(
                  key: const Key('homeView_addNote_floatingActionButton'),
                  onPressed: () {
                    context.read<NotesRepository>().saveNote(Note());
                  },
                  child: const Icon(Icons.add),
                );
              }
              return Container();
            },
          )),
    );
  }
}
