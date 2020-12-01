import 'package:flutter/material.dart';
import 'package:footsteps/config/size_config.dart';
import 'package:footsteps/config/styling.dart';
import 'package:footsteps/screens/Portrait/Sign_up.dart';

class sign_up_text extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: SizeConfig.widthMultiplier * 2,
          vertical: SizeConfig.heightMultiplier * 2),
      child: Column(
        children: [
          Center(
            child: Text(
              "Seeing this for first time?",
              style: AppTheme.titlelight
                  .copyWith(fontSize: SizeConfig.textMultiplier * 1.5),
            ),
          ),
          Center(
            child: InkWell(
                onTap: () {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context)=>Sign_up()
                  ));
                },
                child: Text(
                  "Sign Up",
                  style: AppTheme.titlelight
                      .copyWith(fontSize: SizeConfig.textMultiplier * 1.8,
                      decoration: TextDecoration.underline,
                      color: AppTheme.appOrangeColor
                    ),
                )),
          ),
        ],
      ),
    );
  }
}
