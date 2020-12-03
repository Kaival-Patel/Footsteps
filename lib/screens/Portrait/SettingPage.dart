import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:footsteps/Services/Authentication/FirebaseSignOut.dart';
import 'package:footsteps/Services/Authentication/UserRespository.dart';
import 'package:footsteps/screens/Portrait/Sign_in.dart';

class SettingPage extends StatefulWidget {
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  dynamic userrepo;
  FirebaseSignOut firebaseSignOut=FirebaseSignOut();
  @override
  void initState() {
    super.initState();
    if (_auth.currentUser == null) {
      firebaseSignOut.signOut(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: RaisedButton(
          color: Colors.red,
          child: Text(
            "Logout",
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () {
            firebaseSignOut.signOut(context);
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => Sign_In()));
          },
        ),
      ),
    );
  }
}
