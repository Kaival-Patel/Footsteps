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
  List<dynamic> receipentCode = List();
  List<String> timeStamps = List();
  @override
  void initState() {
    super.initState();
    //fetchIncomingNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder(
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
          DateFormat dateFormat = DateFormat("dd-MM-yyyy, HH:mm a");
          Map<dynamic, dynamic> snapmap = dataSnapshot.value;
          snapmap.forEach((key, value) {
            
            _timestamps.add(key);
            _recipient_codes.add(value['recipient_code']);
          });
          return _recipient_codes == null
              ? SizedBox()
              : ListView.builder(
                  itemBuilder: (context, item) => Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(SizeConfig.textMultiplier*2),
                        border: Border.all(color: AppTheme.appOrangeColor)
                      ),
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
                            "At ${dateFormat.format(DateTime.fromMicrosecondsSinceEpoch(int.parse(_timestamps[item])))}",
                            style: TextStyle(
                                color: Colors.grey, fontStyle: FontStyle.italic),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                              icon: Icon(
                                Icons.done,
                                color: Colors.green,
                              ),
                              onPressed: () {}),
                              IconButton(
                              icon: Icon(
                                Icons.cancel,
                                color: Colors.red,
                              ),
                              onPressed: () {}),
                            ],
                          )
                        ),
                      ),
                    ),
                  ),
                  itemCount: _recipient_codes.length,
                );
        } else {
          return Center(
            child: CircularProgressIndicator(backgroundColor: AppTheme.appDarkVioletColor),
          );
        }

        // Map<dynamic, dynamic> snap = dataSnapshot.value;
        // snap.values.map((e) => Text(e.toString())).toList();
        // if(snap.values.isNotEmpty){
        //   return ListView.builder(
        //   itemBuilder: (context, index) {
        //     return Text(snap[index]['recipient_code']);
        //   },
        //   itemCount: snap.values.length,
        //   );
        // }
        // else{
        //  return Container(
        //   height: 0.0,
        //   width: 0.0,
        // );
        // }

        // return Container(
        //   height: 0.0,
        //   width: 0.0,
        // );

        // if (snapshot.connectionState == ConnectionState.waiting) {
        //   return CircularProgressIndicator();
        // } else if (snapshot.connectionState == ConnectionState.none) {
        //   return Center(
        //     child: Text("No Active Notifications!"),
        //   );
        // } else {
        //   return ListTile(
        //     title: snapshot.data,
        //   );
        // }
      },
    ));
  }
}
