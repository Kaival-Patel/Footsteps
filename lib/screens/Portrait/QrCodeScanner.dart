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
  String currentUserUcode;
  TextEditingController trackerCodeController = TextEditingController();
  String serverToken =
      "AAAApcJlIiE:APA91bHtmvYY5dUoVuaSrxuvNOfamxOy6xtNuiAUv8tNqQxbysSYXRLJI3YiYF3OnaLYZHWjoeg2_K43GmFrcDSjeQbxHZceM_zrtwY-D6c2eutoMmXqs35bi_Ty0q4YkrQyuV1LzG5E";
  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance;
    if (user.currentUser == null) {
      print("NO USER FOUND!!");
      Navigator.pop(context);
    }
    FirebaseDatabase.instance
        .reference()
        .child('Users')
        .child(user.currentUser.uid)
        .once()
        .then((DataSnapshot datasnapshot) {
      currentUserUcode = datasnapshot.value['Ucode'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            flex: 4,
            child: QRView(key: qrKey, onQRViewCreated: _onQRViewCreated),
          ),
          Expanded(
              child: Center(
                  child: Column(children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  icon: Icon(Icons.flash_on),
                  color: Colors.yellow,
                  onPressed: () {
                    setState(() {
                      controller.toggleFlash();
                    });
                  },
                ),
                IconButton(
                  icon: Icon(Icons.refresh),
                  color: Colors.blue,
                  onPressed: () {
                    setState(() {
                      qrText = null;
                      controller.resumeCamera();
                    });
                  },
                ),
              ],
            ),
            qrText == null
                ? Text("Point the camera towards Qr Code to Scan")
                : Text("Scanned Result:${qrText}"),
            if (qrText != null && RegExp(r'^[a-zA-Z0-9]+$').hasMatch(qrText))
              CircularProgressIndicator(),
            if (qrText == null)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Center(
                    child: Container(
                      width: SizeConfig.widthMultiplier * 50,
                      child: TextFormField(
                        decoration: InputDecoration(
                            hintText: "Add by Tracker Code",
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide(
                                    color: AppTheme.appDarkVioletColor))),
                        controller: trackerCodeController,
                      ),
                    ),
                  ),
                  Container(
                    width: SizeConfig.widthMultiplier * 30,
                    child: RaisedButton(
                      child: Text(
                        "Search",
                        style: TextStyle(
                            fontSize: SizeConfig.textMultiplier * 2,
                            color: Colors.white),
                      ),
                      color: AppTheme.appDarkVioletColor,
                      onPressed: () {
                        if (trackerCodeController.text.isNotEmpty) {
                          print(trackerCodeController.text);
                          setState(() {
                            searchUserWithCode(trackerCodeController.text);
                          });
                        } else {
                          cbt.showCenterFlash(
                            bgColor: Colors.red,
                            msgtext: "Please enter the code!",
                            borderColor: Colors.white,
                            textColor: Colors.white,
                            duration: Duration(seconds: 3),
                            ctx: context,
                            alignment: Alignment.bottomCenter,
                          );
                        }
                      },
                    ),
                  ),
                ],
              )
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
    print("SEARCHING USER WITH UCODE ${code}");
    _database.reference().child('Users').once().then((DataSnapshot snapData) {
      Map<dynamic, dynamic> snap = snapData.value;
      //snap.keys will give uids
      snap.forEach((key, value) {
        if (value['Ucode'] == code) {
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
                          "Do you want to add ${profileSnapshot.value['name']} with Username(${value['Ucode']}) for tracking?"),
                      actions: [
                        ButtonBar(
                          children: [
                            FlatButton(
                              onPressed: () async {
                                Navigator.pop(context);

                                //ADD OUTGOING NOTIFICATIONS TO SENDER AND RECIPIENT TO SHOW IN UI
                                addOutgoingNotificationToSender(user.currentUser.uid,key,value['Ucode']);
                                addIncomingNotificationToRecipient(user.currentUser.uid,key,currentUserUcode);
                                
                                //SEND FCM NOTIFICATION TO RECIPIENT DEVICE
                                await fcmManager
                                    .sendNotification(user.currentUser,
                                        value['device_token'], currentUserUcode)
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
              textColor: Colors.white,
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

  Future<void> addOutgoingNotificationToSender(
      String senderUid, String recipientUid,String recipientCode,) async {
      await _database
          .reference()
          .child('Users')
          .child(senderUid)
          .child('Notifications')
          .child('Outgoing Tracking Request')
          .child(DateTime.now().millisecondsSinceEpoch.toString())
          .set({
            'type':'outgoing_tracking_request',
            'to':recipientUid,
            'recipient_code':recipientCode
          }).catchError((e)=>print(e)).whenComplete(() => print("DATABASE OUTGOING NOTIF SENT!!"));
  }

  Future<void> addIncomingNotificationToRecipient(String senderUid, String recipientUid,String senderCode) async {
    await _database
          .reference()
          .child('Users')
          .child(recipientUid)
          .child('Notifications')
          .child('Incoming Tracking Request')
          .child(DateTime.now().millisecondsSinceEpoch.toString())
          .set({
            'type':'incoming_tracking_request',
            'from':senderUid,
            'recipient_code':senderCode
          }).catchError((e)=>print(e)).whenComplete(() => print("DATABASE INCOMING NOTIF SENT!!"));
  }
}
