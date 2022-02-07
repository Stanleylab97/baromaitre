import 'package:baromaitre/pages/dashboard/navigation_drawer.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Offres extends StatefulWidget {
  const Offres({Key? key}) : super(key: key);

  @override
  _OffresState createState() => _OffresState();
}

class _OffresState extends State<Offres> {
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
          "Offres",
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
        ],
      ),
      drawer:  NavigationDrawer(),
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
