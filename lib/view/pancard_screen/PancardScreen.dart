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
import '../../providers/DataProvider.dart';
import '../../shared_preferences/shared_pref.dart';
import '../../utils/DateTextFormatter.dart';
import '../../utils/ImagePicker.dart';
import '../../utils/common_check_box.dart';
import '../../utils/common_elevted_button.dart';
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
  final TextEditingController _nameAsPanCl = TextEditingController();
  final TextEditingController _dOBAsPanCl = TextEditingController();
  final TextEditingController _fatherNameAsPanCl = TextEditingController();
  String image = "";
  var isLoading = true;
  var isEnabledPanNumber = true;
  var isVerifyPanNumber = false;
  var isDataClear = false;
  var _acceptPermissions = false;
  String dobAsPan = "";
  int documentId = 0;
  var isImageDelete = false;
  late LeadPanResponseModel LeadPANData;
  late ValidPanCardResponsModel validPanCardResponsModel;
  late FathersNameByValidPanCardResponseModel
  fathersNameByValidPanCardResponseModel;
  late PostLeadPanResponseModel postLeadPanResponseModel;

  @override
  void initState() {
    super.initState();
    //Api Call
    leadPANApi(context);
  }

  // Callback function to receive the selected image
  void _onImageSelected(File imageFile) async {
    // Handle the selected image here
    // For example, you can setState to update UI with the selected image
    isImageDelete = false;
    Utils.onLoading(context, "");
    await Provider.of<DataProvider>(context, listen: false)
        .postSingleFile(imageFile, true, "", "");
    // Navigator.pop(context);
    Navigator.of(context, rootNavigator: true).pop();
  }

  void _handlePermissionsAccepted(bool accept) {
    setState(() {
      _acceptPermissions = accept;

      print("asdfads$_acceptPermissions");
    });
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
        body: SafeArea(
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

                        if (LeadPANData.panCard != null &&
                            !isDataClear &&
                            !isImageDelete) {
                          isVerifyPanNumber = true;
                          isEnabledPanNumber = false;
                          if(LeadPANData.panCard!=null){
                            _panNumberCl.text = LeadPANData.panCard!;
                          }
                          if(LeadPANData.nameOnCard!=null){
                            _nameAsPanCl.text = LeadPANData.nameOnCard!;
                          }

                          if(LeadPANData.dob!=null){
                            var formateDob =
                            Utils.dateFormate(context, LeadPANData.dob!);
                            dobAsPan = LeadPANData.dob!;
                            _dOBAsPanCl.text = formateDob;
                          }

                          if( LeadPANData.fatherName!=null){
                            _fatherNameAsPanCl.text = LeadPANData.fatherName!;
                          }
                          if(LeadPANData.panImagePath!=null){
                            image = LeadPANData.panImagePath!;
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

                  if (productProvider.getPostSingleFileData != null &&
                      !isImageDelete) {
                    if (productProvider.getPostSingleFileData!.filePath != null) {
                      image = productProvider.getPostSingleFileData!.filePath!;
                      documentId = productProvider.getPostSingleFileData!.docId!;
                    }
                  }

                  return Center(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(30),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                                height: 100,
                                width: 100,
                                alignment: Alignment.topLeft,
                                child: Image.asset('assets/images/scale.png')),
                            const Text(
                              'Enter Your PAN',
                              textAlign: TextAlign.start,
                              style: TextStyle(fontSize: 40, color: Colors.black),
                            ),
                            const SizedBox(height: 20),
                            const Text(
                              'Verify the PAN number',
                              textAlign: TextAlign.start,
                              style: TextStyle(fontSize: 15, color: Colors.black),
                            ),
                            const SizedBox(height: 20),
                            const Text(
                              'PAN Number',
                              textAlign: TextAlign.start,
                              style:
                              TextStyle(fontSize: 14, color: Color(0xff858585)),
                            ),
                            const SizedBox(height: 5),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 2.0, horizontal: 16.0),
                              decoration: BoxDecoration(
                                color: textFiledBackgroundColour,
                                border: Border.all(color: kPrimaryColor),
                                // Set background color
                                borderRadius: BorderRadius.circular(
                                    10.0), // Set border radius
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Expanded(
                                    child: TextField(
                                      controller: _panNumberCl,
                                      keyboardType: TextInputType.text,
                                      cursorColor: Colors.blue,
                                      textCapitalization:
                                      TextCapitalization.characters,
                                      maxLines: 1,
                                      enabled: isEnabledPanNumber,
                                      inputFormatters: [FilteringTextInputFormatter.allow(RegExp((r'[A-Z0-9]'))),
                                        LengthLimitingTextInputFormatter(10)],
                                      /*inputFormatters: [
                                        LengthLimitingTextInputFormatter(10),
                                        // Limit to 10 characters
                                      ],*/
                                      decoration: const InputDecoration(
                                        contentPadding: EdgeInsets.symmetric(
                                            vertical: 0.0, horizontal: 0.0),
                                        hintText: "Enter PAN Number",
                                        fillColor: textFiledBackgroundColour,
                                        filled: true,
                                        border: InputBorder
                                            .none, // Remove underline border
                                      ),
                                      onChanged: (text) async {
                                        print(
                                            'TextField value: $text (${text.length})');
                                        if (text.length == 10) {
                                          // Make API Call to validate PAN card
                                          await getLeadValidPanCard(context,
                                              _panNumberCl.text, productProvider);
                                        }
                                      },
                                    ),
                                  ),
                                  isVerifyPanNumber
                                      ? Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      SvgPicture.asset(
                                        'assets/images/verify_pan.svg',
                                        semanticsLabel: 'Verify PAN SVG',
                                      ),
                                      SizedBox(width: 10),
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            isImageDelete = true;
                                            isEnabledPanNumber = true;
                                            isVerifyPanNumber = false;
                                            isDataClear = true;
                                            _panNumberCl.text = "";
                                            _nameAsPanCl.text = "";
                                            dobAsPan = "";
                                            _dOBAsPanCl.text = "";
                                            _fatherNameAsPanCl.text = "";
                                            image = "";
                                            documentId = 0;
                                            _acceptPermissions = false;

                                            LeadPANData.panCard = "";
                                            LeadPANData.nameOnCard = "";
                                            LeadPANData.dob = "";
                                            LeadPANData.fatherName = "";
                                            LeadPANData.panImagePath = "";
                                            LeadPANData.documentId = 0;
                                          });
                                        },
                                        child: SvgPicture.asset(
                                          'assets/icons/edit_icon.svg',
                                          semanticsLabel: 'Edit Icon SVG',
                                        ),
                                      ),
                                    ],
                                  )
                                      : Container(),
                                ],
                              ),
                            ),
                            SizedBox(height: 20),
                            const Text(
                              'Name ( As per PAN )',
                              textAlign: TextAlign.start,
                              style:
                              TextStyle(fontSize: 14, color: Color(0xff858585)),
                            ),
                            const SizedBox(height: 5),
                            TextField(
                              controller: _nameAsPanCl,
                              keyboardType: TextInputType.text,
                              cursorColor: kPrimaryColor,
                              enabled: false,
                              decoration: const InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 16.0, horizontal: 16.0),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: kPrimaryColor),
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(10.0))),
                                hintText: "Enter Name",
                                fillColor: textFiledBackgroundColour,
                                filled: true,
                                border: OutlineInputBorder(
                                  borderSide:
                                  BorderSide(color: kPrimaryColor, width: 1.0),
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                                ),
                              ),
                            ),
                            SizedBox(height: 20),
                            Text(
                              'DOB ( As per PAN )',
                              textAlign: TextAlign.start,
                              style:
                              TextStyle(fontSize: 14, color: Color(0xff858585)),
                            ),
                            SizedBox(height: 5),
                            TextField(
                              controller: _dOBAsPanCl,
                              keyboardType: TextInputType.text,
                              cursorColor: kPrimaryColor,
                              enabled: false,
                              inputFormatters: [DateTextFormatter()],
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 16.0, horizontal: 16.0),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: kPrimaryColor),
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(10.0))),
                                hintText: "DD | MM | YYYY",
                                fillColor: textFiledBackgroundColour,
                                filled: true,
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: kPrimaryColor, width: 1.0),
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(10.0))),
                              ),
                            ),
                            SizedBox(height: 20),
                            Text(
                              'Father’s Name ( As per PAN )',
                              textAlign: TextAlign.start,
                              style:
                              TextStyle(fontSize: 14, color: Color(0xff858585)),
                            ),
                            SizedBox(height: 5),
                            TextField(
                              controller: _fatherNameAsPanCl,
                              keyboardType: TextInputType.text,
                              cursorColor: kPrimaryColor,
                              textCapitalization: TextCapitalization.characters,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 16.0, horizontal: 16.0),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: kPrimaryColor),
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(10.0))),
                                hintText: "Enter Father Name",
                                fillColor: textFiledBackgroundColour,
                                filled: true,
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: kPrimaryColor, width: 1.0),
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(10.0))),
                              ),
                            ),
                            SizedBox(height: 20),
                            Stack(
                              children: [
                                Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(color: Color(0xff0196CE))),
                                    width: double.infinity,
                                    child: GestureDetector(
                                      onTap: () {
                                        bottomSheetMenu(context);
                                      },
                                      child: Container(
                                        height: 148,
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          color: Color(0xffEFFAFF),
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: (!image.isEmpty)
                                            ? ClipRRect(
                                          borderRadius:
                                          BorderRadius.circular(8.0),
                                          child: Image.network(
                                            image,
                                            fit: BoxFit.cover,
                                            width: double.infinity,
                                            height: 148,
                                          ),
                                        )
                                            : (image.isNotEmpty)
                                            ? ClipRRect(
                                          borderRadius:
                                          BorderRadius.circular(8.0),
                                          child: Image.network(
                                            image,
                                            fit: BoxFit.cover,
                                            width: double.infinity,
                                            height: 148,
                                          ),
                                        )
                                            : Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                          MainAxisAlignment.center,
                                          children: [
                                            SvgPicture.asset(
                                                'assets/images/gallery.svg'),
                                            const Text(
                                              'Upload PAN Image',
                                              style: TextStyle(
                                                  color:
                                                  Color(0xff0196CE),
                                                  fontSize: 12),
                                            ),
                                            const Text(
                                                'Supports : JPEG, PNG',
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    color: Color(
                                                        0xffCACACA))),
                                          ],
                                        ),
                                      ),
                                    )),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      isImageDelete = true;
                                      image = "";
                                    });
                                  },
                                  child: !image.isEmpty
                                      ? Container(
                                    padding: EdgeInsets.all(4),
                                    alignment: Alignment.topRight,
                                    child: SvgPicture.asset(
                                        'assets/icons/delete_icon.svg'),
                                  )
                                      : Container(),
                                )
                              ],
                            ),
                            SizedBox(height: 20),

                            /* CheckboxTerm(
                              content:
                              "By proceeding, I provide consent on the following",
                              onChanged: (bool isChecked) async {

                                if (isChecked) {
                                  final result = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => PermissionsScreen()),
                                  );
                                  // Handle the result from Screen B using the callback function
                                  _handlePermissionsAccepted(result ?? false);
                                }
                                isChecked = _acceptPermissions;
                              },
                            ),*/
                            CommonCheckBox(
                              onChanged: (bool isChecked) async {
                                // Handle the state change here
                                print('Checkbox state changed: $isChecked');
                                if (isChecked) {
                                  final result = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => PermissionsScreen()),
                                  );
                                  // Handle the result from Screen B using the callback function
                                  _handlePermissionsAccepted(result ?? false);
                                }
                              },
                              isChecked: _acceptPermissions,
                              text: "By proceeding, I provide consent on the following",
                              upperCase: false,
                            ),
                            SizedBox(height: 20),
                            /*Text("I hereby accept Scaleup T&C & Privacy Policy . Further, I hereby agree to share my details, including PAN, Date of birth, Name, Pin code, Mobile number, Email id and device information with you and for further sharing with your partners including lending partners"),*/
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'I hereby accept ',
                                    style: TextStyle(
                                      color: Colors.black,
                                    ),
                                  ),
                                  _buildClickableTextSpan(
                                    text: 'T&C  & Privacy Policy',
                                    onClick: ()async {

                                      final result = await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => PermissionsScreen()),
                                      );
                                      // Handle the result from Screen B using the callback function
                                      _handlePermissionsAccepted(result ?? false);
                                    },
                                  ),
                                  TextSpan(
                                    text:
                                    '. Further, I hereby agree to share my details, including PAN, Date of birth, Name, Pin code, Mobile number, Email id and device information with you and for further sharing with your partners including lending partners',
                                    style: TextStyle(
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 30),
                            CommonElevatedButton(
                              onPressed: () async {
                                final prefsUtil = await SharedPref.getInstance();
                                final String? userId = prefsUtil.getString(USER_ID);
                                final int? companyId = prefsUtil.getInt(COMPANY_ID);

                                if (_panNumberCl.text.isEmpty) {
                                  Utils.showToast("Please Enter Valid Pan Card Details",context);
                                }/* else if (_nameAsPanCl.text.isEmpty) {
                                  Utils.showToast("Please Enter Name (As Per Pan))",context);
                                } else if (_dOBAsPanCl.text.isEmpty || dobAsPan.isEmpty) {
                                  Utils.showToast("Please Enter Name (As Per Pan))",context);
                                }*/ else if (_fatherNameAsPanCl.text.isEmpty) {
                                  Utils.showToast("Please Enter Father Name!!!",context);
                                } else if (image.isEmpty) {
                                  Utils.showToast("Upload PAN-CARD Image!! ",context);
                                } else if (!_acceptPermissions) {
                                  Utils.showToast(
                                      "Please provide consent for T&C & privacy!!!",context);
                                } else {
                                  var postLeadPanRequestModel =
                                  PostLeadPanRequestModel(
                                    leadId: prefsUtil.getInt(LEADE_ID),
                                    userId: userId,
                                    activityId: widget.activityId,
                                    subActivityId: widget.subActivityId,
                                    uniqueId: _panNumberCl.text,
                                    imagePath: image,
                                    documentId: documentId,
                                    companyId: companyId,
                                    fathersName: _fatherNameAsPanCl.text,
                                    dob: dobAsPan,
                                    name: _nameAsPanCl.text,
                                  );
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
                    ),
                  );
                }
              }),
        ),
      ),
    );

    Widget loadingWidget = Utils.onLoading(context, "Loading....");
  }

  @override
  void dispose() {
    _panNumberCl.dispose();
    _nameAsPanCl.dispose();
    _dOBAsPanCl.dispose();
    _fatherNameAsPanCl.dispose();
    super.dispose();
  }

  void bottomSheetMenu(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (builder) {
          return ImagePickerWidgets(onImageSelected: _onImageSelected);
        });
  }

  TextSpan _buildClickableTextSpan(
      {required String text, required VoidCallback onClick}) {
    return TextSpan(
      text: text,
      style: TextStyle(
          color: Colors.black, // Set text color to blue for clickable text
          decoration: TextDecoration.underline,
          fontWeight: FontWeight.bold // Underline clickable text
      ),
      recognizer: TapGestureRecognizer()..onTap = onClick,
    );
  }

  Future<void> leadPANApi(BuildContext context) async {
    final prefsUtil = await SharedPref.getInstance();
    String? userId = prefsUtil.getString(USER_ID);
    final String? productCode = prefsUtil.getString(PRODUCT_CODE);

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
    Utils.onLoading(context, "");
    await Provider.of<DataProvider>(context, listen: false)
        .getLeadValidPanCard(pancardNumber);
    Navigator.of(context, rootNavigator: true).pop();

    if (productProvider.getLeadValidPanCardData != null) {
      productProvider.getLeadValidPanCardData!.when(
          success: (ValidPanCardResponsModel) async {
            validPanCardResponsModel = ValidPanCardResponsModel;
            if (validPanCardResponsModel.nameOnPancard != null) {
              _nameAsPanCl.text = validPanCardResponsModel.nameOnPancard!;
              isVerifyPanNumber = true;
              isEnabledPanNumber = false;
              //  Utils.showToast(validPanCardResponsModel.message!,context);
              await getFathersNameByValidPanCard(
                  context, pancardNumber, productProvider);
            } else {
              Utils.showToast(validPanCardResponsModel.message!,context);
              _nameAsPanCl.clear();
              _dOBAsPanCl.clear();
              _fatherNameAsPanCl.clear();
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
            var formateDob = Utils.dateFormate(context, fathersNameByValidPanCardResponseModel.dob);dobAsPan = fathersNameByValidPanCardResponseModel.dob;_dOBAsPanCl.text = formateDob;
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
