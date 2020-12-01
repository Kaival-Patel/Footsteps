import 'package:flutter/material.dart';
import 'package:footsteps/config/size_config.dart';

class AppTheme {
  AppTheme._();

  static const Color appDarkVioletColor = Color(0xFF423B7E);
  static const Color appOrangeColor = Color(0xFFFFA600);
  static const Color appLightOrangeColor = Color(0xFFfce6bd);
  static const Color appLightVioletColor = Color(0xFFEBEAF0);
  static const Color appFormLightVioletColor = Color(0xFFEBEBF3);
  static const Color whiteColor = Colors.white;

  static final ThemeData lightTheme = ThemeData(
    scaffoldBackgroundColor: Colors.white,
    brightness: Brightness.light,
    fontFamily: "Poppins",
    textTheme: lightTextTheme,
  );

  static final ThemeData darkTheme = ThemeData(
    scaffoldBackgroundColor: Colors.black,
    brightness: Brightness.dark,
    fontFamily: "Poppins",
    textTheme: darkTextTheme,
  );

  static final TextTheme lightTextTheme = TextTheme(
    title: titlelight,
    button: buttonlight,
  );

  static final TextTheme darkTextTheme = TextTheme(
    title: titledark,
    button: buttondark,
  );

  static final TextStyle titlelight = TextStyle(
    color: appDarkVioletColor,
    fontSize: 3.5 * SizeConfig.textMultiplier,
  );
  static final TextStyle titledark = TextStyle(
    color: whiteColor,
    fontSize: 3.5 * SizeConfig.textMultiplier,
  );

  static final TextStyle buttonlight = TextStyle(
    color: whiteColor,
    fontSize: 2.5 * SizeConfig.textMultiplier,
  );
  static final TextStyle buttondark = TextStyle(
    color: appDarkVioletColor,
    fontSize: 2.5 * SizeConfig.textMultiplier,
  );

  static const String splashlogoPath = "assets/images/splash_logo.png";
  static const String footstepPath = "assets/images/footstep.png";
  static const String loginBannerPath = "assets/images/login_banner.svg";
  static const String signupBannerPath = "assets/images/signup_banner.svg";
  static const String profileBannerPath = "assets/images/profile_banner.svg";
}
