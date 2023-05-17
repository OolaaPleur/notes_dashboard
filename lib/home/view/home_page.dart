import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:notes_dashboard/home/home.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HomeCubit(),
      child: const HomeView(),
    );
  }
}

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView>
    with SingleTickerProviderStateMixin {
  static const List<Tab> myTabs = <Tab>[
    Tab(text: 'LEFT'),
    Tab(text: 'RIGHT'),
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white60,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 20),
              child: TabBar(
                tabs: const [
                  Text(
                    'Main Screen',
                    style: TextStyle(color: Colors.black26),
                  ),
                  Text(
                    'Secondary Notes',
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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: tabController.index != 1
          ? null
          : FloatingActionButton(
              key: const Key('homeView_addNote_floatingActionButton'),
              onPressed: () {},
              child: const Icon(Icons.add),
            ),
    );
  }
}
