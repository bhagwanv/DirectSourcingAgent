import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../api/ApiService.dart';
import '../../api/FailureException.dart';
import '../../providers/DataProvider.dart';
import '../../shared_preferences/shared_pref.dart';
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
  final String? pageType;

  const PancardScreen(
      {super.key,
      required this.activityId,
      required this.subActivityId,
      this.pageType});

  @override
  State<PancardScreen> createState() => _PancardScreenState();
}

class _PancardScreenState extends State<PancardScreen> {
  final TextEditingController _panNumberCl = TextEditingController();
  final TextEditingController _nameAsPanCl = TextEditingController();
  final TextEditingController _dOBAsPanCl = TextEditingController();
  final TextEditingController _fatherNameAsPanCl = TextEditingController();
  String image = "";
  var isLoading = false;
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
  var isPanProgressDilog = false;
  late FocusNode myFocusNode;

  @override
  void initState() {
    super.initState();
    //Api Call

    leadPANApi(context);
    myFocusNode = FocusNode();
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
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) async {
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
        backgroundColor: Colors.white,
        body: SafeArea(
          top: true,
          bottom: true,
          child: Consumer<DataProvider>(builder: (context, productProvider, child) {
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

                    if (LeadPANData.panCard != null && !isDataClear && !isImageDelete) {
                      isVerifyPanNumber = true;
                      isEnabledPanNumber = false;
                      if (LeadPANData.panCard != null) {
                        _panNumberCl.text = LeadPANData.panCard!;
                      }
                      if (LeadPANData.nameOnCard != null) {
                        _nameAsPanCl.text = LeadPANData.nameOnCard!;
                      }

                      if (LeadPANData.dob != null) {
                        var formateDob =
                            Utils.dateFormate(context, LeadPANData.dob!);
                        dobAsPan = LeadPANData.dob!;
                        _dOBAsPanCl.text = formateDob;
                      }

                      if (LeadPANData.fatherName != null) {
                        _fatherNameAsPanCl.text = LeadPANData.fatherName!;
                      }
                      if (LeadPANData.panImagePath != null) {
                        image = LeadPANData.panImagePath!;
                      }

                      if (LeadPANData.documentId != null) {
                        documentId = LeadPANData.documentId!;
                      }
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
              if (productProvider.getPostSingleFileData != null && !isImageDelete) {
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
                        Center(
                          child: Text(
                            'PAN Verification',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.urbanist(
                              fontSize: 16,
                              color: blackSmall,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        isVerifyPanNumber
                            ? Center(
                                child: Container(
                                  height: 100,
                                  width: 100,
                                  alignment: Alignment.center,
                                  child: SvgPicture.asset(
                                    'assets/images/ic_verified_pancard.svg',
                                    semanticsLabel: 'Verify PAN SVG',
                                  ),
                                ),
                              )
                            : Center(
                                child: Container(
                                  height: 100,
                                  width: 100,
                                  alignment: Alignment.center,
                                  child: SvgPicture.asset(
                                    'assets/images/ic_verify_pancard.svg',
                                    semanticsLabel: 'Verify PAN SVG',
                                  ),
                                ),
                              ),
                        const SizedBox(height: 20),
                        isVerifyPanNumber
                            ? Center(
                                child: Text(
                                  'PAN Verification Complete',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.urbanist(
                                    fontSize: 15,
                                    color: blackSmall,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              )
                            : Center(
                                child: Text(
                                  'Provide your PAN details to verify registered name and active status',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.urbanist(
                                    fontSize: 15,
                                    color: blackSmall,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
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
                                textCapitalization:
                                TextCapitalization.characters,
                                inputFormatter: [
                                  FilteringTextInputFormatter.allow(RegExp((r'[A-Z0-9]'))),
                                  LengthLimitingTextInputFormatter(10)
                                ],
                                onChanged: (text) async {
                                  if (text.length == 10) {
                                    // Make API Call to validate PAN card
                                    setState(() {
                                      isPanProgressDilog = true;
                                    });

                                    await getLeadValidPanCard(context, _panNumberCl.text, productProvider);
                                  } else {
                                    isPanProgressDilog = false;
                                  }
                                }),
                            isVerifyPanNumber
                                ? Positioned(
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
                                          _nameAsPanCl.text = "";
                                          dobAsPan = "";
                                          _dOBAsPanCl.text = "";
                                          documentId = 0;
                                          isPanProgressDilog = false;
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
                                  )
                                : isPanProgressDilog
                                    ? Positioned(
                                        top: 0,
                                        right: 0,
                                        bottom: 0,
                                        child: Container(
                                          // Adjusted to be slightly larger than the indicator
                                          width: 50,
                                          // Adjusted to be slightly larger than the indicator
                                          child: Transform.scale(
                                            scale: 0.4,
                                            // Scale down the CircularProgressIndicator
                                            child: CircularProgressIndicator(
                                              color: kPrimaryColor,
                                            ),
                                          ),
                                        ),
                                      )
                                    : Container(),
                          ],
                        ),
                        const SizedBox(height: 20),
                        CommonTextField(
                          controller: _nameAsPanCl,
                          hintText: "Enter Name",
                          keyboardType: TextInputType.text,
                          enabled: false,
                          inputFormatter: [
                            FilteringTextInputFormatter.allow(
                                RegExp((r'[A-Z]'))),
                          ],
                          labelText: "Name ( As per PAN )",
                          textCapitalization: TextCapitalization.characters,
                        ),
                        const SizedBox(height: 20),
                        CommonTextField(
                          controller: _dOBAsPanCl,
                          hintText: "DD | MM | YYYY",
                          keyboardType: TextInputType.text,
                          enabled: false,
                          labelText: "DOB ( As per PAN )",
                          textCapitalization: TextCapitalization.characters,

                        ),
                        const SizedBox(height: 20),
                        CommonTextField(
                          controller: _fatherNameAsPanCl,
                          hintText: "Enter Father Name",
                          keyboardType: TextInputType.text,
                          enabled: true,
                          inputFormatter: [
                            FilteringTextInputFormatter.allow(
                                RegExp((r'[A-Z ]'))),
                          ],
                          labelText: "Father’s Name ( As per PAN )",
                          textCapitalization: TextCapitalization.characters,

                        ),
                        const SizedBox(height: 20),
                        Stack(
                          children: [
                            Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                        color: const Color(0xff0196CE))),
                                width: double.infinity,
                                child: GestureDetector(

                                  onTap: () {
                                    setState(() {
                                      isDataClear=true;
                                    });

                                   Utils.hideKeyBored(context);
                                    bottomSheetMenu(context);
                                  },
                                  child: Container(
                                    height: 148,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: (image.isNotEmpty)
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
                                                  Text(
                                                    'Upload PAN Image',
                                                    style: GoogleFonts.urbanist(
                                                      fontSize: 12,
                                                      color: kPrimaryColor,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ),
                                                  ),
                                                  Text(
                                                    'Supports : JPEG, PNG',
                                                    style: GoogleFonts.urbanist(
                                                      fontSize: 12,
                                                      color: const Color(
                                                          0xffCACACA),
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ),
                                                  )
                                                ],
                                              ),
                                  ),
                                )),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  isImageDelete = true;
                                  image = "";
                                  isDataClear=true;

                                });
                              },
                              child: image.isNotEmpty
                                  ? Container(
                                      padding: const EdgeInsets.all(4),
                                      alignment: Alignment.topRight,
                                      child: SvgPicture.asset(
                                          'assets/icons/delete_icon.svg'),
                                    )
                                  : Container(),
                            )
                          ],
                        ),
                        const SizedBox(height: 20),
                        CommonCheckBox(
                          onChanged: (bool isChecked) async {
                            if (isChecked) {
                             setState(() {
                               isDataClear=true;
                               _acceptPermissions=true;
                             });
                              Utils.hideKeyBored(context);
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const PermissionsScreen()),
                              );
                              // Handle the result from Screen B using the callback function
                              _handlePermissionsAccepted(result ?? true);
                            }
                          },
                          isChecked: _acceptPermissions,
                          text:
                              "By proceeding, I provide consent on the following",
                          upperCase: false,
                        ),
                        const SizedBox(height: 20),
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'I hereby accept ',
                                style: GoogleFonts.urbanist(
                                  fontSize: 14,
                                  color: blackSmall,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              _buildClickableTextSpan(
                                text: 'T&C  & Privacy Policy',
                                onClick: () async {
                                  Utils.hideKeyBored(context);
                                  setState(() {
                                    isDataClear=true;
                                  });
                                  final result = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            PermissionsScreen()),
                                  );
                                  // Handle the result from Screen B using the callback function
                                  _handlePermissionsAccepted(result ?? true);
                                },
                              ),
                              TextSpan(
                                text:
                                    '. Further, I hereby agree to share my details, including PAN, Date of birth, Name, Pin code, Mobile number, Email id and device information with you and for further sharing with your partners including lending partners.',
                                style: GoogleFonts.urbanist(
                                  fontSize: 14,
                                  color: blackSmall,
                                  fontWeight: FontWeight.w400,
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

                            if (_panNumberCl.text.trim().isEmpty) {
                              Utils.showToast(
                                  "Please Enter Valid Pan Card Details",
                                  context);
                            }
                            /* else if (_nameAsPanCl.text.isEmpty) {
                                  Utils.showToast("Please Enter Name (As Per Pan))",context);
                                } else if (_dOBAsPanCl.text.isEmpty || dobAsPan.isEmpty) {
                                  Utils.showToast("Please Enter Name (As Per Pan))",context);
                                }*/
                            else if (_fatherNameAsPanCl.text.trim().isEmpty) {
                              Utils.showToast(
                                  "Please enter father name!!!", context);
                            } else if (image.isEmpty) {
                              Utils.showToast(
                                  "Upload pan-card image!! ", context);
                            } else if (!_acceptPermissions) {
                              Utils.showToast(
                                  "Please provide consent for T&C & privacy!!!",
                                  context);
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
  }

  @override
  void dispose() {
    _panNumberCl.dispose();
    _nameAsPanCl.dispose();
    _dOBAsPanCl.dispose();
    _fatherNameAsPanCl.dispose();

    myFocusNode;
    super.dispose();
  }

  void bottomSheetMenu(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (builder) {
          return ImagePickerWidgets(onImageSelected: _onImageSelected);
        });
  }

  TextSpan _buildClickableTextSpan({required String text, required VoidCallback onClick}) {
    return TextSpan(
      text: text,
      style: GoogleFonts.urbanist(
        fontSize: 12,
        color: Colors.black, // Set text color to blue for clickable text
        decoration: TextDecoration.underline,
        fontWeight: FontWeight.w900,
      ),
      recognizer: TapGestureRecognizer()..onTap = onClick,
    );
  }

  Future<void> leadPANApi(BuildContext context) async {
    final prefsUtil = await SharedPref.getInstance();
    String? userId = prefsUtil.getString(USER_ID);
    final String? productCode = prefsUtil.getString(PRODUCT_CODE);

    Provider.of<DataProvider>(context, listen: false)
        .getLeadPAN(userId!, productCode!);
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
      leadCurrentActivityAsyncData = await ApiService()
              .leadCurrentActivityAsync(leadCurrentRequestModel, context)
          as LeadCurrentResponseModel?;

      GetLeadResponseModel? getLeadData;
      getLeadData = await ApiService().getLeads(
          prefsUtil.getString(LOGIN_MOBILE_NUMBER)!,
          prefsUtil.getInt(PRODUCT_ID)!,
          prefsUtil.getInt(COMPANY_ID)!,
          prefsUtil.getInt(LEADE_ID)!) as GetLeadResponseModel?;

      customerSequence(
          context, getLeadData, leadCurrentActivityAsyncData, "push");
    } catch (error) {
      if (kDebugMode) {
        print('Error occurred during API call: $error');
      }
    }
  }

  Future<void> getLeadValidPanCard(BuildContext context, String pancardNumber, DataProvider productProvider) async {
    Utils.hideKeyBored(context);

    await Provider.of<DataProvider>(context, listen: false)
        .getLeadValidPanCard(pancardNumber);

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
          Utils.showToast(validPanCardResponsModel.message!, context);
          isPanProgressDilog=false;
          _panNumberCl.clear();
          _nameAsPanCl.clear();
          _dOBAsPanCl.clear();
          _fatherNameAsPanCl.clear();
          setState(() {
            isPanProgressDilog =false;
          });
        }
      }, failure: (exception) {
        if (exception is ApiException) {
          if (exception.statusCode == 401) {
            productProvider.disposeAllProviderData();
            ApiService().handle401(context);
          } else {
            Utils.showToast(exception.errorMessage, context);
          }
        }
      });
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
          fathersNameByValidPanCardResponseModel =
              FathersNameByValidPanCardResponseModel;
          if (fathersNameByValidPanCardResponseModel.dob != null) {
            var formateDob = Utils.dateFormate(
                context, fathersNameByValidPanCardResponseModel.dob);
            dobAsPan = fathersNameByValidPanCardResponseModel.dob;
            _dOBAsPanCl.text = formateDob;
          } else {
            if (fathersNameByValidPanCardResponseModel.message != null) {
              Utils.showToast(
                  fathersNameByValidPanCardResponseModel.message!, context);
            }
          }
        },
        failure: (exception) {
          // Handle failure
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

  Future<void> postLeadPAN(BuildContext context, DataProvider productProvider,
      PostLeadPanRequestModel postLeadPanRequestModel) async {
    Utils.onLoading(context, "");
    await Provider.of<DataProvider>(context, listen: false)
        .postLeadPAN(postLeadPanRequestModel);
    Navigator.of(context, rootNavigator: true).pop();
    if (productProvider.getPostLeadPaneData != null) {
      productProvider.getPostLeadPaneData!.when(
        success: (PostLeadPanResponseModel) {
          // Handle successful response
          postLeadPanResponseModel = PostLeadPanResponseModel;
          if (postLeadPanResponseModel.isSuccess!) {
            fetchData(context);
          }else{
            Utils.showToast(postLeadPanResponseModel.message!, context);
          }
        },
        failure: (exception) {
          // Handle failure
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
}
