import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '../../api/ApiService.dart';
import '../../api/FailureException.dart';
import '../../providers/auth_provider/DataProvider.dart';
import '../../shared_preferences/shared_pref.dart';
import '../../utils/DateTextFormatter.dart';
import '../../utils/ImagePicker.dart';
import '../../utils/common_check_box.dart';
import '../../utils/common_elevted_button.dart';
import '../../utils/common_text_field.dart';
import '../../utils/constant.dart';
import '../../utils/customer_sequence_logic.dart';
import '../../utils/utils_class.dart';
import '../splash/model/GetLeadResponseModel.dart';
import '../splash/model/LeadCurrentRequestModel.dart';
import '../splash/model/LeadCurrentResponseModel.dart';
import 'PermissionsScreen.dart';
import 'model/FathersNameByValidPanCardResponseModel.dart';
import 'model/LeadPanResponseModel.dart';
import 'model/PostLeadPANRequestModel.dart';
import 'model/PostLeadPANResponseModel.dart';
import 'model/ValidPanCardResponsModel.dart';

class PancardScreen extends StatefulWidget {
  final int activityId;
  final int subActivityId;
  final String?  pageType;

  PancardScreen(
      {super.key, required this.activityId, required this.subActivityId, this.pageType});

  @override
  State<PancardScreen> createState() => _PancardScreenState();
}

class _PancardScreenState extends State<PancardScreen> {
  final TextEditingController _panNumberCl = TextEditingController();
  var _nameAsPan="";
  var _dOBAsPan="";
  var isLoading = false;
  var isEnabledPanNumber = true;
  var isVerifyPanNumber = false;
  var isDataClear = false;
  String dobAsPan = "";
  int documentId = 0;
  late LeadPanResponseModel LeadPANData;
  late ValidPanCardResponsModel validPanCardResponsModel;
  late FathersNameByValidPanCardResponseModel
  fathersNameByValidPanCardResponseModel;
  late PostLeadPanResponseModel postLeadPanResponseModel;
  var isPanProgressDilog=false;

