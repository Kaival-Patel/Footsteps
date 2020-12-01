import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:footsteps/config/size_config.dart';
import 'dart:async';
import 'package:footsteps/config/styling.dart';
import 'package:footsteps/screens/Portrait/Sign_in.dart';
import 'package:footsteps/screens/Portrait/middleware.dart';

class splash extends StatefulWidget {
  @override
  _splashState createState() => _splashState();
}

class _splashState extends State<splash> with TickerProviderStateMixin {
  AnimationController scaleanimationController,
      fs1Controller,
      fs2Controller,
      fs3Controller,
      fs4Controller;
  Animation _scaleAmimation,
      fs1animation,
      fs2animation,
      fs3animation,
      fs4animation;

  @override
  void initState() {
    super.initState();

    startSplashTimer();
    scaleanimationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    _scaleAmimation =
        CurvedAnimation(curve: Curves.easeIn, parent: scaleanimationController);
    scaleanimationController.forward();

    fs1Controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    fs1animation =
        CurvedAnimation(curve: Curves.easeInOutBack, parent: fs1Controller);

    fs2Controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    fs2animation =
        CurvedAnimation(curve: Curves.easeInOutBack, parent: fs2Controller);

    fs3Controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    fs3animation =
        CurvedAnimation(curve: Curves.easeInOutBack, parent: fs3Controller);

    fs4Controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    fs4animation =
        CurvedAnimation(curve: Curves.easeInOutBack, parent: fs4Controller);

    fs1Controller.forward().whenComplete(() => fs2Controller
        .forward()
        .whenComplete(() => fs3Controller
            .forward()
            .whenComplete(() => fs4Controller.forward())));
  }

  @override
  void dispose() {

  fs1Controller.dispose();
  fs2Controller.dispose();
  fs3Controller.dispose();
  fs4Controller.dispose();
  scaleanimationController.dispose();
  super.dispose();
   
  }

  startSplashTimer() async {
    //timer duration
    var _duration = new Duration(seconds: 3);
    return new Timer(_duration, navigateFurther);
  }

  void navigateFurther() async {
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (BuildContext context) => Sign_In()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: ScaleTransition(
              scale: scaleanimationController,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 10.0 * SizeConfig.widthMultiplier,
                  vertical: 3 * SizeConfig.heightMultiplier,
                ),
                child: Image(
                  image: AssetImage(AppTheme.splashlogoPath),
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
          Text(
            "Footsteps",
            style: AppTheme.titlelight.copyWith(
                fontSize: SizeConfig.textMultiplier * 5,
                fontWeight: FontWeight.bold),
          ),
          Container(
            height: SizeConfig.heightMultiplier * 20,
            width: SizeConfig.widthMultiplier * 100,
            child: Stack(
              children: [
                Positioned(
                  bottom: SizeConfig.heightMultiplier * 7.5,
                  left: SizeConfig.widthMultiplier * 60,
                  child: FadeTransition(
                    opacity: fs3animation,
                    child: Image(
                      image: AssetImage(AppTheme.footstepPath),
                      height: SizeConfig.heightMultiplier * 8,
                      width: SizeConfig.widthMultiplier * 8,
                    ),
                  ),
                ),
                Positioned(
                  bottom: SizeConfig.heightMultiplier * 3.5,
                  left: SizeConfig.widthMultiplier * 28,
                  child: FadeTransition(
                    opacity: fs2animation,
                    child: Image(
                      image: AssetImage(AppTheme.footstepPath),
                      height: SizeConfig.heightMultiplier * 8,
                      width: SizeConfig.widthMultiplier * 8,
                    ),
                  ),
                ),
                Positioned(
                  top: SizeConfig.heightMultiplier * 12,
                  //bottom: SizeConfig.heightMultiplier*0.1,
                  left: SizeConfig.widthMultiplier * 2,
                  child: FadeTransition(
                    opacity: fs1animation,
                    child: Image(
                      image: AssetImage(AppTheme.footstepPath),
                      height: SizeConfig.heightMultiplier * 8,
                      width: SizeConfig.widthMultiplier * 8,
                    ),
                  ),
                ),
                Positioned(
                  right: SizeConfig.widthMultiplier * 2,
                  bottom: SizeConfig.heightMultiplier * 12,
                  child: FadeTransition(
                    opacity: fs4animation,
                    child: Image(
                      image: AssetImage(AppTheme.footstepPath),
                      height: SizeConfig.heightMultiplier * 8,
                      width: SizeConfig.widthMultiplier * 8,
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
