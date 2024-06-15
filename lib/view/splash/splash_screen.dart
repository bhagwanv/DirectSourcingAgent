import 'package:direct_sourcing_agent/view/login_screen/login_screen.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
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


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getFirebaseUrl();

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
            Image.asset('assets/images/scaleup_logo.png'),
            // Replace with your logo image path
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
            Image.asset('assets/images/made_in_india.png'),
            // Replace with your "Made in India" image path
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
      _isLoggedIn = prefs.getBool(IS_LOGGED_IN) ?? false;
    });
    Future.delayed(Duration(seconds: 2), () {
      if (_isLoggedIn) {
        getLoggedInUserData(context);
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      }
    });
  }

  Future<void> getLoggedInUserData(BuildContext context) async {
    final prefsUtil = await SharedPref.getInstance();
    if (prefsUtil.getString(LOGIN_MOBILE_NUMBER) != null &&
        prefsUtil.getString(USER_ID) != null) {
      var userLoginMobile = prefsUtil.getString(LOGIN_MOBILE_NUMBER);
      var userId = prefsUtil.getString(USER_ID);
      try {
        await Provider.of<DataProvider>(context, listen: false).getUserData(
            userId!, userLoginMobile!);
        final productProvider = Provider.of<DataProvider>(
            context, listen: false);
        if (productProvider.getUserProfileResponse != null) {
          productProvider.getUserProfileResponse!.when(
            success: (data) async {
              final prefsUtil = await SharedPref.getInstance();
              prefsUtil.saveString(USER_ID, data.userId!);
              prefsUtil.saveString(TOKEN, data.userToken!);
              prefsUtil.saveInt(COMPANY_ID, data.companyId!);
              prefsUtil.saveInt(PRODUCT_ID, data.productId!);
              prefsUtil.saveString(PRODUCT_CODE, data.productCode!);
              if (data.companyCode != null) {
                prefsUtil.saveString(COMPANY_CODE, data.companyCode!);
              }
              if (data.role != null) {
                prefsUtil.saveString(ROLE, data.role!);
              }
              if (data.type != null) {
                prefsUtil.saveString(TYPE, data.type!);
              }

              if (data.userData != null) {
                prefsUtil.saveString(USER_NAME, data.userData!.name!);
                prefsUtil.saveString(
                    USER_PAN_NUMBER, data.userData!.panNumber!);
                prefsUtil.saveString(
                    USER_ADHAR_NO, data.userData!.aadharNumber!);
                if (data.userData!.mobile != null) prefsUtil.saveString(
                    USER_MOBILE_NO, data.userData!.mobile!);
                if (data.userData?.address != null) {
                  prefsUtil.saveString(USER_ADDRESS, data.userData!.address!);
                }
                if (data.userData!.workingLocation != null) prefsUtil
                    .saveString(
                    USER_WORKING_LOCTION, data.userData!.workingLocation!);
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
                if (data.userData!.docSignedUrl != null) {
                  prefsUtil.saveString(
                      USER_DOC_SiGN_URL, data.userData!.docSignedUrl!);
                }
              }


              prefsUtil.saveBool(IS_LOGGED_IN, true);
              if (data.isActivated!) {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => BottomNav()),
                );
              } else {
                GetLeadByMobileNo(
                    context, productProvider, userLoginMobile, userId);
              }
            },
            failure: (exception) {
              if (exception is ApiException) {
                if (exception.statusCode == 401) {
                  Utils.showToast(exception.errorMessage, context);
                  productProvider.disposeAllProviderData();
                  ApiService().handle401(context);
                } else {
                  Utils.showToast("Something went Wrong", context);
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

  Future<void> GetLeadByMobileNo(BuildContext context,
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
      leadCurrentActivityAsyncData =
      await ApiService().leadCurrentActivityAsync(
          leadCurrentRequestModel, context)
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

  Future<String> getFirebaseUrl() async {
    final prefsUtil = await SharedPref.getInstance();
    final FirebaseRemoteConfig remoteConfig = FirebaseRemoteConfig.instance;
    await remoteConfig.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: const Duration(seconds: 1),
      minimumFetchInterval: const Duration(seconds: 5),

    ));

    await remoteConfig.fetchAndActivate();
    String Url =remoteConfig.getString('Base_url');
    await prefsUtil.saveString(BASE_URL, Url);
    _checkLoginStatus();
    return 'Fetched: ${remoteConfig.getString('Base_url')}';

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