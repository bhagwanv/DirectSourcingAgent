import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';
import 'package:timer_count_down/timer_controller.dart';
import 'package:timer_count_down/timer_count_down.dart';
import '../../api/ApiService.dart';
import '../../api/FailureException.dart';
import '../../providers/DataProvider.dart';
import '../../shared_preferences/shared_pref.dart';
import '../../utils/common_elevted_button.dart';
import '../../utils/constant.dart';
import '../../utils/customer_sequence_logic.dart';
import '../../utils/utils_class.dart';
import '../splash/model/GetLeadResponseModel.dart';
import '../splash/model/LeadCurrentRequestModel.dart';
import '../splash/model/LeadCurrentResponseModel.dart';
import 'models/AadhaaGenerateOTPRequestModel.dart';
import 'models/ValidateAadhaarOTPRequestModel.dart';

class AadhaarOtpScreen extends StatefulWidget {
  final int activityId;
  final int subActivityId;
  final AadhaarGenerateOTPRequestModel? document;
  String? requestId;

  AadhaarOtpScreen(
      {super.key,
      required this.activityId,
      required this.subActivityId,
      required this.document,
      required this.requestId});

  @override
  State<AadhaarOtpScreen> createState() => _AadhaarOtpScreenState();
}

class _AadhaarOtpScreenState extends State<AadhaarOtpScreen> {
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
  int _start = 60;
  final CountdownController _controller = CountdownController(autoStart: true);
  bool isReSendDisable = true;
  final pinController = TextEditingController();

