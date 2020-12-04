import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:footsteps/Services/Authentication/FirebaseSignOut.dart';
import 'package:footsteps/Services/Authentication/UserRespository.dart';
import 'package:footsteps/components/Dialogs/centerBottomToast.dart';
import 'package:footsteps/config/size_config.dart';
import 'package:footsteps/config/styling.dart';
import 'package:footsteps/screens/Portrait/QrCodeScanner.dart';
import 'package:footsteps/screens/Portrait/Sign_in.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';

class ManageTracker extends StatefulWidget {
  @override
  _ManageTrackerState createState() => _ManageTrackerState();
}

class _ManageTrackerState extends State<ManageTracker> {
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  dynamic userrepo;
  FirebaseSignOut firebaseSignOut;
  FirebaseDatabase _firebaseDatabase = FirebaseDatabase.instance;
  GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey();

  @override
  void initState() {
    super.initState();
    if (_firebaseAuth.currentUser == null) {
      firebaseSignOut.signOut(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key:_scaffoldkey,
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
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "\t\t\tTRACKERS",
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
                      .child('trackers')
                      .onValue,
                  builder: (context, snapshot) {
                    if (snapshot.hasData &&
                        !snapshot.hasError &&
                        snapshot.data.snapshot.value != null) {
                      DataSnapshot dataSnapshot = snapshot.data.snapshot;
                      //print(dataSnapshot.value);
                      List _senderUID = [];
                      List _timestamps = [];
                      List _uCode = [];
                      List _profileName = [];
                      Map<dynamic, dynamic> snapmap = dataSnapshot.value;
                      DateFormat dateFormat = DateFormat("dd-MM-yyyy, HH:mm a");
                      snapmap.forEach((key, value) {
                        print(value);
                        _senderUID.add(value['tracker_uid']);
                        _uCode.add(value['ucode']);
                        print(key);
                        _timestamps.add(key);
                      });

                      return _profileName == null
                          ? SizedBox()
                          : ListView.builder(
                              itemBuilder: (context, item) => Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                          SizeConfig.textMultiplier * 2),
                                      border: Border.all(
                                          color: AppTheme.appOrangeColor)),
                                  child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: ListTile(
                                      title: Text(
                                        "${_uCode[item].toString()}",
                                        style: TextStyle(
                                            color: AppTheme.appDarkVioletColor,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      subtitle: Text(
                                        "Added on ${dateFormat.format(DateTime.fromMillisecondsSinceEpoch(int.parse(_timestamps[item])))}",
                                        style: TextStyle(
                                            color: Colors.grey,
                                            fontStyle: FontStyle.italic),
                                      ),
                                      trailing: IconButton(
                                          icon: Icon(
                                            Icons.delete,
                                            color: Colors.red,
                                          ),
                                          onPressed: () async {
                                            //TODO:IMPLEMENT DELETE TRACKER
                                            _firebaseDatabase
                                                  .reference()
                                                  .child('Users')
                                                  .child(_firebaseAuth
                                                      .currentUser.uid)
                                                  .child('trackers')
                                                  .child(_timestamps[item])
                                                  .remove();
                                              _firebaseDatabase
                                                  .reference()
                                                  .child('Users')
                                                  .child(_senderUID[item])
                                                  .child('tracked_by')
                                                  .child(_timestamps[item])
                                                  .remove();
                                            _scaffoldkey.currentState.showSnackBar(
                                              SnackBar(
                                                content: Text("Removed ${_uCode[item]} from your Tracker List"),
                                              )
                                            );
                                          }),
                                    ),
                                  ),
                                ),
                              ),
                              itemCount: _senderUID.length,
                            );
                    } else if (!snapshot.hasData ||
                        snapshot.data.snapshot.value == null) {
                      return Center(
                        child:
                            Text("No trackers, Click on Add Trackers to add"),
                      );
                    } else {
                      return Center(
                        child: CircularProgressIndicator(
                            backgroundColor: AppTheme.appDarkVioletColor),
                      );
                    }
                  }),
            ),
          ],
        ));
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
