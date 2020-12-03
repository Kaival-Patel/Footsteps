import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:footsteps/Services/Authentication/UserRespository.dart';
import 'package:footsteps/Services/Authentication/auth_service_adapter.dart';
import 'package:footsteps/Services/Authentication/auth_service.dart';
import 'package:footsteps/Services/Authentication/fcmTokenManager.dart';
import 'package:footsteps/config/size_config.dart';
import 'package:footsteps/config/styling.dart';
import 'package:footsteps/screens/Portrait/Home.dart';
import 'package:footsteps/screens/Portrait/HomePage.dart';
import 'package:footsteps/screens/Portrait/ManageTracker.dart';
import 'package:footsteps/screens/Portrait/Sign_in.dart';
import 'package:footsteps/screens/Portrait/splash.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  // debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;

  // runApp(DevicePreview(
  //   builder: (context) => myApp(),
  // ));
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(myApp());
}

class myApp extends StatefulWidget {
  @override
  _myAppState createState() => _myAppState();
}

class _myAppState extends State<myApp> {
  int selectPage = 0;
  @override
  void initState() {
    super.initState();
    //startFCMService();
    
  }

 

  Future<void> startFCMService() async {
    FirebaseMessaging _fcm = FirebaseMessaging();
    print("STARTED FCM SERVICE FROM MAIN!!!");
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
              selectPage = 1;
              print("SELECTED PAGE:1");
            });
          }
          // TODO optional
        },
        onResume: (Map<String, dynamic> message) async {
          print("onResume: $message");
          if (message['data']['screen'] == "ManageTracker") {
            setState(() {
              selectPage = 1;
              print("SELECTED PAGE:1");
            });
          }
          // TODO optional
        },
        onBackgroundMessage: fcmTokenManager.myBackgroundMessageHandler);
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<UserRepository>(
          create: (context) => UserRepository.instance(),
        ),
      ],
      child: Consumer(
        builder: (context, UserRepository user, child) {
          switch (user.status) {
            case Status.Authenticated:
              return LayoutBuilder(
                  builder: (context, constraints) => OrientationBuilder(
                        builder: (context, orientation) {
                          SizeConfig().init(constraints, orientation);
                          return MaterialApp(
                            debugShowCheckedModeBanner: false,
                            theme: AppTheme.lightTheme,
                            home: Home(
                              user: user.user,
                            ),
                          );
                        },
                      ));
            case Status.Authenticating:
              return LayoutBuilder(
                  builder: (context, constraints) => OrientationBuilder(
                        builder: (context, orientation) {
                          SizeConfig().init(constraints, orientation);
                          return MaterialApp(
                            debugShowCheckedModeBanner: false,
                            theme: AppTheme.lightTheme,
                            home: splash(),
                          );
                        },
                      ));
            case Status.Unauthenticated:
              return LayoutBuilder(
                  builder: (context, constraints) => OrientationBuilder(
                        builder: (context, orientation) {
                          SizeConfig().init(constraints, orientation);
                          return MaterialApp(
                            debugShowCheckedModeBanner: false,
                            theme: AppTheme.lightTheme,
                            home: splash(),
                          );
                        },
                      ));
            case Status.Uninitialized:
              return LayoutBuilder(
                  builder: (context, constraints) => OrientationBuilder(
                        builder: (context, orientation) {
                          SizeConfig().init(constraints, orientation);
                          return MaterialApp(
                            debugShowCheckedModeBanner: false,
                            theme: AppTheme.lightTheme,
                            home: splash(),
                          );
                        },
                      ));
            case Status.Registering:
              return LayoutBuilder(
                  builder: (context, constraints) => OrientationBuilder(
                        builder: (context, orientation) {
                          SizeConfig().init(constraints, orientation);
                          return MaterialApp(
                            debugShowCheckedModeBanner: false,
                            theme: AppTheme.lightTheme,
                            home: Sign_In(),
                          );
                        },
                      ));
          }
        },
      ),
    );
  }
}