  Widget buildCountdown() {
    print("_start $_start");
    return Countdown(
      controller: _controller,
      seconds: _start,
      build: (_, double time) => Text(
        " ${time.toStringAsFixed(0)} Sec",
        style: GoogleFonts.urbanist(
          fontSize: 15,
          color: kPrimaryColor,
          fontWeight: FontWeight.w400,
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
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child:
            Consumer<DataProvider>(builder: (context, productProvider, child) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 30, top: 20, right: 30, bottom: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: SvgPicture.asset(
                          "assets/icons/back_arrow_icon.svg",
                          colorFilter: const ColorFilter.mode(
                              Colors.black,
                              BlendMode
                                  .srcIn), // Replace blackSmall with Colors.black
                        ),
                      ),
                      const Spacer(),
                      Text(
                        'Enter OTP',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.urbanist(
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Spacer()
                    ],
                  ),
                  const SizedBox(
                    height: 125,
                  ),
                  Text(
                    'Enter the verification code sent on Aadhaar registered mobile number',
                    textAlign: TextAlign.start,
                    style: GoogleFonts.urbanist(
                      fontSize: 15,
                      color: blackSmall,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(
                    height: 55,
                  ),
                  Center(
                    child: Pinput(
                      length: 6,
                      controller: pinController,
                      showCursor: true,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp("[0-9\]")),
                      ],
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
                  isReSendDisable
                      ? SizedBox(
                          width: double.infinity,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Resend Code in ',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.urbanist(
                                  fontSize: 15,
                                  color: kPrimaryColor,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              buildCountdown(),
                            ],
                          ),
                        )
                      : Container(),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                      padding: EdgeInsets.all(10),
                      child: Center(
                        child: RichText(
                          text: TextSpan(
                              text: 'If you didn’t received a code!',
                              style: GoogleFonts.urbanist(
                                fontSize: 15,
                                color: blackSmall,
                                fontWeight: FontWeight.w400,
                              ),
                              children: <TextSpan>[
                                isReSendDisable
                                    ? TextSpan(
                                        text: '  Resend',
                                        style: GoogleFonts.urbanist(
                                          fontSize: 15,
                                          color: Colors.grey,
                                          fontWeight: FontWeight.w400,
                                        ),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () async {})
                                    : TextSpan(
                                        text: '  Resend',
                                        style: GoogleFonts.urbanist(
                                          fontSize: 15,
                                          color: kPrimaryColor,
                                          fontWeight: FontWeight.w400,
                                        ),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () async {
                                            isReSendDisable = true;
                                            generateAadhaarOTPAPI(
                                                context, productProvider);
                                          })
                              ]),
                        ),
                      )),
                  const SizedBox(
                    height: 10,
                  ),
                  CommonElevatedButton(
                    onPressed: () {
                      validateAadhaar(
                          context, pinController.text, productProvider);
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

  void validateAadhaar(
    BuildContext context,
    String otpText,
    DataProvider productProvider,
  ) async {
    if (otpText.isEmpty) {
      Utils.showToast("Please Enter OTP", context);
    } else if (otpText.length < 6) {
      Utils.showToast("PLease Enter Valid Otp", context);
    } else {
      final prefsUtil = await SharedPref.getInstance();

      var req = ValidateAadhaarOTPRequestModel(
          leadId: prefsUtil.getInt(LEADE_ID),
          userId: prefsUtil.getString(USER_ID),
          activityId: widget.activityId,
          subActivityId: widget.subActivityId,
          documentNumber: widget.document?.DocumentNumber!,
          frontFileUrl: widget.document?.FrontFileUrl!,
          backFileUrl: widget.document?.BackFileUrl!,
          frontDocumentId: widget.document?.FrontDocumentId!,
          backDocumentId: widget.document?.BackDocumentId!,
          otp: otpText,
          requestId: widget.requestId!,
          companyId: prefsUtil.getInt(COMPANY_ID));
      Utils.onLoading(context, "");
      await Provider.of<DataProvider>(context, listen: false)
          .validateAadhaarOtp(req);
      Navigator.of(context, rootNavigator: true).pop();
      if (productProvider.getValidateAadhaarOTPData != null) {
        productProvider.getValidateAadhaarOTPData!.when(
          success: (ValidateAadhaarOTPResponseModel) async {
            var leadAadhaarResponse = ValidateAadhaarOTPResponseModel;
            if (leadAadhaarResponse != null) {
              if (leadAadhaarResponse.isSuccess != null) {
                if (leadAadhaarResponse.isSuccess!) {
                  fetchData(context);
                } else {
                  Utils.showToast(leadAadhaarResponse.message!, context);
                }
              }
            }
          },
          failure: (exception) {
            if (exception is ApiException) {
              if (exception.statusCode == 401) {
                productProvider.disposeAllProviderData();
                ApiService().handle401(context);
              } else {
                Utils.showToast(exception.errorMessage, context);
              }
            }
          },
        );
      }
    }
  }

  Future<void> fetchData(BuildContext context) async {
    final prefsUtil = await SharedPref.getInstance();
    try {
      LeadCurrentResponseModel? leadCurrentActivityAsyncData;
      var leadCurrentRequestModel = LeadCurrentRequestModel(
        companyId: prefsUtil.getInt(COMPANY_ID),
        productId: prefsUtil.getInt(PRODUCT_ID),
        leadId: prefsUtil.getInt(LEADE_ID),
        userId: prefsUtil.getString(USER_ID),
        mobileNo: prefsUtil.getString(LOGIN_MOBILE_NUMBER),
        activityId: widget.activityId,
        subActivityId: widget.subActivityId,
        monthlyAvgBuying: 0,
        vintageDays: 0,
        isEditable: true,
      );
      leadCurrentActivityAsyncData = await ApiService()
              .leadCurrentActivityAsync(leadCurrentRequestModel, context)
          as LeadCurrentResponseModel?;

      GetLeadResponseModel? getLeadData;
      getLeadData = await ApiService().getLeads(
          prefsUtil.getString(LOGIN_MOBILE_NUMBER)!,
          prefsUtil.getInt(PRODUCT_ID)!,
          prefsUtil.getInt(COMPANY_ID)!,
          prefsUtil.getInt(LEADE_ID)!) as GetLeadResponseModel?;

      customerSequence(
          context, getLeadData, leadCurrentActivityAsyncData, "push");
    } catch (error) {
      if (kDebugMode) {
        print('Error occurred during API call: $error');
      }
    }
  }

  void generateAadhaarOTPAPI(
    BuildContext context,
    DataProvider productProvider,
  ) async {
    var request = AadhaarGenerateOTPRequestModel(
        DocumentNumber: widget.document?.DocumentNumber!,
        FrontFileUrl: widget.document?.FrontFileUrl!,
        BackFileUrl: widget.document?.BackFileUrl!,
        FrontDocumentId: widget.document?.FrontDocumentId!,
        BackDocumentId: widget.document?.BackDocumentId!,
        otp: "",
        requestId: "");
    Utils.onLoading(context, "");
    await Provider.of<DataProvider>(context, listen: false)
        .leadAadharGenerateOTP(request);
    Navigator.of(context, rootNavigator: true).pop();
    if (productProvider.getLeadAadharGenerateOTP != null) {
      productProvider.getLeadAadharGenerateOTP!.when(
        success: (AadhaarGenerateOTPResponseModel) async {
          var leadAadhaarResponse = AadhaarGenerateOTPResponseModel;
          if (leadAadhaarResponse != null) {
            if (leadAadhaarResponse.data!.message != null) {
              /*Utils.showToast(
                  " ${leadAadhaarResponse.data!.message!}",context);*/
            }
            widget.requestId = leadAadhaarResponse.requestId!;
          }
        },
        failure: (exception) {
          if (exception is ApiException) {
            if (exception.statusCode == 401) {
              productProvider.disposeAllProviderData();
              ApiService().handle401(context);
            } else {
              Utils.showToast(exception.errorMessage, context);
            }
          }
        },
      );
    }
  }
}