  @override
  void initState() {
    super.initState();
    //Api Call
    leadPANApi(context);
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
        if(widget.pageType == "pushReplacement" ) {
          final bool shouldPop = await Utils().onback(context);
          if (shouldPop) {
            SystemNavigator.pop();
          }
        } else {
          SystemNavigator.pop();
        }
      },
      child: Scaffold(
        backgroundColor:Colors.white ,
        body: Container(
          child: SafeArea(
            top: true,
            bottom: true,
            child: Consumer<DataProvider>(
                builder: (context, productProvider, child) {
                  if (productProvider.getLeadPANData == null && isLoading) {
                    return Utils.onLoading(context, "");
                  } else {
                    if (productProvider.getLeadPANData != null && isLoading) {
                      Navigator.of(context, rootNavigator: true).pop();
                      isLoading = false;
                    }

                    if (productProvider.getLeadPANData != null) {
                      productProvider.getLeadPANData!.when(
                        success: (LeadPanResponseModel) {
                          // Handle successful response
                          LeadPANData = LeadPanResponseModel;

                          if (LeadPANData.panCard != null && !isDataClear) {
                            isVerifyPanNumber = true;
                            isEnabledPanNumber = false;
                            if(LeadPANData.panCard!=null){_panNumberCl.text = LeadPANData.panCard!;}
                            if(LeadPANData.nameOnCard!=null){
                              _nameAsPan = LeadPANData.nameOnCard!;
                            }

                            if(LeadPANData.dob!=null){
                              var formateDob =
                              Utils.dateFormate(context, LeadPANData.dob!);
                              dobAsPan = LeadPANData.dob!;
                              _dOBAsPan = formateDob;
                            }

                            if(LeadPANData.documentId!=null){
                              documentId = LeadPANData.documentId!;
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

                    if (productProvider.getPostSingleFileData != null ) {
                      if (productProvider.getPostSingleFileData!.filePath != null) {
                        documentId = productProvider.getPostSingleFileData!.docId!;
                      }
                    }

                    return SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(30),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text(
                              'PAN Verification',
                              textAlign: TextAlign.start,
                              style: TextStyle(fontSize: 16, color: Colors.black,fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 20),
                            isVerifyPanNumber?Container(
                                height: 100,
                                width: 100,
                                alignment: Alignment.center,
                                child:  SvgPicture.asset(
                                  'assets/images/ic_verified_pancard.svg',
                                  semanticsLabel: 'Verify PAN SVG',
                                ),):Container(
                              height: 100,
                              width: 100,
                              alignment: Alignment.center,
                              child:  SvgPicture.asset(
                                'assets/images/ic_verify_pancard.svg',
                                semanticsLabel: 'Verify PAN SVG',
                              ),),

                            const SizedBox(height: 20),
                            isVerifyPanNumber?const Text(
                              'PAN Verification Complete',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 15, color: Colors.black),
                            ):
                            const Text(
                              'Provide your PAN details to verify registered name and active status',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 15, color: Colors.black),
                            ),
                            const SizedBox(height: 30),

                            Stack(
                              children: [
                                CommonTextField(
                                    controller: _panNumberCl,
                                    hintText: "Enter PAN Number",
                                    keyboardType: TextInputType.text,
                                    enabled: isEnabledPanNumber,
                                    labelText: "Enter PAN Number",
                                    textCapitalization: TextCapitalization.characters,
                                    inputFormatter: [FilteringTextInputFormatter.allow(RegExp((r'[A-Z0-9]'))),
                                      LengthLimitingTextInputFormatter(10)],
                                    onChanged: (text) async {
                                      if (text.length == 10) {
                                        // Make API Call to validate PAN card
                                        setState(() {
                                          isPanProgressDilog=true;
                                        });

                                        await getLeadValidPanCard(context,
                                            _panNumberCl.text, productProvider);
                                      }else{
                                        isPanProgressDilog=false;
                                      }
                                    }),
                                isVerifyPanNumber?
                                Positioned(
                                  top: 0,
                                  right: 0,
                                  bottom: 0,
                                  child: GestureDetector(
                                    onTap: () {
                                      // print('Edit icon tapped');
                                      setState(() {
                                        isEnabledPanNumber = true;
                                        isVerifyPanNumber = false;
                                        isDataClear = true;
                                        _panNumberCl.text = "";
                                        _nameAsPan = "";
                                        dobAsPan = "";
                                        _dOBAsPan= "";
                                        documentId = 0;

                                        LeadPANData.panCard = "";
                                        LeadPANData.nameOnCard = "";
                                        LeadPANData.dob = "";
                                        LeadPANData.fatherName = "";
                                        LeadPANData.panImagePath = "";
                                        LeadPANData.documentId = 0;
                                      });
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(8),
                                      child: SvgPicture.asset(
                                        'assets/images/verify_pan.svg',
                                        semanticsLabel: 'Verify PAN SVG',
                                      ),
                                    ),
                                  ),
                                ): isPanProgressDilog?Positioned(
                                  top: 0,
                                  right: 0,
                                  bottom: 0,
                                  child: Container(
                                    // Adjusted to be slightly larger than the indicator
                                    width: 50, // Adjusted to be slightly larger than the indicator
                                    child: Transform.scale(
                                      scale: 0.4, // Scale down the CircularProgressIndicator
                                      child: CircularProgressIndicator(
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                ):Container(),
                              ],
                            ),


                            const SizedBox(height: 20),
                            isVerifyPanNumber? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [

                                const Text(
                                  'Details',
                                  textAlign: TextAlign.start,
                                  style: TextStyle(fontSize: 14, color: Colors.black),
                                ),
                                const SizedBox(height: 10),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 2.0, horizontal: 16.0),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(color: light_gry),
                                    // Set background color
                                    borderRadius: BorderRadius.circular(
                                        10.0), // Set border radius
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              'Name : ',
                                              textAlign: TextAlign.start,
                                              style: TextStyle(fontSize: 15, color: dark_gry),
                                            ),
                                            Text(
                                              '$_nameAsPan',
                                              textAlign: TextAlign.start,
                                              style: TextStyle(fontSize: 15, color: Colors.black),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 8),
                                        Row(
                                          children: [
                                            Text(
                                              'Date of Birth :  ',
                                              textAlign: TextAlign.start,
                                              style: TextStyle(fontSize: 15, color: Colors.grey),
                                            ),
                                            Text(
                                              '$_dOBAsPan',
                                              textAlign: TextAlign.start,
                                              style: TextStyle(fontSize: 15, color: Colors.black),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 8),


                                      ],
                                    ),
                                  ),

                                ),
                              ],
                            ):Container(),


                            SizedBox(height: 40),
                            CommonElevatedButton(
                              onPressed: () async {
                                final prefsUtil = await SharedPref.getInstance();
                                final String? userId = prefsUtil.getString(USER_ID);
                                final int? companyId = prefsUtil.getInt(COMPANY_ID);

                                if (_panNumberCl.text.isEmpty) {
                                  Utils.showToast("Please Enter Valid Pan Card Details",context);
                                } else {
                                  var postLeadPanRequestModel =
                                  PostLeadPanRequestModel(
                                    leadId: prefsUtil.getInt(LEADE_ID),
                                    userId: userId,
                                    activityId: widget.activityId,
                                    subActivityId: widget.subActivityId,
                                    uniqueId: _panNumberCl.text,
                                    imagePath: "",
                                    documentId: documentId,
                                    companyId: companyId,
                                    fathersName: "",
                                    dob: dobAsPan,
                                    name: _nameAsPan,
                                  );

                                  print("saveData${postLeadPanRequestModel.toJson().toString()}");
                                  await postLeadPAN(context, productProvider,
                                      postLeadPanRequestModel);
                                }
                              },
                              text: "next",
                              upperCase: true,
                            )
                          ],
                        ),
                      ),
                    );
                  }
                }),
          ),
        ),
      ),
    );

    Widget loadingWidget = Utils.onLoading(context, "Loading....");
  }

  @override
  void dispose() {
    _panNumberCl.dispose();
    super.dispose();
  }

  Future<void> leadPANApi(BuildContext context) async {
    final prefsUtil = await SharedPref.getInstance();
   // String? userId = prefsUtil.getString(USER_ID);
    //final String? productCode = prefsUtil.getString(PRODUCT_CODE);
    final String? productCode = "BusinessLoan";
    String? userId = "ab9d9b2b-546b-47ff-b010-2e9ddbea0d12";
    Provider.of<DataProvider>(context, listen: false).getLeadPAN(userId!,productCode!);
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

  Future<void> getLeadValidPanCard(BuildContext context, String pancardNumber,
      DataProvider productProvider) async {
    Utils.hideKeyBored(context);
    //Utils.onLoading(context, "");
    await Provider.of<DataProvider>(context, listen: false)
        .getLeadValidPanCard(pancardNumber);
    isPanProgressDilog=false;
   // Navigator.of(context, rootNavigator: true).pop();

    if (productProvider.getLeadValidPanCardData != null) {
      productProvider.getLeadValidPanCardData!.when(
        success: (ValidPanCardResponsModel) async {
          validPanCardResponsModel = ValidPanCardResponsModel;
          if (validPanCardResponsModel.nameOnPancard != null) {
            _nameAsPan = validPanCardResponsModel.nameOnPancard!;
            isVerifyPanNumber = true;
            isEnabledPanNumber = false;
          //  Utils.showToast(validPanCardResponsModel.message!,context);
            await getFathersNameByValidPanCard(
                context, pancardNumber, productProvider);
          } else {
            Utils.showToast(validPanCardResponsModel.message!,context);
            _nameAsPan="";
            _dOBAsPan="";
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
          }
      );
    }
  }

  Future<void> getFathersNameByValidPanCard(BuildContext context,
      String pancardNumber, DataProvider productProvider) async {
    Utils.onLoading(context, "");
    await Provider.of<DataProvider>(context, listen: false)
        .getFathersNameByValidPanCard(pancardNumber);
    Navigator.of(context, rootNavigator: true).pop();

    if (productProvider.getFathersNameByValidPanCardData != null) {
      productProvider.getFathersNameByValidPanCardData!.when(
        success: (FathersNameByValidPanCardResponseModel) {
          // Handle successful response
          fathersNameByValidPanCardResponseModel = FathersNameByValidPanCardResponseModel;
          if (fathersNameByValidPanCardResponseModel.dob != null) {
            var formateDob = Utils.dateFormate(context, fathersNameByValidPanCardResponseModel.dob);dobAsPan = fathersNameByValidPanCardResponseModel.dob;_dOBAsPan = formateDob;
          } else {
            if(fathersNameByValidPanCardResponseModel.message != null) {
              Utils.showToast(fathersNameByValidPanCardResponseModel.message!, context);
            }
          }
        },
        failure: (exception) {
          // Handle failure
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
  }

  Future<void> postLeadPAN(BuildContext context, DataProvider productProvider,
      PostLeadPanRequestModel postLeadPanRequestModel) async {
    Utils.onLoading(context, "Loading...");
    await Provider.of<DataProvider>(context, listen: false)
        .postLeadPAN(postLeadPanRequestModel);
    Navigator.of(context, rootNavigator: true).pop();
    if (productProvider.getPostLeadPaneData != null) {
      productProvider.getPostLeadPaneData!.when(
        success: (PostLeadPanResponseModel) {
          // Handle successful response
          postLeadPanResponseModel = PostLeadPanResponseModel;
          Utils.showToast(postLeadPanResponseModel.message!,context);
          if (postLeadPanResponseModel.isSuccess!) {
            fetchData(context);
          }
        },
        failure: (exception) {
          // Handle failure
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
  }
}
