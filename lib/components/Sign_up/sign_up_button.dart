import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:footsteps/components/AuthButtons.dart';
import 'package:footsteps/config/size_config.dart';
import 'package:footsteps/config/styling.dart';
import 'package:footsteps/models/formModels/SignInModel.dart';
import 'package:footsteps/screens/Portrait/HomePage.dart';
import 'package:footsteps/validation/sign_in_validation.dart';
import 'package:provider/provider.dart';

class sign_up_button extends StatelessWidget {
  String email, password;
  VoidCallback onButtonPressed;
  sign_up_button({this.email, this.password,this.onButtonPressed});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: SizeConfig.widthMultiplier * 5,
            vertical: SizeConfig.heightMultiplier * 3,
          ),
          child: AuthButtons(
              btncolor: AppTheme.appDarkVioletColor,
              btntext: "Sign Up",
              height: SizeConfig.heightMultiplier * 5.5,
              width: SizeConfig.isMobilePortrait
                  ? SizeConfig.widthMultiplier * 70
                  : SizeConfig.widthMultiplier * 50,
              onbuttonPressed:onButtonPressed,

          //AuthButtons("Sign In",AppTheme.appDarkVioletColor,SizeConfig.heightMultiplier*5.5,SizeConfig.widthMultiplier*50),
        ),)
      ],
    );
  }
}
