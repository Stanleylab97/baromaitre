import 'package:baromaitre/blocs/navigation/navigation_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Menu extends StatelessWidget {
  Menu({ Key? key ,required this.menuscaleAnimation,required this.slideAnimation}) : super(key: key);
  late Animation<Offset> slideAnimation;
  late Animation<double> menuscaleAnimation;


  @override
  Widget build(BuildContext context) {
     return SlideTransition(
      position: slideAnimation,
      child: ScaleTransition(
        scale: menuscaleAnimation,
        child: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GestureDetector(
                  onTap: (){BlocProvider.of<NavigationBloc>(context).add(NavigationEvents.HomeClickedEvent);},
                  child: const Text(
                    "Accueil",
                    style: TextStyle(color: Colors.white, fontSize: 25),
                  ),
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: (){BlocProvider.of<NavigationBloc>(context).add(NavigationEvents.ProfilClickedEvent);},
                  child: const Text(
                    "Profil",
                    style: const TextStyle(color: Colors.white, fontSize: 25),
                  ),
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: (){BlocProvider.of<NavigationBloc>(context).add(NavigationEvents.ClientsClickedEvent);},
                  child: const Text(
                    "Clients",
                    style: const TextStyle(color: Colors.white, fontSize: 25),
                  ),
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: (){BlocProvider.of<NavigationBloc>(context).add(NavigationEvents.OffresClickedEvent);},
                  child: const Text(
                    "Offres",
                    style: const TextStyle(color: Colors.white, fontSize: 25),
                  ),
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: (){BlocProvider.of<NavigationBloc>(context).add(NavigationEvents.ConfreresClickedEvent);},
                  child: const Text(
                    "Confrères",
                    style: const TextStyle(color: Colors.white, fontSize: 25),
                  ),
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: (){BlocProvider.of<NavigationBloc>(context).add(NavigationEvents.ForumClickedEvent);},
                  child: const Text(
                    "Forum",
                    style: const TextStyle(color: Colors.white, fontSize: 25),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  

  }
}