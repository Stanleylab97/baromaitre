import 'dart:convert';

import 'package:baromaitre/blocs/internet_bloc.dart';
import 'package:baromaitre/blocs/signIn_bloc.dart';
import 'package:baromaitre/pages/lauching/done.dart';
import 'package:baromaitre/pages/lauching/forgot_password.dart';
import 'package:baromaitre/pages/lauching/register.dart';
import 'package:baromaitre/pages/lauching/verify_email.dart';
import 'package:baromaitre/pages/lauching/verify_matricule.dart';
import 'package:baromaitre/pages/menu_pages/home.dart';
import 'package:baromaitre/pages/ui/authentication/header_widget.dart';
import 'package:baromaitre/utils/commons/network_handler.dart';
import 'package:baromaitre/utils/commons/next_screen.dart';
import 'package:baromaitre/utils/commons/snackbar.dart';
import 'package:baromaitre/utils/commons/theme_helper.dart';
import 'package:baromaitre/utils/commons/utils/icons.dart';
import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  final String? tag;
  const LoginPage({Key? key, this.tag}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final auth = FirebaseAuth.instance;
  NetworkHandler networkHandler = NetworkHandler();
  double _headerHeight = 250;
  var _formKey = GlobalKey<FormState>();
  bool circular = false;
  bool validate = false;
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  bool vis = true;
  String errorText = "";
  var formKey = GlobalKey<FormState>();
  var _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool offsecureText = true;
  bool signInStart = false;
  bool signInComplete = false;
  Icon lockIcon = LockIcon().lock;


  void lockPressed() {
    if (offsecureText == true) {
      setState(() {
        offsecureText = false;
        lockIcon = LockIcon().open;
      });
    } else {
      setState(() {
        offsecureText = true;
        lockIcon = LockIcon().lock;
      });
    }
  }

  handleSignInwithemailPassword() async {
    final InternetBloc ib = Provider.of<InternetBloc>(context, listen: false);
    final SignInBloc sb = Provider.of<SignInBloc>(context, listen: false);
    await ib.checkInternet();
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      FocusScope.of(context).requestFocus(new FocusNode());

      await ib.checkInternet();
      if (ib.hasInternet == false) {
        openSnacbar(_scaffoldKey, 'no internet');
      } else {
        setState(() {
          signInStart = true;
        });
        sb.signInwithEmailPassword(email.text.trim(), password.text.trim()).then((_) async {
          if (sb.hasError == false) {
            sb
                .getUserDatafromFirebase(sb.firebaseLoyer.uid)
                .then((value) => sb
                .saveDataToSP()
                .then((value) => sb.setSignIn().then((value) {
              setState(() {
                signInComplete = true;
              });
              afterSignIn();
            })));
          } else {
            setState(() {
              signInStart = false;
            });
            openSnacbar(_scaffoldKey, sb.errorCode);
          }
        });
      }
    }
  }

  afterSignIn() {
    if (widget.tag == null) {
      nextScreenReplace(
          context,
          DonePage());
    } else {
      Navigator.pop(context);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: _headerHeight,
              child: HeaderWidget(_headerHeight, true,
                  Icons.login_rounded), //let's create a common header widget
            ),
            SafeArea(
              child: Container(
                  padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                  margin: EdgeInsets.fromLTRB(
                      20, 10, 20, 10), // This will be the login form
                  child: Column(
                    children: [
                      Text(
                        'Bienvenue',
                        style: TextStyle(
                            fontSize: 45, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Connectez-vous!',
                        style: TextStyle(color: Colors.grey),
                      ),
                      SizedBox(height: 20.0),
                      Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              Container(
                                  child: TextFormField(
                                      controller: email,
                                      validator: (input) {
                                        if (input!.isEmpty)
                                          return 'Saisissez votre e-mail';
                                        if (!input.toString().contains("@"))
                                          return "Adresse invalide";
                                        return null;
                                      },
                                      decoration: InputDecoration(
                                        errorText: validate ? null : errorText,
                                        labelText: 'Email',
                                        prefixIcon: Icon(Icons.email),
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.black,
                                            width: 2,
                                          ),
                                        ),
                                      ))),
                              SizedBox(height: 10.0),
                              Container(
                                  child: TextFormField(
                                controller: password,
                                validator: (input) {
                                  if (input.toString().length < 6)
                                    return 'Entrez au moins 6 caractères';
                                  return null;
                                },
                                obscureText: vis,
                                decoration: InputDecoration(
                                  labelText: 'Mot de passe',
                                  prefixIcon: Icon(Icons.lock),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.black,
                                      width: 2,
                                    ),
                                  ),
                                  suffixIcon: IconButton(
                                    icon: Icon(vis
                                        ? Icons.visibility_off
                                        : Icons.visibility),
                                    onPressed: () {
                                      setState(() {
                                        vis = !vis;
                                      });
                                    },
                                  ),
                                ),
                              )),
                              SizedBox(height: 15.0),
                              Container(
                                margin: EdgeInsets.fromLTRB(10, 0, 10, 20),
                                alignment: Alignment.topRight,
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ForgotPasswordPage()),
                                    );
                                  },
                                  child: Text(
                                    "Mot de passe oublié?",
                                    style: TextStyle(
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                decoration:
                                    ThemeHelper().buttonBoxDecoration(context),
                                child: circular
                                    ? Center(child: CircularProgressIndicator())
                                    : ElevatedButton(
                                        style: ThemeHelper().buttonStyle(),
                                        child: Padding(
                                          padding: EdgeInsets.fromLTRB(
                                              40, 10, 40, 10),
                                          child: Text(
                                            'Connexion'.toUpperCase(),
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white),
                                          ),
                                        ),
                                        onPressed: () async {
                                          try {

                                            handleSignInwithemailPassword();
                                            final SignInBloc sb = Provider.of<SignInBloc>(context, listen: false);

                                                  var response = await networkHandler
                                                  .getAccountStatus(
                                                      "/current-account-status?matricule=" +
                                                          sb.firebaseLoyer.loyerDataGotFromAPI.matricule.toString(),
                                                      "60|CIYrEpYmyqOX5ifLrAxSCDKwseGqaclm3h6wzEgN");
                                              if (response.statusCode == 200 ||
                                                  response.statusCode == 201) {
                                                Map<String, dynamic> output =
                                                    json.decode(response.body);
                                                if (output["accountActivate"] =
                                                    true) {
                                                  Navigator.pushAndRemoveUntil(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            VerifyEmail(),
                                                      ),
                                                      (route) => false);
                                                } else {
                                                  CherryToast.error(
                                                      title: "",
                                                      displayTitle: false,
                                                      description:
                                                      "Cet compte est suspendu! Rapprochez-vous du bâtonnier",
                                                      animationType:
                                                      ANIMATION_TYPE
                                                          .fromTop,
                                                      animationDuration:
                                                      Duration(
                                                          milliseconds:
                                                          2000),
                                                      autoDismiss: true)
                                                      .show(context);
                                                }
                                                setState(() {
                                                  circular = false;
                                                  validate = false;
                                                });
                                              } else if (response.statusCode ==
                                                  404) {
                                                CherryToast.error(
                                                        title: "Désolé",
                                                        displayTitle: false,
                                                        description:
                                                            "Ce matricule n'est pas reconnu!",
                                                        animationType:
                                                            ANIMATION_TYPE
                                                                .fromTop,
                                                        animationDuration:
                                                            Duration(
                                                                milliseconds:
                                                                    2000),
                                                        autoDismiss: true)
                                                    .show(context);
                                              } else {
                                                CherryToast.info(
                                                  title: "Désolé",
                                                  action:
                                                      "Une erreur s'est produite",
                                                  actionHandler: () {
                                                    print(
                                                        "Action button pressed");
                                                  },
                                                ).show(context);
                                              }
                                              Navigator.of(context)
                                                  .pushReplacement(
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              Home()));

                                            //After successful login we will redirect to profile page. Let's create profile page now
                                            Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        VerifyEmail()));
                                          } on FirebaseAuthException catch (e) {}
                                        },
                                      ),
                              ),
                              Container(
                                margin: EdgeInsets.fromLTRB(10, 20, 10, 20),
                                //child: Text('Don\'t have an account? Create'),
                                child: Text.rich(TextSpan(children: [
                                  TextSpan(text: "Pas de compte ?"),
                                  TextSpan(
                                    text: ' Créez un compte',
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    MatriculeVerify()));
                                      },
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context).accentColor),
                                  ),
                                ])),
                              ),
                            ],
                          )),
                    ],
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
