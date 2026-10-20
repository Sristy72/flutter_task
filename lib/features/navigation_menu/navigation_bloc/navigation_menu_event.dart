import 'package:equatable/equatable.dart';

abstract class NavigationMenuEvent extends Equatable{

}

class NavigationItemSelected extends NavigationMenuEvent{
  final int index;

  NavigationItemSelected(this.index);

  @override
  // TODO: implement props
  List<Object?> get props => [index];

}