import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:footsteps/config/size_config.dart';

class centerBottomToast {
  // FlashPosition flashPosition;
  // FlashStyle flashStyle;
  // Alignment alignment;
  // Duration duration;
  // Color borderColor, bgcolor, textColor;
  // String msgText;
  // bool enableDrag;
  // BuildContext ctx;
  // centerBottomToast(
  //     {this.flashPosition,
  //     this.flashStyle,
  //     this.alignment,
  //     this.duration,
  //     this.bgcolor,
  //     this.borderColor,
  //     this.enableDrag,
  //     this.ctx,
  //     this.msgText});
  void showCenter1Flash({
    FlashPosition flashPosition,
    FlashStyle flashStyle,
    Alignment alignment,
    Duration duration,
    Color borderColor, bgcolor, textColor,
    String msgText,
    bool enableDrag,
    BuildContext ctx
  }) {
    showFlash(
      context: ctx,
      duration: Duration(seconds: 5),
      builder: (_, controller) {
        return Flash(
            controller: controller,
            enableDrag: enableDrag,
            alignment: alignment,
            onTap: () => controller.dismiss(),
            child: Padding(
              padding: EdgeInsets.all(SizeConfig.imageSizeMultiplier * 2),
              child: DefaultTextStyle(
                style: TextStyle(color: textColor),
                child: Text(msgText),
              ),
            ));
      },
    ).then((_) {
      if (_ != null) {
        showMessage(_.toString(),ctx);
      }
    });
  }
   void showMessage(String message,BuildContext ctx) {
    showFlash(
        context: ctx,
        duration: Duration(seconds: 3),
        builder: (_, controller) {
          return Flash(
            controller: controller,
            position: FlashPosition.top,
            style: FlashStyle.grounded,
            child: FlashBar(
              icon: Icon(
                Icons.face,
                size: 36.0,
                color: Colors.black,
              ),
              message: Text(message),
            ),
          );
        });
  }
   
  // 
   void showCenterFlash({
    FlashPosition position,
    FlashStyle style,
    Alignment alignment,
    BuildContext ctx,
    String msgtext,
    Color bgColor,
    Color textColor,
    Color borderColor,
    Duration duration
  }) {
    showFlash(
      context: ctx,
      duration: duration,
      builder: (_, controller) {
        return Flash(
          controller: controller,
          backgroundColor: bgColor,
          borderRadius: BorderRadius.circular(8.0),
          borderColor: borderColor,
          position: position,
          style: style,
          alignment: alignment,
          enableDrag: false,
          onTap: () => controller.dismiss(),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: DefaultTextStyle(
              style: TextStyle(color:textColor),
              child: Text(
                msgtext,
              ),
            ),
          ),
        );
      },
    ).then((_) {
      if (_ != null) {
        showMessage(_.toString(),ctx);
      }
    });
  }
}

  // void showFlash(
  // FlashPosition flashPosition,
  // FlashStyle flashStyle,
  // Alignment alignment,
  // Duration duration,
  // Color borderColor, bgcolor, textColor,
  // String msgText,
  // bool enableDrag,
  // BuildContext ctx){
  //     context: ctx,
  //     duration: Duration(),
  //     builder: (_, controller) {
  //       return Flash(
  //           controller: controller,
  //           enableDrag: enableDrag,
  //           alignment: alignment,
  //           onTap: () => controller.dismiss(),
  //           child: Padding(
  //             padding: EdgeInsets.all(SizeConfig.imageSizeMultiplier * 2),
  //             child: DefaultTextStyle(
  //               style: TextStyle(color: textColor),
  //               child: Text(msgText),
  //             ),
  //           ));
  //     };
  // }
      

