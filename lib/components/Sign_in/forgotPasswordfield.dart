import 'package:flutter/material.dart';
import 'package:footsteps/config/size_config.dart';
import 'package:footsteps/config/styling.dart';

class forgotPasswordfield extends StatelessWidget {
  VoidCallback onPressed;
  forgotPasswordfield({this.onPressed});
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.symmetric(
            horizontal: SizeConfig.widthMultiplier * 2,
            vertical: SizeConfig.heightMultiplier * 0.2),
        child: InkWell(
          onTap: onPressed,
          child: Text(
            "Forgot Password",
            style: AppTheme.titlelight.copyWith(
                fontSize: SizeConfig.textMultiplier * 1.8,
                decoration: TextDecoration.underline,
                color: AppTheme.appOrangeColor),
          ),
        ));
  }
}
