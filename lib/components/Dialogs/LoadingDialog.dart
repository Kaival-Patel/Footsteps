import 'package:flutter/material.dart';
import 'package:footsteps/config/size_config.dart';
import 'package:loading_indicator/loading_indicator.dart';

class LoadingDialog {
  String loadingmsg;
  Indicator indicator;
  Color indicatorColor;
  BuildContext context;

  LoadingDialog(
      {this.loadingmsg, this.indicator, this.indicatorColor, this.context});

  showLoadingDialog() {
    AlertDialog(
      content:Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          LoadingIndicator(indicatorType: indicator,color: indicatorColor,),
          Text(loadingmsg,style: TextStyle(fontSize: SizeConfig.textMultiplier*3.5),)
        ],
      ),
    );
  }
  //  showLoadingDialog() {
  //   showDialog(
  //       context: this.context,
  //       barrierDismissible: false,
  //       child: );
  // }
}
