import 'package:baromaitre/blocs/signIn_bloc.dart';
import 'package:baromaitre/pages/lauching/login.dart';
import 'package:baromaitre/pages/menu_pages/home.dart';
import 'package:baromaitre/utils/commons/next_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashPage extends StatefulWidget {
  SplashPage({Key? key}) : super(key: key);

  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {

  afterSplash() {
    final SignInBloc sb = context.read<SignInBloc>();
    Future.delayed(Duration(milliseconds: 1000)).then((value) {
      if (sb.isSignedIn == true) {
        redirectUser();
      } else
        gotoSignInPage();
    });
  }



  Future redirectUser() async {

      nextScreenReplace(context, Home());

  }

  gotoHomePage() {
    final SignInBloc sb = context.read<SignInBloc>();
    if (sb.isSignedIn == true) {
      sb.getDataFromSp();
    }
    nextScreenReplace(context, Home());
  }

  gotoSignInPage() {
    nextScreenReplace(context, LoginPage());
  }

  @override
  void initState() {
    //afterSplash();
    super.initState();
    Future.delayed(Duration(milliseconds: 5000)).then((value) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
                child: Image(
                  image: AssetImage("assets/images/logos/logo_500x500.png"),
                  height: 240,
                  width: 240,
                  fit: BoxFit.contain,
                )),
            SpinKitSpinningLines(
              duration: Duration(microseconds: 3000),
              color: Colors.blue,
              size: 50.0,
            ),

            Divider(height: 5,
            color: Colors.blue,
              indent: 100,
            endIndent: 100,),
            SizedBox(height: 5),
            Text("Bienvenue sur la plateforme collaborative\n des Avocats",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14),),


          ],
        ) );
  }
}


