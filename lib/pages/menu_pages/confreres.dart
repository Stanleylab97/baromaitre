import 'package:baromaitre/pages/dashboard/navigation_drawer.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';

class Confreres extends StatefulWidget {
  const Confreres({Key? key}) : super(key: key);

  @override
  _ConfreresState createState() => _ConfreresState();
}

class _ConfreresState extends State<Confreres> {
  bool _folded=true;

  @override
  Widget build(BuildContext context) {
    Size size=MediaQuery.of(context).size;
    return Scaffold(

      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: Builder(
          builder: (context) {
            return InkWell(
              child: Icon(Icons.menu, color: Colors.black, size: 35),
              onTap: ()=> Scaffold.of(context).openDrawer(),
            );
          },),
        title: Text(
          "Confrères",
          style: TextStyle(fontSize: 14, color: Colors.black),
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
              child:  CountryCodePicker(
                  onChanged: (c){

                  },
                  initialSelection: 'BJ',
                  showFlag: true,
                  showOnlyCountryWhenClosed: true,
                )

          ),
          Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {},
                child: Icon(
                  Icons.filter_alt_rounded,
                  color: Colors.black,
                ),
              )
          ),
        ],
      ),
      drawer:  NavigationDrawer(),
      body: Container(
        padding: EdgeInsets.only(left: 16, right: 16, top: 16),
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
              AnimatedContainer(
                  width: _folded ? size.width*.1556: size.width*.91,
                  duration: Duration(milliseconds: 200),
                  height: size.height*0.07,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(32),
                  color: Colors.white,
                    boxShadow: kElevationToShadow[6]
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(child: Container(
                      padding: EdgeInsets.only(left: 16),
                      child: !_folded? TextField(decoration: InputDecoration(
                        hintText: "Rechercher un confrère",
                        hintStyle: TextStyle(color: Colors.black),
                        border:InputBorder.none
                      )):null
                    )),
                    AnimatedContainer(duration: Duration(milliseconds: 200),
                      child: Material(
                        type: MaterialType.transparency,
                        child: InkWell(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(_folded?32:0),
                                topRight: Radius.circular(32),
                              bottomLeft: Radius.circular(_folded?32:0),
                              bottomRight: Radius.circular(32),

                            ),
                          child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Icon(_folded?Icons.search:Icons.close, color: Colors.blue[400]),
                        ),
                          onTap: (){
                          setState(() {
                            _folded=!_folded;
                          });
                        }),
                      ),
                    ),
                   /*Padding(
                     padding: const EdgeInsets.all(1.5),
                   ),*/
                    //Text(_folded? 'Contactez vos confrères en moins de 2':"", style: TextStyle(fontSize: 12),)
                  ],
                ),
              ),
              SizedBox(height: 1),

            ],
          ),
        ),

      ),
    );
  }
}
