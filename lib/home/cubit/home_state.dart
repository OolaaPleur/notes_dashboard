part of 'home_cubit.dart';

enum HomeTab { mainScreen, secondaryNotes }

class HomeState extends Equatable {
  const HomeState({this.tab = HomeTab.mainScreen});

  final HomeTab tab;

  @override
  List<Object> get props => [tab];
}
