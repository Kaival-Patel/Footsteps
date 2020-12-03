import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:footsteps/Services/Authentication/FirebaseSignOut.dart';
import 'package:footsteps/Services/Authentication/UserRespository.dart';
import 'package:footsteps/components/Dialogs/centerBottomToast.dart';
import 'package:footsteps/config/styling.dart';
import 'package:footsteps/screens/Portrait/QrCodeScanner.dart';
import 'package:footsteps/screens/Portrait/Sign_in.dart';
import 'package:permission_handler/permission_handler.dart';

class ManageTracker extends StatefulWidget {
  @override
  _ManageTrackerState createState() => _ManageTrackerState();
}

class _ManageTrackerState extends State<ManageTracker> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  dynamic userrepo;
  FirebaseSignOut firebaseSignOut;
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
      floatingActionButton: FloatingActionButton.extended(
        label: Text("Add Tracker"),
        backgroundColor: AppTheme.appOrangeColor,
        icon: Icon(Icons.qr_code_scanner),
        isExtended: true,
        onPressed: () {
          openQRCodeScanner();
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      
    );
  }

  Future<void> openQRCodeScanner() async {
    if (await Permission.camera.isGranted) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => QrCodeScanner()));
    } else if (await Permission.camera.isDenied ||
        await Permission.camera.isUndetermined ||
        await Permission.camera.isRestricted) {
      Permission.camera.request().then((value) {
        if (value.isGranted) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => QrCodeScanner()));
        } else {
          centerBottomToast().showCenterFlash(
            alignment: Alignment.bottomCenter,
            bgColor: Colors.white,
            textColor: Colors.red,
            borderColor: Colors.redAccent,
            ctx: context,
            duration: Duration(seconds: 3),
            msgtext: "Please Allow us Camera Permission to Scan QR Code",
          );
        }
      });
    } else {
      centerBottomToast().showCenterFlash(
        alignment: Alignment.bottomCenter,
        bgColor: Colors.white,
        textColor: Colors.red,
        borderColor: Colors.redAccent,
        ctx: context,
        duration: Duration(seconds: 3),
        msgtext: "Please Allow us Camera Permission to Scan QR Code",
      );
    }
  }
}
