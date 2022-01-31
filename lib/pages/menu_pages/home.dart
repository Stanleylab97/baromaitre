import 'package:baromaitre/blocs/navigation/navigation_bloc.dart';
import 'package:baromaitre/pages/dashboard/navigation_drawer.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        centerTitle: true,

        backgroundColor: Colors.white,
        leading: Builder(
          builder: (context) {
          return InkWell(
            child: Icon(FontAwesomeIcons.bars,color: Colors.black),
            onTap: ()=> Scaffold.of(context).openDrawer(),
          );
        },),
        title: Text(
          "Accueil",
          style: TextStyle(fontSize: 24, color: Colors.black),
        ),
        actions: [
        /*  InkWell(
            child: Icon(Icons.notifications, color: Colors.black),
            onTap: (){},
          ),
          InkWell(
            child: Icon(Icons.settings, color: Colors.black),
            onTap: (){},
          ),*/
          Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {},
                child: Icon(
                  Icons.notifications,
                  color: Colors.black,
                  size: 26.0,
                ),
              )
          ),
          Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {},
                child: Icon(
                    Icons.settings,
                  color: Colors.black,
                ),
              )
          ),
        ],
      ),
      drawer: const NavigationDrawer(),
      body: Container(
        padding: EdgeInsets.only(left: 16, right: 16, top: 48),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(40)),
          color: Colors.white
        )
      ),
    );
  }
}
