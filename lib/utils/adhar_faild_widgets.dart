import 'package:direct_sourcing_agent/utils/utils_class.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../api/ApiService.dart';
import '../shared_preferences/shared_pref.dart';
import '../view/splash/model/GetLeadResponseModel.dart';
import '../view/splash/model/LeadCurrentRequestModel.dart';
import '../view/splash/model/LeadCurrentResponseModel.dart';
import 'common_elevted_button.dart';
import 'constant.dart';
import 'customer_sequence_logic.dart';

class AdharFailedWidgets extends StatelessWidget {
  String message;
  String imagePath;
  final int activityId;
  final int subActivityId;

  //KycFailedWidgets({required this.message,super.key});

  AdharFailedWidgets({Key? key, required this.message, required this.imagePath,required this.activityId,required this.subActivityId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      color: Colors.transparent, //could change this to Color(0xFF737373),
      //so you don't have to change MaterialApp canvasColor
      child: Container(
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30.0),
                topRight: Radius.circular(30.0))),
        child: SingleChildScrollView(
            child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Container(),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          fetchData(context);
                        },
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                  height: 150,
                  width: 150,
                  alignment: Alignment.topCenter,
                  child: Image.asset(imagePath)),
              const SizedBox(
                height: 10,
              ),
              Center(
                child: Text(
                  "Oops ...",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 15, color: Colors.red),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20,0,20,0),
                child: Center(
                  child: Text(
                    message,
                    textAlign: TextAlign.justify,
                    style: TextStyle(fontSize: 15, color: Colors.black,letterSpacing: 0.5),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
      Padding(
        padding: const EdgeInsets.all(10.0),
        child: CommonElevatedButton(onPressed: (){
          fetchData(context);
        }, text: "RETRY",upperCase: true, ),
      ),
            ],
          ),
        )),
      ),
    );
  }
  Future<void> fetchData(BuildContext context) async {
    final prefsUtil = await SharedPref.getInstance();
    Utils.onLoading(context, "");
    try {
      LeadCurrentResponseModel? leadCurrentActivityAsyncData;
      var leadCurrentRequestModel = LeadCurrentRequestModel(
        companyId: prefsUtil.getInt(COMPANY_ID),
        productId: prefsUtil.getInt(PRODUCT_ID),
        leadId: prefsUtil.getInt(LEADE_ID),
        userId: prefsUtil.getString(USER_ID),
        mobileNo: prefsUtil.getString(LOGIN_MOBILE_NUMBER),
        activityId: activityId,
        subActivityId: subActivityId,
        monthlyAvgBuying: 0,
        vintageDays: 0,
        isEditable: true,
      );
      leadCurrentActivityAsyncData =
      await ApiService().leadCurrentActivityAsync(leadCurrentRequestModel,context)
      as LeadCurrentResponseModel?;
      Navigator.of(context, rootNavigator: true).pop();
      GetLeadResponseModel? getLeadData;
      getLeadData = await ApiService().getLeads(
          prefsUtil.getString(LOGIN_MOBILE_NUMBER)!,
          prefsUtil.getInt(PRODUCT_ID)!,
          prefsUtil.getInt(COMPANY_ID)!,
          prefsUtil.getInt(LEADE_ID)!) as GetLeadResponseModel?;

      customerSequence(context, getLeadData, leadCurrentActivityAsyncData, "push");
    } catch (error) {
      Navigator.of(context, rootNavigator: true).pop();
      if (kDebugMode) {
        print('Error occurred during API call: $error');
      }
    }
  }
}
