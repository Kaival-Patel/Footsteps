import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:footsteps/config/size_config.dart';
import 'package:footsteps/config/styling.dart';
class LoginBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: SizeConfig.widthMultiplier * 5,
          vertical: SizeConfig.isMobilePortrait?SizeConfig.heightMultiplier * 0.2:SizeConfig.heightMultiplier * 2),
      child: Container(
        child: AspectRatio(
          aspectRatio: SizeConfig.isMobilePortrait ? 1.0 : 2.0,
          child: SizedBox(
              height: SizeConfig.heightMultiplier*20,
              width: SizeConfig.widthMultiplier*20,
              child: SvgPicture.asset(AppTheme.loginBannerPath)
            ),
          // child: Image(
          //   image: AssetImage(AppTheme.loginBannerPath),
          // ),
        ),
      ),
    );
  }
}