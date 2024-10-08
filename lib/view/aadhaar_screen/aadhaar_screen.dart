import 'dart:io';

import 'package:direct_sourcing_agent/utils/loader.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../api/ApiService.dart';
import '../../api/FailureException.dart';
import '../../providers/DataProvider.dart';
import '../../shared_preferences/shared_pref.dart';
import '../../utils/ImagePicker.dart';
import '../../utils/aadhaar_number_formatter.dart';
import '../../utils/common_elevted_button.dart';
import '../../utils/common_text_field.dart';
import '../../utils/constant.dart';
import '../../utils/utils_class.dart';
import 'aadhaar_otp_screen.dart';
import 'components/CheckboxTerm.dart';
import 'models/AadhaaGenerateOTPRequestModel.dart';
import 'models/LeadAadhaarResponse.dart';

class AadhaarScreen extends StatefulWidget {
  final int activityId;
  final int subActivityId;
  final String? pageType;

  const AadhaarScreen(
      {super.key,
      required this.activityId,
      required this.subActivityId,
      this.pageType});

  @override
  State<AadhaarScreen> createState() => _AadhaarScreenState();
}

class _AadhaarScreenState extends State<AadhaarScreen> {
  final TextEditingController _aadhaarController = TextEditingController();
  DataProvider productProvider = DataProvider();
  String frontDocumentId = "";
  String backDocumentId = "";
  String frontFileUrl = "";
  String backFileUrl = "";
  var isFrontImageDelete = false;
  var isBackImageDelete = false;
  bool tcChecked = false;
  var isPanProgressDilog = false;
  var isVerifyAdharNumber = false;
  var isEnabledAdharNumber = true;
  var isFillData = false;
  var isLoading = true;

  void _onFontImageSelected(File imageFile) async {
    isFrontImageDelete = true;
    Utils.onLoading(context, "");
    // Perform asynchronous work first
    await Provider.of<DataProvider>(context, listen: false)
        .PostFrontAadhaarSingleFileData(imageFile, true, "", "");
    Navigator.of(context, rootNavigator: true).pop();
    // Update the widget state synchronously inside setState
  }

  // Callback function to receive the selected image
  void _onBackImageSelected(File imageFile) async {
    isBackImageDelete = true;
    Utils.onLoading(context, "");
    await Provider.of<DataProvider>(context, listen: false)
        .postAadhaarBackSingleFile(imageFile, true, "", "");

    Navigator.of(context, rootNavigator: true).pop();
    // Update the widget state synchronously inside setState
  }

  void bottomSheetMenu(BuildContext context, String frontImage) {
    showModalBottomSheet(
        context: context,
        builder: (builder) {
          // return const ImagePickerWidgets();
          return ImagePickerWidgets(
              onImageSelected: (frontImage == "AADHAAR_FRONT_IMAGE")
                  ? _onFontImageSelected
                  : _onBackImageSelected);
        });
  }

