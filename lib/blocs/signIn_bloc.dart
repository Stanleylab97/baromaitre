import 'package:baromaitre/models/firebase_loyer.dart';
import 'package:baromaitre/models/loyer_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:package_info/package_info.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignInBloc extends ChangeNotifier {
  SignInBloc() {
    checkSignIn();
    checkGuestUser();
    initPackageInfo();
  }

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  final String defaultUserImageUrl =
      'https://www.oxfordglobal.co.uk/nextgen-omics-series-us/wp-content/uploads/sites/16/2020/03/Jianming-Xu-e5cb47b9ddeec15f595e7000717da3fe.png';

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  bool _guestUser = false;
  bool get guestUser => _guestUser;

  bool _isSignedIn = false;
  bool get isSignedIn => _isSignedIn;

  bool _hasError = false;
  bool get hasError => _hasError;

  late String _errorCode;
  String get errorCode => _errorCode;

  late FirebaseLoyer _firebaseLoyer;
  FirebaseLoyer get firebaseLoyer => _firebaseLoyer;

  String? _signInProvider;
  String? get signInProvider => _signInProvider;

  late String timestamp;

  String _appVersion = '0.0';
  String get appVersion => _appVersion;

  String _packageName = '';
  String get packageName => _packageName;

  void initPackageInfo() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    _appVersion = packageInfo.version;
    _packageName = packageInfo.packageName;
    notifyListeners();
  }

  Future signUpwithEmailPassword(
      LoyerAppData newloyerData, userPassword) async {
    try {
      final User? user = (await _firebaseAuth.createUserWithEmailAndPassword(
        email: newloyerData.email,
        password: userPassword,
      ))
          .user;
      assert(user != null);
      assert(await user!.getIdToken() != null);
      this._firebaseLoyer=FirebaseLoyer(loyerDataGotFromAPI: LoyerAppData(matricule: newloyerData.matricule,nom: newloyerData.nom,prenom: newloyerData.prenom, sexe: newloyerData.sexe,email: newloyerData.email,specialite: newloyerData.specialite,country_code: newloyerData.country_code,contact: newloyerData.contact,cabinet: newloyerData.cabinet,dateSermont: newloyerData.dateSermont), status: "Offline", description: "", imageUrl: defaultUserImageUrl, lastseen: FieldValue.serverTimestamp(),signInProvider: "email",createdAt: FieldValue.serverTimestamp());
      _hasError = false;
      notifyListeners();
    } catch (e) {
      _hasError = true;
      _errorCode = e.toString();
      notifyListeners();
    }
  }

  Future signInwithEmailPassword(userEmail, userPassword) async {
    try {
      final User? user = (await _firebaseAuth.signInWithEmailAndPassword(
          email: userEmail, password: userPassword))
          .user;
      assert(user != null);
      assert(await user?.getIdToken() != null);
      final User? currentUser = _firebaseAuth.currentUser;
      this._firebaseLoyer.uid = currentUser!.uid;
      FirebaseFirestore.instance
          .collection('users')
          .doc(this._firebaseLoyer.uid)
          .get()
          .then((DocumentSnapshot documentSnapshot) {
        if (documentSnapshot.exists) {

          this._firebaseLoyer.imageUrl = documentSnapshot['profileUrl'];
        } else {
          print('Document does not exist on the database');
        }
      });

      _hasError = false;
      notifyListeners();
    } catch (e) {
      _hasError = true;
      _errorCode = e.toString();
      notifyListeners();
    }
  }

  Future<bool> checkUserExists() async {
    DocumentSnapshot snap = await firestore.collection('users').doc(_firebaseLoyer.uid).get();
    if (snap.exists) {
      print('User Exists');
      return true;
    } else {
      print('new user');
      return false;
    }
  }

  Future saveToFirebase() async {
    final DocumentReference ref =
    FirebaseFirestore.instance.collection('users').doc(_firebaseLoyer.uid);
    // var userData = {
    //   'name': _name,
    //   'email': _email,
    //   'uid': _uid,
    //   'status': _status,
    //   'lastseen':FieldValue.serverTimestamp().toString(),
    //   'profileUrl': _imageUrl,
    //   'category': _category,
    //   'timestamp': timestamp,
    //   'loved items': [],
    //   'bookmarked items': []
    // };

    await ref.set(_firebaseLoyer);
    print('Data save to FB');
  }

  Future getTimestamp() async {
    DateTime now = DateTime.now();
    String _timestamp = DateFormat('yyyyMMddHHmmss').format(now);
    timestamp = _timestamp;
  }

  Future saveDataToSP() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();

    await sp.setString('uid', _firebaseLoyer.uid.toString());
    await sp.setString('nome', _firebaseLoyer.loyerDataGotFromAPI.nom);
    await sp.setString('prenom', _firebaseLoyer.loyerDataGotFromAPI.prenom);
    await sp.setInt('matricule', _firebaseLoyer.loyerDataGotFromAPI.matricule);
    await sp.setString('contact', _firebaseLoyer.loyerDataGotFromAPI.contact);
    await sp.setString('email', _firebaseLoyer.loyerDataGotFromAPI.email);
    await sp.setString('specialite', _firebaseLoyer.loyerDataGotFromAPI.specialite);
    await sp.setString('sexe', _firebaseLoyer.loyerDataGotFromAPI.sexe);
    await sp.setString('date_sermont', _firebaseLoyer.loyerDataGotFromAPI.dateSermont);
    await sp.setString('cabinet', _firebaseLoyer.loyerDataGotFromAPI.cabinet);
    await sp.setString('country_code', _firebaseLoyer.loyerDataGotFromAPI.country_code);
    await sp.setString('imageUrl', _firebaseLoyer.imageUrl);
    await sp.setString('sign_in_provider', _firebaseLoyer.signInProvider);
    await sp.setString('description', _firebaseLoyer.description);

  }

  Future getDataFromSp() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    _firebaseLoyer.loyerDataGotFromAPI.nom = sp.getString('nom').toString();
    _firebaseLoyer.loyerDataGotFromAPI.prenom = sp.getString('prenom').toString();
    _firebaseLoyer.loyerDataGotFromAPI.contact = sp.getString('contrat').toString();
    _firebaseLoyer.loyerDataGotFromAPI.matricule = sp.getInt('matricule')!.toInt();
    _firebaseLoyer.loyerDataGotFromAPI.country_code = sp.getString('country_code').toString();
    _firebaseLoyer.loyerDataGotFromAPI.cabinet = sp.getString('cabinet').toString();
    _firebaseLoyer.loyerDataGotFromAPI.dateSermont = sp.getString('date_sermont').toString();
    _firebaseLoyer.loyerDataGotFromAPI.sexe = sp.getString('sexe').toString();
    _firebaseLoyer.loyerDataGotFromAPI.specialite = sp.getString('specialite').toString();
    _firebaseLoyer.imageUrl = sp.getString('imageUrl').toString();
    _firebaseLoyer.uid = sp.getString('uid').toString();
    _firebaseLoyer.description=sp.getString('description').toString();
    _firebaseLoyer.signInProvider = sp.getString('sign_in_provider').toString();

    notifyListeners();
  }

  Future getUserDatafromFirebase(uid) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .get()
        .then((DocumentSnapshot snap) {
      this._firebaseLoyer = FirebaseLoyer(uid: snap['uid'],loyerDataGotFromAPI: LoyerAppData(matricule: snap['matricule'], nom: snap['nom'], prenom:  snap['prenom'],sexe:  snap['sexe'],email: snap['email'] , specialite: snap['specialite'],country_code: snap['country_code'],contact:snap['contact'] ,cabinet: snap['cabinet'] ,dateSermont:snap['dateSermont']), status: snap['status'], description: snap['description'], imageUrl: snap['imageUrl'] , lastseen: snap['lastseen'] , signInProvider: snap['signInProvider'], createdAt: snap['createdAt'] ) ;

      print(_firebaseLoyer.loyerDataGotFromAPI.nom);
    });
    notifyListeners();
  }

  Future setSignIn() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setBool('signed_in', true);
    _isSignedIn = true;
    notifyListeners();
  }

  void checkSignIn() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    _isSignedIn = sp.getBool('signed_in') ?? false;
    notifyListeners();
  }

  Future userSignout() async {

    if (_signInProvider == 'email') {
      await _firebaseAuth.signOut();
    }
  }

  Future afterUserSignOut() async {
    await userSignout().then((value) async {
      await clearAllData();
      _isSignedIn = false;
      _guestUser = false;
      notifyListeners();
    });
  }

  Future setGuestUser() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    await sp.setBool('guest_user', true);
    _guestUser = true;
    notifyListeners();
  }

  void checkGuestUser() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    _guestUser = sp.getBool('guest_user') ?? false;
    notifyListeners();
  }

  Future clearAllData() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    sp.clear();
  }

  Future guestSignout() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    await sp.setBool('guest_user', false);
    _guestUser = false;
    notifyListeners();
  }

  Future updateUserProfile(String newName, String newImageUrl) async {
    final SharedPreferences sp = await SharedPreferences.getInstance();

    FirebaseFirestore.instance
        .collection('users')
        .doc(_firebaseLoyer.uid)
        .update({'name': newName, 'imageUrl': newImageUrl});

    sp.setString('name', newName);
    sp.setString('imageUrl', newImageUrl);
    _firebaseLoyer.loyerDataGotFromAPI.nom = newName;
    _firebaseLoyer.imageUrl = newImageUrl;

    notifyListeners();
  }

  Future<int> getTotalUsersCount() async {
    final String fieldName = 'count';
    final DocumentReference ref =
    firestore.collection('item_count').doc('users_count');
    DocumentSnapshot snap = await ref.get();
    if (snap.exists == true) {
      int itemCount = snap[fieldName] ?? 0;
      return itemCount;
    } else {
      await ref.set({fieldName: 0});
      return 0;
    }
  }

  Future increaseUserCount() async {
    await getTotalUsersCount().then((int documentCount) async {
      await firestore
          .collection('item_count')
          .doc('users_count')
          .update({'count': documentCount + 1});
    });
  }
}