import 'package:flutter/material.dart';
import 'package:footsteps/config/size_config.dart';
import 'package:footsteps/config/styling.dart';
import 'package:footsteps/models/formModels/SignInModel.dart';
import 'package:footsteps/validation/sign_in_validation.dart';
import 'package:provider/provider.dart';

class emailfield extends StatelessWidget {
  FocusNode focus;
  String email = "";

  TextEditingController emailCTRL = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<sign_in_validation>(
      create: (context) => sign_in_validation(),
      child: Consumer<sign_in_validation>(
        builder: (context, model, child) => Column(children: [
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
                    onChanged: (value) {
                      //TODO: Put the ref to provider
                      email = value;
                      //emailCTRL.text = value;
                      model.changeEmail(value);
                      
                      //model.submitData();
                      //print(Provider.of<SignInModel>(context,listen: false).email);
                    },
                    controller: emailCTRL,
                    onFieldSubmitted: (v) {
                      print("SUBMITTED EMAIL!!");
                      FocusScope.of(context).requestFocus(focus);
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
          )
        ]),
      ),
    );
  }
}
