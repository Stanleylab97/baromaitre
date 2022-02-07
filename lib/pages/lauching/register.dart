import 'package:baromaitre/blocs/internet_bloc.dart';
import 'package:baromaitre/blocs/signIn_bloc.dart';
import 'package:baromaitre/models/loyer_data.dart';
import 'package:baromaitre/pages/lauching/done.dart';
import 'package:baromaitre/pages/lauching/terms_of_use.dart';
import 'package:baromaitre/pages/lauching/verify_email.dart';
import 'package:baromaitre/pages/ui/authentication/header_widget.dart';
import 'package:baromaitre/utils/commons/next_screen.dart';
import 'package:baromaitre/utils/commons/snackbar.dart';
import 'package:baromaitre/utils/commons/theme_helper.dart';
import 'package:baromaitre/utils/commons/utils/icons.dart';
import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/src/response.dart';
import 'package:provider/provider.dart';

class RegistrationPage extends StatefulWidget {
  LoyerAppData avocat;
  final String? tag;
  RegistrationPage({required this.avocat,this.tag});

  @override
  State<StatefulWidget> createState() {
    return _RegistrationPageState();
  }
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  var _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool checkedValue = false;
  bool checkboxValue = false;
  bool offsecureText = true;
  bool offsecureText1 = true;
  Icon lockIcon = LockIcon().lock;
  Icon lockIcon1 = LockIcon().lock;
  TextEditingController nom = TextEditingController();
  TextEditingController prenom = TextEditingController();
  TextEditingController tel = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController pass = TextEditingController();
  TextEditingController confirmpass = TextEditingController();

  bool signUpStarted = false;
  bool signUpCompleted = false;

  SizedBox get smallHeightSpacing => SizedBox(height: 12);

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

