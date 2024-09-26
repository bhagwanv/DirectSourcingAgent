import 'package:direct_sourcing_agent/utils/MixpanelManager.dart';
import 'package:direct_sourcing_agent/utils/MixpannelEventName.dart';
import 'package:direct_sourcing_agent/utils/common_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import '../../providers/DataProvider.dart';
import '../../shared_preferences/shared_pref.dart';
import '../../utils/PermissionPage.dart';
import '../../utils/common_elevted_button.dart';
import '../../utils/constant.dart';
import '../../utils/utils_class.dart';
import '../otp_screens/OtpScreen.dart';

class LoginScreen extends StatefulWidget {

  final String? pageType;
  const LoginScreen({super.key, this.pageType});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _mobileNumberController = TextEditingController();
  var isTermChecked = false;

  @override
  void dispose() {
    _mobileNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) {
          return;
        }
        final bool shouldPop = await Utils().onback(context);
        if (shouldPop) {
          SystemNavigator.pop();
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          top: true,
          child:
              Consumer<DataProvider>(builder: (context, dataProvider, child) {
            return SingleChildScrollView(
                child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const SizedBox(height: 77),
                    Image.asset('assets/images/scaleup_logo_two.png'),
                    // Replace with your actual logo path
                    const SizedBox(height: 77),
                    Text(
                      'Welcome',
                      style: GoogleFonts.urbanist(
                        fontSize: 30,
                        color: Colors.black,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Text(
                      'Sign in or create a new account',
                      style: GoogleFonts.urbanist(
                        fontSize: 15,
                        color: Colors.black,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 77),
                    Padding(
                      padding: const EdgeInsets.only(right: 15, left: 15),
                      child: CommonTextField(
                        controller: _mobileNumberController,
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.done,
                        inputFormatter: [
                          FilteringTextInputFormatter.allow(RegExp((r'[0-9]'))),
                          LengthLimitingTextInputFormatter(10)
                        ],
                        maxLines: 1,
                        hintText: "Enter Mobile Number",
                        labelText: "Enter Mobile Number",
                      ),
                    ),
                    const SizedBox(height: 77),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Checkbox(
                          activeColor: kPrimaryColor,
                          checkColor: Colors.white,
                          value: isTermChecked,
                          side: const BorderSide(color: kPrimaryColor),
                          onChanged: (bool? value) {
                            setState(() {
                              isTermChecked = value!;
                            });
                          },
                        ),
                        Expanded(
                            child: Padding(
                          padding: const EdgeInsets.only(top: 12.0),
                          child: Container(
                            alignment: Alignment.center,
                            child: RichText(
                              text: TextSpan(
                                style: TextStyle(fontSize: 12),
                                children: <TextSpan>[
                                  TextSpan(
                                    text: 'I agree to the ',
                                    style: GoogleFonts.urbanist(
                                      fontSize: 12,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  TextSpan(
                                    text: 'Terms of service',
                                    style: GoogleFonts.urbanist(
                                      fontSize: 12,
                                      color: kPrimaryColor,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  TextSpan(
                                    text: ' and ',
                                    style: GoogleFonts.urbanist(
                                      fontSize: 12,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  TextSpan(
                                    text: 'Privacy Policy',
                                    style: GoogleFonts.urbanist(
                                      fontSize: 12,
                                      color: kPrimaryColor,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  TextSpan(
                                    text:
                                        ', override my NDNC registration and authorize Scaleup to contact me through Calls, WhatsApp, SMS & Email',
                                    style: GoogleFonts.urbanist(
                                      fontSize: 12,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        )),
                      ],
                    ),
                    const SizedBox(height: 25),
                    Padding(
                      padding: const EdgeInsets.only(right: 15, left: 15),
                      child: CommonElevatedButton(
                        textSize: 20.0,
                        onPressed: () async {
                          var mixpanelData = {
                            'Button Name': 'Continue',
                            'Screen': 'Login Screen',
                            'Mobile Number':
                                _mobileNumberController.text.trim(),
                            'Term and Condition Check': isTermChecked,
                          };
                          MixpanelManager().trackEvent(
                              MixpannelEventName.loginAttempt, mixpanelData);
                          if (_mobileNumberController.text.trim().isEmpty) {
                            Utils.showToast(
                                "Please enter mobile number", context);
                          } else if (!Utils.isPhoneNoValid(
                              _mobileNumberController.text)) {
                            Utils.showToast(
                                "Please enter valid mobile number", context);
                          } else if (!isTermChecked) {
                            Utils.hideKeyBored(context);
                            Utils.showToast(
                                "Please check term & condition", context);
                          } else {
                            PermissionStatus cameraPermissionStatus =
                                await Permission.camera.status;
                            PermissionStatus microphonePermissionStatus =
                                await Permission.microphone.status;
                            PermissionStatus smsPermissionStatus =
                                await Permission.sms.status;
                            Utils.hideKeyBored(context);
                            final prefsUtil = await SharedPref.getInstance();
                            await prefsUtil.saveString(LOGIN_MOBILE_NUMBER,
                                _mobileNumberController.text.toString());
                            if (cameraPermissionStatus.isGranted &&
                                microphonePermissionStatus.isGranted &&
                                smsPermissionStatus.isGranted) {
                              Utils.onLoading(context, "");
                              await Provider.of<DataProvider>(context,
                                      listen: false)
                                  .genrateOtp(
                                      context, _mobileNumberController.text);
                              if (dataProvider.genrateOptData != null) {
                                Navigator.of(context, rootNavigator: true)
                                    .pop();
                                dataProvider.genrateOptData!.when(
                                  success: (data) async {
                                    if (!data.status!) {
                                      Utils.showToast(data.message!, context);
                                    } else {
                                      var mixpanelData = {
                                        'Button Name': 'Continue',
                                        'Screen': 'Login Screen',
                                        'Mobile Number':
                                        _mobileNumberController.text.trim(),
                                      };
                                      MixpanelManager().trackEvent(
                                          MixpannelEventName.otpSent, mixpanelData);
                                      prefsUtil.saveString(DSA_OTP, data.otp!);
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) {
                                            return  OtpScreen(userOtp: data.otp!,userLoginMobile:_mobileNumberController.text,);
                                          },
                                        ),
                                      );
                                    }
                                  },
                                  failure: (exception) {},
                                );
                              }
                              dataProvider.disposeAllProviderData();
                            } else {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const PermissionPage()),
                              );
                            }
                          }
                        },
                        text: "Continue",
                        upperCase: false,
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ));
          }),
        ),
      ),
    );
  }
}
