import 'package:direct_sourcing_agent/providers/DataProvider.dart';
import 'package:direct_sourcing_agent/shared_preferences/shared_pref.dart';
import 'package:direct_sourcing_agent/utils/constant.dart';
import 'package:direct_sourcing_agent/utils/utils_class.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../api/ApiService.dart';
import '../../api/FailureException.dart';
import 'package:provider/provider.dart';
import '../../utils/common_elevted_button.dart';
import '../utils/customer_sequence_logic.dart';
import '../view/dashboard/bottom_navigation.dart';
import '../view/splash/model/GetLeadResponseModel.dart';
import '../view/splash/model/LeadCurrentRequestModel.dart';
import '../view/splash/model/LeadCurrentResponseModel.dart';
import 'model/InProgressScreenModel.dart';

class ProfileReview extends StatefulWidget {
  final String? pageType;

  ProfileReview({super.key, this.pageType});

  @override
  State<ProfileReview> createState() => _ProfileReviewState();
}

class _ProfileReviewState extends State<ProfileReview> {
  var isLoading = true;
  InProgressScreenModel? inProgressScreenModel = null;
  String leadCode = "";

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      callApi(context);
    });
    super.initState();
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
        if (widget.pageType == "pushReplacement") {
          final bool shouldPop = await Utils().onback(context);
          if (shouldPop) {
            SystemNavigator.pop();
          }
        } else {
          SystemNavigator.pop();
        }
      },
      child: Scaffold(
        body: Consumer<DataProvider>(builder: (context, productProvider, child) {
          if (productProvider.InProgressScreenData == null && isLoading) {
            return Container();
          } else {
            if (productProvider.InProgressScreenData != null && isLoading) {
              //Navigator.of(context, rootNavigator: true).pop();
              isLoading = false;
            }

            if (productProvider.InProgressScreenData != null) {
              productProvider.InProgressScreenData!.when(
                success: (InProgressScreenData) async {
                  if (InProgressScreenData != null &&
                      InProgressScreenData.isSuccess!) {
                    inProgressScreenModel = InProgressScreenData;
                    if (inProgressScreenModel!.result!.leadCode != null) {
                      leadCode = inProgressScreenModel!.result!.leadCode!;
                    }
                  }
                },
                failure: (exception) {
                  if (exception is ApiException) {
                    if(exception.statusCode==401){
                      productProvider.disposeAllProviderData();
                      ApiService().handle401(context);
                    }else{
                      Utils.showToast(exception.errorMessage,context);
                    }
                  }
                },
              );
            }

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(30),
                child: Column(
                  children: [
                    const SizedBox(height: 50),
                    Container(
                      alignment: Alignment.center,
                      child: SvgPicture.asset(
                          'assets/images/profile_view_pendding.svg'),
                    ),
                    const SizedBox(height: 60),
                    Padding(
                      padding: EdgeInsets.only(left: 5, right: 5),
                      child: Column(
                        children: [
                          Text(
                            leadCode,
                            style:
                                TextStyle(color: kPrimaryColor, fontSize: 20),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                     Padding(
                      padding: EdgeInsets.only(left: 5, right: 5),
                      child: Column(
                        children: [
                          Text(
                            "Your profile is under review",
                            style: GoogleFonts.urbanist(
                              fontSize: 20,
                              color: kPrimaryColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 15),
                    Column(
                      children: [
                        Text(
                          "Your profile has been submitted & will be reviewed by our team You will be notified if any additional information is required ",
                          style: GoogleFonts.urbanist(
                            fontSize: 14,
                            color: blackSmall,
                            fontWeight: FontWeight.w400,
                          ),
                          textAlign: TextAlign.justify,
                        ),
                      ],
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
            );
          }
        }),
      ),
    );
  }

  Future<void> callApi(BuildContext context) async {
    final prefsUtil = await SharedPref.getInstance();
    final int? leadId = prefsUtil.getInt(LEADE_ID);
    Provider.of<DataProvider>(context, listen: false).leadDataOnInProgressScreen(context, leadId!);
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
                if (data.userData?.salesAgentCommissions != null) {
                  prefsUtil.saveCommissions(data.userData!.salesAgentCommissions!);
                }
                if (data.userData?.docSignedUrl != null) {
                  prefsUtil.saveString(
                      USER_DOC_SiGN_URL, data.userData!.docSignedUrl!
                  );
                }
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
