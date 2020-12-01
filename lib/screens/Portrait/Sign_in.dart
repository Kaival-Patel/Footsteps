import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:footsteps/Services/Authentication/UserRespository.dart';
import 'package:footsteps/components/Dialogs/centerBottomToast.dart';
import 'package:footsteps/components/Sign_in/LoginBanner.dart';
import 'package:footsteps/components/Sign_in/emailfield.dart';
import 'package:footsteps/components/Sign_in/forgotPasswordfield.dart';
import 'package:footsteps/components/Sign_in/passwordfield.dart';
import 'package:footsteps/components/Sign_in/sign_in_button.dart';
import 'package:footsteps/components/Sign_in/sign_up_field.dart';
import 'package:footsteps/config/size_config.dart';
import 'package:footsteps/config/styling.dart';
import 'package:footsteps/screens/Portrait/Home.dart';
import 'package:footsteps/screens/Portrait/HomePage.dart';
import 'package:provider/provider.dart';

class Sign_In extends StatelessWidget {
  FocusNode focus;
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserRepository>(context);
    TextEditingController emailCTRL = TextEditingController();
    TextEditingController pwdCTRL = TextEditingController();
    centerBottomToast cbt = centerBottomToast();
    GlobalKey<FormState> formkey = GlobalKey();
    FirebaseDatabase _database = FirebaseDatabase.instance;
    //FirebaseMessaging _fcm = FirebaseMessaging();
    return Scaffold(
      //resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          //Login Banner
          LoginBanner(),
          //Email Label
          Form(
            key: formkey,
            child: Column(
              children: [
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
                          keyboardType: TextInputType.name,
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
                            if (emailCTRL.text.isEmpty) {
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
          //Sign In Button
          user.status == Status.Authenticating
              ? Padding(
                  padding: EdgeInsets.all(SizeConfig.textMultiplier * 3),
                  child: CircularProgressIndicator(
                    backgroundColor: AppTheme.appOrangeColor,
                  ),
                )
              : sign_in_button(onButtonPressed: () async {
                  if (emailCTRL.text.isNotEmpty &&
                      pwdCTRL.text.isNotEmpty &&
                      formkey.currentState.validate()) {
                    //fwd to signup
                    print(emailCTRL.text);
                    print(pwdCTRL.text);
                    if (!await user.signIn(
                        emailCTRL.text.trim(), pwdCTRL.text.trim())) {
                      cbt.showCenterFlash(
                        bgColor: Colors.white,
                        msgtext:
                            "Incorrect Login Credentials or maybe its an Error!",
                        borderColor: Colors.red,
                        textColor: Colors.red,
                        duration: Duration(seconds: 3),
                        ctx: context,
                        alignment: Alignment.bottomCenter,
                      );
                    } else {
                      if (user.user != null) {
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
                                "Online Status Updation failed ${e.toString()}",
                            borderColor: Colors.red,
                            textColor: Colors.red,
                            duration: Duration(seconds: 3),
                            ctx: context,
                            alignment: Alignment.bottomCenter,
                          );
                        });

                        
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => Home(
                            user: user.user,
                          ),
                        ));
                      }
                    }
                  } else {
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
                }),
          //forgot password field
          forgotPasswordfield(
            onPressed: () {
              //TODO: Goto Forgot password page
            },
          ),
          sign_up_text()
        ],
      )),
    );
    //Landscape Orientation
  }
}
