import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

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
import 'camera_page.dart';
import 'model/LeadSelfieResponseModel.dart';
import 'model/PostLeadSelfieRequestModel.dart';

class TakeSelfieScreen extends StatefulWidget {
  final int activityId;
  final int subActivityId;
  final String?  pageType;

  TakeSelfieScreen(
      {super.key, required this.activityId, required this.subActivityId, this.pageType});

  @override
  State<TakeSelfieScreen> createState() => _TakeSelfieScreenState();
}

class _TakeSelfieScreenState extends State<TakeSelfieScreen> {
  var selfieImage = "";
  var isLoading = false;
  var frontDocumentId = 0;
  var isSelfieDelete = false;
  var isAgenSelfieDelete = false;

  void _handlePermissionsAccepted(File? picture) {
    setState(() {
/*
      File file = File(picture!.path);
      print("dsfjskf$picture");
*/

      uolpadSelfie(context, picture!);
    });
  }

  @override
  void initState() {
    super.initState();
    //Api Call
    getLeadSelfie(context);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    LeadSelfieResponseModel? leadSelfieResponseModel = null;

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
        backgroundColor: textFiledBackgroundColour,
        body: SafeArea(
          child:
          Consumer<DataProvider>(builder: (context, productProvider, child) {
            if (productProvider.getLeadSelfieData == null && isLoading) {
              return CircularProgressIndicator();
            } else {
              if (productProvider.getLeadSelfieData != null && isLoading) {
                Navigator.of(context, rootNavigator: true).pop();
                isLoading = false;
              }
              if (productProvider.getLeadSelfieData != null) {
                productProvider.getLeadSelfieData!.when(
                  success: (LeadSelfieResponseModel) async {
                    leadSelfieResponseModel = LeadSelfieResponseModel;
                    if (leadSelfieResponseModel != null) {
                      if (leadSelfieResponseModel!.frontImageUrl != null && leadSelfieResponseModel!.frontDocumentId != null && !isSelfieDelete) {
                        selfieImage = leadSelfieResponseModel!.frontImageUrl!;
                        frontDocumentId =
                        leadSelfieResponseModel!.frontDocumentId!;
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
                if (productProvider.getPostSelfieImageSingleFileData != null) {
                  if (productProvider
                      .getPostSelfieImageSingleFileData!.filePath !=
                      null &&
                      productProvider.getPostSelfieImageSingleFileData!.docId !=
                          null &&
                      !isAgenSelfieDelete) {
                    selfieImage = productProvider
                        .getPostSelfieImageSingleFileData!.filePath!;
                    frontDocumentId =
                    productProvider.getPostSelfieImageSingleFileData!.docId!;
                  }
                }
              }
            }
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 30, top: 50, right: 30, bottom: 30),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'A Selfie with your identity \nStay still and look at the camera',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16, color: Colors.black),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                        'Position your face in the center of the\nframe. Make sure your face is well-lit and nclearly visible.',
                        textAlign: TextAlign.start,
                        style: TextStyle(fontSize: 15, color: Colors.black),
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(0),
                          child: Container(
                            width: 250,
                            height: 250,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.rectangle,
                                border:
                                Border.all(color: kPrimaryColor, width: 1),
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    topRight: Radius.circular(10),
                                    bottomRight: Radius.circular(10),
                                    bottomLeft: Radius.circular(10))),
                            child: Center(
                              child: Container(
                                  child: (!selfieImage.isEmpty)
                                      ? Stack(
                                    children: [
                                      Container(
                                        child: ClipRRect(
                                          borderRadius:
                                          BorderRadius.circular(8.0),
                                          child: Image.network(
                                            selfieImage,
                                            fit: BoxFit.cover,
                                            width: double.infinity,
                                            height: 250,
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              isSelfieDelete = true;
                                              isAgenSelfieDelete = true;
                                              selfieImage = "";
                                            });
                                          },
                                          child: Container(
                                            height: 250,
                                            width: 250,
                                            padding: EdgeInsets.all(4),
                                            alignment: Alignment.topRight,
                                            child: SvgPicture.asset(
                                                'assets/icons/delete_icon.svg'),
                                          ))
                                    ],
                                  )
                                      : Container(
                                    child: SvgPicture.asset(
                                        'assets/images/take_selfie.svg'),
                                  )),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 50),
                      (selfieImage.isEmpty)
                          ? CommonElevatedButton(
                        onPressed: () async {
                          isAgenSelfieDelete = false;
                          final result = await availableCameras().then(
                                  (value) => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) =>
                                          CameraPage(cameras: value))));

                          // Handle the result from Screen B using the callback function
                          _handlePermissionsAccepted(result ?? "");
                        },
                        text: "Take a Selfie",
                        upperCase: true,
                      )
                          : CommonElevatedButton(
                        onPressed: () async {
                          if (!selfieImage.isEmpty) {
                            await postLeadSelfie(selfieImage,
                                frontDocumentId, productProvider);
                          }
                        },
                        text: "Next",
                        upperCase: true,
                      ),
                    ]),
              ),
            );
          }),
        ),
      ),
    );
  }

  Future<void> getLeadSelfie(BuildContext context) async {
    final prefsUtil = await SharedPref.getInstance();
    final String? userId = prefsUtil.getString(USER_ID);
    final String? productCode = prefsUtil.getString(PRODUCT_CODE);
    Provider.of<DataProvider>(context, listen: false).getLeadSelfie(userId!,productCode!);
  }

  Future<void> uolpadSelfie(BuildContext context, File picture) async {
    Utils.onLoading(context, "");
    await Provider.of<DataProvider>(context, listen: false)
        .postTakeSelfieFile(picture, true, "", "");
    Navigator.of(context, rootNavigator: true).pop();
  }

  Future<void> postLeadSelfie(String selfieImage, int frontDocumentId,
      DataProvider productProvider) async {
    final prefsUtil = await SharedPref.getInstance();
    final String? userId = prefsUtil.getString(USER_ID);
    var postLeadSelfieRequestModel = PostLeadSelfieRequestModel(
      leadId: prefsUtil.getInt(LEADE_ID),
      userId: userId,
      activityId: widget.activityId,
      subActivityId: widget.subActivityId,
      frontImageUrl: selfieImage,
      frontDocumentId: frontDocumentId,
      companyId: prefsUtil.getInt(COMPANY_ID),
    );

    Utils.onLoading(context, "");
    await Provider.of<DataProvider>(context, listen: false)
        .postLeadSelfie(postLeadSelfieRequestModel);
    Navigator.of(context, rootNavigator: true).pop();

    if (productProvider.getPostLeadSelfieData != null) {
      productProvider.getPostLeadSelfieData!.when(
        success: (PostLeadSelfieResponseModel) async {
          var postLeadSelfieResponseModel = PostLeadSelfieResponseModel;
          if (postLeadSelfieResponseModel != null) {
            if (postLeadSelfieResponseModel.isSuccess != null &&
                postLeadSelfieResponseModel.isSuccess!) {
              fetchData(context);
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
    ;
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
          await ApiService().leadCurrentActivityAsync(leadCurrentRequestModel, context)
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
