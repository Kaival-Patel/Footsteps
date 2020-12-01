import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:footsteps/config/size_config.dart';
import 'package:footsteps/config/styling.dart';

class AuthButtons extends StatelessWidget {
  @required
  String btntext;
  @required
  Color btncolor;
  @required
  double height, width;
  @required
  VoidCallback onbuttonPressed;
  AuthButtons({this.btntext, this.btncolor, this.height, this.width,this.onbuttonPressed});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:onbuttonPressed,
      child: Container(
          decoration: BoxDecoration(
            color: btncolor,
            borderRadius: BorderRadius.circular(5.0),
          ),
          height: height,
          width: width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 7,
                child: Align(
                  alignment: Alignment.center,
                  child: Text(btntext,
                      style: AppTheme.titledark
                          .copyWith(fontSize: SizeConfig.textMultiplier * 2.5)),
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
    );
  }
}
