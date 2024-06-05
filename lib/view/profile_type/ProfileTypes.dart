import 'dart:convert';

import 'package:direct_sourcing_agent/api/ApiService.dart';
import 'package:direct_sourcing_agent/api/FailureException.dart';
import 'package:direct_sourcing_agent/providers/DataProvider.dart';
import 'package:direct_sourcing_agent/shared_preferences/shared_pref.dart';
import 'package:direct_sourcing_agent/utils/customer_sequence_logic.dart';
import 'package:direct_sourcing_agent/utils/utils_class.dart';
import 'package:direct_sourcing_agent/view/splash/model/GetLeadResponseModel.dart';
import 'package:direct_sourcing_agent/view/splash/model/LeadCurrentRequestModel.dart';
import 'package:direct_sourcing_agent/view/splash/model/LeadCurrentResponseModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../utils/common_elevted_button.dart';
import '../../utils/constant.dart';
import '../aadhaar_screen/components/CheckboxTerm.dart';
import 'model/ChooseUserTypeRequestModel.dart';

class ProfileTypes extends StatefulWidget {
  final int activityId;
  final int subActivityId;
  final String? pageType;
  final String? dsaType;

  ProfileTypes(
      {super.key,
      required this.activityId,
      required this.subActivityId,
      this.pageType,
      required this.dsaType});

  @override
  State<ProfileTypes> createState() => _ProfileTypesState();
}

class _ProfileTypesState extends State<ProfileTypes> {
  bool _isSelected1 = false;
  bool _isSelected2 = false;
  String? userType;

  void _handleCheckboxChange(int index, bool? value) {
    setState(() {
      if (index == 1) {
        _isSelected1 = value!;
        _isSelected2 = !value;
      } else if (index == 2) {
        _isSelected2 = value!;
        _isSelected1 = !value;
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(widget.dsaType == "DSAPersonalInfo") {

    }
  }

  @override
  Widget build(BuildContext context) {
    bool isTermsChecks = false;

    return Scaffold(body: SafeArea(
      child: Consumer<DataProvider>(builder: (context, productProvider, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 40),
            Center(
              child: Text(
                'Choose Profile Type',
                textAlign: TextAlign.start,
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 70),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: CheckboxTerm(
                content: "DSA (Direct Selling Agent):",
                isChecked: _isSelected1,
                onChanged: (bool? value) {
                  isTermsChecks = value!;
                  userType = "DSA";
                  _handleCheckboxChange(1, isTermsChecks);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 52, right: 30),
              child: Text(
                "If you are representing a registered entity such as a Pvt Ltd Company, HUF, LLC, Proprietorship, or any other registered firm type, you can onboard with us as a DSA. As a DSA, you will facilitate loan applications and earn higher commissions based on successful disbursements.",
                textAlign: TextAlign.justify,
                style: GoogleFonts.urbanist(
                  fontSize: 12,
                  color: Colors.black,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
            const SizedBox(height: 50),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: CheckboxTerm(
                content: "Connector",
                isChecked: _isSelected2,
                onChanged: (bool? value) {
                  userType = "Connector";
                  isTermsChecks = value!;
                  _handleCheckboxChange(2, isTermsChecks);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 52, right: 30),
              child: Text(
                "If you are an individual without any formal firm registration, you can join us as a Connector. As a Connector, you can refer potential loan applicants and earn commissions based on successful disbursements.",
                textAlign: TextAlign.justify,
                style: GoogleFonts.urbanist(
                  fontSize: 12,
                  color: Colors.black,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 30, right: 30, top: 80),
              child: Column(
                children: [
                  CommonElevatedButton(
                    onPressed: () async {
                      chooseUserTypeApi(
                          context, productProvider, isTermsChecks, userType!);
                    },
                    text: "Next",
                    upperCase: true,
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    ));
  }

  void chooseUserTypeApi(BuildContext context, DataProvider productProvider, bool isTermsChecks, String userType) async {
    Utils.onLoading(context, "");
    final prefsUtil = await SharedPref.getInstance();
    var model = ChooseUserTypeRequestModel(
        leadId: prefsUtil.getInt(LEADE_ID),
        activityId: widget.activityId,
        subActivityId: widget.subActivityId,
        userId: prefsUtil.getString(USER_ID),
        companyId: prefsUtil.getInt(COMPANY_ID),
        dsaType: userType);
    print(model.toJson().toString());
    await productProvider.getChooseUserType(model);
    Navigator.of(context, rootNavigator: true).pop();
    if (productProvider.getChooseUserTypeData != null) {
      productProvider.getChooseUserTypeData!.when(
        success: (data) {
          if (data.isSuccess!) {
            fetchData(context);
          }else{
            Utils.showToast(data.message!, context);
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

  Future<void> fetchData(BuildContext context) async {
    final prefsUtil = await SharedPref.getInstance();
    try {
      LeadCurrentResponseModel? leadCurrentActivityAsyncData;
      var leadCurrentRequestModel = LeadCurrentRequestModel(
        companyId: prefsUtil.getInt(COMPANY_ID),
        productId: prefsUtil.getInt(PRODUCT_ID),
        leadId: prefsUtil.getInt(LEADE_ID),
        mobileNo: prefsUtil.getString(LOGIN_MOBILE_NUMBER),
        activityId: widget.activityId,
        subActivityId: widget.subActivityId,
        userId: prefsUtil.getString(USER_ID),
        monthlyAvgBuying: 0,
        vintageDays: 0,
        isEditable: true,
      );
      leadCurrentActivityAsyncData =
          await ApiService().leadCurrentActivityAsync(leadCurrentRequestModel)
              as LeadCurrentResponseModel?;

      GetLeadResponseModel? getLeadData;
      getLeadData = await ApiService().getLeads(
          prefsUtil.getString(LOGIN_MOBILE_NUMBER)!,
          prefsUtil.getInt(COMPANY_ID)!,
          prefsUtil.getInt(PRODUCT_ID)!,
          prefsUtil.getInt(LEADE_ID)!) as GetLeadResponseModel?;

      customerSequence(context, getLeadData, leadCurrentActivityAsyncData, "push");
    } catch (error) {
      if (kDebugMode) {
        print('Error occurred during API call: $error');
      }
    }
  }
}
