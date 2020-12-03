import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:footsteps/Services/Authentication/fcmTokenManager.dart';
import 'package:footsteps/components/Dialogs/centerBottomToast.dart';
import 'package:footsteps/config/styling.dart';
import 'package:footsteps/screens/Portrait/AddTrackersPage.dart';
import 'package:footsteps/screens/Portrait/SettingPage.dart';
import 'HomePage.dart';
import 'ProfilePage.dart';
import 'package:flutter/material.dart';
import '../../config/size_config.dart';

class Home extends StatefulWidget {
  User user;
  Home({this.user});
  @override
  _HomeState createState() => _HomeState(user: this.user);
}

class _HomeState extends State<Home>
    with WidgetsBindingObserver, SingleTickerProviderStateMixin {
  User user;
  _HomeState({this.user});
  List<Widget> pages;
  int selectedpage = 0;
  fcmTokenManager fcmManager = fcmTokenManager();
  FirebaseMessaging _fcm = FirebaseMessaging();
  FirebaseDatabase _database = FirebaseDatabase.instance;
  centerBottomToast cbt = centerBottomToast();
  String fcmToken;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    ChangeUserStatusToOnline();
    AddBackgroundChannel();
    print("SELECTED PAGE GOT FROM MAIN:$selectedpage");
    setFCMtoken();
    startFCMService();
  }

  Future<void> startFCMService() async {
    FirebaseMessaging _fcm = FirebaseMessaging();
    print("STARTED FCM SERVICE FROM HOME!!!");
    _fcm.configure(
        onMessage: (Map<String, dynamic> message) async {
          print("onMessage:=> $message");
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
          print("onLaunch:=> ${message['data']['screen']}");
          if (message['data']['screen'] == "ManageTracker") {
            setState(() {
              selectedpage = 1;
              print("SELECTED PAGE:1");
            });
          }
          // TODO optional
        },
        onResume: (Map<String, dynamic> message) async {
          print("onResume: $message");
          if (message['data']['screen'] == "ManageTracker") {
            setState(() {
              selectedpage = 1;
              print("SELECTED PAGE:1");
            });
          }
          // TODO optional
        },
        onBackgroundMessage: fcmTokenManager.myBackgroundMessageHandler);
  }

  Future<String> setFCMtoken() async {
    fcmToken = await _fcm.getToken();
    //save fcm token id to fdatabase
    print(fcmToken);
    _database
        .reference()
        .child('Users')
        .child(user.uid)
        .child('device_token')
        .set(fcmToken)
        .catchError((e) {
      cbt.showCenterFlash(
        bgColor: Colors.white,
        msgtext: "FCM Token Generation Failed => ${e.toString()}",
        borderColor: Colors.red,
        textColor: Colors.red,
        duration: Duration(seconds: 5),
        ctx: context,
        alignment: Alignment.bottomCenter,
      );
    });
  }

  void AddBackgroundChannel() {}

  @override
  void didChangeAppLifeCycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      print("RESUME!!!");
      ChangeUserStatusToOnline();
    }
    if (state == AppLifecycleState.detached) {
      print("DETACHED!!!");
      changeOnlineStatus();
    }
    if (state == AppLifecycleState.paused) {
      print("PAUSED!!!!");
      changeOnlineStatus();
    }
    if (state == AppLifecycleState.inactive) {
      print("INACTIVE!!!!");
      changeOnlineStatus();
    }
  }

  Future<void> ChangeUserStatusToOnline() async {
    await FirebaseDatabase.instance
        .reference()
        .child('Users')
        .child(FirebaseAuth.instance.currentUser.uid)
        .child('isOnline')
        .set(true);
  }

  @override
  Widget build(BuildContext context) {
    pages = [
      HomePage(user: user),
      AddTrackersPage(),
      SettingPage(),
      ProfilePage(
        user: user,
      )
    ];
    return WillPopScope(
      onWillPop: changeOnlineStatus,
      child: Scaffold(
        bottomNavigationBar: BottomNavyBar(
          selectedIndex: selectedpage,
          showElevation: true,
          itemCornerRadius: 4,
          curve: Curves.bounceInOut,
          onItemSelected: (index) => setState(() {
            selectedpage = index;
          }),
          items: [
            BottomNavyBarItem(
              icon: Icon(Icons.location_on_outlined),
              title: Text("Track"),
              activeColor: AppTheme.appOrangeColor,
            ),
            BottomNavyBarItem(
              icon: Icon(Icons.add_circle_outline),
              title: Text("Manage"),
              activeColor: Colors.blue,
            ),
            BottomNavyBarItem(
              icon: Icon(Icons.settings),
              title: Text("Settings"),
              activeColor: Colors.grey[800],
            ),
            BottomNavyBarItem(
              icon: Icon(Icons.person_outline),
              title: Text("Profile"),
              activeColor: AppTheme.appDarkVioletColor,
            ),
          ],
        ),
        body: IndexedStack(
          index: selectedpage,
          children: pages,
        ),
      ),
    );
  }

  Future<bool> changeOnlineStatus() async {
    print("Changing status to offline");
    await FirebaseDatabase.instance
        .reference()
        .child('Users')
        .child(FirebaseAuth.instance.currentUser.uid)
        .child('isOnline')
        .set(false);
    SystemNavigator.pop();
    return true;
  }
}
