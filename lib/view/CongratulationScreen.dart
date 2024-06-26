import 'package:direct_sourcing_agent/view/splash/model/GetLeadResponseModel.dart';
import 'package:direct_sourcing_agent/view/splash/model/LeadCurrentRequestModel.dart';
import 'package:direct_sourcing_agent/view/splash/model/LeadCurrentResponseModel.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:timer_count_down/timer_controller.dart';
import 'package:timer_count_down/timer_count_down.dart';

import '../api/ApiService.dart';
import '../api/FailureException.dart';
import '../providers/DataProvider.dart';
import '../shared_preferences/shared_pref.dart';
import '../utils/common_elevted_button.dart';
import '../utils/constant.dart';
import '../utils/customer_sequence_logic.dart';
import '../utils/utils_class.dart';
import 'dashboard/bottom_navigation.dart';

class CongratulationScreen extends StatefulWidget {
  final String transactionReqNo;
  final dynamic amount;
  final String mobileNo;
  final int loanAccountId;
  final int creditDay;

  const CongratulationScreen(
      {super.key,
      required this.transactionReqNo,
      required this.amount,
      required this.mobileNo,
      required this.loanAccountId,
      required this.creditDay});

  @override
  State<CongratulationScreen> createState() => _CongratulationScreenState();
}

class _CongratulationScreenState extends State<CongratulationScreen> {
  int _start = 5;
  static const platform = MethodChannel('com.ScaleUP');

  final CountdownController _controller = CountdownController(autoStart: true);

  @override
  void initState() {
    _start = 5;
    // buildCountdown();
    super.initState();
  }

  Widget buildCountdown() {
    return Countdown(
      controller: _controller,
      seconds: _start,
      build: (_, double time) => Text(
        " ${time.toStringAsFixed(0)} Sec",
        style: GoogleFonts.urbanist(
          fontSize: 15,
          color: Colors.black,
          fontWeight: FontWeight.w400,
        ),
      ),
      interval: Duration(seconds: 1),
      onFinished: () {
        setState(() {
          redirect(widget.transactionReqNo, widget.amount, widget.mobileNo!,
              widget.loanAccountId!, widget.creditDay!);
          SystemNavigator.pop();
        });
      },
    );
  }

  static Future<void> redirect(String? transactionReqNo, dynamic amount,
      String mobileNumber, int loanAccountId, int creditDay) async {
    try {
      await platform.invokeMethod('returnToPayment', {
        'transactionReqNo': transactionReqNo,
        'amount': amount,
        'mobileNo': mobileNumber,
        'loanAccountId': loanAccountId,
        'creditDay': creditDay,
      });
    } on PlatformException catch (e) {
      print("Failed to redirect: '${e.message}'.");
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
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
        backgroundColor: whiteColor,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(12.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 100,
                  ),
                  Container(
                      height: 250,
                      width: 250,
                      alignment: Alignment.topCenter,
                      child:
                          SvgPicture.asset("assets/images/congratulation.svg")),
                  SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: Text(
                      "Congratulation",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.urbanist(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Center(
                      child: Text(
                        "Your Profile is up for Review Our Team Will Review it in 48 Hours and Activate Your Profile if No Additional Information is Required.",
                        textAlign: TextAlign.justify,
                        style: GoogleFonts.urbanist(
                          fontSize: 15,
                          color: Colors.black,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 70),
                  CommonElevatedButton(
                    onPressed: () async {
                      getLoggedInUserData(context);
                    },
                    text: "Refresh   status",
                    upperCase: true,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> getLoggedInUserData(BuildContext context) async {
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
                prefsUtil.saveDouble(USER_PAY_OUT, data.userData!.payout!);
                if (data.userData?.docSignedUrl != null) {
                  prefsUtil.saveString(
                      USER_DOC_SiGN_URL, data.userData!.docSignedUrl!
                  );
                }
                prefsUtil.saveDouble(USER_PAY_OUT, data.userData!.payout!);
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

  Future<void> fetchData(BuildContext context, String userLoginMobile) async {
    final prefsUtil = await SharedPref.getInstance();
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
      GetLeadResponseModel? getLeadData;
      getLeadData = await ApiService().getLeads(
          userLoginMobile,
          prefsUtil.getInt(PRODUCT_ID)!,
          prefsUtil.getInt(COMPANY_ID)!,
          prefsUtil.getInt(LEADE_ID)!) as GetLeadResponseModel?;
      customerSequence(context, getLeadData, leadCurrentActivityAsyncData,
          "pushReplacement");
    } catch (error) {
      if (kDebugMode) {
        print('Error occurred during API call: $error');
      }
    }
  }
}
