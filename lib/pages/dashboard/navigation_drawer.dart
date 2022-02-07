import 'package:baromaitre/pages/lauching/login.dart';
import 'package:baromaitre/pages/menu_pages/external_profile.dart';
import 'package:baromaitre/pages/menu_pages/parameters.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:baromaitre/pages/dashboard/drawer_item.dart';
import 'package:baromaitre/pages/menu_pages/confreres.dart';
import 'package:baromaitre/pages/menu_pages/clients.dart';
import 'package:baromaitre/pages/menu_pages/forum.dart';
import 'package:baromaitre/pages/menu_pages/home.dart';
import 'package:baromaitre/pages/menu_pages/offres.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:baromaitre/pages/menu_pages/profile.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


class NavigationDrawer extends StatelessWidget {
  NavigationDrawer({Key? key}) : super(key: key);
  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Material(
        color: Colors.blue,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24.0, 80, 24, 0),
          child: Column(
            children: [
              InkWell(child: headerWidget(),
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const ExternalProfile()));
                },
              ),
              const SizedBox(height: 40,),
              const Divider(thickness: 1, height: 10, color: Colors.white,),
              const SizedBox(height: 40,),
              DrawerItem(
                  name: 'Accueil',
                  icon: Icons.home_filled,
                  onPressed: ()=> onItemPressed(context, index: 0)
              ),
              const SizedBox(height: 30,),
              DrawerItem(
                  name: 'Offres',
                  icon: FontAwesomeIcons.handshake,
                  onPressed: ()=> onItemPressed(context, index: 6)
              ),
              const SizedBox(height: 30,),
              DrawerItem(
                  name: 'Cabinet',
                  icon: FontAwesomeIcons.university,
                  onPressed: ()=> onItemPressed(context, index: 1)
              ),
              const SizedBox(height: 30,),
              DrawerItem(
                name: 'Confrères',
                icon: Icons.people,
                onPressed: ()=> onItemPressed(context, index: 2),
              ),

              const SizedBox(height: 30,),
              DrawerItem(
                  name: 'Forums',
                  icon: Icons.message_outlined,
                  onPressed: ()=> onItemPressed(context, index: 3)
              ),
              const SizedBox(height: 30,),
              const Divider(thickness: 1, height: 10, color: Colors.white,),
              const SizedBox(height: 30,),
              DrawerItem(
                  name: 'Paramètres',
                  icon: Icons.settings,
                  onPressed: ()=> onItemPressed(context, index: 4)
              ),
              const SizedBox(height: 30,),
              DrawerItem(
                  name: 'Déconnexion',
                  icon: Icons.logout,
                  onPressed: ()=> onItemPressed(context, index: 5)
              ),

            ],
          ),
        ),
      ),
    );
  }

  void onItemPressed(BuildContext context, {required int index}){
    Navigator.pop(context);

    switch(index){
      case 0:
        Navigator.push(context, MaterialPageRoute(builder: (context) => const Home()));
        break;
      case 1:
        Navigator.push(context, MaterialPageRoute(builder: (context) => const Clients()));
        break;
      case 2:
        Navigator.push(context, MaterialPageRoute(builder: (context) => const Confreres()));
        break;
      case 3:
        Navigator.push(context, MaterialPageRoute(builder: (context) => const Forum()));
        break;
      case 4:
        Navigator.push(context, MaterialPageRoute(builder: (context) => const Parameters()));
        break;
      case 5:
        {
          auth.signOut();
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => LoginPage()));
        }
        break;
      case 6:
        Navigator.push(context, MaterialPageRoute(builder: (context) => const Offres()));
        break;
    }
  }

  Widget headerWidget() {
    const url = 'https://images.pexels.com/photos/5668777/pexels-photo-5668777.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500';
    return Row(
      children: [
        const CircleAvatar(
          radius: 40,
          backgroundImage: CachedNetworkImageProvider(url),
        ),
        const SizedBox(width: 20,),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text('Me Aline ODJE', style: TextStyle(fontSize: 14, color: Colors.white)),
            SizedBox(height: 10,),
            Text('person@email.com', style: TextStyle(fontSize: 14, color: Colors.white))
          ],
        )
      ],
    );

  }
}