  @override
  Widget build(BuildContext context) {
    LeadAadhaarResponse? leadAadhaarResponse = null;
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
            child: Consumer<DataProvider>(
                builder: (context, productProvider, child) {
              if (productProvider.getLeadAadhaar != null) {
                if (isLoading) {
                  Navigator.of(context, rootNavigator: true).pop();
                }
                isLoading = false;
                productProvider.getLeadAadhaar!.when(
                  success: (LeadAadhaarResponse) async {
                    leadAadhaarResponse = LeadAadhaarResponse;
                    if (leadAadhaarResponse != null && !isFillData) {
                      if (leadAadhaarResponse!.documentNumber != null) {
                        _aadhaarController.text =
                            leadAadhaarResponse!.documentNumber!;
                        isVerifyAdharNumber = true;
                      }

                      if (leadAadhaarResponse!.frontDocumentId != null) {
                        frontDocumentId =
                            leadAadhaarResponse!.frontDocumentId!.toString();
                      }

                      if (leadAadhaarResponse!.backDocumentId != null) {
                        backDocumentId =
                            leadAadhaarResponse!.backDocumentId!.toString();
                      }

                      if (leadAadhaarResponse!.frontImageUrl != null &&
                          !isFrontImageDelete) {
                        frontFileUrl =
                            leadAadhaarResponse!.frontImageUrl!.toString();
                      }

                      if (leadAadhaarResponse!.backImageUrl != null &&
                          !isBackImageDelete) {
                        backFileUrl =
                            leadAadhaarResponse!.backImageUrl!.toString();
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

                if (productProvider.getPostFrontAadhaarSingleFileData != null &&
                    isFrontImageDelete) {
                  if (productProvider
                          .getPostFrontAadhaarSingleFileData!.filePath !=
                      null) {
                    frontFileUrl = productProvider
                        .getPostFrontAadhaarSingleFileData!.filePath!;
                    frontDocumentId = productProvider
                        .getPostFrontAadhaarSingleFileData!.docId!
                        .toString();
                  }
                }
                if (productProvider.getPostBackAadhaarSingleFileData != null &&
                    isBackImageDelete) {
                  if (productProvider
                          .getPostBackAadhaarSingleFileData!.filePath !=
                      null) {
                    backFileUrl = productProvider
                        .getPostBackAadhaarSingleFileData!.filePath!;
                    backDocumentId = productProvider
                        .getPostBackAadhaarSingleFileData!.docId!
                        .toString();
                  }
                }
                return SingleChildScrollView(
                    child: Padding(
                  padding: const EdgeInsets.only(left: 30, right: 30, top: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Aadhaar Verification',
                        textAlign: TextAlign.start,
                        style: GoogleFonts.urbanist(
                          fontSize: 16,
                          color: blackSmall,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 20),
                      isVerifyAdharNumber
                          ? Container(
                              height: 100,
                              width: 100,
                              alignment: Alignment.center,
                              child: SvgPicture.asset(
                                'assets/images/ic_verified_pancard.svg',
                                semanticsLabel: 'Verify PAN SVG',
                              ),
                            )
                          : Container(
                              height: 100,
                              width: 100,
                              alignment: Alignment.center,
                              child: SvgPicture.asset(
                                'assets/images/ic_verify_pancard.svg',
                                semanticsLabel: 'Verify PAN SVG',
                              ),
                            ),
                      const SizedBox(height: 20),
                      Text(
                        'Provide your Aadhaar details to verify registered name and active status',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.urbanist(
                          fontSize: 15,
                          color: blackSmall,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(height: 30),
                      Stack(
                        children: [
                          CommonTextField(
                              controller: _aadhaarController,
                              hintText: "XXXX XXXX XXXX",
                              textInputAction: TextInputAction.done,
                              keyboardType: TextInputType.number,
                              labelText: "Aadhaar Card Number",
                              textCapitalization: TextCapitalization.characters,
                              inputFormatter: [
                                FilteringTextInputFormatter.digitsOnly,
                                AadhaarNumberFormatter(),
                              ],
                              onChanged: (text) async {
                                print("Text${text.length}");
                                if (text.length == 14) {
                                  setState(() {
                                    isVerifyAdharNumber = true;
                                    //isFillData=false;
                                  });
                                } else {
                                  setState(() {
                                    print("Text${text.length}");
                                    isVerifyAdharNumber = false;
                                    isFillData = true;
                                  });
                                }
                              }),
                          isVerifyAdharNumber
                              ? Positioned(
                                  top: 0,
                                  right: 0,
                                  bottom: 0,
                                  child: GestureDetector(
                                    onTap: () {
                                      // print('Edit icon tapped');
                                      setState(() {});
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
                                      child: SizedBox(
                                        // Adjusted to be slightly larger than the indicator
                                        width: 50,
                                        // Adjusted to be slightly larger than the indicator
                                        child: Transform.scale(
                                          scale: 0.4,
                                          // Scale down the CircularProgressIndicator
                                          child: const CircularProgressIndicator(
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ),
                                    )
                                  : Container(),
                        ],
                      ),
                      const SizedBox(height: 26),
                      Container(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [kPrimaryColor, kPrimaryColor],
                          ),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        height: 148,
                        child: Stack(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(1),
                              child: InkWell(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: textFiledBackgroundColour,
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  child: (frontFileUrl.isNotEmpty)
                                      ? ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                          child: Image.network(
                                            frontFileUrl,
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
                                            Center(
                                                child: SvgPicture.asset(
                                                    "assets/icons/gallery.svg",
                                                    colorFilter:
                                                        const ColorFilter.mode(
                                                            kPrimaryColor,
                                                            BlendMode.srcIn))),
                                             Text(
                                              'Upload Aadhaar Front Image',
                                              style: GoogleFonts.urbanist(
                                                fontSize: 12,
                                                color: kPrimaryColor,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                             Text(
                                              'Supports : JPEG, PNG',
                                              style: GoogleFonts.urbanist(
                                                fontSize: 12,
                                                color: blackSmall,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ],
                                        ),
                                ),
                                onTap: () {
                                  Utils.hideKeyBored(context);
                                  bottomSheetMenu(
                                      context, "AADHAAR_FRONT_IMAGE");
                                },
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  isFrontImageDelete = true;
                                  frontFileUrl = "";
                                  productProvider.disposeFrontAadhaarSingleFileData();
                                });
                              },
                              child: frontFileUrl.isNotEmpty
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
                      ),
                      const SizedBox(height: 16),
                      Stack(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [kPrimaryColor, kPrimaryColor],
                              ),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            height: 148,
                            child: Padding(
                              padding: const EdgeInsets.all(1),
                              child: InkWell(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: textFiledBackgroundColour,
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  child: (backFileUrl.isNotEmpty)
                                      ? ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                          child: Image.network(
                                            backFileUrl,
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
                                            Center(
                                                child: SvgPicture.asset(
                                                    "assets/icons/gallery.svg",
                                                    colorFilter:
                                                        const ColorFilter.mode(
                                                            kPrimaryColor,
                                                            BlendMode.srcIn))),
                                             Text(
                                              'Upload Aadhar Back Image',
                                              style: GoogleFonts.urbanist(
                                                fontSize: 12,
                                                color: kPrimaryColor,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                             Text(
                                              'Supports : JPEG, PNG',
                                              style: GoogleFonts.urbanist(
                                                fontSize: 12,
                                                color: blackSmall,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ],
                                        ),
                                ),
                                onTap: () {
                                  Utils.hideKeyBored(context);
                                  bottomSheetMenu(
                                      context, "AADHAAR_BACK_IMAGE");
                                },
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                isBackImageDelete = true;
                                backFileUrl = "";
                                productProvider.disposeBackAadhaarSingleFileData();
                              });
                            },
                            child: !backFileUrl.isEmpty
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
                      const SizedBox(height: 46),
                      CommonElevatedButton(
                        onPressed: () {
                          //validate data
                          if (productProvider
                                  .getPostFrontAadhaarSingleFileData !=
                              null) {
                            if (productProvider
                                    .getPostFrontAadhaarSingleFileData!
                                    .filePath !=
                                null) {
                              frontFileUrl = productProvider
                                  .getPostFrontAadhaarSingleFileData!.filePath!;
                              frontDocumentId = productProvider
                                  .getPostFrontAadhaarSingleFileData!.docId!
                                  .toString();
                            }
                          }
                          if (productProvider
                                  .getPostBackAadhaarSingleFileData !=
                              null) {
                            if (productProvider
                                    .getPostBackAadhaarSingleFileData!
                                    .filePath !=
                                null) {
                              backFileUrl = productProvider
                                  .getPostBackAadhaarSingleFileData!.filePath!;
                              backDocumentId = productProvider
                                  .getPostBackAadhaarSingleFileData!.docId!
                                  .toString();
                            }
                          }

                          //call api
                          if (_aadhaarController.text.trim() == "") {
                            Utils.showToast(
                                "Please Enter Aadhaar Number", context);
                          } else if (!isVerifyAdharNumber) {
                            Utils.showToast(
                                "Please Enter valid Aadhaar Number", context);
                          } else if (frontFileUrl == "" ||
                              frontDocumentId == "") {
                            Utils.showToast(
                                "Please select Aadhaar Front Image", context);
                          } else if (backFileUrl == "" ||
                              backDocumentId == "") {
                            Utils.showToast(
                                "Please select Aadhaar Back Image", context);
                          } else {
                            String stringWithSpaces = _aadhaarController.text;
                            String stringWithoutSpaces =
                                stringWithSpaces.replaceAll(RegExp(r'\s+'), '');
                            generateAadhaarOTPAPI(
                                context,
                                productProvider,
                                stringWithoutSpaces,
                                frontFileUrl,
                                frontDocumentId,
                                backFileUrl,
                                backDocumentId);
                          }
                        },
                        text: 'NEXT',
                        upperCase: true,
                      ),
                      const SizedBox(height: 50),
                    ],
                  ),
                ));
              } else {
                return const Center(
                  child: Loader(),
                );
              }
            }),
          )),
    );
  }

  @override
  void initState() {
    super.initState();

    getAadhaarData(context);
  }

  @override
  void dispose() {
    _aadhaarController.dispose();
    super.dispose();
  }

  void generateAadhaarOTPAPI(
      BuildContext context,
      DataProvider productProvider,
      String documentNumber,
      String fFileUrl,
      String fDocumentId,
      String bFileUrl,
      String bDocumentId) async {
    var request = AadhaarGenerateOTPRequestModel(
        DocumentNumber: documentNumber,
        FrontFileUrl: fFileUrl,
        BackFileUrl: bFileUrl,
        FrontDocumentId: fDocumentId,
        BackDocumentId: bDocumentId,
        otp: "",
        requestId: "");

    Utils.onLoading(context, "");

    await Provider.of<DataProvider>(context, listen: false)
        .leadAadharGenerateOTP(request);

    Navigator.of(context, rootNavigator: true).pop();

    if (productProvider.getLeadAadharGenerateOTP != null) {
      productProvider.getLeadAadharGenerateOTP!.when(
        success: (AadhaarGenerateOTPResponseModel) async {
          var leadAadhaarResponse = AadhaarGenerateOTPResponseModel;
          if (leadAadhaarResponse != null && leadAadhaarResponse.data != null) {
            String reqID = "";
            if (leadAadhaarResponse.data!.message != null) {
              print(leadAadhaarResponse.data!.message!);
            }
            reqID = leadAadhaarResponse.requestId!;
            productProvider.disposeAllSingleFileData();
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AadhaarOtpScreen(
                        activityId: widget.activityId,
                        subActivityId: widget.subActivityId,
                        document: request,
                        requestId: reqID)));
          } else {
            Utils.showToast(
                leadAadhaarResponse.error!.error!.message!, context);
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

  Future<void> getAadhaarData(BuildContext context) async {
    final prefsUtil = await SharedPref.getInstance();
    final String? userId = prefsUtil.getString(USER_ID);
    final String? productCode = prefsUtil.getString(PRODUCT_CODE);

    Provider.of<DataProvider>(context, listen: false)
        .getLeadAadhar(userId!, productCode!);
  }
}
