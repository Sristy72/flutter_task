import 'package:equatable/equatable.dart';

class NavigationMenuState extends Equatable{
  final int selectedIndex;
  const NavigationMenuState({this.selectedIndex = 0});

  NavigationMenuState copyWith({
    int? index
}){
    return NavigationMenuState(
      selectedIndex: index ?? selectedIndex
    );
}

  @override
  // TODO: implement props
  List<Object?> get props => [selectedIndex];
}