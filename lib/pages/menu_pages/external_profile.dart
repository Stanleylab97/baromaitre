import 'package:baromaitre/pages/ui/externalProfile/appBar_widget.dart';
//import 'package:baromaitre/pages/ui/externalProfile/button_widget.dart';
import 'package:baromaitre/pages/ui/externalProfile/number_widget.dart';
import 'package:baromaitre/pages/ui/externalProfile/profil_widget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';


class ExternalProfile extends StatefulWidget {
  const ExternalProfile({Key? key}) : super(key: key);

  @override
  _ExternalProfileState createState() => _ExternalProfileState();
}

class _ExternalProfileState extends State<ExternalProfile> {
  double translateX = 0.0;
  double translateY = 0.0;
  double myWidth = 0;

  @override
  Widget build(BuildContext context) {
    BorderRadiusGeometry radius = BorderRadius.only(
      topLeft: Radius.circular(24.0),
      topRight: Radius.circular(24.0),
    );
    final user = UserPreferences.myUser;
    return Scaffold(
      appBar: buildAppBar(context),
      body: ListView(
        physics: BouncingScrollPhysics(),
        children: [
          ProfileWidget(
            imagePath: user.imagePath,
            onClicked: () async {},
          ),
          const SizedBox(height: 24),
          buildName(user),
          const SizedBox(height: 24),
          Center(
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50.00),
                    color: Colors.blue[50]),
                width: MediaQuery.of(context).size.width - 100,
                height: MediaQuery.of(context).size.height* .06,
                child: GestureDetector(
                  onHorizontalDragUpdate: (event) async {
                    if (event.primaryDelta! > 10) {
                      _incTansXVal();
                    }
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      paymentSuccessful(),
                      myWidth == 0.0
                          ? Expanded(
                        child: Center(
                          child: Text(
                            "Glisser pour appeler",
                            style:
                            TextStyle(color: Colors.blue, fontSize: 14.0),
                          ),
                        ),
                      )
                          : SizedBox(),
                    ],
                  ),
                ),
              ),

          ),
          const SizedBox(height: 24),
          NumbersWidget(),
          const SizedBox(height: 48),
          buildAbout(user),
      SlidingUpPanel(
        panel: Center(
          child: Text("This is the sliding Widget"),
        ),

        collapsed: Container(
          decoration: BoxDecoration(
              color: Colors.blueGrey,
              borderRadius: radius
          ),
          child: Center(
            child: Text(
              "This is the collapsed Widget",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),

        body: Center(
          child: Text("This is the Widget behind the sliding panel"),
        ),

        borderRadius: radius,
      ),


    ],
      ),
    );
  }

  Widget buildName(User user) => Column(
    children: [
      Text(
        user.name,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
      ),
      const SizedBox(height: 4),
      Text(
        user.email,
        style: TextStyle(color: Colors.grey),
      )
    ],
  );

  Widget paymentSuccessful() => Transform.translate(
    offset: Offset(translateX, translateY),
    child: AnimatedContainer(
      duration: Duration(milliseconds: 200),
      curve: Curves.linear,
      width: 100 + myWidth,
      height: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50.00),
        color: Colors.blue,
      ),
      child: myWidth > 0.0
          ? Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.check,
            color: Colors.white,
            size: 24,
          ),
          Flexible(
            child: Text(
              "Appel en cours",
              style: TextStyle(color: Colors.white, fontSize: 20.00),
            ),
          ),
        ],
      )
          : Icon(
        FontAwesomeIcons.phoneAlt,
        color: Colors.white,
        size: 24.00,
      ),
    ),
  );

  _incTansXVal() async {
    int canLoop = -1;
    for (var i = 0; canLoop == -1; i++)
      await Future.delayed(Duration(milliseconds: 1), () {
        setState(() {
          if (translateX + 1 <
              MediaQuery.of(context).size.width - (200 + myWidth)) {
            translateX += 1;
            myWidth = MediaQuery.of(context).size.width - (200 + myWidth);
          } else {
            canLoop = 1;
          }
        });
      });
  }
}

  Widget buildAbout(User user) => Container(
    padding: EdgeInsets.symmetric(horizontal: 48),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Biographie',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Text(
          user.about,
          style: TextStyle(fontSize: 16, height: 1.4),
        ),
      ],
    ),
  );


class UserPreferences {
  static const myUser = User(
    imagePath:
    'https://images.pexels.com/photos/7875843/pexels-photo-7875843.jpeg?auto=compress&cs=tinysrgb&h=750&w=1260',
    name: 'Sarah Abs',
    email: 'sarah.abs@gmail.com',
    about:
    'Certified Personal Trainer and Nutritionist with years of experience in creating effective diets and training plans focused on achieving individual customers goals in a smooth way.',
    isDarkMode: false,
  );
}

class User {
  final String imagePath;
  final String name;
  final String email;
  final String about;
  final bool isDarkMode;

  const User({
    required this.imagePath,
    required this.name,
    required this.email,
    required this.about,
    required this.isDarkMode,
  });
}