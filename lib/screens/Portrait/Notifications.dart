import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:footsteps/config/size_config.dart';
import 'package:footsteps/config/styling.dart';
import 'package:intl/intl.dart';

class Notifications extends StatefulWidget {
  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  FirebaseDatabase _firebaseDatabase = FirebaseDatabase.instance;
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "\t\t\tINCOMING TRACKING REQUESTS",
          style: TextStyle(
              color: Colors.grey,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic,
              fontSize: SizeConfig.textMultiplier * 1.5),
        ),
        Flexible(
          child: StreamBuilder(
            stream: _firebaseDatabase
                .reference()
                .child('Users')
                .child(_firebaseAuth.currentUser.uid)
                .child('Notifications')
                .child('Incoming Tracking Request')
                .onValue,
            builder: (context, snapshot) {
              if (snapshot.hasData &&
                  !snapshot.hasError &&
                  snapshot.data.snapshot.value != null) {
                DataSnapshot dataSnapshot = snapshot.data.snapshot;
                //print(dataSnapshot.value);
                List _timestamps = [];
                List _recipient_codes = [];
                List _senderUID = [];
                DateFormat dateFormat = DateFormat("dd-MM-yyyy, HH:mm a");
                Map<dynamic, dynamic> snapmap = dataSnapshot.value;
                snapmap.forEach((key, value) {
                  _timestamps.add(key);
                  _recipient_codes.add(value['recipient_code']);
                  _senderUID.add(value['from']);
                });
                return _recipient_codes == null
                    ? SizedBox()
                    : ListView.builder(
                        itemBuilder: (context, item) => Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                    SizeConfig.textMultiplier * 2),
                                border:
                                    Border.all(color: AppTheme.appOrangeColor)),
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: ListTile(
                                  title: Text(
                                    "${_recipient_codes[item].toString()} wants to add you as their tracker",
                                    style: TextStyle(
                                        color: AppTheme.appDarkVioletColor,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Text(
                                    "At ${dateFormat.format(DateTime.fromMillisecondsSinceEpoch(int.parse(_timestamps[item])))}",
                                    style: TextStyle(
                                        color: Colors.grey,
                                        fontStyle: FontStyle.italic),
                                  ),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                          icon: Icon(
                                            Icons.done,
                                            color: Colors.green,
                                          ),
                                          onPressed: () async {
                                            //TODO:IMPLEMENT ACCEPT NOTIFICATION
                                            await addUserToTrackingList(
                                                _senderUID[item]);
                                            _firebaseDatabase
                                                .reference()
                                                .child('Users')
                                                .child(_firebaseAuth
                                                    .currentUser.uid)
                                                .child('Notifications')
                                                .child(
                                                    'Incoming Tracking Request')
                                                .child(_timestamps[item])
                                                .remove();
                                            _firebaseDatabase
                                                .reference()
                                                .child('Users')
                                                .child(_senderUID[item])
                                                .child('Notifications')
                                                .child(
                                                    'Outgoing Tracking Request')
                                                .child(_timestamps[item])
                                                .remove();
                                          }),
                                      IconButton(
                                          icon: Icon(
                                            Icons.cancel,
                                            color: Colors.red,
                                          ),
                                          onPressed: () {
                                            //TODO: IMPLEMENT REJECT NOTIFICATION
                                          }),
                                    ],
                                  )),
                            ),
                          ),
                        ),
                        itemCount: _recipient_codes.length,
                      );
              } else if(!snapshot.hasData||snapshot.data.snapshot.value == null) {
                return Center(
                  child: Text("No active Notifications, You're all caught up!"),
                );
              }
               else{
                 return Center(
                  child: CircularProgressIndicator(
                      backgroundColor: AppTheme.appDarkVioletColor),
                );
               } 
              }
          ),
        ),
      ],
    ));
  }

  Future<void> addUserToTrackingList(String uid) async {
    _firebaseDatabase
        .reference()
        .child('Users')
        .child(_firebaseAuth.currentUser.uid)
        .child('trackers')
        .child(DateTime.now().millisecondsSinceEpoch.toString())
        .set({
          'tracker_uid':uid
        });
    _firebaseDatabase
        .reference()
        .child('Users')
        .child(uid)
        .child('tracked_by')
        .child(DateTime.now().millisecondsSinceEpoch.toString())
        .set({
          'tracker_uid':uid
        });
  }
}

