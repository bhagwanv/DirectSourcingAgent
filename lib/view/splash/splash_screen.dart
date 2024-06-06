import 'package:direct_sourcing_agent/view/login_screen/login_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../api/ApiService.dart';
import '../../api/FailureException.dart';
import '../../providers/DataProvider.dart';
import '../../shared_preferences/shared_pref.dart';
import '../../utils/constant.dart';
import '../../utils/customer_sequence_logic.dart';
import '../../utils/utils_class.dart';
import '../dashboard/bottom_navigation.dart';
import '../otp_screens/OtpScreen.dart';
import '../otp_screens/model/GetUserProfileRequest.dart';
import '../pancard_screen/PancardScreen.dart';
import 'model/GetLeadResponseModel.dart';
import 'model/LeadCurrentRequestModel.dart';
import 'model/LeadCurrentResponseModel.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _isLoggedIn = false;
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body:
      Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Spacer(),
            Image.asset('assets/images/scaleup_logo.png'), // Replace with your logo image path
            const SizedBox(height: 20),
            const Text(
              'Scaleup',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.normal,
              ),
            ),
            const Spacer(),
            const CustomCircularLoader(),
            const Spacer(),
            const SizedBox(height: 40),
            Image.asset('assets/images/made_in_india.png'), // Replace with your "Made in India" image path
            const SizedBox(height: 20),
            const Icon(Icons.check_circle, color: Colors.green),
            const Text(
              '100% Safe & Secure',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Copyright 2024 Scaleup. All rights reserved.',
              style: TextStyle(
                fontSize: 12,
              ),
            ),
            /*const Row(
                mainAxisAlignment:MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Powered by ',
                    style: TextStyle(
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    'ShopGirana E-Trading Pvt. Ltd.',
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 12,
                    ),
                  ),
                ]
            ),*/
            const SizedBox(height: 16)
          ],
        ),
      ),
    );
  }

  _checkLoginStatus() async {
    final prefs = await SharedPref.getInstance();
    setState(() {
      _isLoggedIn = prefs.getBool(IS_LOGGED_IN)?? false;
    });
    Future.delayed(Duration(seconds: 2), () {
      if (_isLoggedIn) {
        getLoggedInUserData(context);
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
      }
    });
  }

  Future<void> getLoggedInUserData(BuildContext context) async {
    final prefsUtil = await SharedPref.getInstance();
    try {
      //var getUserProfileRequest = GetUserProfileRequest(mobileNumber:  prefsUtil.getString(LOGIN_MOBILE_NUMBER), userId:  prefsUtil.getString(USER_ID), leadId:  prefsUtil.getInt(LEADE_ID));
      await Provider.of<DataProvider>(context, listen: false).getUserData();
      final productProvider = Provider.of<DataProvider>(context, listen: false);
      if(productProvider.getUserProfileResponse != null) {
        productProvider.getUserProfileResponse!.when(
          success: (data) async {
            final prefsUtil = await SharedPref.getInstance();
            prefsUtil.saveString(USER_ID, data.userId!);
            prefsUtil.saveString(TOKEN, data.userToken!);
            prefsUtil.saveInt(LEADE_ID, data.leadId!);
            prefsUtil.saveInt(COMPANY_ID, data.companyId!);
            prefsUtil.saveInt(PRODUCT_ID, data.productId!);
            prefsUtil.saveString(PRODUCT_CODE, data.productCode!);
            prefsUtil.saveString(COMPANY_CODE, data.companyCode!);
            prefsUtil.saveBool(IS_LOGGED_IN, true);
            if (data.isActivated!) {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const BottomNav()),
              );
            } else {
              fetchData(context, prefsUtil.getString(LOGIN_MOBILE_NUMBER)!);
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
      leadCurrentActivityAsyncData =
      await ApiService().leadCurrentActivityAsync(leadCurrentRequestModel, context)
      as LeadCurrentResponseModel?;
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
}
class CustomCircularLoader extends StatelessWidget {
  const CustomCircularLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36,
      height: 36,
      child: CircularProgressIndicator(
        strokeWidth: 3,
        valueColor: AlwaysStoppedAnimation(kPrimaryColor),
      ),
    );
  }
}