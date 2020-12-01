import 'package:flutter/material.dart';
import 'package:footsteps/Services/Authentication/UserRespository.dart';
import 'package:footsteps/screens/Portrait/Sign_in.dart';

class SettingPage extends StatefulWidget {
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
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
            UserRepository.instance().signOut();
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => Sign_In()));
          },
        ),
      ),
    );
  }
}
