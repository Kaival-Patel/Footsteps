import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:footsteps/Services/Authentication/UserRespository.dart';
import 'package:footsteps/Services/Authentication/auth_service_adapter.dart';
import 'package:footsteps/components/Dialogs/LoadingDialog.dart';
import 'package:footsteps/components/Dialogs/centerBottomToast.dart';
import 'package:footsteps/components/Sign_up/SignupBanner.dart';
import 'package:footsteps/Services/Authentication/auth_service.dart';
import 'package:footsteps/components/Sign_up/sign_in_field.dart';
import 'package:footsteps/components/Sign_up/sign_up_button.dart';
import 'package:footsteps/config/size_config.dart';
import 'package:footsteps/config/styling.dart';
import 'package:footsteps/models/UcodeGenerator.dart';
import 'package:footsteps/screens/Portrait/Home.dart';
import 'package:footsteps/screens/Portrait/HomePage.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:provider/provider.dart';

class Sign_up extends StatefulWidget {
  @override
  _Sign_upState createState() => _Sign_upState();
}

class _Sign_upState extends State<Sign_up> {
  Focus focus;
  TextEditingController emailCTRL = TextEditingController();
  TextEditingController pwdCTRL = TextEditingController();
  TextEditingController nameCTRL = TextEditingController();
  GlobalKey<FormState> formkey = GlobalKey();
  GlobalKey<ScaffoldState> scaffoldkey = GlobalKey();
  UCodeGenerator uc = UCodeGenerator();
  centerBottomToast cbt = centerBottomToast();
  FirebaseDatabase _database = FirebaseDatabase.instance;
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserRepository>(context);
    LoadingDialog ld = LoadingDialog(
        indicator: Indicator.ballPulse,
        indicatorColor: AppTheme.appOrangeColor,
        context: context,
        loadingmsg: "Registering you in System,Please wait!");

    // final AuthService authService =
    //     Provider.of<AuthService>(context, listen: false);
    return Scaffold(
      //resizeToAvoidBottomInset: false,
      key: scaffoldkey,
      body: SingleChildScrollView(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          //Signup Banner
          Padding(
            padding: EdgeInsets.only(
                top: SizeConfig.heightMultiplier * 10,
                bottom: SizeConfig.heightMultiplier * 10),
            child: SizedBox(
                height: SizeConfig.heightMultiplier * 17,
                width: SizeConfig.widthMultiplier * 90,
                child: SignUpBanner()),
          ),

          //FORM
          Form(
            key: formkey,
            child: Column(
              children: [
                //NAME LABEL WITH FIELD
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
                //Email Field
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
                        title: TextFormField(
                          autofocus: true,
                          autocorrect: true,
                          keyboardType: TextInputType.name,
                          style: AppTheme.titlelight.copyWith(
                              fontSize: SizeConfig.textMultiplier * 2,
                              fontWeight: FontWeight.bold),
                          cursorColor: AppTheme.appDarkVioletColor,
                          controller: nameCTRL,
                          onFieldSubmitted: (v) {
                            print("SUBMITTED EMAIL!!");
                            //FocusScope.of(context).requestFocus(focus);
                          },
                          validator: (value) {
                            if (value.isEmpty) {
                              cbt.showCenterFlash(
                                bgColor: Colors.white,
                                msgtext: "Please provide name!",
                                borderColor: Colors.red,
                                textColor: Colors.red,
                                duration: Duration(seconds: 3),
                                ctx: context,
                                alignment: Alignment.bottomCenter,
                              );
                            }
                          },
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Martin Fox",
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
                //Email Field
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: SizeConfig.widthMultiplier * 5,
                    vertical: SizeConfig.heightMultiplier * 0.2,
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
                          Icons.email_sharp,
                          color: Colors.grey,
                          size: SizeConfig.isMobilePortrait
                              ? SizeConfig.imageSizeMultiplier * 7.5
                              : SizeConfig.imageSizeMultiplier * 4,
                        ),
                        title: TextFormField(
                          autofocus: true,
                          autocorrect: true,
                          keyboardType: TextInputType.emailAddress,
                          style: AppTheme.titlelight.copyWith(
                              fontSize: SizeConfig.textMultiplier * 2,
                              fontWeight: FontWeight.bold),
                          cursorColor: AppTheme.appDarkVioletColor,
                          controller: emailCTRL,
                          onFieldSubmitted: (v) {
                            print("SUBMITTED EMAIL!!");
                            //FocusScope.of(context).requestFocus(focus);
                          },
                          validator: (value) {
                            if (!isEmailValid() || emailCTRL.text.isEmpty) {
                              cbt.showCenterFlash(
                                bgColor: Colors.white,
                                msgtext: "Please provide valid email!",
                                borderColor: Colors.red,
                                textColor: Colors.red,
                                duration: Duration(seconds: 3),
                                ctx: context,
                                alignment: Alignment.bottomCenter,
                              );
                            }
                          },
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "abc@xyz.com",
                              hintStyle: AppTheme.titlelight.copyWith(
                                  fontSize: SizeConfig.textMultiplier * 2,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.grey)),
                        ),
                      ),
                    ),
                  ),
                ),

