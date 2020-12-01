import 'package:clipboard_manager/clipboard_manager.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:footsteps/Services/Authentication/UserRespository.dart';
import 'package:footsteps/components/Dialogs/centerBottomToast.dart';
import 'package:footsteps/components/ProfileBanner.dart';
import 'package:footsteps/config/size_config.dart';
import 'package:footsteps/config/styling.dart';
import 'package:footsteps/screens/Portrait/Sign_in.dart';
import 'package:qr_flutter/qr_flutter.dart';

class ProfilePage extends StatefulWidget {
  User user;
  ProfilePage({this.user});
  @override
  _ProfilePageState createState() => _ProfilePageState(user: this.user);
}

class _ProfilePageState extends State<ProfilePage> {
  FirebaseDatabase _database = FirebaseDatabase.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;
  String name, email, uid, trackerCode;
  bool isEmailVerified, isNameFieldEnabled = false;
  dynamic userrepo;
  TextEditingController nameCTRL, emailCTRL, trackerCodeCTRL;
  User user;
  Color editIconColor = Colors.grey;
  Icon editIcon, emailIcon;
  GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey();
  _ProfilePageState({this.user});
  @override
  void initState() {
    super.initState();
    editIcon = Icon(
      Icons.edit_outlined,
      color: editIconColor,
    );
    nameCTRL = TextEditingController();
    emailCTRL = TextEditingController();
    trackerCodeCTRL = TextEditingController();
    if (_auth.currentUser == null) {
      signOut();
    } else {
      fetchUserProfile();
    }
    print(FirebaseAuth.instance.currentUser.displayName);
  }

  Future<void> fetchUserProfile() async {
    setState(() {
      name = _auth.currentUser.displayName;
      print("PROFILE NAME:${name}");
      email = _auth.currentUser.email;
      uid = _auth.currentUser.uid;
      isEmailVerified = _auth.currentUser.emailVerified;
      nameCTRL.text = name;
      emailCTRL.text = email;
      if (isEmailVerified) {
        emailIcon = Icon(
          Icons.verified,
          color: Colors.green,
        );
      } else {
        emailIcon = Icon(
          Icons.refresh_rounded,
          color: Colors.red,
        );
      }
    });
    _database
        .reference()
        .child('Users')
        .child(user.uid)
        .child('Ucode')
        .once()
        .then((DataSnapshot datasnap) {
      setState(() {
        trackerCode = datasnap.value;
        trackerCodeCTRL.text = trackerCode;
      });
    });
  }

