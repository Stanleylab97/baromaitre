import 'dart:convert';
import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:connectivity/connectivity.dart';
import 'package:data_connection_checker_tv/data_connection_checker.dart';
import 'package:baromaitre/pages/lauching/register.dart';
import 'package:baromaitre/utils/commons/network_handler.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class MatriculeVerify extends StatefulWidget {
  const MatriculeVerify({Key? key}) : super(key: key);

  @override
  _MatriculeVerifyState createState() => _MatriculeVerifyState();
}

class _MatriculeVerifyState extends State<MatriculeVerify> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  var log = Logger();
  NetworkHandler networkHandler = NetworkHandler();
  late String token;
  bool circular = false;
  bool validate = false;
  TextEditingController matricule = TextEditingController();
  @override
  Widget build(BuildContext context) {
    //Communication Started with API
    Map<String, String> _login_data = {"email": "", "password": ""};

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 24, horizontal: 32),
          child: Column(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Icon(
                    Icons.arrow_back,
                    size: 32,
                    color: Colors.black54,
                  ),
                ),
              ),
              SizedBox(
                height: 18,
              ),
              Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.deepPurple.shade50,
                  shape: BoxShape.circle,
                ),
                child: Image.asset(
                  'assets/images/check_matricule.jpg',
                ),
              ),
              SizedBox(
                height: 24,
              ),
              Text(
                'Procédons à votre identification au barreau',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "Veuillez saisir votre matricule",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black38,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 28,
              ),
              Container(
                padding: EdgeInsets.all(28),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        maxLength: 12,
                        controller: matricule,
                        validator: (inputMatricule) {
                          if (inputMatricule!.toString().isEmpty)
                            return 'Veuillez entrer le matricule';

                          if (inputMatricule.length < 12)
                            return 'Le matricule doit être formé sur de 12 ciffres';

                          return null;
                        },
                        keyboardType: TextInputType.number,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black12),
                              borderRadius: BorderRadius.circular(10)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black12),
                              borderRadius: BorderRadius.circular(10)),
                          suffixIcon: Icon(
                            Icons.check_circle,
                            color: Colors.green,
                            size: 32,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 22,
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: circular
                            ? Center(child: CircularProgressIndicator())
                            : ElevatedButton(
                                onPressed: () {
                                  getTokenAndCheckMatricule(
                                      _login_data, matricule.text.trim());
                                },
                                style: ButtonStyle(
                                  foregroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.white),
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.blue),
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(24.0),
                                    ),
                                  ),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(14.0),
                                  child: Text(
                                    'Vérifier',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ),
                              ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> getTokenAndCheckMatricule(
      Map<String, String> login_data, String matricule_data) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      setState(() {
        validate = true;
        circular = true;
      });
      try {
        var isDeviceConnected = false;
        print('Inside try');
        verifyMatricule("4|LMCpg0lFbitmvyy6NQBcksbiyGhZIoZ1ADWKyoI6");
        if (true) {
          print('User device connected to internet');
          verifyMatricule("4|LMCpg0lFbitmvyy6NQBcksbiyGhZIoZ1ADWKyoI6");
          circular=false;
          // var response = await networkHandler.post("/users/register", login_data);
          // if (response.statusCode == 200 || response.statusCode == 201) {
          //   Map<String, dynamic> output = json.decode(response.body);
          //   /*setState(() {
          //     token = output["token"];
          //   });*/
          //  // verifyMatricule("4|LMCpg0lFbitmvyy6NQBcksbiyGhZIoZ1ADWKyoI6");
          // } else {
          //   CherryToast.error(
          //     title: '',
          //     enableIconAnimation: false,
          //     displayTitle: false,
          //     description: 'Invalid account information',
          //     animationType: ANIMATION_TYPE.fromRight,
          //     animationDuration: Duration(milliseconds: 1000),
          //     autoDismiss: true,
          //   ).show(context);
          //   Flushbar(
          //     message: "Une erreur s'est produite",
          //     icon: Icon(
          //       Icons.info_outline,
          //       size: 28.0,
          //       color: Colors.blue[300],
          //     ),
          //     duration: Duration(seconds: 3),
          //     leftBarIndicatorColor: Colors.blue[300],
          //   )..show(context);
          // }
        } else {
          Flushbar(
            title: "Hey Ninja",
            message:
                "Lorem Ipsum is simply dummy text of the printing and typesetting industry",
            flushbarPosition: FlushbarPosition.TOP,
            flushbarStyle: FlushbarStyle.FLOATING,
            reverseAnimationCurve: Curves.decelerate,
            forwardAnimationCurve: Curves.elasticOut,
            backgroundColor: Colors.red,
            boxShadows: [
              BoxShadow(
                  color: Colors.blue, offset: Offset(0.0, 2.0), blurRadius: 3.0)
            ],
            backgroundGradient:
                LinearGradient(colors: [Colors.blueGrey, Colors.black]),
            isDismissible: false,
            duration: Duration(seconds: 4),
            icon: Icon(
              Icons.info_outline,
              color: Colors.greenAccent,
            ),
            mainButton: FlatButton(
              onPressed: () {},
              child: Text(
                "BAD",
                style: TextStyle(color: Colors.amber),
              ),
            ),
            showProgressIndicator: true,
            progressIndicatorBackgroundColor: Colors.blueGrey,
            titleText: Text(
              "Connexion impossible",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                  color: Colors.yellow[600],
                  fontFamily: "ShadowsIntoLightTwo"),
            ),
            messageText: Text(
              "Vérifiez votre connexion internet!",
              style: TextStyle(
                  fontSize: 18.0,
                  color: Colors.green,
                  fontFamily: "ShadowsIntoLightTwo"),
            ),
          );
           circular = false;
        }
      } catch (e) {
        Flushbar(
          message: e.toString(),
          icon: Icon(
            Icons.info_outline,
            size: 28.0,
            color: Colors.blue[300],
          ),
          duration: Duration(seconds: 3),
          leftBarIndicatorColor: Colors.blue[300],
        )..show(context);
         circular = false;
      }
    }
  }

  Future<void> verifyMatricule(String token) async {
    try {
      var isDeviceConnected = false;

      if (true) {
        var response = await networkHandler.checkMatricule(
            "/api/verify-matricule/" + matricule.text.trim(), token);
        if (response.statusCode == 200 || response.statusCode == 201) {
          Map<String, dynamic> output = json.decode(response.body);
          print(response);
          print(output);
          setState(() {
            circular = false;
            validate = false;
          });
          var avocat = response;
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => RegistrationPage(avocat: avocat),
              ),
              (route) => false);
        } else if (response.statusCode == 404) {
          CherryToast.error(
              title:  "",
              displayTitle:  false,
              description:  "Ce matricule n'est pas reconnu!",
              animationType: ANIMATION_TYPE.fromTop,
              animationDuration: Duration(milliseconds:  2000),
              autoDismiss:  true
          ).show(context);

        } else {
          CherryToast.info(
            title:  "Désolé",
            action:  "Une erreur s'est produite",
            actionHandler: (){
              print("Action button pressed");
            },
          ).show(context);
        }
      } else {
        Flushbar(
          title: "Hey Ninja",
          message:
              "Lorem Ipsum is simply dummy text of the printing and typesetting industry",
          flushbarPosition: FlushbarPosition.TOP,
          flushbarStyle: FlushbarStyle.FLOATING,
          reverseAnimationCurve: Curves.decelerate,
          forwardAnimationCurve: Curves.elasticOut,
          backgroundColor: Colors.red,
          boxShadows: [
            BoxShadow(
                color: Colors.blue, offset: Offset(0.0, 2.0), blurRadius: 3.0)
          ],
          backgroundGradient:
              LinearGradient(colors: [Colors.blueGrey, Colors.black]),
          isDismissible: false,
          duration: Duration(seconds: 4),
          icon: Icon(
            Icons.info_outline,
            color: Colors.greenAccent,
          ),
          mainButton: FlatButton(
            onPressed: () {},
            child: Text(
              "BAD",
              style: TextStyle(color: Colors.amber),
            ),
          ),
          showProgressIndicator: true,
          progressIndicatorBackgroundColor: Colors.blueGrey,
          titleText: Text(
            "Connexion impossible",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
                color: Colors.yellow[600],
                fontFamily: "ShadowsIntoLightTwo"),
          ),
          messageText: Text(
            "Vérifiez votre connexion internet!",
            style: TextStyle(
                fontSize: 18.0,
                color: Colors.green,
                fontFamily: "ShadowsIntoLightTwo"),
          ),
        );
      }
    } catch (e) {
      CherryToast.error(
          title:  "",
          displayTitle:  false,
          description:  e.toString(),
          animationType: ANIMATION_TYPE.fromTop,
          animationDuration: Duration(milliseconds:  2000),
          autoDismiss:  true
      ).show(context);
    }
  }

  showError(String errormessage) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Errreur'),
            content: Text(errormessage),
            actions: <Widget>[
              FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'))
            ],
          );
        });
  }

  Future<bool> isConnected()  async {

      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.mobile) {
        // I am connected to a mobile network, make sure there is actually a net connection.
        if (await DataConnectionChecker().hasConnection) {
          // Mobile data detected & internet connection confirmed.
          return true;
        } else {
          // Mobile data detected but no internet connection found.
          return false;
        }
      } else if (connectivityResult == ConnectivityResult.wifi) {
        // I am connected to a WIFI network, make sure there is actually a net connection.
        if (await DataConnectionChecker().hasConnection) {
          // Wifi detected & internet connection confirmed.
          return true;
        } else {
          // Wifi detected but no internet connection found.
          return false;
        }
      } else {
        // Neither mobile data or WIFI detected, not internet connection found.
        return false;
      }
    }


}
