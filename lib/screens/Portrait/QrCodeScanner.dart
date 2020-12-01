import 'dart:async';
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:footsteps/components/Dialogs/centerBottomToast.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:footsteps/Services/Authentication/fcmTokenManager.dart';
import 'package:footsteps/config/size_config.dart';
import 'package:footsteps/config/styling.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QrCodeScanner extends StatefulWidget {
  @override
  _QrCodeScannerState createState() => _QrCodeScannerState();
}

class _QrCodeScannerState extends State<QrCodeScanner> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  String qrText;
  FirebaseMessaging _fcm = FirebaseMessaging();
  QRViewController controller;
  FirebaseDatabase _database = FirebaseDatabase.instance;
  fcmTokenManager fcmManager = fcmTokenManager();
  FirebaseAuth user;
  centerBottomToast cbt = centerBottomToast();
  String serverToken =
      "AAAApcJlIiE:APA91bHtmvYY5dUoVuaSrxuvNOfamxOy6xtNuiAUv8tNqQxbysSYXRLJI3YiYF3OnaLYZHWjoeg2_K43GmFrcDSjeQbxHZceM_zrtwY-D6c2eutoMmXqs35bi_Ty0q4YkrQyuV1LzG5E";
  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance;
    //fcmTokenManager.startFCMService(context);
    if (user.currentUser == null) {
      print("NO USER FOUND!!");
      Navigator.pop(context);
    }
    //startFCMService();
  }

  Future<void> startFCMService() async {
    FirebaseMessaging _fcm = FirebaseMessaging();
    print("....::::STARTING FCM SERVICE::::....");
    _fcm.configure(
        onMessage: (Map<String, dynamic> message) async {
          print("onMessage: $message");
          showDialog(
              context: context,
              child: Container(
                height: SizeConfig.heightMultiplier * 20,
                child: AlertDialog(
                  title: Text(
                    message['notification']['title'],
                    style: TextStyle(fontSize: SizeConfig.textMultiplier * 3),
                  ),
                  content: Text(message['notification']['body']),
                  actions: [
                    ButtonBar(
                      children: [
                        FlatButton(
                          onPressed: () async {
                            //TODO:When user click yes to approve connection
                          },
                          child: Text(
                            "Yes",
                            style: TextStyle(
                                fontSize: SizeConfig.textMultiplier * 2),
                          ),
                          color: AppTheme.appDarkVioletColor,
                        ),
                        FlatButton(
                          onPressed: () async {
                            Navigator.pop(context);
                          },
                          child: Text(
                            "No",
                            style: TextStyle(
                                fontSize: SizeConfig.textMultiplier * 2,
                                color: Colors.grey),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ));
        },
        onLaunch: (Map<String, dynamic> message) async {
          print("onLaunch: $message");
          showDialog(
              context: context,
              child: Container(
                height: SizeConfig.heightMultiplier * 20,
                child: AlertDialog(
                  title: Text(
                    message['notification']['title'],
                    style: TextStyle(fontSize: SizeConfig.textMultiplier * 3),
                  ),
                  content: Text(message['notification']['body']),
                  actions: [
                    ButtonBar(
                      children: [
                        FlatButton(
                          onPressed: () async {
                            //TODO:When user click yes to approve connection
                          },
                          child: Text(
                            "Yes",
                            style: TextStyle(
                                fontSize: SizeConfig.textMultiplier * 2),
                          ),
                          color: AppTheme.appDarkVioletColor,
                        ),
                        FlatButton(
                          onPressed: () async {
                            Navigator.pop(context);
                          },
                          child: Text(
                            "No",
                            style: TextStyle(
                                fontSize: SizeConfig.textMultiplier * 2,
                                color: Colors.grey),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ));
          // TODO optional
        },
        onResume: (Map<String, dynamic> message) async {
          print("onResume: $message");
          showDialog(
              context: context,
              child: Container(
                height: SizeConfig.heightMultiplier * 20,
                child: AlertDialog(
                  title: Text(
                    message['notification']['title'],
                    style: TextStyle(fontSize: SizeConfig.textMultiplier * 3),
                  ),
                  content: Text(message['notification']['body']),
                  actions: [
                    ButtonBar(
                      children: [
                        FlatButton(
                          onPressed: () async {
                            //TODO:When user click yes to approve connection
                          },
                          child: Text(
                            "Yes",
                            style: TextStyle(
                                fontSize: SizeConfig.textMultiplier * 2),
                          ),
                          color: AppTheme.appDarkVioletColor,
                        ),
                        FlatButton(
                          onPressed: () async {
                            Navigator.pop(context);
                          },
                          child: Text(
                            "No",
                            style: TextStyle(
                                fontSize: SizeConfig.textMultiplier * 2,
                                color: Colors.grey),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ));
          // TODO optional
        },
        onBackgroundMessage: fcmTokenManager.myBackgroundMessageHandler);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            flex: 5,
            child: QRView(key: qrKey, onQRViewCreated: _onQRViewCreated),
          ),
          Expanded(
              child: Center(
                  child: Column(children: [
            qrText == null
                ? Text("Point the camera towards Qr Code to Scan")
                : Text("Scanned Result:${qrText}"),
            if (qrText != null && RegExp(r'^[a-zA-Z0-9]+$').hasMatch(qrText))
              CircularProgressIndicator(),
          ])))
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        qrText = scanData;
        controller.pauseCamera();
        if (RegExp(r'^[a-zA-Z0-9]+$').hasMatch(qrText)) {
          searchUserWithCode(qrText);
        } else {
          print("Different QR CODE SCANNED!!");
          controller.resumeCamera();
        }
      });
    });
  }

  Future<void> searchUserWithCode(String code) async {
    _database.reference().child('Users').once().then((DataSnapshot snapData) {
      Map<dynamic, dynamic> snap = snapData.value;
      //snap.keys will give uids
      snap.forEach((key, value) {
        if (value['Ucode'] == qrText) {
          //key will give that user's UID from which we shall Connect
          print("Device TOKEN:${value['device_token']}");
          if (value['device_token'] != null) {
            _database
                .reference()
                .child('Users')
                .child(key)
                .child('Profile')
                .once()
                .then((DataSnapshot profileSnapshot) {
              showDialog(
                  context: context,
                  barrierDismissible: false,
                  child: Container(
                    height: SizeConfig.heightMultiplier * 20,
                    child: AlertDialog(
                      title: Text(
                        "Add Tracker",
                        style:
                            TextStyle(fontSize: SizeConfig.textMultiplier * 3),
                      ),
                      content: Text(
                          "Do you want to add ${profileSnapshot.value['name']} for tracking?"),
                      actions: [
                        ButtonBar(
                          children: [
                            FlatButton(
                              onPressed: () async {
                                Navigator.pop(context);
                                await fcmManager
                                    .sendNotification(
                                        user.currentUser, value['device_token'])
                                    .then((value) {
                                  cbt.showCenterFlash(
                                    bgColor: Colors.green,
                                    msgtext: "Tracking Request Sent",
                                    borderColor: Colors.white,
                                    textColor: Colors.white,
                                    duration: Duration(seconds: 3),
                                    ctx: context,
                                    alignment: Alignment.bottomCenter,
                                  );
                                });
                                
                              },
                              child: Text(
                                "Yes",
                                style: TextStyle(
                                    fontSize: SizeConfig.textMultiplier * 2),
                              ),
                              color: AppTheme.appDarkVioletColor,
                            ),
                            FlatButton(
                              onPressed: () async {
                                Navigator.pop(context);
                                setState(() {
                                  qrText = null;
                                });
                                controller.resumeCamera();
                              },
                              child: Text(
                                "No",
                                style: TextStyle(
                                    fontSize: SizeConfig.textMultiplier * 2,
                                    color: Colors.grey),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ));
            });
          } else {
            cbt.showCenterFlash(
              bgColor: Colors.red,
              msgtext: "Couldnt get User device to send request!",
              borderColor: Colors.white,
              textColor: Colors.red,
              duration: Duration(seconds: 3),
              ctx: context,
              alignment: Alignment.bottomCenter,
            );
          }
        }
      });
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
