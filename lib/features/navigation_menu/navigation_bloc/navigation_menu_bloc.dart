
import 'package:flutter_bloc/flutter_bloc.dart';

import 'navigation_menu_event.dart';
import 'navigation_menu_state.dart';

class NavigationMenuBloc extends Bloc<NavigationMenuEvent, NavigationMenuState>{
  NavigationMenuBloc() : super(const NavigationMenuState()){
    on<NavigationItemSelected>(_onNavigationItemSelected);
  }

  void _onNavigationItemSelected(
      NavigationItemSelected event,
      Emitter<NavigationMenuState> emit
      ){
    emit(state.copyWith(index: event.index));
  }

}