                //PWD FIELD
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: SizeConfig.isMobilePortrait
                        ? SizeConfig.widthMultiplier * 11
                        : SizeConfig.widthMultiplier * 20,
                    vertical: SizeConfig.heightMultiplier * 1,
                  ),
                  child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Password",
                        style: TextStyle(
                            color: AppTheme.appOrangeColor,
                            fontWeight: FontWeight.w600,
                            fontSize: SizeConfig.textMultiplier * 2.5),
                      )),
                ),

                //Password Field
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: SizeConfig.widthMultiplier * 5,
                    vertical: SizeConfig.heightMultiplier * 0.2,
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
                          Icons.lock,
                          color: Colors.grey,
                          size: SizeConfig.isMobilePortrait
                              ? SizeConfig.imageSizeMultiplier * 7.5
                              : SizeConfig.imageSizeMultiplier * 4,
                        ),
                        title: TextFormField(
                          autofocus: true,
                          autocorrect: true,
                          keyboardType: TextInputType.visiblePassword,
                          style: AppTheme.titlelight.copyWith(
                              fontSize: SizeConfig.textMultiplier * 2,
                              fontWeight: FontWeight.bold),
                          cursorColor: AppTheme.appDarkVioletColor,
                          controller: pwdCTRL,

                          obscureText: true,
                          //scrollPadding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "*****",
                              hintStyle: AppTheme.titlelight.copyWith(
                                  fontSize: SizeConfig.textMultiplier * 2,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.grey)),
                          validator: (value) {
                            if (value.isEmpty && emailCTRL.text.isEmpty) {
                              cbt.showCenterFlash(
                                bgColor: Colors.white,
                                msgtext: "Password or Email cannot be empty",
                                borderColor: Colors.red,
                                textColor: Colors.red,
                                duration: Duration(seconds: 3),
                                ctx: context,
                                alignment: Alignment.bottomCenter,
                              );
                            }
                            if (value.isEmpty) {
                              cbt.showCenterFlash(
                                bgColor: Colors.white,
                                msgtext: "Password cannot be empty",
                                borderColor: Colors.red,
                                textColor: Colors.red,
                                duration: Duration(seconds: 3),
                                ctx: context,
                                alignment: Alignment.bottomCenter,
                              );
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          //Password Label
          //passwordfield(),
          //Sign In Button
          user.status == Status.Registering
              ? Padding(
                  padding: EdgeInsets.all(SizeConfig.imageSizeMultiplier * 2),
                  child: CircularProgressIndicator(
                    backgroundColor: AppTheme.appOrangeColor,
                  ),
                )
              : sign_up_button(onButtonPressed: () async {
                  if (isEmailValid() &&
                      pwdCTRL.text.isNotEmpty &&
                      pwdCTRL.text.length >= 6 &&
                      nameCTRL.text.isNotEmpty) {
                    //fwd to signup
                    print(emailCTRL.text);
                    print(pwdCTRL.text);
                    try {
                      if (!await user.signUp(
                          emailCTRL.text.trim(), pwdCTRL.text.trim())) {
                        cbt.showCenterFlash(
                          bgColor: Colors.white,
                          msgtext:
                              "Error registering you as user, Try Again Later!",
                          borderColor: Colors.red,
                          textColor: Colors.red,
                          duration: Duration(seconds: 3),
                          ctx: context,
                          alignment: Alignment.bottomCenter,
                        );
                      } else {
                        if (user.user != null) {
                          FirebaseAuth.instance.currentUser
                              .updateProfile(displayName: nameCTRL.text);
                          //Upload User details to db
                          _database
                              .reference()
                              .child('Users')
                              .child(user.user.uid)
                              .child('Profile')
                              .set({
                            'name': nameCTRL.text,
                            'email': emailCTRL.text
                          }).catchError((e) {
                            cbt.showCenterFlash(
                              bgColor: Colors.white,
                              msgtext:
                                  "Error while uploading in Database ${e.toString()}",
                              borderColor: Colors.red,
                              textColor: Colors.red,
                              duration: Duration(seconds: 3),
                              ctx: context,
                              alignment: Alignment.bottomCenter,
                            );
                          });

                          _database
                              .reference()
                              .child('Users')
                              .child(user.user.uid)
                              .child('Ucode')
                              .set(uc.ucode(nameCTRL.text, user.user.uid))
                              .catchError((e) {
                            cbt.showCenterFlash(
                              bgColor: Colors.white,
                              msgtext:
                                  "Error while uploading in Database ${e.toString()}",
                              borderColor: Colors.red,
                              textColor: Colors.red,
                              duration: Duration(seconds: 3),
                              ctx: context,
                              alignment: Alignment.bottomCenter,
                            );
                          });

                          _database
                              .reference()
                              .child('Users')
                              .child(user.user.uid)
                              .child('isOnline')
                              .set(true)
                              .catchError((e) {
                            cbt.showCenterFlash(
                              bgColor: Colors.white,
                              msgtext:
                                  "Error while uploading in Database ${e.toString()}",
                              borderColor: Colors.red,
                              textColor: Colors.red,
                              duration: Duration(seconds: 3),
                              ctx: context,
                              alignment: Alignment.bottomCenter,
                            );
                          });

                          Navigator.of(context)
                              .pushReplacement(MaterialPageRoute(
                            builder: (context) => Home(
                              user: user.user,
                            ),
                          ));
                        }
                      }
                    } catch (e) {
                      cbt.showCenterFlash(
                        bgColor: Colors.white,
                        msgtext: "Error : ${e.toString()}",
                        borderColor: Colors.red,
                        textColor: Colors.red,
                        duration: Duration(seconds: 3),
                        ctx: context,
                        alignment: Alignment.bottomCenter,
                      );
                    }
                  } else {
                    if (emailCTRL.text.isEmpty) {
                      cbt.showCenterFlash(
                        bgColor: Colors.white,
                        msgtext: "Please provide Email ID",
                        borderColor: Colors.red,
                        textColor: Colors.red,
                        duration: Duration(seconds: 3),
                        ctx: context,
                        alignment: Alignment.bottomCenter,
                      );
                    }
                    if (pwdCTRL.text.isEmpty) {
                      cbt.showCenterFlash(
                        bgColor: Colors.white,
                        msgtext: "Please provide Password",
                        borderColor: Colors.red,
                        textColor: Colors.red,
                        duration: Duration(seconds: 3),
                        ctx: context,
                        alignment: Alignment.bottomCenter,
                      );
                    }
                    if (pwdCTRL.text.length < 6) {
                      cbt.showCenterFlash(
                        bgColor: Colors.white,
                        msgtext:
                            "Please provide Password with minimum 6 characters",
                        borderColor: Colors.red,
                        textColor: Colors.red,
                        duration: Duration(seconds: 3),
                        ctx: context,
                        alignment: Alignment.bottomCenter,
                      );
                    }
                    if (nameCTRL.text.isEmpty) {
                      cbt.showCenterFlash(
                        bgColor: Colors.white,
                        msgtext: "Please provide Name",
                        borderColor: Colors.red,
                        textColor: Colors.red,
                        duration: Duration(seconds: 3),
                        ctx: context,
                        alignment: Alignment.bottomCenter,
                      );
                    }
                  }
                }),
          //forgot password field
          sign_up_text()
        ],
      )),
    );
  }

  bool isEmailValid() {
    if (RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(emailCTRL.text.trim())) {
      return true;
    } else {
      return false;
    }
  }
}
