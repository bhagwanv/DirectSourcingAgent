import 'package:direct_sourcing_agent/view/otp_screens/model/GetUserProfileResponse.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';
import 'package:sms_autofill/sms_autofill.dart';
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
import '../dashboard/bottom_navigation.dart';
import '../splash/model/GetLeadResponseModel.dart';
import '../splash/model/LeadCurrentRequestModel.dart';
import '../splash/model/LeadCurrentResponseModel.dart';
import 'model/GetUserProfileRequest.dart';
import 'model/VarifayOtpRequest.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> with CodeAutoFill {
  String? appSignature;
  String? otpCode;
  DataProvider? productProvider;
  bool isReSendDisable = true;
  String? userLoginMobile;
  var isLoading = true;
  int _start = 30;
  final CountdownController _controller = CountdownController(autoStart: true);

  @override
  void codeUpdated() {
    setState(() {
      otpCode = code;
      print("Code ######## " + otpCode!);
    });
  }

  @override
  void initState() {
    super.initState();
    listenOtp();
    _start = 30;
    // startTimer();
    SmsAutoFill().getAppSignature.then((signature) {
      setState(() {
        appSignature = signature;
        print("MUkesh " + appSignature!);
      });
    });
  }

  Widget buildCountdown() {
    return Countdown(
      controller: _controller,
      seconds: _start,
      build: (_, double time) => Text(
        " ${time.toStringAsFixed(0)} S",
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

  void listenOtp() async {
    final prefsUtil = await SharedPref.getInstance();
    userLoginMobile = prefsUtil.getString(LOGIN_MOBILE_NUMBER);
    await SmsAutoFill().listenForCode();
    print("OTP listen  Called");
  }

  @override
  void dispose() {
    SmsAutoFill().unregisterListener();
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
        child:
            Consumer<DataProvider>(builder: (context, productProvider, child) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 30, top: 30, right: 30, bottom: 30),
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
                        'Verification Code',
                        textAlign: TextAlign.start,
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
                  userLoginMobile != null
                      ? Text(
                          'Please enter the OTP Send to your Number \n+91 ${userLoginMobile}',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.urbanist(
                            fontSize: 15,
                            color: Colors.black,
                            fontWeight: FontWeight.w400,
                          ),
                        )
                      : Container(),
                  const SizedBox(
                    height: 43,
                  ),
                  Center(
                    child: Pinput(
                      controller: pinController,
                      length: 6,
                      androidSmsAutofillMethod:
                          AndroidSmsAutofillMethod.smsRetrieverApi,
                      showCursor: true,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp("[0-9\]")),
                      ],
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
                  SizedBox(
                    width: double.infinity,
                    child: isReSendDisable
                        ? Row(
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
                          )
                        : Container(),
                  ),
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
                                fontSize: 14,
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
                                            listenOtp();
                                            pinController.clear();
                                            await reSendOpt(
                                                context,
                                                productProvider,
                                                userLoginMobile!,
                                                _controller);
                                            isReSendDisable = true;
                                          })
                              ]),
                        ),
                      )),
                  const SizedBox(
                    height: 10,
                  ),
                  CommonElevatedButton(
                    textSize: 16,
                    onPressed: () async {
                      await callVerifyOtpApi(context, pinController.text,
                          productProvider, userLoginMobile!, pinController);
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

  Future<void> callVerifyOtpApi(
      BuildContext context,
      String otpText,
      DataProvider productProvider,
      String userLoginMobile,
      TextEditingController pinController) async {
    if (otpText.isEmpty) {
      Utils.showBottomSheet(
          context,
          "Please enter the OTP we just sent you on your mobile number",
          VALIDACTION_IMAGE_PATH);
    } else if (otpText.length < 6) {
      pinController.clear();
      Utils.showBottomSheet(
          context,
          "Please enter the OTP we just sent you on your mobile number",
          VALIDACTION_IMAGE_PATH);
    } else {
      productProvider.disposeAllProviderData();
      Utils.onLoading(context, "");
      await Provider.of<DataProvider>(context, listen: false)
          .verifyOtp(VarifayOtpRequest(
        mobileNo: userLoginMobile,
        otp: otpText,
      ));
      Navigator.of(context, rootNavigator: true).pop();
      if (productProvider.getVerifyData != null) {
        productProvider.getVerifyData!.when(
          success: (data) async {
            if (!data.status!) {
              pinController.clear();
              Utils.showToast(data.message!, context);
            } else {
              final prefsUtil = await SharedPref.getInstance();
              await prefsUtil.saveString(TOKEN, data.token!);
              await prefsUtil.saveString(USER_ID, data.userId!);
              getLoggedInUserData(context, productProvider);
            }
          },
          failure: (exception) {
            Utils.showToast("Something went wrong", context);
          },
        );
      }
    }
  }

  Future<void> GetLeadByMobileNo(
      BuildContext context,
      DataProvider productProvider,
      String userLoginMobile,
      String userId) async {

      productProvider.disposeAllProviderData();
      Utils.onLoading(context, "");
      await Provider.of<DataProvider>(context, listen: false)
          .GetLeadByMobileNo(userId, userLoginMobile);
      Navigator.of(context, rootNavigator: true).pop();
      if (productProvider.getLeadMobileNoData != null) {
        productProvider.getLeadMobileNoData!.when(
          success: (data) async {
            if (!data.status!) {
              Utils.showToast(data.message!, context);
            } else {
              final prefsUtil = await SharedPref.getInstance();
              await prefsUtil.saveInt(LEADE_ID, data.leadId!);
              fetchData(context, prefsUtil.getString(LOGIN_MOBILE_NUMBER)!);
            }
          },
          failure: (exception) {
            Utils.showToast("Something went wrong", context);
          },
        );
      }

  }

  Future<void> getLoggedInUserData(BuildContext context, DataProvider productProvider) async {
    final prefsUtil = await SharedPref.getInstance();
    if(prefsUtil.getString(LOGIN_MOBILE_NUMBER) != null && prefsUtil.getString(USER_ID) != null) {
      var userLoginMobile = prefsUtil.getString(LOGIN_MOBILE_NUMBER);
      var  userId = prefsUtil.getString(USER_ID);
      try {
        await Provider.of<DataProvider>(context, listen: false).getUserData(userId!, userLoginMobile!);
        final productProvider = Provider.of<DataProvider>(context, listen: false);
        if(productProvider.getUserProfileResponse != null) {
          productProvider.getUserProfileResponse!.when(
            success: (data) async {
              final prefsUtil = await SharedPref.getInstance();
              prefsUtil.saveString(USER_ID, data.userId!);
              prefsUtil.saveString(TOKEN, data.userToken!);
              prefsUtil.saveInt(COMPANY_ID, data.companyId!);
              prefsUtil.saveInt(PRODUCT_ID, data.productId!);
              prefsUtil.saveString(PRODUCT_CODE, data.productCode!);
              if( data.companyCode!=null) {
                prefsUtil.saveString(COMPANY_CODE, data.companyCode!);
              }
              if( data.role!=null) {
                prefsUtil.saveString(ROLE, data.role!);
              } if( data.type!=null) {
                prefsUtil.saveString(TYPE, data.type!);
              }

              if(data.userData!=null){
                prefsUtil.saveString(USER_NAME, data.userData!.name!);
                prefsUtil.saveString(USER_PAN_NUMBER, data.userData!.panNumber!);
                prefsUtil.saveString(USER_ADHAR_NO, data.userData!.aadharNumber!);
                if(data.userData!.mobile != null) prefsUtil.saveString(USER_MOBILE_NO, data.userData!.mobile!);
                if (data.userData?.address != null) {
                  prefsUtil.saveString(USER_ADDRESS, data.userData!.address!);
                }
                if(data.userData!.workingLocation != null) prefsUtil.saveString(USER_WORKING_LOCTION, data.userData!.workingLocation!);
                if (data.userData?.selfie != null) {
                  prefsUtil.saveString(USER_SELFI, data.userData!.selfie!);
                }
                prefsUtil.saveInt(USER_PAY_OUT, data.userData!.payout!);
                if (data.userData?.docSignedUrl != null) {
                  prefsUtil.saveString(
                      USER_DOC_SiGN_URL, data.userData!.docSignedUrl!
                  );
                }
                prefsUtil.saveInt(USER_PAY_OUT, data.userData!.payout!);
                if( data.userData!.docSignedUrl!=null) {
                  prefsUtil.saveString(
                      USER_DOC_SiGN_URL, data.userData!.docSignedUrl!);
                }

              }

              prefsUtil.saveBool(IS_LOGGED_IN, true);
              if (data.isActivated!) {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) =>  BottomNav()),
                );
              } else {
                GetLeadByMobileNo(context, productProvider, userLoginMobile, userId);
              }
            },
            failure: (exception) {
              if (exception is ApiException) {
                if(exception.statusCode==401){
                  Utils.showToast(exception.errorMessage,context);
                  productProvider.disposeAllProviderData();
                  ApiService().handle401(context);
                }else{
                  Utils.showToast("Something went Wrong",context);
                }
              }
            },
          );
        }
      } catch (error) {
        Navigator.of(context, rootNavigator: true).pop();
        if (kDebugMode) {
          print('Error occurred during API call: $error');
        }
      }
    } else {
      ApiService().handle401(context);
    }
  }

  Future<void> fetchData(BuildContext context, String userLoginMobile) async {
    final prefsUtil = await SharedPref.getInstance();
    Utils.onLoading(context, "");
    try {
      LeadCurrentResponseModel? leadCurrentActivityAsyncData;
      var leadCurrentRequestModel = LeadCurrentRequestModel(
        companyId: prefsUtil.getInt(COMPANY_ID),
        productId: prefsUtil.getInt(PRODUCT_ID),
        leadId: prefsUtil.getInt(LEADE_ID),
        mobileNo: userLoginMobile,
        activityId: 0,
        subActivityId: 0,
        userId: prefsUtil.getString(USER_ID),
        monthlyAvgBuying: 0,
        vintageDays: 0,
        isEditable: true,
      );
      leadCurrentActivityAsyncData = await ApiService()
              .leadCurrentActivityAsync(leadCurrentRequestModel, context)
          as LeadCurrentResponseModel?;
      Navigator.of(context, rootNavigator: true).pop();
      GetLeadResponseModel? getLeadData;
      getLeadData = await ApiService().getLeads(
          userLoginMobile,
          prefsUtil.getInt(COMPANY_ID)!,
          prefsUtil.getInt(PRODUCT_ID)!,
          prefsUtil.getInt(LEADE_ID)!) as GetLeadResponseModel?;
      customerSequence(context, getLeadData, leadCurrentActivityAsyncData,
          "pushReplacement");
    } catch (error) {
      Navigator.of(context, rootNavigator: true).pop();
      if (kDebugMode) {
        print('Error occurred during API call: $error');
      }
    }
  }

  Future<void> reSendOpt(BuildContext context, DataProvider productProvider,
      String userLoginMobile, CountdownController controller) async {
    Utils.onLoading(context, "");
    await Provider.of<DataProvider>(context, listen: false)
        .genrateOtp(context, userLoginMobile);
    Navigator.of(context, rootNavigator: true).pop();

    if (productProvider.genrateOptData != null) {
      productProvider.genrateOptData!.when(
        success: (GenrateOptResponceModel) {
          // Handle successful response
          var genrateOptResponceModel = GenrateOptResponceModel;

          if (!genrateOptResponceModel.status!) {
            Utils.showToast(genrateOptResponceModel.message!, context);
          } else {
            controller.restart();
          }
        },
        failure: (exception) {
          // Handle failure
          print('Failure! Error: ${exception}');
        },
      );
    }
  }
}