  void lockPressed1() {
    if (offsecureText1 == true) {
      setState(() {
        offsecureText1 = false;
        lockIcon1 = LockIcon().open;
      });
    } else {
      setState(() {
        offsecureText1 = true;
        lockIcon1 = LockIcon().lock;
      });
    }
  }
  Future handleSignUpwithEmailPassword() async {
    final InternetBloc ib = Provider.of<InternetBloc>(context, listen: false);
    final SignInBloc sb = Provider.of<SignInBloc>(context, listen: false);
    await ib.checkInternet();
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      FocusScope.of(context).requestFocus(new FocusNode());
      await ib.checkInternet();
      if (ib.hasInternet == false) {
        openSnacbar(_scaffoldKey, 'Pas de connexion internet');
      } else {
        setState(() {
          signUpStarted = true;
        });

        widget.avocat.email=email.text;
        widget.avocat.nom=nom.text;
        widget.avocat.prenom=prenom.text;
        widget.avocat.contact=tel.text;

        sb
            .signUpwithEmailPassword(widget.avocat, pass.text)
            .then((_) async {
          if (sb.hasError == false) {
            sb.getTimestamp().then((value) => sb
                .saveToFirebase()
                .then((value) => sb.increaseUserCount())
                .then((value) => sb.guestSignout().then((value) => sb
                .saveDataToSP()
                .then((value) => sb.setSignIn().then((value) {
              setState(() {
                signUpCompleted = true;
              });
              afterSignUp();
            })))));
          } else {
            setState(() {
              signUpStarted = false;
            });
            openSnacbar(_scaffoldKey, sb.errorCode);
          }
        });
      }
    }
  }

  afterSignUp() {
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
        child: Stack(
          children: [
            Container(
              height: 150,
              child: HeaderWidget(150, false, Icons.person_add_alt_1_rounded),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(25, 50, 25, 10),
              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
              alignment: Alignment.center,
              child: Column(
                children: [
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        GestureDetector(
                          child: Stack(
                            children: [
                              Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  border:
                                      Border.all(width: 5, color: Colors.white),
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black12,
                                      blurRadius: 20,
                                      offset: const Offset(5, 5),
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  Icons.person,
                                  color: Colors.grey.shade300,
                                  size: 80.0,
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.fromLTRB(80, 80, 0, 0),
                                child: Icon(
                                  Icons.add_circle,
                                  color: Colors.grey.shade700,
                                  size: 25.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Container(
                          child: TextFormField(
                            decoration: ThemeHelper().textInputDecoration(
                                'Nom', 'Enter your first name'),
                            initialValue: widget.avocat.nom,
                          ),
                          decoration: ThemeHelper().inputBoxDecorationShaddow(),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Container(
                          child: TextFormField(
                            initialValue: widget.avocat.prenom,
                            decoration: ThemeHelper().textInputDecoration(
                                'Prénom', 'Enter your last name'),
                          ),
                          decoration: ThemeHelper().inputBoxDecorationShaddow(),
                        ),
                        SizedBox(height: 15.0),
                        Container(
                          child: TextFormField(
                            decoration: ThemeHelper().textInputDecoration(
                                "E-mail", "Enter your email"),
                            keyboardType: TextInputType.emailAddress,
                            initialValue: widget.avocat.email,
                            validator: (val) {
                              if (!(val!.isEmpty) &&
                                  !RegExp(r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$")
                                      .hasMatch(val)) {
                                return "Enter a valid email address";
                              }
                              return null;
                            },
                          ),
                          decoration: ThemeHelper().inputBoxDecorationShaddow(),
                        ),
                        SizedBox(height: 15.0),
                        Container(
                          child: TextFormField(
                            decoration: ThemeHelper().textInputDecoration(
                                "Téléphone", "Enter your mobile number"),
                            initialValue: widget.avocat.contact,
                            keyboardType: TextInputType.phone,
                            validator: (val) {
                              if (!(val!.isEmpty) &&
                                  !RegExp(r"^(\d+)*$").hasMatch(val)) {
                                return "Enter a valid phone number";
                              }
                              return null;
                            },
                          ),
                          decoration: ThemeHelper().inputBoxDecorationShaddow(),
                        ),
                        SizedBox(height: 15.0),
                        Container(
                          child: TextFormField(
                            controller: pass,
                            obscureText: offsecureText,
                            decoration: InputDecoration(
                              labelText: 'Mot de passe',
                              hintText: 'Entrez un mot de passe',
                              suffixIcon: IconButton(
                                  icon: lockIcon,
                                  onPressed: () {
                                    lockPressed();
                                  }),
                            ),
                            validator: (val) {
                              if (val!.isEmpty) {
                                return "Please enter your password";
                              }
                              return null;
                            },
                          ),
                          decoration: ThemeHelper().inputBoxDecorationShaddow(),
                        ),
                        SizedBox(height: 10.0),
                        Container(
                          child: TextFormField(
                            controller: confirmpass,
                            obscureText: offsecureText1,
                            decoration: InputDecoration(
                              labelText: 'Vérification du mot de passe',
                              hintText: 'Veuillez vérifier votre mot de passe',
                              suffixIcon: IconButton(
                                  icon: lockIcon,
                                  onPressed: () {
                                    lockPressed1();
                                  }),
                            ),
                            validator: (String? value) {
                              if (value!.length == 0)
                                return "Le mot de passe ne peut rester vide";
                              if (value != pass.value.text)
                                return "Les mots de passe ne sont pas identiques";
                              return null;
                            }
                          ),
                          decoration: ThemeHelper().inputBoxDecorationShaddow(),
                        ),
                        SizedBox(height: 15.0),
                        TermsOfUse(),
                        // FormField<bool>(
                        //   builder: (state) {
                        //     return Column(
                        //       children: <Widget>[
                        //         Row(
                        //           children: <Widget>[
                        //             Checkbox(
                        //                 value: checkboxValue,
                        //                 onChanged: (value) {
                        //                   setState(() {
                        //                     checkboxValue = value!;
                        //                     state.didChange(value);
                        //                   });
                        //                 }),
                        //             Text(
                        //               "J'acceptes les ",
                        //               style: TextStyle(
                        //                   fontSize: 12, color: Colors.grey),
                        //             ),
                        //             InkWell(
                        //                 onTap: () {},
                        //                 child: Text(
                        //                   "termes et conditions.",
                        //                   style: TextStyle(
                        //                       fontSize: 12,
                        //                       color: Colors.blue[600]),
                        //                 ))
                        //           ],
                        //         ),
                        //         Container(
                        //           alignment: Alignment.centerLeft,
                        //           child: Text(
                        //             state.errorText ?? '',
                        //             textAlign: TextAlign.left,
                        //             style: TextStyle(
                        //               color: Theme.of(context).errorColor,
                        //               fontSize: 12,
                        //             ),
                        //           ),
                        //         )
                        //       ],
                        //     );
                        //   },
                        //   validator: (value) {
                        //     if (!checkboxValue) {
                        //       return 'Vous devez accepter les termes d\'utilisation';
                        //     } else {
                        //       return null;
                        //     }
                        //   },
                        // ),
                        SizedBox(height: 10.0),
                        Container(
                          decoration:
                              ThemeHelper().buttonBoxDecoration(context),
                          child: ElevatedButton(
                            style: ThemeHelper().buttonStyle(),
                            child: Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(40, 10, 40, 10),
                              child: Text(
                                "Enregister".toUpperCase(),
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                try {
                                  await FirebaseAuth.instance
                                      .createUserWithEmailAndPassword(
                                          email: email.text.trim(),
                                          password: pass.text.trim());


                                  Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                          builder: (context) => VerifyEmail()));
                                } on FirebaseAuthException catch (e) {
                                  CherryToast.error(
                                      title:  "",
                                      displayTitle:  false,
                                      description:  "Vérifiez votre connexion internet",
                                      animationType: ANIMATION_TYPE.fromTop,
                                      animationDuration: Duration(milliseconds:  2000),
                                      autoDismiss:  true
                                  ).show(context);
                                }

                              }
                            },
                          ),
                        ),
                        SizedBox(height: 10.0),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
