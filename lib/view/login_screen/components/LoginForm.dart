import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../../providers/auth_provider/DataProvider.dart';
import '../../../shared_preferences/shared_pref.dart';
import '../../../utils/common_elevted_button.dart';
import '../../../utils/constant.dart';
import '../../../utils/utils_class.dart';
import '../../aadhaar_screen/components/CheckboxTerm.dart';
import '../../otp_screens/OtpScreen.dart';

class LoginForm extends StatefulWidget {
  DataProvider? productProvider;
  int? activityId;
  int? subActivityId;
  final int? companyID;
  final int? ProductID;
  final String? MobileNumber;

  LoginForm(
      {required this.productProvider,
      required this.activityId,
      required this.subActivityId,
      this.companyID,
      this.ProductID,
      this.MobileNumber,
      super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController _mobileNumberCl = TextEditingController();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool isTermsChecks = false;
    _mobileNumberCl.text = widget.MobileNumber.toString();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(children: [
           SizedBox(
            width: 58,
            child: TextField(
              readOnly: true,
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.done,
              maxLength: 10,
              maxLines: 1,
              cursorColor: Colors.blue,
              decoration: InputDecoration(
                counterText: "",
                hintText: "+91",
                fillColor: textFiledBackgroundColour,
                filled: true,
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: kPrimaryColor),
                ),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    borderSide: BorderSide(color: kPrimaryColor)),
              ),
            ),
          ),
          SizedBox(
            width: 20,
          ),
          Expanded(
            child: SizedBox(
              child: TextField(
                controller: _mobileNumberCl,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.done,
                maxLength: 10,
                maxLines: 1,
                readOnly: true,
                cursorColor: Colors.black,
                decoration: const InputDecoration(
                  counterText: "",
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: kPrimaryColor),
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                  hintText: "Enter Your Number",
                  fillColor: textFiledBackgroundColour,
                  filled: true,
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: kPrimaryColor, width: 1.0),
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                ),
              ),
            ),
          )
        ]),
        const SizedBox(
          height: 50,
        ),
        Column(
          children: [
            CheckboxTerm(
              content:
              "I acknowledge and consent to the sharing of my data for the purpose of Scaleup pay application. I understand that my data may be used in accordance with the scaleup privacy policy. By proceeding, I agree to these terms.",
              onChanged: (bool? value) {
                isTermsChecks = value!;
              },
            )
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(top: 50),
          child: Column(
            children: [
              CommonElevatedButton(
                onPressed: () async {
                  if (_mobileNumberCl.text.isEmpty) {
                    Utils.showToast("Please Enter Mobile Number",context);
                  } else if (!Utils.isPhoneNoValid(_mobileNumberCl.text)) {
                    Utils.showToast("Please Enter Valid Mobile Number",context);
                  } else if (!isTermsChecks) {
                    Utils.showToast("Please Check Terms And Conditions",context);
                  } else {

                    final prefsUtil = await SharedPref.getInstance();
                    Utils.onLoading(context, "");
                    await Provider.of<DataProvider>(context, listen: false).genrateOtp(context, _mobileNumberCl.text, widget.companyID!);

                    if (widget.productProvider!.genrateOptData != null) {
                      widget.productProvider!.genrateOptData!.when(
                        success: (GenrateOptResponceModel) async {
                          // Handle successful response
                          var genrateOptResponceModel = GenrateOptResponceModel;

                          if (!genrateOptResponceModel.status!) {
                            Utils.showToast(genrateOptResponceModel.message!,context);
                          } else {
                            await prefsUtil.saveString(LOGIN_MOBILE_NUMBER, _mobileNumberCl.text.toString());
                            await prefsUtil.saveInt(COMPANY_ID, widget.companyID!);
                            await prefsUtil.saveInt(PRODUCT_ID, widget.ProductID!);
                            widget.productProvider!.disposeAllProviderData();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return OtpScreen(
                                      activityId: widget.activityId!,
                                      subActivityId: widget.subActivityId!);
                                },
                              ),
                            );
                          }
                        },
                        failure: (exception) {
                          // Handle failure
                          print("dfjsf2");
                          //print('Failure! Error: ${exception.message}');
                        },
                      );
                    }
                    //Utils.hideKeyBored(context);
                    Navigator.of(context, rootNavigator: true).pop();

                  }
                  ;
                },
                text: "GET OTP",
                upperCase: true,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
