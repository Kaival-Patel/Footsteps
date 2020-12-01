import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

@immutable
class UserInformation {
  const UserInformation({
    @required this.uid,
    this.email,
    this.photoUrl,
    this.displayName,
  });
  final String uid;
  final String email;
  final String photoUrl;
  final String displayName;
}

abstract class AuthService {
  Future<UserInformation> currentUser();
  Future<UserInformation> signUpwithEmailandPassword(String email, String password);
  Future<UserInformation> signInwithEmailandPassword(String email, String password);
  Future<void> sendPasswordResetLink(String email);
  Future<void> signOut();
  Stream<UserInformation> get onAuthStateChanged;
  void dispose();
}
