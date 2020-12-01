import 'dart:async';
import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:footsteps/config/size_config.dart';
import 'package:footsteps/config/styling.dart';
import 'package:http/http.dart' as http;

class fcmTokenManager {
  FirebaseMessaging _fcm = FirebaseMessaging();
  
  String serverToken =
      "AAAApcJlIiE:APA91bHtmvYY5dUoVuaSrxuvNOfamxOy6xtNuiAUv8tNqQxbysSYXRLJI3YiYF3OnaLYZHWjoeg2_K43GmFrcDSjeQbxHZceM_zrtwY-D6c2eutoMmXqs35bi_Ty0q4YkrQyuV1LzG5E";
  Future<Map<String, dynamic>> sendNotification(User user,String deviceToken) async {
    print("FCM TOKEN SEND NOTI:$deviceToken");
    await http.post(
      "https://fcm.googleapis.com/fcm/send",
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'key=$serverToken',
      },
      body: jsonEncode(
        <String, dynamic>{
          'notification': <String, dynamic>{
            'body': '${user.displayName} wants to add you as tracker!',
            'title': 'Incoming Tracking Request'
          },
          'priority': 'high',
          'data': <String, dynamic>{
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'id': '1',
            'status': 'done'
          },
          'to': deviceToken
        },
      ),
    );
    final Completer<Map<String, dynamic>> completer =
        Completer<Map<String, dynamic>>();
    _fcm.configure(onMessage: (Map<String, dynamic> message) async {
      completer.complete(message);
    });
    return completer.future;
  }

  static Future<void> startFCMService(BuildContext context) async {
    FirebaseMessaging _fcm = FirebaseMessaging();
    print("STARTED FCM SERVICE FROM MAIN!!!");
    _fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("Message REVOKED:-> $message");
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
      onBackgroundMessage: fcmTokenManager.myBackgroundMessageHandler
    );
  }

  


  static Future<dynamic> myBackgroundMessageHandler(
      Map<String, dynamic> message) async {
    if (message.containsKey('data')) {
      // Handle data message
      final dynamic data = message['data'];
    }

    if (message.containsKey('notification')) {
      // Handle notification message
      final dynamic notification = message['notification'];
    }
    print(message);

    // Or do other work.
  }
}
