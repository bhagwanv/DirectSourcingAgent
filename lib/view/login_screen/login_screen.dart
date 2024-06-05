import 'package:direct_sourcing_agent/utils/common_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../providers/DataProvider.dart';
import '../../shared_preferences/shared_pref.dart';
import '../../utils/common_elevted_button.dart';
import '../../utils/constant.dart';
import '../../utils/utils_class.dart';
import '../otp_screens/OtpScreen.dart';

class LoginScreen extends StatefulWidget {
  final String? pageType;

  const LoginScreen(
      {super.key,
        this.pageType});

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
      onPopInvoked: (didPop) async {
        debugPrint("didPop1: $didPop");
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
          child: Consumer<DataProvider>(
              builder: (context, dataProvider, child) {
                return SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            const SizedBox(height: 97),
                            Image.asset('assets/images/scaleup_logo_two.png'),
                            // Replace with your actual logo path
                            const SizedBox(height: 87),
                            const Text(
                              'Welcome',
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                            const Text(
                              'Sign in or create a new account',
                              style: TextStyle(fontSize: 16),
                            ),
                            const SizedBox(height: 92),
                            CommonTextField(
                              controller: _mobileNumberController,
                              keyboardType: TextInputType.number,
                              textInputAction: TextInputAction.done,
                              maxLength: 10,
                              maxLines: 1,
                              hintText: "Enter Mobile Number",
                              labelText: "Enter Mobile Number",
                            ),
                            const SizedBox(height: 32),
                            CommonElevatedButton(
                              onPressed: () async {
                                if (_mobileNumberController.text.isEmpty) {
                                  Utils.showToast("Please Enter Mobile Number",context);
                                } else if (!Utils.isPhoneNoValid(_mobileNumberController.text)) {
                                  Utils.showToast("Please Enter Valid Mobile Number",context);
                                }  else if (!isTermChecked) {
                                  Utils.hideKeyBored(context);
                                  Utils.showToast("Please Check Term n Condition",context);
                                } else {
                                  final prefsUtil = await SharedPref.getInstance();
                                  Utils.onLoading(context, "");
                                  await Provider.of<DataProvider>(context, listen: false).genrateOtp(context, _mobileNumberController.text);
                                  if (dataProvider.genrateOptData != null) {
                                    await prefsUtil.saveString(LOGIN_MOBILE_NUMBER, _mobileNumberController.text.toString());
                                    Navigator.of(context, rootNavigator: true).pop();
                                    dataProvider.genrateOptData!.when(
                                      success: (data) async {
                                        if (!data.status!) {
                                          Utils.showToast(data.message!,context);
                                        } else {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) {
                                                return OtpScreen();
                                              },
                                            ),
                                          );
                                        }
                                      },
                                      failure: (exception) {
                                      },
                                    );
                                  }
                                  dataProvider.disposeAllProviderData();
                                }
                              },
                              text: "Continue",
                              upperCase: true,
                            ),
                            const SizedBox(height: 88),
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
                                                style: TextStyle(color: Colors.black),
                                              ),
                                              TextSpan(
                                                text: 'Terms of service',
                                                style: TextStyle(color: Colors.blue),
                                              ),
                                              TextSpan(
                                                text: ' and ',
                                                style: TextStyle(color: Colors.black),
                                              ),
                                              TextSpan(
                                                text: 'Privacy Policy',
                                                style: TextStyle(color: Colors.blue),
                                              ),
                                              TextSpan(
                                                text: ', override my NDNC registration and authorize Scaleup to contact me through Calls, WhatsApp, SMS & Email',
                                                style: TextStyle(color: Colors.black),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    )
                                ),
                              ],)
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
