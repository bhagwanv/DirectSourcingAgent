import 'package:direct_sourcing_agent/inprogress/ProfileReview.dart';
import 'package:direct_sourcing_agent/utils/screen_type.dart';
import 'package:direct_sourcing_agent/view/agreement_screen/Agreementscreen.dart';
import 'package:direct_sourcing_agent/view/dsa_company/direct_selling_agent.dart';
import 'package:direct_sourcing_agent/view/profile_type/ProfileTypes.dart';
import 'package:flutter/material.dart';
import '../view/CongratulationScreen.dart';
import '../view/aadhaar_screen/aadhaar_screen.dart';
import '../view/bank_details_screen/BankDetailsScreen.dart';
import '../view/dashboard/bottom_navigation.dart';
import '../view/login_screen/login_screen.dart';
import '../view/pancard_screen/PancardScreen.dart';
import '../view/rejected/rejected_screen.dart';
import '../view/splash/model/GetLeadResponseModel.dart';
import '../view/splash/model/LeadCurrentResponseModel.dart';
import '../view/take_selfi/take_selfi_screen.dart';

ScreenType? customerSequence(
    BuildContext context,
    GetLeadResponseModel? getLeadData,
    LeadCurrentResponseModel? leadCurrentActivityAsyncData,
    String pageType) {
  if ((getLeadData != null) && (leadCurrentActivityAsyncData != null)) {
    if (pageType == "pushReplacement") {
      if (leadCurrentActivityAsyncData.currentSequence! != 0) {
        var currentSequence = leadCurrentActivityAsyncData.currentSequence!;
        debugPrint("sequence no.  $currentSequence");
        var leadCurrentActivity = leadCurrentActivityAsyncData
            .leadProductActivity!
            .firstWhere((product) => product.sequence == currentSequence);
        debugPrint("ACTIVITYnAME  ${leadCurrentActivity.activityName}");
        debugPrint("SubActivityName  ${leadCurrentActivity.subActivityName}");
        if (leadCurrentActivity.activityName == "MobileOtp") {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
                builder: (context) => LoginScreen(pageType: pageType)),
          );
          return ScreenType.login;
        } else if (leadCurrentActivity.activityName == "KYC") {
          if (leadCurrentActivity.subActivityName == "Pan") {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                  builder: (context) => PancardScreen(
                      activityId: leadCurrentActivity.activityMasterId!,
                      subActivityId: leadCurrentActivity.subActivityMasterId!,
                      pageType: pageType)),
            );
            return ScreenType.pancard;
          } else if (leadCurrentActivity.subActivityName == "Aadhar") {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                  builder: (context) => AadhaarScreen(
                      activityId: leadCurrentActivity.activityMasterId!,
                      subActivityId: leadCurrentActivity.subActivityMasterId!,
                      pageType: pageType)),
            );
            return ScreenType.aadhar;
          } else if (leadCurrentActivity.subActivityName == "Selfie") {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                  builder: (context) => TakeSelfieScreen(
                      activityId: leadCurrentActivity.activityMasterId!,
                      subActivityId: leadCurrentActivity.subActivityMasterId!,
                      pageType: pageType)),
            );
            return ScreenType.selfie;
          }
        } else if (leadCurrentActivity.activityName == "Bank Detail") {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
                builder: (context) => BankDetailsScreen(
                    activityId: leadCurrentActivity.activityMasterId!,
                    subActivityId: leadCurrentActivity.subActivityMasterId!)),
          );
          return ScreenType.bankDetail;
        } else if (leadCurrentActivity.activityName == "PersonalInfo") {
          return ScreenType.personalInfo;
        } else if (leadCurrentActivity.activityName == "BusinessInfo") {
          /* Navigator.of(context).pushReplacement(
            MaterialPageRoute(
                builder: (context) => BusinessDetailsScreen(
                    activityId: leadCurrentActivity.activityMasterId!,
                    subActivityId: leadCurrentActivity.subActivityMasterId!,
                    pageType: pageType)),
          );*/
          return ScreenType.businessInfo;
        } else if (leadCurrentActivity.activityName == "Inprogress") {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
                builder: (context) => ProfileReview(pageType: pageType)),
          );
          return ScreenType.Inprogress;
        } else if (leadCurrentActivity.activityName == "DSAAgreement") {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
                builder: (context) => AgreementScreen(
                    activityId: leadCurrentActivity.activityMasterId!,
                    subActivityId: leadCurrentActivity.subActivityMasterId!,
                    pageType: pageType)),
          );
          return ScreenType.AgreementEsign;
        } else if (leadCurrentActivity.activityName == "DSACongratulations") {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
                builder: (context) => CongratulationScreen(transactionReqNo: "", amount: "", mobileNo: "", loanAccountId: 0, creditDay: 0)),
          );
          return ScreenType.AgreementEsign;
        } else if (leadCurrentActivity.activityName == "Show Offer") {
          /*Navigator.of(context).pushReplacement(
            MaterialPageRoute(
                builder: (context) => ShowOffersScreen(
                    activityId: leadCurrentActivity.activityMasterId!,
                    subActivityId: leadCurrentActivity.subActivityMasterId!,
                    pageType: pageType)),
          );*/
          return ScreenType.showoOffer;
        } else if (leadCurrentActivity.activityName == "Rejected") {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
                builder: (context) => RejectedScreen(pageType: pageType)),
          );
          return ScreenType.Rejected;
        } else if (leadCurrentActivity.activityName == "Disbursement") {
          /*Navigator.of(context).pushReplacement(
            MaterialPageRoute(
                builder: (context) => CreditLineApproved(
                    activityId: leadCurrentActivity.activityMasterId!,
                    subActivityId: leadCurrentActivity.subActivityMasterId!,
                    pageType: pageType,
                    isDisbursement: true)),
          );*/
          return ScreenType.Disbursement;
        } else if (leadCurrentActivity.activityName ==
            "Disbursement Completed") {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
                builder: (context) => BottomNav(pageType: pageType)),
          );
          return ScreenType.DisbursementCompleted;
        } else if (leadCurrentActivity.activityName == "MyAccount") {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
                builder: (context) => BottomNav(pageType: pageType)),
          );
          return ScreenType.MyAccount;
        } else if (leadCurrentActivity.activityName == "DSATypeSelection") {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => ProfileTypes( activityId: leadCurrentActivity.activityMasterId!,
                subActivityId: leadCurrentActivity.subActivityMasterId!,pageType: pageType, dsaType: leadCurrentActivity.activityName)),);
          return ScreenType.DSATypeSelection;
        } else if (leadCurrentActivity.activityName == "DSAPersonalInfo") {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => DirectSellingAgent( activityId: leadCurrentActivity.activityMasterId!,
                subActivityId: leadCurrentActivity.subActivityMasterId!,pageType: pageType)),);
          return ScreenType.DSAPersonalInfo;
        }
      } else {
        return null;
      }
    } else {
      if (leadCurrentActivityAsyncData.currentSequence! != 0) {
        var currentSequence = leadCurrentActivityAsyncData.currentSequence!;
        debugPrint("sequence no.  $currentSequence");
        var leadCurrentActivity = leadCurrentActivityAsyncData
            .leadProductActivity!
            .firstWhere((product) => product.sequence == currentSequence);
        debugPrint("ACTIVITYnAME  ${leadCurrentActivity.activityName}");
        debugPrint("SubActivityName  ${leadCurrentActivity.subActivityName}");
        if (leadCurrentActivity.activityName == "MobileOtp") {
          Navigator.of(context).push(
            MaterialPageRoute(
                builder: (context) => LoginScreen(pageType: pageType)),
          );
          return ScreenType.login;
        } else if (leadCurrentActivity.activityName == "KYC") {
          if (leadCurrentActivity.subActivityName == "Pan") {
            Navigator.of(context).push(
              MaterialPageRoute(
                  builder: (context) => PancardScreen(
                      activityId: leadCurrentActivity.activityMasterId!,
                      subActivityId: leadCurrentActivity.subActivityMasterId!,
                      pageType: pageType)),
            );
            return ScreenType.pancard;
          } else if (leadCurrentActivity.subActivityName == "Aadhar") {
            Navigator.of(context).push(
              MaterialPageRoute(
                  builder: (context) => AadhaarScreen(
                      activityId: leadCurrentActivity.activityMasterId!,
                      subActivityId: leadCurrentActivity.subActivityMasterId!,
                      pageType: pageType)),
            );
            return ScreenType.aadhar;
          } else if (leadCurrentActivity.subActivityName == "Selfie") {
            Navigator.of(context).push(
              MaterialPageRoute(
                  builder: (context) => TakeSelfieScreen(
                      activityId: leadCurrentActivity.activityMasterId!,
                      subActivityId: leadCurrentActivity.subActivityMasterId!,
                      pageType: pageType)),
            );
            return ScreenType.selfie;
          }
        } else if (leadCurrentActivity.activityName == "Bank Detail") {
          Navigator.of(context).push(
            MaterialPageRoute(
                builder: (context) => BankDetailsScreen(
                    activityId: leadCurrentActivity.activityMasterId!,
                    subActivityId: leadCurrentActivity.subActivityMasterId!)),
          );
          return ScreenType.bankDetail;
        } else if (leadCurrentActivity.activityName == "PersonalInfo") {
          return ScreenType.personalInfo;
        } else if (leadCurrentActivity.activityName == "BusinessInfo") {
          /*Navigator.of(context).push(
            MaterialPageRoute(
                builder: (context) => BusinessDetailsScreen(
                    activityId: leadCurrentActivity.activityMasterId!,
                    subActivityId: leadCurrentActivity.subActivityMasterId!,
                    pageType: pageType)),
          );*/
          return ScreenType.businessInfo;
        } else if (leadCurrentActivity.activityName == "Inprogress") {
          Navigator.of(context).push(
            MaterialPageRoute(
                builder: (context) => ProfileReview(pageType: pageType)),
          );
          return ScreenType.Inprogress;
        }  else if (leadCurrentActivity.activityName == "DSAAgreement") {
          Navigator.of(context).push(
            MaterialPageRoute(
                builder: (context) => AgreementScreen(
                    activityId: leadCurrentActivity.activityMasterId!,
                    subActivityId: leadCurrentActivity.subActivityMasterId!,
                    pageType: pageType)),
          );
          return ScreenType.AgreementEsign;
        }else if (leadCurrentActivity.activityName == "DSACongratulations") {
          Navigator.of(context).push(
            MaterialPageRoute(
                builder: (context) => CongratulationScreen(transactionReqNo: "", amount: "", mobileNo: "", loanAccountId: 0, creditDay: 0)),
          );
          return ScreenType.AgreementEsign;
        } else if (leadCurrentActivity.activityName == "Show Offer") {
          /*Navigator.of(context).pushReplacement(
            MaterialPageRoute(
                builder: (context) => ShowOffersScreen(
                    activityId: leadCurrentActivity.activityMasterId!,
                    subActivityId: leadCurrentActivity.subActivityMasterId!,
                    pageType: pageType)),
          );*/
          return ScreenType.showoOffer;
        } else if (leadCurrentActivity.activityName == "Rejected") {
          Navigator.of(context).push(
            MaterialPageRoute(
                builder: (context) => RejectedScreen(pageType: pageType)),
          );
          return ScreenType.Rejected;
        } else if (leadCurrentActivity.activityName == "Disbursement") {
          /* Navigator.of(context).push(
           MaterialPageRoute(
                builder: (context) => CreditLineApproved(
                    activityId: leadCurrentActivity.activityMasterId!,
                    subActivityId: leadCurrentActivity.subActivityMasterId!,
                    pageType: pageType,
                    isDisbursement: true)),
          );*/
          return ScreenType.Disbursement;
        } else if (leadCurrentActivity.activityName ==
            "Disbursement Completed") {
          Navigator.of(context).push(
            //MaterialPageRoute(builder: (context) => CreditLineApproved(activityId: leadCurrentActivity.activityMasterId!, subActivityId: leadCurrentActivity.subActivityMasterId!,isDisbursement: true,)),
            MaterialPageRoute(
                builder: (context) => BottomNav(pageType: pageType)),
          );
          return ScreenType.DisbursementCompleted;
        } else if (leadCurrentActivity.activityName == "MyAccount") {
          Navigator.of(context).push(
            MaterialPageRoute(
                builder: (context) => BottomNav(pageType: pageType)),
          );
          return ScreenType.MyAccount;
        } else if (leadCurrentActivity.activityName == "DSATypeSelection") {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => ProfileTypes( activityId: leadCurrentActivity.activityMasterId!,
                subActivityId: leadCurrentActivity.subActivityMasterId!,pageType: pageType, dsaType: leadCurrentActivity.activityName)),);
          return ScreenType.DSATypeSelection;
        } else if (leadCurrentActivity.activityName == "DSAPersonalInfo") {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => DirectSellingAgent( activityId: leadCurrentActivity.activityMasterId!,
                subActivityId: leadCurrentActivity.subActivityMasterId!,pageType: pageType)),);
          return ScreenType.DSAPersonalInfo;
        }
      } else {
        return null;
      }
    }
  } else {
    return null;
  }
  return null;
}
