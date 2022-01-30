import 'package:baromaitre/blocs/navigation/navigation_bloc.dart';
import 'package:baromaitre/pages/dashboard/dashboardd.dart';
import 'package:baromaitre/pages/menu_pages/clients.dart';
import 'package:baromaitre/pages/menu_pages/confreres.dart';
import 'package:baromaitre/pages/menu_pages/forum.dart';
import 'package:baromaitre/pages/menu_pages/home.dart';
import 'package:baromaitre/pages/menu_pages/offres.dart';
import 'package:baromaitre/pages/menu_pages/profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'menu_widgetd.dart';

final Color backgroundColor = const Color(0xFF4A4A58);

class MenuDashboardPage extends StatefulWidget {
  const MenuDashboardPage({Key? key}) : super(key: key);

  @override
  State<MenuDashboardPage> createState() => _MenuDashboardPageState();
}

class _MenuDashboardPageState extends State<MenuDashboardPage>
    with SingleTickerProviderStateMixin {
  bool isCollapsed = true;
  late double screenWidth, screenHeight;
  late AnimationController _controller;
  late Animation<double> scaleAnimation;
  late Animation<double> menuscaleAnimation;
  late Animation<Offset> slideAnimation;

  void onMenuTap() {
    setState(() {
      if (isCollapsed)
        _controller.forward();
      else
        _controller.reverse();
      isCollapsed = !isCollapsed;
    });
  }

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    scaleAnimation = Tween<double>(begin: 1, end: 0.8).animate(_controller);
    menuscaleAnimation = Tween<double>(begin: 0.5, end: 1).animate(_controller);
    slideAnimation = Tween<Offset>(begin: Offset(-1, 0), end: Offset(0, 0))
        .animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    screenHeight = size.height;
    screenWidth = size.width;
    return Scaffold(
      backgroundColor: backgroundColor,
      body:Placeholder()); /*BlocProvider<NavigationBloc>(
        create: (context)=>NavigationBloc(Home(onclick: onMenuTap),onMenuTap),
        child: Stack(
          children: [
            Menu(
                slideAnimation: slideAnimation,
                menuscaleAnimation: menuscaleAnimation),
            Dashboard(
                isCollapsed: isCollapsed,
                onMenuTap: onMenuTap,
                scaleAnimation: scaleAnimation,
                screenWidth: screenWidth,
                child: BlocBuilder<NavigationBloc, NavigationStates>(builder: (context,
                    NavigationStates navigationState) {
                  return navigationState as Widget;
                }),
            ),
          ],
        ),
      ),
    )*/
  }

  int findSelectedIndex(NavigationStates navigationState) {
    if (navigationState is Home) {
      return 0;
    } else if (navigationState is Confreres) {
      return 1;
    } else if (navigationState is Offres) {
      return 2;
    } else if (navigationState is Forum) {
      return 3;
    } else if (navigationState is Clients) {
      return 4;
    } else if (navigationState is Profil) {
      return 5;
    }
    else {
      return 0;
    }
  }
}