  void signOut() {
    userrepo.signOut();
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => Sign_In(),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldkey,
      body: _auth.currentUser == null
          ? Center(
              child: RaisedButton(
                child: Text("Something went wrong! Tap to Logout",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: SizeConfig.textMultiplier * 1.5,
                    )),
                onPressed: () {
                  signOut();
                },
                color: AppTheme.appDarkVioletColor,
              ),
            )
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding:
                        EdgeInsets.only(top: SizeConfig.heightMultiplier * 2),
                    child: Container(
                        height: SizeConfig.heightMultiplier * 30,
                        width: SizeConfig.widthMultiplier * 90,
                        alignment: Alignment.center,
                        child: ProfileBanner()),
                  ),
                  //NAME LABEL
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: SizeConfig.isMobilePortrait
                          ? SizeConfig.widthMultiplier * 11
                          : SizeConfig.widthMultiplier * 20,
                      vertical: SizeConfig.heightMultiplier * 0.1,
                    ),
                    child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Name",
                          style: TextStyle(
                              color: AppTheme.appOrangeColor,
                              fontWeight: FontWeight.w600,
                              fontSize: SizeConfig.textMultiplier * 2.5),
                        )),
                  ),
                  //NAME Field
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: SizeConfig.widthMultiplier * 5,
                      vertical: SizeConfig.heightMultiplier * 1.2,
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: AppTheme.appFormLightVioletColor,
                      ),
                      height: SizeConfig.isMobilePortrait
                          ? SizeConfig.heightMultiplier * 8
                          : SizeConfig.heightMultiplier * 5,
                      width: SizeConfig.isMobilePortrait
                          ? SizeConfig.widthMultiplier * 80
                          : SizeConfig.widthMultiplier * 60,
                      child: Center(
                        child: ListTile(
                          leading: Icon(
                            Icons.person,
                            color: Colors.grey,
                            size: SizeConfig.isMobilePortrait
                                ? SizeConfig.imageSizeMultiplier * 7.5
                                : SizeConfig.imageSizeMultiplier * 4,
                          ),
                          trailing: IconButton(
                              icon: editIcon,
                              onPressed: () {
                                if (editIcon.icon == Icons.edit_outlined) {
                                  setState(() {
                                    isNameFieldEnabled = !isNameFieldEnabled;
                                    if (isNameFieldEnabled) {
                                      editIconColor =
                                          AppTheme.appDarkVioletColor;
                                      editIcon = Icon(
                                        Icons.edit_outlined,
                                        color: editIconColor,
                                      );
                                    } else {
                                      editIconColor = Colors.grey;
                                      editIcon = Icon(
                                        Icons.edit_outlined,
                                        color: editIconColor,
                                      );
                                    }
                                  });
                                } else {
                                  setState(() {
                                    user
                                        .updateProfile(
                                            displayName: nameCTRL.text)
                                        .catchError((e) =>
                                            centerBottomToast().showCenterFlash(
                                              alignment: Alignment.bottomCenter,
                                              bgColor: Colors.red,
                                              textColor: Colors.white,
                                              borderColor: Colors.red[800],
                                              ctx: context,
                                              duration: Duration(seconds: 3),
                                              msgtext:
                                                  "Couldnt update your Profile name,Error :${e.toString()}!",
                                            ))
                                        .whenComplete(() {
                                      if (_auth.currentUser.displayName ==
                                          nameCTRL.text) {
                                        centerBottomToast().showCenterFlash(
                                          alignment: Alignment.bottomCenter,
                                          bgColor: Colors.green,
                                          textColor: Colors.white,
                                          borderColor: Colors.green[800],
                                          ctx: context,
                                          duration: Duration(seconds: 3),
                                          msgtext:
                                              "Successfully Updated your Username!",
                                        );
                                        setState(() {
                                          name = nameCTRL.text;
                                          isNameFieldEnabled = false;
                                          editIconColor = Colors.grey;
                                          editIcon = Icon(
                                            Icons.edit_outlined,
                                            color: editIconColor,
                                          );
                                        });
                                      }
                                    });
                                  });
                                }
                              }),
                          title: TextFormField(
                            autofocus: true,
                            autocorrect: true,
                            enabled: isNameFieldEnabled,
                            keyboardType: TextInputType.name,
                            style: AppTheme.titlelight.copyWith(
                                fontSize: SizeConfig.textMultiplier * 2,
                                fontWeight: FontWeight.bold),
                            cursorColor: AppTheme.appDarkVioletColor,
                            controller: nameCTRL,
                            onChanged: (value) {
                              if (value != name) {
                                setState(() {
                                  editIcon = Icon(
                                    Icons.done_outline_rounded,
                                    color: Colors.green,
                                  );
                                });
                              } else {
                                setState(() {
                                  editIcon = Icon(
                                    Icons.edit_outlined,
                                    color: editIconColor,
                                  );
                                });
                              }
                            },
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: name,
                                hintStyle: AppTheme.titlelight.copyWith(
                                    fontSize: SizeConfig.textMultiplier * 2,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.grey)),
                          ),
                        ),
                      ),
                    ),
                  ),

                  //EMAIL LABEL
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: SizeConfig.isMobilePortrait
                          ? SizeConfig.widthMultiplier * 11
                          : SizeConfig.widthMultiplier * 20,
                      vertical: SizeConfig.heightMultiplier * 0.1,
                    ),
                    child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Email",
                          style: TextStyle(
                              color: AppTheme.appOrangeColor,
                              fontWeight: FontWeight.w600,
                              fontSize: SizeConfig.textMultiplier * 2.5),
                        )),
                  ),
                  //EMAIL Field
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: SizeConfig.widthMultiplier * 5,
                      vertical: SizeConfig.heightMultiplier * 1.2,
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: AppTheme.appFormLightVioletColor,
                      ),
                      height: SizeConfig.isMobilePortrait
                          ? SizeConfig.heightMultiplier * 8
                          : SizeConfig.heightMultiplier * 5,
                      width: SizeConfig.isMobilePortrait
                          ? SizeConfig.widthMultiplier * 80
                          : SizeConfig.widthMultiplier * 60,
                      child: Center(
                        child: ListTile(
                          leading: Icon(
                            Icons.email,
                            color: Colors.grey,
                            size: SizeConfig.isMobilePortrait
                                ? SizeConfig.imageSizeMultiplier * 7.5
                                : SizeConfig.imageSizeMultiplier * 4,
                          ),
                          trailing: IconButton(
                              icon: emailIcon,
                              onPressed: () {
                                if (emailIcon.icon == Icons.refresh_rounded) {
                                  if (!FirebaseAuth
                                      .instance.currentUser.emailVerified) {
                                    showDialog(
                                        context: context,
                                        child: Container(
                                            height:
                                                SizeConfig.heightMultiplier *
                                                    20,
                                            child: AlertDialog(
                                                title: Text(
                                                  "Verify Email",
                                                  style: TextStyle(
                                                      fontSize: SizeConfig
                                                              .textMultiplier *
                                                          3),
                                                ),
                                                content: Text(
                                                    "A link for email verification would be sent to : ${emailCTRL.text}"),
                                                actions: [
                                                  ButtonBar(children: [
                                                    FlatButton(
                                                      child: Text("Send",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: SizeConfig
                                                                      .textMultiplier *
                                                                  2)),
                                                      onPressed: () {
                                                        user
                                                            .sendEmailVerification()
                                                            .catchError((e) {
                                                          centerBottomToast()
                                                              .showCenterFlash(
                                                            alignment: Alignment
                                                                .bottomCenter,
                                                            bgColor: Colors.red,
                                                            textColor:
                                                                Colors.white,
                                                            borderColor:
                                                                Colors.red,
                                                            ctx: context,
                                                            duration: Duration(
                                                                seconds: 5),
                                                            msgtext:
                                                                "Error Sending verification link,Issue:${e.toString()}",
                                                          );
                                                        });
                                                        Navigator.pop(context);
                                                      },
                                                      color: AppTheme
                                                          .appDarkVioletColor,
                                                    ),
                                                    FlatButton(
                                                      child: Text("Cancel",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.grey,
                                                              fontSize: SizeConfig
                                                                      .textMultiplier *
                                                                  2)),
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                    ),
                                                  ])
                                                ])));
                                  } else {
                                    setState(() {
                                      emailIcon = Icon(Icons.verified,
                                          color: Colors.green);
                                    });
                                  }
                                }
                              }),
                          title: TextFormField(
                            autofocus: true,
                            autocorrect: true,
                            enabled: false,
                            keyboardType: TextInputType.name,
                            style: AppTheme.titlelight.copyWith(
                                fontSize: SizeConfig.textMultiplier * 2,
                                fontWeight: FontWeight.bold),
                            cursorColor: AppTheme.appDarkVioletColor,
                            controller: emailCTRL,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: name,
                                hintStyle: AppTheme.titlelight.copyWith(
                                    fontSize: SizeConfig.textMultiplier * 2,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.grey)),
                          ),
                        ),
                      ),
                    ),
                  ),

                  trackerCode != null
                      ? Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: SizeConfig.isMobilePortrait
                                ? SizeConfig.widthMultiplier * 11
                                : SizeConfig.widthMultiplier * 20,
                            vertical: SizeConfig.heightMultiplier * 0.1,
                          ),
                          child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Tracker Code",
                                style: TextStyle(
                                    color: AppTheme.appOrangeColor,
                                    fontWeight: FontWeight.w600,
                                    fontSize: SizeConfig.textMultiplier * 2.5),
                              )),
                        )
                      : Row(),
                  //EMAIL Field
                  trackerCode != null
                      ? Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: SizeConfig.widthMultiplier * 5,
                            vertical: SizeConfig.heightMultiplier * 1.2,
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: AppTheme.appFormLightVioletColor,
                            ),
                            height: SizeConfig.isMobilePortrait
                                ? SizeConfig.heightMultiplier * 8
                                : SizeConfig.heightMultiplier * 5,
                            width: SizeConfig.isMobilePortrait
                                ? SizeConfig.widthMultiplier * 80
                                : SizeConfig.widthMultiplier * 60,
                            child: Center(
                              child: ListTile(
                                leading: Icon(
                                  Icons.code_rounded,
                                  color: Colors.grey,
                                  size: SizeConfig.isMobilePortrait
                                      ? SizeConfig.imageSizeMultiplier * 7.5
                                      : SizeConfig.imageSizeMultiplier * 4,
                                ),
                                trailing: IconButton(
                                  icon: Icon(Icons.copy, color: Colors.blue),
                                  onPressed: () {
                                    ClipboardManager.copyToClipBoard(
                                            trackerCode)
                                        .then((result) {
                                      _scaffoldkey.currentState
                                          .showSnackBar(SnackBar(
                                        content: Text("Copied to Clipboard"),
                                      ));
                                    });
                                  },
                                ),
                                title: TextFormField(
                                  autofocus: true,
                                  autocorrect: true,
                                  enabled: false,
                                  keyboardType: TextInputType.name,
                                  style: AppTheme.titlelight.copyWith(
                                      fontSize: SizeConfig.textMultiplier * 2,
                                      fontWeight: FontWeight.bold),
                                  cursorColor: AppTheme.appDarkVioletColor,
                                  controller: trackerCodeCTRL,
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: 'Tracker Code',
                                      hintStyle: AppTheme.titlelight.copyWith(
                                          fontSize:
                                              SizeConfig.textMultiplier * 2,
                                          fontWeight: FontWeight.normal,
                                          color: Colors.grey)),
                                ),
                              ),
                            ),
                          ),
                        )
                      : Row(),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: SizeConfig.widthMultiplier * 5,
                      vertical: SizeConfig.heightMultiplier * 2.5,
                    ),
                    child: GestureDetector(
                      onTap: () {
                        //TODO: Generate QR CODE
                        showDialog(
                            context: context,
                            child: Container(
                                //height: SizeConfig.heightMultiplier*50,
                                //width: SizeConfig.widthMultiplier*90,
                                child: AlertDialog(
                              content: SizedBox(
                                height: 200,
                                width: 200,
                                child: Center(
                                  child: QrImage(
                                    data: trackerCode,
                                    size: 200.0,
                                    version: QrVersions.auto,
                                  ),
                                ),
                              ),
                            )));
                      },
                      child: Container(
                          decoration: BoxDecoration(
                            color: AppTheme.appDarkVioletColor,
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          height: SizeConfig.heightMultiplier * 7,
                          width: SizeConfig.widthMultiplier * 70,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                flex: 7,
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Text("Show your QR Code",
                                      style: AppTheme.titledark.copyWith(
                                          fontSize:
                                              SizeConfig.textMultiplier * 2.5)),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Align(
                                    alignment: Alignment.center,
                                    child: Icon(
                                      Icons.arrow_forward,
                                      color: Colors.white,
                                      size: SizeConfig.textMultiplier * 2.5,
                                    )),
                              )
                            ],
                          )),
                    ),
                  ),
                  Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: SizeConfig.widthMultiplier * 2,
                          vertical: SizeConfig.heightMultiplier * 0.2),
                      child: InkWell(
                        onTap: () {},
                        child: Text(
                          "Change Password",
                          style: AppTheme.titlelight.copyWith(
                              fontSize: SizeConfig.textMultiplier * 1.8,
                              decoration: TextDecoration.underline,
                              color: AppTheme.appOrangeColor),
                        ),
                      ))
                ],
              ),
            ),
    );
  }
}
