import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'auth_service.dart';
//import 'package:footsteps/Services/Authentication/auth_service.dart';

class FirebaseAuthService implements AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  UserInformation _userfromFirebase(User user) {
    if (user == null) {
      return null;
    }
    return UserInformation(uid: user.uid);
  }

  @override
  Stream<UserInformation> get onAuthStateChanged {
    return _firebaseAuth.authStateChanges().map(_userfromFirebase);
  }

  @override
  Future<UserInformation> signUpwithEmailandPassword(String email, String password) async {
    final UserCredential userCredential = await _firebaseAuth
        .createUserWithEmailAndPassword(email: email, password: password);
    return _userfromFirebase(userCredential.user);
  }

  @override
  Future<UserInformation> signInwithEmailandPassword(String email, String password) async {
    final UserCredential userCredential = await _firebaseAuth
        .signInWithEmailAndPassword(email: email, password: password);
    return _userfromFirebase(userCredential.user);
  }

  @override
  Future<UserInformation> currentUser() async {
    final User user = _firebaseAuth.currentUser;
    return _userfromFirebase(user);
  }

  @override
  Future<void> signOut() async {
    return _firebaseAuth.signOut();
  }

  @override
  Future<void> sendPasswordResetLink(String email) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  @override
  void dispose() {}
}
