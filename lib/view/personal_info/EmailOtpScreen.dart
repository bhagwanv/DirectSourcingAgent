import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:timer_count_down/timer_controller.dart';
import 'package:timer_count_down/timer_count_down.dart';
import '../../api/ApiService.dart';
import '../../providers/DataProvider.dart';
import '../../utils/common_elevted_button.dart';
import '../../utils/constant.dart';
import '../../utils/utils_class.dart';
import 'model/OTPValidateForEmailRequest.dart';
import 'model/SendOtpOnEmailResponce.dart';

class EmailOtpScreen extends StatefulWidget {
  String? emailID;

  EmailOtpScreen({required this.emailID, super.key});

  @override
  State<EmailOtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<EmailOtpScreen> {
  String? appSignature;
  String? otpCode;
  DataProvider? productProvider;
  int _start = 60;
  bool isReSendDisable = true;
  var isLoading = true;
  final CountdownController _controller = CountdownController(autoStart: true);

  @override
  void initState() {
    super.initState();
    _start = 60;
  }

  Widget buildCountdown() {
    print("_start $_start");
    return Countdown(
      controller: _controller,
      seconds: _start,
      build: (_, double time) => Text(
        time.toStringAsFixed(0)+" S",
        style: TextStyle(
          fontSize: 15,
          color: Colors.blue,
          fontWeight: FontWeight.normal,
        ),
      ),
      interval: Duration(seconds: 1),
      onFinished: () {
        setState(() {
          isReSendDisable = false;
        });
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pinController = TextEditingController();
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 60,
      textStyle: const TextStyle(
        fontSize: 22,
        color: Colors.black,
      ),
      decoration: BoxDecoration(
        color: textFiledBackgroundColour,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: kPrimaryColor),
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Consumer<DataProvider>(builder: (context, productProvider, child) {
          return SingleChildScrollView(
            child: Padding(
              padding:
              const EdgeInsets.only(left: 30, top: 50, right: 30, bottom: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      height: 69,
                      width: 51,
                      alignment: Alignment.topLeft,
                      child: Image.asset('assets/images/scale.png')),
                  const SizedBox(
                    height: 50,
                  ),
                  Text(
                    'We just sent you an verification code on your emailID Please enter otp to verify',
                    textAlign: TextAlign.start,
                    style: TextStyle(fontSize: 15, color: Colors.black),
                  ),
                  const SizedBox(
                    height: 55,
                  ),
                  Center(
                    child: Pinput(
                      controller: pinController,
                      length: 6,
                      androidSmsAutofillMethod:
                      AndroidSmsAutofillMethod.smsRetrieverApi,
                      showCursor: true,
                      inputFormatters: [FilteringTextInputFormatter.allow(RegExp("[0-9\]")),],
                      pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
                      defaultPinTheme: defaultPinTheme,
                      focusedPinTheme: defaultPinTheme.copyWith(
                        decoration: defaultPinTheme.decoration!.copyWith(
                          border: Border.all(color: kPrimaryColor),
                        ),
                      ),
                      onCompleted: (pin) => debugPrint(pin),
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  isReSendDisable?SizedBox(
                    width: double.infinity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Resend Code in ',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 15,
                              color: kPrimaryColor,
                              fontWeight: FontWeight.normal),
                        ),
                        buildCountdown(),
                      ],
                    ),
                  ):Container(),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                      padding: EdgeInsets.all(10),
                      child: Center(
                        child: RichText(
                          text: TextSpan(
                              text: 'If you didnt received a code click',
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal),
                              children: <TextSpan>[
                                isReSendDisable
                                    ? TextSpan(
                                    text: '  Resend',
                                    style: const TextStyle(
                                        color: Colors.grey,
                                        fontSize: 14,
                                        fontWeight: FontWeight.normal),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () async {})
                                    : TextSpan(
                                    text: '  Resend',
                                    style: const TextStyle(
                                        color: Colors.blueAccent,
                                        fontSize: 14,
                                        fontWeight: FontWeight.normal),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () async {
                                        reSendOpt(context, productProvider, _controller, widget.emailID);
                                        isReSendDisable = true;
                                      })
                              ]),
                        ),
                      )),
                  SizedBox(
                    height: 20,
                  ),
                  Center(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop(true);
                        },
                        child: Text(
                          'Back',
                          textAlign: TextAlign.start,
                          style: TextStyle(fontSize: 15, color: Colors.blue),
                        ),
                      )
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  CommonElevatedButton(
                    onPressed: () {
                      callVerifyOtpApi(context, pinController.text,
                          widget.emailID!, productProvider);
                    },
                    text: "Verify Code",
                    upperCase: true,
                  )
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  void callVerifyOtpApi(BuildContext context, String otpText, String email,
      DataProvider productProvider) async {
    var isValid = false;
    if (otpText.isEmpty) {
      Utils.showToast("Please Enter Opt",context);
    } else if (otpText.length < 6) {
      Utils.showToast("PLease Enter Valid Otp",context);
    } else {
      Utils.onLoading(context, "");
      try {
        await productProvider.otpValidateForEmail(OtpValidateForEmailRequest(email: email, otp: otpText));
        if (productProvider.getValidOtpEmailData != null &&
            productProvider.getValidOtpEmailData!.status != null &&
            !productProvider.getValidOtpEmailData!.status!) {
          Utils.showToast(productProvider.getValidOtpEmailData!.message!,context);
        } else {
          isValid = true;
          Navigator.of(context, rootNavigator: true).pop();
        }
      } catch (error) {
        // Handle any errors that occur during the API call
        Utils.showToast("An error occurred: $error",context);
      } finally {
        Navigator.of(context, rootNavigator: true).pop({
          'isValid': isValid,
          'Email': email,
        });
      }
    }
  }

  void reSendOpt(BuildContext context, DataProvider productProvider, CountdownController controller, String? emailID) async {
    /*Utils.onLoading(context, "");
    SendOtpOnEmailResponce sendOtpOnEmailResponce;
    sendOtpOnEmailResponce = await ApiService().sendOtpOnEmail(emailID!);
    Navigator.of(context, rootNavigator: true).pop();
    if (sendOtpOnEmailResponce != null && sendOtpOnEmailResponce.status!) {
      controller.restart();
      Utils.showToast(sendOtpOnEmailResponce.message!,context);
    }*/

  }
}
