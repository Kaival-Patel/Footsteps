import 'ValidateField.dart';
import 'package:flutter/material.dart';

class sign_in_validation with ChangeNotifier {
  ValidateField _email = ValidateField(null, null);
  ValidateField _pwd = ValidateField(null, null);
  ValidateField get email => _email;
  ValidateField get pwd => _pwd;
  String get emailvalue => _email.value;
  String get pwdvalue => _pwd.value;
  

  bool get isValid {
    if (_email != null && _pwd != null) {
      return true;
    } else {
      return false;
    }
  }

  void changeEmail(String value) {
    if (RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(value)) {
      _email = ValidateField(value, null);
      print(email.value);
    } else {
      _email = ValidateField(
          null, "Logging in with a valid email would be a Good Idea!");
    }

    notifyListeners();
  }

  void changePassword(String value) {
    if (value.isNotEmpty) {
      _pwd = ValidateField(value, null);
      print(pwd.value);
    } else {
      _pwd = ValidateField(null, "Without Password, we cannot let you in!");
    }
    notifyListeners();
  }

  void submitData() {
    print("Email:$emailvalue");
    print("Password:$pwdvalue");
    //notifyListeners();
  }
}
