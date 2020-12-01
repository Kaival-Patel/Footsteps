import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:footsteps/Services/Authentication/auth_service.dart';
import 'package:footsteps/Services/Authentication/firebase_auth_service.dart';

enum AuthServiceType { firebase }

class AuthServiceAdapter implements AuthService {
  AuthServiceAdapter({@required AuthServiceType initAuthServiceType})
      : authServiceTypeNotifier =
            ValueNotifier<AuthServiceType>(initAuthServiceType) {
    _setup();
  }

  final FirebaseAuthService _firebaseAuthService = FirebaseAuthService();
  final ValueNotifier<AuthServiceType> authServiceTypeNotifier;
  AuthServiceType get authServiceType => authServiceTypeNotifier.value;
  AuthService get authService =>
      authServiceType == AuthServiceType.firebase ? _firebaseAuthService : null;

  StreamSubscription<UserInformation> _firebaseAuthSubscription;
  void _setup() {
    _firebaseAuthSubscription =
        _firebaseAuthService.onAuthStateChanged.listen((UserInformation user) {
      if (authServiceType == AuthServiceType.firebase) {
        _onAuthStateChangedController.add(user);
      }
    }, onError: (dynamic error) {
      if (authServiceType == AuthServiceType.firebase) {
        _onAuthStateChangedController.addError(error);
      }
    });
  }
  @override
  void dispose() {
    _firebaseAuthSubscription?.cancel();
    _onAuthStateChangedController?.close();
    authServiceTypeNotifier.dispose();
  }
  final StreamController<UserInformation> _onAuthStateChangedController =
      StreamController<UserInformation>.broadcast();
  @override
  Stream<UserInformation> get onAuthStateChanged => _onAuthStateChangedController.stream;

  @override
  Future<UserInformation> currentUser() => authService.currentUser();

  @override
  Future<UserInformation> signUpwithEmailandPassword(String email, String password) =>
      authService.signUpwithEmailandPassword(email, password);

  @override
  Future<UserInformation> signInwithEmailandPassword(String email, String password) =>
      authService.signInwithEmailandPassword(email, password);

  @override
  Future<void> sendPasswordResetLink(String email) =>
      authService.sendPasswordResetLink(email);

  @override
  Future<void> signOut() => authService.signOut();
}
