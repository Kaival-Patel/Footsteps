import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:footsteps/screens/Portrait/Sign_in.dart';

class FirebaseSignOut {
  Future<void> signOut(BuildContext context) async {
    FirebaseDatabase _database = FirebaseDatabase.instance;
    FirebaseAuth _auth = FirebaseAuth.instance; 
    _database
        .reference()
        .child('Users')
        .child(_auth.currentUser.uid)
        .child('device_token')
        .remove();
    _auth.signOut();
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => Sign_In(),
        ));
  }
}
