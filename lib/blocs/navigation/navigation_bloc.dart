import 'package:baromaitre/pages/menu_pages/clients.dart';
import 'package:baromaitre/pages/menu_pages/confreres.dart';
import 'package:baromaitre/pages/menu_pages/forum.dart';
import 'package:baromaitre/pages/menu_pages/home.dart';
import 'package:baromaitre/pages/menu_pages/offres.dart';
import 'package:baromaitre/pages/menu_pages/profile.dart';
import 'package:flutter/cupertino.dart';
import 'package:bloc/bloc.dart';



enum NavigationEvents{
  HomeClickedEvent,
  OffresClickedEvent,
  ConfreresClickedEvent,
  ForumClickedEvent,
  ProfilClickedEvent,
  ClientsClickedEvent
}

abstract class NavigationStates{

}

class NavigationBloc extends Bloc<NavigationEvents,NavigationStates>{
  final VoidCallback onMenuTap;

  NavigationBloc(NavigationStates initialState, this.onMenuTap) : super(initialState){
    on<NavigationEvents>((event,emit)=> mapEventToState(event,emit));
  }


  Stream<NavigationStates> mapEventToState(NavigationEvents event,Emitter<NavigationStates> emit) async*{
    switch(event){
     /* case NavigationEvents.HomeClickedEvent:
        yield Home(onclick: onMenuTap);
        break;
      case NavigationEvents.OffresClickedEvent:
        yield Offres(onMenuTap: onMenuTap);
        break;
      case NavigationEvents.ConfreresClickedEvent:
        yield Confreres(onMenuTap: onMenuTap);
        break;
      case NavigationEvents.ForumClickedEvent:
        yield Forum(onMenuTap: onMenuTap);
        break;
      case NavigationEvents.ProfilClickedEvent:
        yield Profil(onMenuTap: onMenuTap);
        break;
      case NavigationEvents.ClientsClickedEvent :
        yield Clients(onMenuTap: onMenuTap);
        break;*/
    }
  }

}