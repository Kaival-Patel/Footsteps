import 'package:flutter/material.dart';

class SignInModel with ChangeNotifier {
  String email;
  void changeemail(String email) {
    this.email = email;
    print("EMAIL:${email}");
    notifyListeners();
  }
}
