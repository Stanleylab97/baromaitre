import 'package:baromaitre/blocs/navigation/navigation_bloc.dart';
import 'package:baromaitre/pages/dashboard/navigation_drawer.dart';
import 'package:flutter/material.dart';

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
            child: Icon(Icons.menu, color: Colors.black, size: 35),
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
        ),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          physics: ClampingScrollPhysics(),
          child:  Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Container(
                  height: 200,
                  child: PageView(
                    controller: PageController(viewportFraction: 0.8),
                    scrollDirection: Axis.horizontal,
                    pageSnapping: true,
                    children: [
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 8),
                        color: Colors.redAccent,
                        width: 100,
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 8),
                        color: Colors.blue,
                        width: 100,
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 8),
                        color: Colors.green,
                        width: 100,
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 8),
                        color: Colors.yellowAccent,
                        width: 100,
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'Transactions',
                  style: TextStyle(color: Colors.black, fontSize: 20),
                ),
                SizedBox(height: 5),
                ListView.separated(
                  shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text("MacBook"),
                        subtitle: Text("Apple"),
                        trailing: Text("-200"),
                      );
                    },
                    separatorBuilder: (context, index) {
                      return Divider(
                        height: 3,
                        color: Colors.black45,
                      );
                    },
                    itemCount: 10),
                SizedBox(height: 20)
              ],
            ),
          ),

      ),
    );
  }
}
