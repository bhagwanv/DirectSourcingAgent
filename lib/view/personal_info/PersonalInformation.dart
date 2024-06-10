import 'dart:io';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import '../../api/ApiService.dart';
import '../../api/FailureException.dart';
import '../../providers/DataProvider.dart';
import '../../shared_preferences/shared_pref.dart';
import '../../utils/ImagePicker.dart';
import '../../utils/common_check_box.dart';
import '../../utils/common_elevted_button.dart';
import '../../utils/constant.dart';
import '../../utils/customer_sequence_logic.dart';
import '../../utils/utils_class.dart';
import '../login_screen/login_screen.dart';
import '../splash/model/GetLeadResponseModel.dart';
import '../splash/model/LeadCurrentRequestModel.dart';
import '../splash/model/LeadCurrentResponseModel.dart';
import 'EmailOtpScreen.dart';
import 'model/CityResponce.dart';
import 'model/ElectricityAuthenticationReqModel.dart';
import 'model/ElectricityServiceProviderListResModel.dart';
import 'model/ElectricityStateResModel.dart';
import 'model/EmailExistRespoce.dart';
import 'model/PersonalDetailsRequestModel.dart';
import 'model/PersonalDetailsResponce.dart';
import 'model/ReturnObject.dart';
import 'model/SendOtpOnEmailResponce.dart';

class PersonalInformation extends StatefulWidget {
  int? activityId;
  int? subActivityId;
  String image = "";
  final String? pageType;

  PersonalInformation(
      {required this.activityId,
        required this.subActivityId,
        this.pageType,
        super.key});

  @override
  State<PersonalInformation> createState() => _PersonalInformationState();
}

class _PersonalInformationState extends State<PersonalInformation> {
  //basic details
  final TextEditingController _firstNameCl = TextEditingController();
  final TextEditingController _middleNameCl = TextEditingController();
  final TextEditingController _lastNameCl = TextEditingController();
  final TextEditingController _genderCl = TextEditingController();
  final TextEditingController _emailIDCl = TextEditingController();
  final TextEditingController _alternatePhoneNumberCl = TextEditingController();
  final TextEditingController _countryCl = TextEditingController();
  final TextEditingController _customerIvrsCl = TextEditingController();
  final TextEditingController _electryCityServiceCl = TextEditingController();
  final TextEditingController _electryDistrictCl = TextEditingController();
  String? selectedGenderValue;
  String? selectedMaritalStatusValue;
  final List<String> genderList = [
    'Male',
    'Female',
  ];
  final List<String> maritalList = [
    'Married',
    'Single',
    'Others',
    'Divorced',
    'Widow',
  ];

  //permanent Address
  final TextEditingController _permanentStateNameCl = TextEditingController();
  final TextEditingController _permanentCityNameCl = TextEditingController();
  final TextEditingController _permanentAddressPinCodeCl =
  TextEditingController();
  final TextEditingController _permanentAddresslineOneCl =
  TextEditingController();
  final TextEditingController _permanentAddresslineTwoCl =
  TextEditingController();
  List<CityResponce?> permanentCitylist = [];

  //current Address
  final TextEditingController _currentAddressLineOneCl =
  TextEditingController();
  final TextEditingController _currentAddressLineTwoCl =
  TextEditingController();
  final TextEditingController _currentAddressPinCodeCl =
  TextEditingController();
  List<CityResponce?> citylist = [];
  ReturnObject? selectedCurrentState;
  CityResponce? selectedCurrentCity;
  int? billDocId;

  //ownership type
  String? selectedOwnershipTypeValue = "";
  final List<String> ownershipTypeList = [
    'Owned',
    'Owned by parents',
    'Owned by Spouse',
    'Rented',
  ];
  bool selectedOwnershipEditable = false;

  String? selectOwnershipProofValue;
  final List<String> ownershipProofList = [
    'Electricity Manual Bill Upload',
    'Digital Bill Verification'
  ];

  ElectricityServiceProviderListResModel? selectServiceProviderValue;
  String? selectServiceProviderCode = "";
  String? selectedStateValue = "";
  List<ElectricityServiceProviderListResModel> selectServiceProviderList = [];

  ElectricityStateResModel? selectDistrictValue;

  List<ElectricityStateResModel> selectDistrictList = [];

  bool ischeckCurrentAdress = true;
  var isLoading = true;
  late int selectedStateID;
  var stateId = 0;
  var isEmailClear = false;
  var isValidEmail = false;
  var cityCallInitial = true;
  var isCurrentAddSame = false;
  var updateData = false;
  PersonalDetailsResponce? personalDetailsResponce = null;
  var isImageDelete = false;

  var customerName = "";
  var customerAddress = "";
  var consumerNumber = "";
  var electricityServiceProvider = "";
  var electricityState = "";
  var isCustomerName = false;
  var isOwnerShipProofEditable = false;
  var isElectriCityDistrictEdit = false;
  var isElectriCityServiceEdit = false;

  @override
  void initState() {
    super.initState();
    getPersonalDetailAndStateApi(context);
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
        body: SafeArea(
          child: Consumer<DataProvider>(
              builder: (context, productProvider, child) {
                if (productProvider.getPersonalDetailsData == null && isLoading) {
                  return Center(child: Utils.onLoading(context, ""));
                } else {
                  if (productProvider.getPersonalDetailsData != null && isLoading) {
                    Navigator.of(context, rootNavigator: true).pop();
                    isLoading = false;
                  }

                  if (!updateData) {
                    _countryCl.text = "India";

                    if (productProvider.getPersonalDetailsData != null) {
                      productProvider.getPersonalDetailsData!.when(
                        success: (PersonalDetailsResponce) async {
                          personalDetailsResponce = PersonalDetailsResponce;
                          if (personalDetailsResponce != null) {
                            _firstNameCl.text = personalDetailsResponce!.firstName!;
                            if (personalDetailsResponce!.middleName != null) {
                              _middleNameCl.text =
                              personalDetailsResponce!.middleName!;
                            }
                            _lastNameCl.text = personalDetailsResponce!.lastName!;

                            if (personalDetailsResponce!.emailId!.isNotEmpty &&
                                !isValidEmail &&
                                !isEmailClear) {
                              isValidEmail = true;
                              _emailIDCl.text = personalDetailsResponce!.emailId!;
                            }

                            if (personalDetailsResponce!.alternatePhoneNo != null) {
                              _alternatePhoneNumberCl.text =
                              personalDetailsResponce!.alternatePhoneNo!;
                            }

                            if (personalDetailsResponce!
                                .manulaElectrictyBillImage !=
                                null &&
                                !isImageDelete) {
                              widget.image = personalDetailsResponce!
                                  .manulaElectrictyBillImage!;
                            }

                            if (personalDetailsResponce!.gender == "Male" ||
                                personalDetailsResponce!.gender == "M") {
                              _genderCl.text = "Male";
                            } else if (personalDetailsResponce!.gender ==
                                "Female" ||
                                personalDetailsResponce!.gender == "F") {
                              _genderCl.text = "Female";
                            } else {
                              _genderCl.text = "Other";
                            }

                            if (personalDetailsResponce!.marital != null) {
                              if (personalDetailsResponce!.marital!.isNotEmpty) {
                                if (personalDetailsResponce!.marital == "Married") {
                                  selectedMaritalStatusValue = "Married";
                                } else if (personalDetailsResponce!.marital ==
                                    "Single") {
                                  selectedMaritalStatusValue = "Single";
                                } else if (personalDetailsResponce!.marital ==
                                    "Others") {
                                  selectedMaritalStatusValue = "Others";
                                } else if (personalDetailsResponce!.marital ==
                                    "Divorced") {
                                  selectedMaritalStatusValue = "Divorced";
                                } else if (personalDetailsResponce!.marital ==
                                    "Widow") {
                                  selectedMaritalStatusValue = "Widow";
                                }
                              }
                            }

                            if (personalDetailsResponce!.ownershipType != null) {
                              if (personalDetailsResponce!
                                  .ownershipType!.isNotEmpty &&
                                  !selectedOwnershipEditable) {
                                if (personalDetailsResponce!.ownershipType ==
                                    "Owned") {
                                  selectedOwnershipTypeValue = "Owned";
                                } else if (personalDetailsResponce!.ownershipType ==
                                    "Owned by parents") {
                                  selectedOwnershipTypeValue = "Owned by parents";
                                } else if (personalDetailsResponce!.ownershipType ==
                                    "Owned by Spouse") {
                                  selectedOwnershipTypeValue = "Owned by Spouse";
                                } else {
                                  selectedOwnershipTypeValue = "Rented";
                                }
                              }
                            }

                            if (personalDetailsResponce!.ownershipTypeProof !=
                                null) {
                              if (personalDetailsResponce!
                                  .ownershipTypeProof!.isNotEmpty &&
                                  !isOwnerShipProofEditable) {
                                if (personalDetailsResponce!.ownershipTypeProof ==
                                    "Electricity Manual Bill Upload") {
                                  selectOwnershipProofValue =
                                  "Electricity Manual Bill Upload";
                                } else {
                                  selectOwnershipProofValue =
                                  "Digital Bill Verification";
                                }
                              }
                            }

                            //set permanent Address
                            if (personalDetailsResponce!
                                .permanentAddressLine1!.isNotEmpty) {
                              _permanentAddresslineOneCl.text =
                              personalDetailsResponce!.permanentAddressLine1!;
                            }

                            if (personalDetailsResponce!
                                .permanentAddressLine2!.isNotEmpty) {
                              _permanentAddresslineTwoCl.text =
                              personalDetailsResponce!.permanentAddressLine2!;
                            }

                            if (personalDetailsResponce!.permanentPincode != null) {
                              _permanentAddressPinCodeCl.text =
                                  personalDetailsResponce!.permanentPincode!
                                      .toString();
                            }

                            if (personalDetailsResponce!.permanentAddressLine1 ==
                                personalDetailsResponce!.resAddress1 &&
                                personalDetailsResponce!.permanentAddressLine2 ==
                                    personalDetailsResponce!.resAddress2) {
                              isCurrentAddSame = true;
                            }

                            //set Current Address
                            if (personalDetailsResponce!.resAddress1!.isNotEmpty) {
                              _currentAddressLineOneCl.text =
                              personalDetailsResponce!.resAddress1!;
                            }
                            if (personalDetailsResponce!.resAddress2!.isNotEmpty) {
                              _currentAddressLineTwoCl.text =
                              personalDetailsResponce!.resAddress2!;
                            }
                            if (personalDetailsResponce!.pincode != null) {
                              _currentAddressPinCodeCl.text =
                                  personalDetailsResponce!.pincode!.toString();
                            }

                            if (personalDetailsResponce!.state != null) {
                              stateId = personalDetailsResponce!.state!;
                            }

                            if (personalDetailsResponce!
                                .electricityBillDocumentId !=
                                null) {
                              billDocId = personalDetailsResponce!
                                  .electricityBillDocumentId!;
                            }
                            if (productProvider.getAllCityData != null) {
                              permanentCitylist = productProvider.getAllCityData!;
                            }

                            if (productProvider.getCurrentAllCityData != null) {
                              citylist = productProvider.getCurrentAllCityData!;
                            }

                            //set Digital veryFication Ivrs number
                            if (personalDetailsResponce!.ivrsNumber != null &&
                                !isOwnerShipProofEditable) {
                              consumerNumber = personalDetailsResponce!.ivrsNumber;
                              _customerIvrsCl.text =
                                  personalDetailsResponce!.ivrsNumber;
                              if (personalDetailsResponce!
                                  .electricityServiceProvider !=
                                  null &&
                                  !isOwnerShipProofEditable) {
                                electricityServiceProvider =
                                personalDetailsResponce!
                                    .electricityServiceProvider!;
                                _electryCityServiceCl.text =
                                personalDetailsResponce!
                                    .electricityServiceProvider!;
                                isElectriCityServiceEdit = false;
                              }
                              if (personalDetailsResponce!.electricityState !=
                                  null &&
                                  !isOwnerShipProofEditable) {
                                electricityState =
                                personalDetailsResponce!.electricityState!;
                                _electryDistrictCl.text =
                                personalDetailsResponce!.electricityState!;
                                isElectriCityDistrictEdit = false;
                              }
                              isOwnerShipProofEditable = true;
                              getIvrsNumberExist(
                                context,
                                productProvider,
                                _customerIvrsCl,
                              );
                            }
                          } else {
                            if (!isEmailClear && !isValidEmail) {
                              _emailIDCl.text = personalDetailsResponce!.emailId!;
                            } else if (!isValidEmail) {
                              _emailIDCl.clear();
                            }

                            if (productProvider.getAllCityData != null) {
                              permanentCitylist = productProvider.getAllCityData!;
                            }

                            if (productProvider.getCurrentAllCityData != null) {
                              citylist = productProvider.getCurrentAllCityData!;
                            }
                            if (citylist.isNotEmpty) {
                              selectedCurrentCity = citylist.first;
                              print("dsds" + selectedCurrentCity!.name!);
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
                  }
                  if (productProvider
                      .getpostElectricityBillDocumentSingleFileData !=
                      null &&
                      !isImageDelete) {
                    billDocId = productProvider
                        .getpostElectricityBillDocumentSingleFileData!.docId!;
                    widget.image = productProvider
                        .getpostElectricityBillDocumentSingleFileData!.filePath!;
                  }
                  return SingleChildScrollView(
                      child: Padding(
                        padding:
                        const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(height: 50),
                            const Text(
                              'Personal Information',
                              textAlign: TextAlign.start,
                              style: TextStyle(fontSize: 35, color: Colors.black),
                            ),
                            const SizedBox(height: 15),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 20, horizontal: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  basicDetailsFields(productProvider),
                                  const SizedBox(height: 20),
                                  permanentAddressField(productProvider),
                                  currentAddressFields(productProvider),
                                  const SizedBox(height: 15),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 4.0),
                                    child: Text(
                                      "Ownership Type",
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  DropdownButtonFormField2<String>(
                                    isExpanded: true,
                                    decoration: InputDecoration(
                                      contentPadding:
                                      const EdgeInsets.symmetric(vertical: 16),
                                      fillColor: textFiledBackgroundColour,
                                      filled: true,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: const BorderSide(
                                            color: kPrimaryColor, width: 1),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: const BorderSide(
                                            color: kPrimaryColor, width: 1),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: const BorderSide(
                                            color: kPrimaryColor, width: 1),
                                      ),
                                    ),
                                    hint: const Text(
                                      'Ownership Type',
                                      style: TextStyle(
                                        color: blueColor,
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    items: getDropDownOption(ownershipTypeList),
                                    value: selectedOwnershipTypeValue!.isNotEmpty
                                        ? selectedOwnershipTypeValue
                                        : null,
                                    onChanged: (String? value) {
                                      setState(() {
                                        selectedOwnershipEditable = true;
                                        selectedOwnershipTypeValue = value;
                                      });
                                    },
                                    buttonStyleData: const ButtonStyleData(
                                      padding: EdgeInsets.only(right: 8),
                                    ),
                                    dropdownStyleData: const DropdownStyleData(
                                      maxHeight: 200,
                                    ),
                                    menuItemStyleData: MenuItemStyleData(
                                      padding:
                                      const EdgeInsets.symmetric(horizontal: 8.0),
                                      customHeights:
                                      _getCustomItemsHeights(ownershipTypeList),
                                    ),
                                    iconStyleData: const IconStyleData(
                                      openMenuIcon: Icon(Icons.arrow_drop_up),
                                    ),
                                  ),
                                  const SizedBox(height: 15),
                                  (selectedOwnershipTypeValue!.isNotEmpty &&
                                      selectedOwnershipTypeValue == "Rented")
                                      ? Container()
                                      : Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(left: 4.0),
                                        child: Text(
                                          "Ownership Proof",
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                      ),
                                      SizedBox(height: 8),
                                      DropdownButtonFormField2<String>(
                                        isExpanded: true,
                                        decoration: InputDecoration(
                                          contentPadding:
                                          const EdgeInsets.symmetric(
                                              vertical: 16),
                                          fillColor: textFiledBackgroundColour,
                                          filled: true,
                                          border: OutlineInputBorder(
                                            borderRadius:
                                            BorderRadius.circular(10),
                                            borderSide: const BorderSide(
                                                color: kPrimaryColor, width: 1),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                            BorderRadius.circular(10),
                                            borderSide: const BorderSide(
                                                color: kPrimaryColor, width: 1),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                            BorderRadius.circular(10),
                                            borderSide: BorderSide(
                                                color: kPrimaryColor, width: 1),
                                          ),
                                        ),
                                        hint: const Text(
                                          'Select Ownership Proof',
                                          style: TextStyle(
                                            color: blueColor,
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        items:
                                        getDropDownOption(ownershipProofList),
                                        value: selectOwnershipProofValue,
                                        onChanged: (String? value) async {
                                          setState(() {
                                            selectOwnershipProofValue = value;
                                            isOwnerShipProofEditable = true;
                                            if (selectOwnershipProofValue ==
                                                "Digital Bill Verification") {
                                              customerName = "";
                                              customerAddress = "";
                                              electricityServiceProvider = "";
                                              _customerIvrsCl.text = "";
                                              electricityState = "";
                                              selectDistrictList.clear();
                                              selectServiceProviderList.clear();
                                              isElectriCityDistrictEdit = true;
                                              isElectriCityServiceEdit = true;
                                            }
                                          });
                                        },
                                        buttonStyleData: const ButtonStyleData(
                                          padding: EdgeInsets.only(right: 8),
                                        ),
                                        dropdownStyleData:
                                        const DropdownStyleData(
                                          maxHeight: 200,
                                        ),
                                        menuItemStyleData: MenuItemStyleData(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8.0),
                                          customHeights: _getCustomItemsHeights(
                                              ownershipProofList),
                                        ),
                                        iconStyleData: const IconStyleData(
                                          openMenuIcon: Icon(Icons.arrow_drop_up),
                                        ),
                                      ),
                                      const SizedBox(height: 15),
                                      selectOwnershipProofValue ==
                                          "Digital Bill Verification"
                                          ? digitalBillFields(productProvider)
                                          : selectOwnershipProofValue ==
                                          "Electricity Manual Bill Upload"
                                          ? Stack(
                                        children: [
                                          Container(
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                  BorderRadius
                                                      .circular(10),
                                                  border: Border.all(
                                                      color: Color(
                                                          0xff0196CE))),
                                              width: double.infinity,
                                              child: GestureDetector(
                                                onTap: () {
                                                  bottomSheetMenu(
                                                      context);
                                                },
                                                child: Container(
                                                  height: 148,
                                                  width:
                                                  double.infinity,
                                                  decoration:
                                                  BoxDecoration(
                                                    color: Color(
                                                        0xffEFFAFF),
                                                    borderRadius:
                                                    BorderRadius
                                                        .circular(
                                                        10),
                                                  ),
                                                  child: (widget.image
                                                      .isNotEmpty)
                                                      ? ClipRRect(
                                                    borderRadius:
                                                    BorderRadius
                                                        .circular(
                                                        8.0),
                                                    child: Image
                                                        .network(
                                                      widget
                                                          .image,
                                                      fit: BoxFit
                                                          .cover,
                                                      width: double
                                                          .infinity,
                                                      height: 148,
                                                    ),
                                                  )
                                                      : (widget.image
                                                      .isNotEmpty)
                                                      ? ClipRRect(
                                                    borderRadius:
                                                    BorderRadius.circular(
                                                        8.0),
                                                    child: Image
                                                        .network(
                                                      widget
                                                          .image,
                                                      fit: BoxFit
                                                          .cover,
                                                      width: double
                                                          .infinity,
                                                      height:
                                                      148,
                                                    ),
                                                  )
                                                      : Column(
                                                    crossAxisAlignment:
                                                    CrossAxisAlignment
                                                        .center,
                                                    mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .center,
                                                    children: [
                                                      SvgPicture.asset(
                                                          'assets/images/gallery.svg'),
                                                      const Text(
                                                        'Upload Electry City Bill Image',
                                                        style: TextStyle(
                                                            color: Color(0xff0196CE),
                                                            fontSize: 12),
                                                      ),
                                                      const Text(
                                                          'Supports : JPEG, PNG',
                                                          style:
                                                          TextStyle(fontSize: 12, color: Color(0xffCACACA))),
                                                    ],
                                                  ),
                                                ),
                                              )),
                                          GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                isImageDelete = true;
                                                widget.image = "";
                                              });
                                            },
                                            child: widget
                                                .image.isNotEmpty
                                                ? Container(
                                              padding:
                                              EdgeInsets.all(
                                                  4),
                                              alignment: Alignment
                                                  .topRight,
                                              child: SvgPicture.asset(
                                                  'assets/icons/delete_icon.svg'),
                                            )
                                                : Container(),
                                          )
                                        ],
                                      )
                                          : Container(),
                                    ],
                                  ),
                                  const SizedBox(height: 50),
                                  CommonElevatedButton(
                                    onPressed: () async {
                                      ValidationResult result = await validateData(context, productProvider);
                                      PersonalDetailsRequestModel postData = result.postData;
                                      bool isValid = result.isValid;
                                      print("wqwwewew" + postData.toJson().toString());
                                      if (isValid) {
                                        submitPersonalInformationApi(
                                            context, productProvider, postData);
                                      } else {
                                        print("unValid");
                                      }
                                    },
                                    text: "NEXT",
                                    upperCase: true,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ));
                }
              }),
        ),
      ),
    );
  }

  void submitPersonalInformationApi(
      BuildContext context,
      DataProvider productProvider,
      PersonalDetailsRequestModel postData) async {
    Utils.onLoading(context, "");
    await productProvider.postLeadPersonalDetail(postData, context);
    if (productProvider.getPostPersonalDetailsResponseModel?.statusCode !=
        401) {
      if (productProvider.getPostPersonalDetailsResponseModel != null) {
        Navigator.of(context, rootNavigator: true).pop();
        if (productProvider.getPostPersonalDetailsResponseModel!.isSuccess!) {
          if (productProvider.getPostPersonalDetailsResponseModel!.message !=
              null) {}
          fetchData(context);
        }
      } else {
        Navigator.of(context, rootNavigator: true).pop();
      }
    } else {
      Navigator.pushAndRemoveUntil<dynamic>(
        context,
        MaterialPageRoute<dynamic>(
          builder: (BuildContext context) =>
              LoginScreen(),
        ),
            (route) => false, //if you want to disable back feature set to false
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
      await ApiService().leadCurrentActivityAsync(leadCurrentRequestModel, context)
      as LeadCurrentResponseModel?;

      GetLeadResponseModel? getLeadData;
      getLeadData = await ApiService().getLeads(
          prefsUtil.getString(LOGIN_MOBILE_NUMBER)!,
          prefsUtil.getInt(COMPANY_ID)!,
          prefsUtil.getInt(PRODUCT_ID)!,
          prefsUtil.getInt(LEADE_ID)!) as GetLeadResponseModel?;

      customerSequence(
          context, getLeadData, leadCurrentActivityAsyncData, "push");
    } catch (error) {
      if (kDebugMode) {
        print('Error occurred during API call: $error');
      }
    }
  }

  void callSendOptEmail(BuildContext context, String emailID) async {
    updateData = true;
    SendOtpOnEmailResponce data;
    data = await ApiService().sendOtpOnEmail(emailID);
    Navigator.of(context, rootNavigator: true).pop();
    if (data != null && data.status!) {
      final result = await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => EmailOtpScreen(
                emailID: emailID,
              )));

      if (result != null &&
          result.containsKey('isValid') &&
          result.containsKey('Email')) {
        setState(() {
          isValidEmail = result['isValid'];
          _emailIDCl.text = result['Email'];
        });
      } else {
        print('Result is null or does not contain expected keys');
      }
    } else {
      Utils.showToast(data.message!, context);
    }
  }

  void callEmailIDExist(BuildContext context, String emailID) async {
    Utils.onLoading(context, "");
    final prefsUtil = await SharedPref.getInstance();
    final String? userId = prefsUtil.getString(USER_ID);
    EmailExistRespoce data;
    data = await ApiService().emailExist(userId!, emailID) as EmailExistRespoce;
    if (data.isSuccess!) {
      Utils.showToast(data.message!, context);
      Navigator.of(context, rootNavigator: true).pop();
    } else {
      callSendOptEmail(context, _emailIDCl.text);
    }
  }

  List<DropdownMenuItem<String>> getDropDownOption(List<String> items) {
    final List<DropdownMenuItem<String>> menuItems = [];
    for (final String item in items) {
      menuItems.addAll(
        [
          DropdownMenuItem<String>(
            value: item,
            child: Text(
              item,
              style: const TextStyle(
                fontSize: 14,
              ),
            ),
          ),
          //If it's last item, we will not add Divider after it.
          if (item != items.last)
            const DropdownMenuItem<String>(
              enabled: false,
              child: Divider(
                height: 0.1,
              ),
            ),
        ],
      );
    }
    return menuItems;
  }

  List<DropdownMenuItem<ElectricityServiceProviderListResModel>>
  getDropDownOptionServiceList(
      List<ElectricityServiceProviderListResModel?> items) {
    final List<DropdownMenuItem<ElectricityServiceProviderListResModel>>
    menuItems = [];
    for (final ElectricityServiceProviderListResModel? item in items) {
      menuItems.addAll(
        [
          DropdownMenuItem<ElectricityServiceProviderListResModel>(
            value: item,
            child: Text(
              item!.serviceProvider!,
              // Assuming 'name' is the property to display
              style: const TextStyle(
                fontSize: 14,
              ),
            ),
          ),
          // If it's not the last item, add Divider after it.
          if (item != items.last)
            const DropdownMenuItem<ElectricityServiceProviderListResModel>(
              enabled: false,
              child: Divider(
                height: 0.1,
              ),
            ),
        ],
      );
    }
    return menuItems;
  }

  List<DropdownMenuItem<ElectricityStateResModel>> getDropDownOptionDisticList(
      List<ElectricityStateResModel?> items) {
    final List<DropdownMenuItem<ElectricityStateResModel>> menuItems = [];
    for (final ElectricityStateResModel? item in items) {
      menuItems.addAll(
        [
          DropdownMenuItem<ElectricityStateResModel>(
            value: item,
            child: Text(
              item!.districtName!, // Assuming 'name' is the property to display
              style: const TextStyle(
                fontSize: 14,
              ),
            ),
          ),
          // If it's not the last item, add Divider after it.
          if (item != items.last)
            const DropdownMenuItem<ElectricityStateResModel>(
              enabled: false,
              child: Divider(
                height: 0.1,
              ),
            ),
        ],
      );
    }
    return menuItems;
  }

  List<double> _getCustomItemsHeights(List<String> items) {
    final List<double> itemsHeights = [];
    for (int i = 0; i < (items.length * 2) - 1; i++) {
      if (i.isEven) {
        itemsHeights.add(40);
      }
      //Dividers indexes will be the odd indexes
      if (i.isOdd) {
        itemsHeights.add(4);
      }
    }
    return itemsHeights;
  }

  List<double> _getCustomItemsHeightsService(
      List<ElectricityServiceProviderListResModel> items) {
    final List<double> itemsHeights = [];
    for (int i = 0; i < (items.length * 2) - 1; i++) {
      if (i.isEven) {
        itemsHeights.add(40);
      }
      //Dividers indexes will be the odd indexes
      if (i.isOdd) {
        itemsHeights.add(4);
      }
    }
    return itemsHeights;
  }

  List<double> _getCustomItemsHeightsDistic(
      List<ElectricityStateResModel> items) {
    final List<double> itemsHeights = [];
    for (int i = 0; i < (items.length * 2) - 1; i++) {
      if (i.isEven) {
        itemsHeights.add(40);
      }
      //Dividers indexes will be the odd indexes
      if (i.isOdd) {
        itemsHeights.add(4);
      }
    }
    return itemsHeights;
  }

  List<double> _getCustomItemsHeights2(List<ReturnObject?> items) {
    final List<double> itemsHeights = [];
    for (int i = 0; i < (items.length * 2) - 1; i++) {
      if (i.isEven) {
        itemsHeights.add(40);
      }
      //Dividers indexes will be the odd indexes
      if (i.isOdd) {
        itemsHeights.add(4);
      }
    }
    return itemsHeights;
  }

  List<double> _getCustomItemsHeights3(List<CityResponce?> items) {
    final List<double> itemsHeights = [];
    for (int i = 0; i < (items.length * 2) - 1; i++) {
      if (i.isEven) {
        itemsHeights.add(40);
      }
      //Dividers indexes will be the odd indexes
      if (i.isOdd) {
        itemsHeights.add(4);
      }
    }
    return itemsHeights;
  }

  List<DropdownMenuItem<ReturnObject>> getAllState(List<ReturnObject?> items) {
    final List<DropdownMenuItem<ReturnObject>> menuItems = [];
    for (final ReturnObject? item in items) {
      menuItems.addAll(
        [
          DropdownMenuItem<ReturnObject>(
            value: item,
            child: Text(
              item!.name!, // Assuming 'name' is the property to display
              style: const TextStyle(
                fontSize: 14,
              ),
            ),
          ),
          // If it's not the last item, add Divider after it.
          if (item != items.last)
            const DropdownMenuItem<ReturnObject>(
              enabled: false,
              child: Divider(
                height: 0.1,
              ),
            ),
        ],
      );
    }
    return menuItems;
  }

  List<DropdownMenuItem<CityResponce>> getAllCity(List<CityResponce?> list) {
    final List<DropdownMenuItem<CityResponce>> menuItems = [];
    for (final CityResponce? item in list) {
      menuItems.addAll(
        [
          DropdownMenuItem<CityResponce>(
            value: item,
            child: Text(
              item!.name!, // Assuming 'name' is the property to display
              style: const TextStyle(
                fontSize: 14,
              ),
            ),
          ),
          // If it's not the last item, add Divider after it.
          if (item != list.last)
            const DropdownMenuItem<CityResponce>(
              enabled: false,
              child: Divider(
                height: 0.1,
              ),
            ),
        ],
      );
    }
    return menuItems;
  }

  List<DropdownMenuItem<CityResponce>> getCurrentAllCity(
      List<CityResponce?> list) {
    final List<DropdownMenuItem<CityResponce>> menuItems = [];
    for (final CityResponce? item in list) {
      menuItems.addAll(
        [
          DropdownMenuItem<CityResponce>(
            value: item,
            child: Text(
              item!.name!, // Assuming 'name' is the property to display
              style: const TextStyle(
                fontSize: 14,
              ),
            ),
          ),
          // If it's not the last item, add Divider after it.
          if (item != list.last)
            const DropdownMenuItem<CityResponce>(
              enabled: false,
              child: Divider(
                height: 0.1,
              ),
            ),
        ],
      );
    }
    return menuItems;
  }

  Widget buildStateField(DataProvider productProvider) {
    if (personalDetailsResponce != null) {
      if (personalDetailsResponce!.permanentState != null) {
        if (productProvider.getAllStateData != null) {
          var allStates = productProvider.getAllStateData!.returnObject!;
          var initialData = allStates.firstWhere(
                  (element) =>
              element?.id == personalDetailsResponce!.permanentState,
              orElse: () => null);
          _permanentStateNameCl.text = initialData!.name!;
        }
        if (personalDetailsResponce!.permanentState != null) {
          if (personalDetailsResponce!.permanentCity != null &&
              cityCallInitial) {
            permanentCitylist.clear();
            Provider.of<DataProvider>(context, listen: false)
                .getAllCity(personalDetailsResponce!.permanentState!);
            cityCallInitial = false;
          }
        }
        return TextField(
          enabled: false,
          controller: _permanentStateNameCl,
          keyboardType: TextInputType.number,
          textInputAction: TextInputAction.next,
          maxLines: 1,
          cursorColor: Colors.black,
          decoration: const InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: kPrimaryColor,
                ),
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              ),
              hintText: "State",
              labelText: "State",
              fillColor: textFiledBackgroundColour,
              filled: true,
              border: OutlineInputBorder(
                borderSide: BorderSide(color: kPrimaryColor, width: 1.0),
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              )),
        );
      } else {
        return Container();
      }
    } else {
      return Container();
    }
  }

  Widget buildCityField(DataProvider productProvider) {
    if (personalDetailsResponce!.permanentCity != null) {
      var initialData = productProvider.getAllCityData!.firstWhere(
              (element) => element?.id == personalDetailsResponce!.permanentCity,
          orElse: () => CityResponce());
      _permanentCityNameCl.text = initialData!.name!;

      return TextField(
        enabled: false,
        controller: _permanentCityNameCl,
        keyboardType: TextInputType.number,
        textInputAction: TextInputAction.next,
        maxLines: 1,
        cursorColor: Colors.black,
        decoration: const InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: kPrimaryColor,
              ),
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
            ),
            hintText: "City",
            labelText: "City",
            fillColor: textFiledBackgroundColour,
            filled: true,
            border: OutlineInputBorder(
              borderSide: BorderSide(color: kPrimaryColor, width: 1.0),
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
            )),
      );
    } else {
      return Container();
    }
  }

  Future<void> getPersonalDetailAndStateApi(BuildContext context) async {
    final prefsUtil = await SharedPref.getInstance();
    final String? userId = prefsUtil.getString(USER_ID);
    final String? productCode = prefsUtil.getString(PRODUCT_CODE);
    Provider.of<DataProvider>(context, listen: false)
        .getLeadPersonalDetails(userId!, productCode!);
    Provider.of<DataProvider>(context, listen: false).getAllState();
  }

  Widget permanentAddressField(DataProvider productProvider) {
    return Column(
      children: [
        const Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Permanent Address',
            style: TextStyle(fontSize: 15, color: Colors.black),
          ),
        ),
        const SizedBox(height: 15),
        TextField(
          enabled: false,
          controller: _permanentAddresslineOneCl,
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.next,
          maxLines: 1,
          cursorColor: Colors.black,
          decoration: const InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: kPrimaryColor,
                ),
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              ),
              hintText: "Address line 1",
              labelText: "Address line 1",
              fillColor: textFiledBackgroundColour,
              filled: true,
              border: OutlineInputBorder(
                borderSide: BorderSide(color: kPrimaryColor, width: 1.0),
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              )),
        ),
        const SizedBox(height: 15),
        TextField(
          enabled: false,
          controller: _permanentAddresslineTwoCl,
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.next,
          maxLines: 1,
          cursorColor: Colors.black,
          decoration: const InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: kPrimaryColor,
                ),
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              ),
              hintText: "Address line 2",
              labelText: "Address line 2",
              fillColor: textFiledBackgroundColour,
              filled: true,
              border: OutlineInputBorder(
                borderSide: BorderSide(color: kPrimaryColor, width: 1.0),
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              )),
        ),
        const SizedBox(height: 15),
        TextField(
          enabled: false,
          controller: _permanentAddressPinCodeCl,
          keyboardType: TextInputType.number,
          textInputAction: TextInputAction.next,
          maxLines: 1,
          cursorColor: Colors.black,
          decoration: const InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: kPrimaryColor,
                ),
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              ),
              hintText: "Pin Code*",
              labelText: "Pin Code*",
              fillColor: textFiledBackgroundColour,
              filled: true,
              border: OutlineInputBorder(
                borderSide: BorderSide(color: kPrimaryColor, width: 1.0),
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              )),
        ),
        const SizedBox(height: 15),
        buildStateField(productProvider),
        const SizedBox(height: 15),
        permanentCitylist!.isNotEmpty
            ? buildCityField(productProvider)
            : Container(),
        const SizedBox(height: 15),
        TextField(
          enabled: false,
          controller: _countryCl,
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.next,
          maxLines: 1,
          cursorColor: Colors.black,
          decoration: const InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: kPrimaryColor,
                ),
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              ),
              hintText: "Country",
              labelText: "Country",
              fillColor: textFiledBackgroundColour,
              filled: true,
              border: OutlineInputBorder(
                borderSide: BorderSide(color: kPrimaryColor, width: 1.0),
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              )),
        ),
        const SizedBox(height: 15),
      ],
    );
  }

  Widget basicDetailsFields(DataProvider productProvider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          enabled: false,
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.next,
          controller: _firstNameCl,
          maxLines: 1,
          cursorColor: Colors.black,
          canRequestFocus: true,
          decoration: const InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: kPrimaryColor,
                ),
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              ),
              hintText: "First Name",
              labelText: "First Name",
              fillColor: textFiledBackgroundColour,
              filled: true,
              border: OutlineInputBorder(
                borderSide: BorderSide(color: kPrimaryColor, width: 1.0),
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              )),
        ),
        const SizedBox(height: 15),
        TextField(
          enabled: false,
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.next,
          controller: _middleNameCl,
          maxLines: 1,
          cursorColor: Colors.black,
          decoration: const InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: kPrimaryColor,
                ),
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              ),
              hintText: "Middle Name",
              labelText: "Middle Name",
              fillColor: textFiledBackgroundColour,
              filled: true,
              border: OutlineInputBorder(
                borderSide: BorderSide(color: kPrimaryColor, width: 1.0),
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              )),
        ),
        const SizedBox(height: 15),
        TextField(
          enabled: false,
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.next,
          controller: _lastNameCl,
          maxLines: 1,
          cursorColor: Colors.black,
          decoration: const InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: kPrimaryColor,
                ),
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              ),
              hintText: "Last Name",
              labelText: "Last Name",
              fillColor: textFiledBackgroundColour,
              filled: true,
              border: OutlineInputBorder(
                borderSide: BorderSide(color: kPrimaryColor, width: 1.0),
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              )),
        ),
        const SizedBox(height: 15),
        TextField(
          enabled: false,
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.next,
          controller: _genderCl,
          maxLines: 1,
          cursorColor: Colors.black,
          decoration: const InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: kPrimaryColor,
                ),
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              ),
              hintText: "Gender",
              labelText: "Gender",
              fillColor: textFiledBackgroundColour,
              filled: true,
              border: OutlineInputBorder(
                borderSide: BorderSide(color: kPrimaryColor, width: 1.0),
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              )),
        ),
        const SizedBox(height: 15),
        const Padding(
          padding: EdgeInsets.only(left: 4.0),
          child: Text(
            "Martial Status",
            style: TextStyle(color: Colors.grey),
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField2<String>(
          isExpanded: true,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(vertical: 16),
            fillColor: textFiledBackgroundColour,
            filled: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: kPrimaryColor, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: kPrimaryColor, width: 1),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: kPrimaryColor, width: 1),
            ),
          ),
          hint: const Text(
            'marital Status',
            style: TextStyle(
              color: blueColor,
              fontSize: 14.0,
              fontWeight: FontWeight.w500,
            ),
          ),
          items: getDropDownOption(maritalList),
          value: selectedMaritalStatusValue,
          onChanged: (String? value) {
            setState(() {
              selectedMaritalStatusValue = value;
            });
          },
          buttonStyleData: const ButtonStyleData(
            padding: EdgeInsets.only(right: 8),
          ),
          dropdownStyleData: const DropdownStyleData(
            maxHeight: 200,
          ),
          menuItemStyleData: MenuItemStyleData(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            customHeights: _getCustomItemsHeights(maritalList),
          ),
          iconStyleData: const IconStyleData(
            openMenuIcon: Icon(Icons.arrow_drop_up),
          ),
        ),
        SizedBox(height: 15),
        Stack(
          children: [
            TextField(
              enabled: !isValidEmail,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              controller: _emailIDCl,
              maxLines: 1,
              cursorColor: Colors.black,
              decoration: InputDecoration(
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(
                    color: kPrimaryColor,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
                hintText: "E-mail ID",
                labelText: "E-mail ID",
                fillColor: textFiledBackgroundColour,
                filled: true,
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: kPrimaryColor, width: 1.0),
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
              ),
            ),
            _emailIDCl.text.isNotEmpty
                ? Positioned(
              right: 0,
              top: 0,
              bottom: 0,
              child: Container(
                child: IconButton(
                  onPressed: () => setState(() {
                    isEmailClear = false;
                    isValidEmail = false;
                    _emailIDCl.clear();
                  }),
                  icon: SvgPicture.asset(
                    'assets/icons/email_cross.svg',
                    semanticsLabel: 'My SVG Image',
                  ),
                ),
              ),
            )
                : Container(),
          ],
        ),
        SizedBox(height: 15),
        (!isEmailClear && _emailIDCl.text.isNotEmpty)
            ? Container(
          child: Row(
            children: [
              Text(
                'VERIFIED',
                style: TextStyle(
                    fontSize: 16,
                    decoration: TextDecoration.underline,
                    color: Colors.blue),
              ),
              SizedBox(
                width: 8,
              ),
              SvgPicture.asset('assets/icons/tick_square.svg'),
            ],
          ),
        )
            : Align(
            alignment: Alignment.centerLeft,
            child: InkWell(
              onTap: () async {
                if (_emailIDCl.text.isEmpty) {
                  Utils.showToast("Please Enter Email ID", context);
                } else if (!Utils.validateEmail(_emailIDCl.text)) {
                  Utils.showToast("Please Enter Valid Email ID", context);
                } else {
                  callEmailIDExist(context, _emailIDCl.text);
                }
              },
              child: Text(
                'Click here to Verify',
                style: TextStyle(
                    fontSize: 16,
                    decoration: TextDecoration.underline,
                    color: Colors.blue),
              ),
            )),
        SizedBox(height: 24),
        TextField(
          keyboardType: TextInputType.number,
          textInputAction: TextInputAction.next,
          controller: _alternatePhoneNumberCl,
          maxLines: 1,
          maxLength: 10,
          cursorColor: Colors.black,
          decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: kPrimaryColor,
                ),
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              ),
              hintText: "Alternate Phone Number",
              labelText: "Alternate Phone Number",
              fillColor: textFiledBackgroundColour,
              filled: true,
              border: OutlineInputBorder(
                borderSide: BorderSide(color: kPrimaryColor, width: 1.0),
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              )),
        ),
      ],
    );
  }

  Widget currentAddressFields(DataProvider productProvider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Current Address',
            style: TextStyle(fontSize: 16, color: Colors.black),
          ),
        ),
        const SizedBox(height: 15),
        CommonCheckBox(
          isChecked: isCurrentAddSame,
          onChanged: (bool isChecked) {
            setState(() {
              isCurrentAddSame = isChecked;
              updateData = true;
              if (isChecked) {
                print("Check${isChecked}");
                ischeckCurrentAdress = false;
                _currentAddressLineOneCl.text =
                personalDetailsResponce!.permanentAddressLine1!;
                _currentAddressLineTwoCl.text =
                personalDetailsResponce!.permanentAddressLine2!;
                _currentAddressPinCodeCl.text =
                    personalDetailsResponce!.permanentPincode!.toString();
              } else {
                ischeckCurrentAdress = true;
                _currentAddressLineOneCl.clear();
                _currentAddressLineTwoCl.clear();
                _currentAddressPinCodeCl.clear();
              }
            });
          },
          text: "Same as Permanent address",
          upperCase: false,
        ),
        const SizedBox(height: 15),
        TextField(
          enabled: ischeckCurrentAdress,
          controller: _currentAddressLineOneCl,
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.next,
          maxLines: 1,
          cursorColor: Colors.black,
          decoration: const InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: kPrimaryColor,
                ),
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              ),
              hintText: "Address line 1",
              labelText: "Address line 1",
              fillColor: textFiledBackgroundColour,
              filled: true,
              border: OutlineInputBorder(
                borderSide: BorderSide(color: kPrimaryColor, width: 1.0),
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              )),
        ),
        const SizedBox(height: 15),
        TextField(
          enabled: ischeckCurrentAdress,
          controller: _currentAddressLineTwoCl,
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.next,
          maxLines: 1,
          cursorColor: Colors.black,
          decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: kPrimaryColor,
                ),
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              ),
              hintText: "Address line 2",
              labelText: "Address line 2",
              fillColor: textFiledBackgroundColour,
              filled: true,
              border: OutlineInputBorder(
                borderSide: BorderSide(color: kPrimaryColor, width: 1.0),
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              )),
        ),
        const SizedBox(height: 15),
        TextField(
          enabled: ischeckCurrentAdress,
          controller: _currentAddressPinCodeCl,
          keyboardType: TextInputType.number,
          textInputAction: TextInputAction.next,
          maxLines: 1,
          cursorColor: Colors.black,
          decoration: const InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: kPrimaryColor,
                ),
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              ),
              hintText: "Pin Code*",
              labelText: "Pin Code*",
              fillColor: textFiledBackgroundColour,
              filled: true,
              border: OutlineInputBorder(
                borderSide: BorderSide(color: kPrimaryColor, width: 1.0),
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              )),
        ),
        const SizedBox(height: 15),
        isCurrentAddSame
            ? Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildStateField(productProvider),
            const SizedBox(height: 15),
            permanentCitylist.isNotEmpty
                ? buildCityField(productProvider)
                : Container(),
            const SizedBox(height: 15),
          ],
        )
            : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            productProvider.getAllStateData != null
                ? DropdownButtonFormField2<ReturnObject>(
              isExpanded: true,
              decoration: InputDecoration(
                contentPadding:
                const EdgeInsets.symmetric(vertical: 16),
                fillColor: textFiledBackgroundColour,
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(
                      color: kPrimaryColor, width: 1),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(
                      color: kPrimaryColor, width: 1),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide:
                  BorderSide(color: kPrimaryColor, width: 1),
                ),
              ),
              hint: const Text(
                'State',
                style: TextStyle(
                  color: blueColor,
                  fontSize: 14.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
              items: getAllState(
                  productProvider.getAllStateData!.returnObject!),
              onChanged: (ReturnObject? value) {
                setState(() {
                  selectedCurrentCity = null;
                  selectedCurrentState = value;
                  citylist.clear();
                  Provider.of<DataProvider>(context, listen: false)
                      .getCurrentAllCity(value!.id!);
                });
              },
              buttonStyleData: const ButtonStyleData(
                padding: EdgeInsets.only(right: 8),
              ),
              dropdownStyleData: const DropdownStyleData(
                maxHeight: 200,
              ),
              menuItemStyleData: MenuItemStyleData(
                padding:
                const EdgeInsets.symmetric(horizontal: 8.0),
                customHeights: _getCustomItemsHeights2(
                    productProvider.getAllStateData!.returnObject!),
              ),
              iconStyleData: const IconStyleData(
                openMenuIcon: Icon(Icons.arrow_drop_up),
              ),
            )
                : Container(),
            const SizedBox(height: 15),
            citylist.isNotEmpty
                ? DropdownButtonFormField2<CityResponce>(
              isExpanded: true,
              decoration: InputDecoration(
                contentPadding:
                const EdgeInsets.symmetric(vertical: 16),
                fillColor: textFiledBackgroundColour,
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(
                      color: kPrimaryColor, width: 1),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(
                      color: kPrimaryColor, width: 1),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide:
                  BorderSide(color: kPrimaryColor, width: 1),
                ),
              ),
              hint: const Text(
                'City',
                style: TextStyle(
                  color: blueColor,
                  fontSize: 14.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
              items: getCurrentAllCity(citylist),
              onChanged: (CityResponce? value) {
                setState(() {
                  selectedCurrentCity = value;
                });
              },
              buttonStyleData: const ButtonStyleData(
                padding: EdgeInsets.only(right: 8),
              ),
              dropdownStyleData: const DropdownStyleData(
                maxHeight: 200,
              ),
              menuItemStyleData: MenuItemStyleData(
                padding:
                const EdgeInsets.symmetric(horizontal: 8.0),
                customHeights: _getCustomItemsHeights3(citylist),
              ),
              iconStyleData: const IconStyleData(
                openMenuIcon: Icon(Icons.arrow_drop_up),
              ),
            )
                : Container(),
          ],
        ),
        const SizedBox(height: 15),
        TextField(
          enabled: false,
          controller: _countryCl,
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.next,
          maxLines: 1,
          cursorColor: Colors.black,
          decoration: const InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: kPrimaryColor,
                ),
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              ),
              hintText: "Country",
              labelText: "Country",
              fillColor: textFiledBackgroundColour,
              filled: true,
              border: OutlineInputBorder(
                borderSide: BorderSide(color: kPrimaryColor, width: 1.0),
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              )),
        ),
      ],
    );
  }

  Future<ValidationResult> validateData(
      BuildContext context, DataProvider productProvider) async {
    final prefsUtil = await SharedPref.getInstance();
    final String? userId = prefsUtil.getString(USER_ID);
    final int? leadId = prefsUtil.getInt(LEADE_ID);
    final int? companyId = prefsUtil.getInt(COMPANY_ID);
    final String? mobileNo = prefsUtil.getString(LOGIN_MOBILE_NUMBER);

    var currentStateId = "";
    var currentCityId = "";

    //address
    if (isCurrentAddSame) {
      currentStateId = personalDetailsResponce!.permanentState!.toString();
      currentCityId = personalDetailsResponce!.permanentCity!.toString();
    } else {
      if (selectedCurrentState != null) {
        currentStateId = selectedCurrentState!.id.toString();
      }
      if (selectedCurrentCity != null) {
        currentCityId = selectedCurrentCity!.id.toString();
      }
    }

    //bill
    if (productProvider.getpostElectricityBillDocumentSingleFileData != null) {
      billDocId =
      productProvider.getpostElectricityBillDocumentSingleFileData!.docId!;
    }

    PersonalDetailsRequestModel postData = PersonalDetailsRequestModel(
        firstName: _firstNameCl.text.toString(),
        lastName: _lastNameCl.text.toString(),
        fatherName: personalDetailsResponce!.fatherName!,
        fatherLastName: personalDetailsResponce!.fatherLastName!,
        dOB: "",
        alternatePhoneNo: _alternatePhoneNumberCl.text.toString(),
        emailId: _emailIDCl.text.toString(),
        typeOfAddress: "Permanent",
        permanentAddressLine1: personalDetailsResponce!.permanentAddressLine1!,
        permanentAddressLine2: personalDetailsResponce!.permanentAddressLine2!,
        permanentPincode: personalDetailsResponce!.permanentPincode!.toString(),
        permanentCity: personalDetailsResponce!.permanentCity!.toString(),
        permanentState: personalDetailsResponce!.permanentState!.toString(),
        pincode: _currentAddressPinCodeCl.text.toString(),
        state: currentStateId,
        city: currentCityId,
        residenceStatus: "",
        leadId: leadId,
        userId: userId,
        activityId: widget.activityId!,
        subActivityId: widget.subActivityId!,
        middleName: _middleNameCl.text.toString(),
        companyId: companyId,
        mobileNo: mobileNo,
        ownershipType: selectedOwnershipTypeValue,
        ownershipTypeAddress: "",
        ownershipTypeName: "",
        ownershipTypeResponseId: "",
        gender: _genderCl.text.toString(),
        marital: selectedMaritalStatusValue,
        resAddress1: _currentAddressLineOneCl.text.toString(),
        resAddress2: _currentAddressLineTwoCl.text.toString(),
        ownershipTypeProof: selectOwnershipProofValue,
        electricityBillDocumentId:
        selectOwnershipProofValue == "Electricity Manual Bill Upload"
            ? billDocId
            : null,
        ivrsNumber:
        selectOwnershipProofValue != "Electricity Manual Bill Upload"
            ? _customerIvrsCl.text.toString()
            : null,
        electricityServiceProvider:
        selectOwnershipProofValue != "Electricity Manual Bill Upload"
            ? electricityServiceProvider
            : null,
        electricityState:
        selectOwnershipProofValue != "Electricity Manual Bill Upload"
            ? electricityState
            : null);

    bool isValid = false;
    String errorMessage = "";

    if (_firstNameCl.text.toString().isEmpty) {
      errorMessage = "First name should not be empty";
      isValid = false;
    } else if (_lastNameCl.text.toString().isEmpty) {
      errorMessage = "Last name should not be empty";
      isValid = false;
    } else if (_alternatePhoneNumberCl.text.toString().isEmpty) {
      errorMessage = "Alternate Mobile Number should not be empty";
      isValid = false;
    } else if (_emailIDCl.text.toString().isEmpty) {
      errorMessage = "Email should not be empty";
      isValid = false;
    } else if (userId!.isEmpty) {
      errorMessage = "User Id should not be empty";
      isValid = false;
    } else if (selectedMaritalStatusValue == null) {
      errorMessage = "Martial Status should not be empty";
      isValid = false;
    } else if (currentStateId.isEmpty) {
      errorMessage = "Current State is required";
      isValid = false;
    } else if (currentStateId.isEmpty) {
      errorMessage = "Current City is required";
      isValid = false;
    } else if (!isValidEmail) {
      errorMessage = "Verify Email ";
      isValid = false;
    } else if (selectOwnershipProofValue == "Digital Bill Verification") {
      if (_customerIvrsCl.text.length < 10) {
        errorMessage = "ivrsNumber should not be empty";
        isValid = false;
      } else if (electricityServiceProvider.isEmpty) {
        errorMessage = "Electricity Service Provider should not be empty";
        isValid = false;
      } else if (electricityState.isEmpty) {
        errorMessage = "Please Select Correct Service Provider";
        isValid = false;
      } else {
        isValid = true;
      }
    } else if (selectOwnershipProofValue == "Electricity Manual Bill Upload") {
      if (billDocId == null) {
        errorMessage = "Please Add Bill Document";
        isValid = false;
      } else if (billDocId == 0) {
        errorMessage = "Please Add Bill Document";
        isValid = false;
      } else {
        isValid = true;
      }
    } else {
      isValid = true;
    }

    if (errorMessage.isNotEmpty) {
      Utils.showToast(errorMessage.toString(), context);
    }

    print("postData::: " + postData.toJson().toString());
    return ValidationResult(postData, isValid);
  }

  void bottomSheetMenu(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (builder) {
          return ImagePickerWidgets(onImageSelected: _onImageSelected);
        });
  }

  // Callback function to receive the selected image
  void _onImageSelected(File imageFile) async {
    Utils.onLoading(context, "");
    isImageDelete = false;
    // Perform asynchronous work first
    await Provider.of<DataProvider>(context, listen: false)
        .postElectricityBillDocumentSingleFile(imageFile, true, "", "");
    Navigator.of(context, rootNavigator: true).pop();
  }

  Future<void> getIvrsNumberExist(
      BuildContext context,
      DataProvider productProvider,
      TextEditingController customerIvrsCl,
      ) async {
    final prefsUtil = await SharedPref.getInstance();
    final String? userId = prefsUtil.getString(USER_ID);

    Utils.onLoading(context, "");
    await Provider.of<DataProvider>(context, listen: false)
        .getIvrsNumberExist(userId!, customerIvrsCl.text);
    Navigator.of(context, rootNavigator: true).pop();

    if (productProvider.getIvrsData != null) {
      productProvider.getIvrsData!.when(
        success: (data) async {
          // Handle successful response
          consumerNumber = _customerIvrsCl.text.toString();
          if (data.result!) {
            Utils.showToast("Data Already Exists", context);
          } else {
            Utils.hideKeyBored(context);
            await getKarzaElectricityServiceProviderList(
                context, productProvider);

            // await getKarzaElectricityState(context,productProvider);
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
  }

  Future<void> getKarzaElectricityServiceProviderList(
      BuildContext context, DataProvider productProvider) async {
    Utils.onLoading(context, "");
    await Provider.of<DataProvider>(context, listen: false)
        .getKarzaElectricityServiceProviderList();
    Navigator.of(context, rootNavigator: true).pop();

    if (productProvider.getElectricityServiceProviderData != null) {
      productProvider.getElectricityServiceProviderData!.when(
        success: (data) {
          // Handle successful response
          if (data.isNotEmpty) {
            selectServiceProviderList.addAll(data!);
          }

          selectServiceProviderList.forEach((var data) {
            if (_electryCityServiceCl.text.isNotEmpty) {
              if (_electryCityServiceCl.text == data.serviceProvider) {
                selectedStateValue = data.state;
              }
            }
          });
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
    setState(() {});
  }

  Future<void> getKarzaElectricityState(
      BuildContext context, DataProvider productProvider) async {
    final prefsUtil = await SharedPref.getInstance();
    final String? userId = prefsUtil.getString(USER_ID);

    Utils.onLoading(context, "");
    await Provider.of<DataProvider>(context, listen: false)
        .getKarzaElectricityState(selectedStateValue!);
    Navigator.of(context, rootNavigator: true).pop();

    if (productProvider.getElectricityStateListData != null) {
      productProvider.getElectricityStateListData!.when(
        success: (data) {
          // Handle successful response
          selectDistrictList.clear();
          if (data.isNotEmpty) {
            selectDistrictList.addAll(data!);
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
    setState(() {});
  }

  Future<void> getKarzaElectricityAuthentication(BuildContext context,
      DataProvider productProvider, String districtName) async {
    final prefsUtil = await SharedPref.getInstance();
    final int? leadeId = prefsUtil.getInt(LEADE_ID);

    var clientData = ClientData(caseId: leadeId.toString());
    var electricityAuthenticationReqModel = ElectricityAuthenticationReqModel(
        consumerId: _customerIvrsCl.text,
        consent: "Y",
        district: districtName,
        serviceProvider: selectServiceProviderCode,
        clientData: clientData);

    Utils.onLoading(context, "");
    await Provider.of<DataProvider>(context, listen: false)
        .getKarzaElectricityAuthentication(electricityAuthenticationReqModel);
    Navigator.of(context, rootNavigator: true).pop();
    if (productProvider.getElectricityAuthenticationData != null) {
      productProvider.getElectricityAuthenticationData!.when(
        success: (data) {
          // Handle successful response
          if (data.result!.consumerName != null) {
            customerName = data.result!.consumerName!;

            isCustomerName = true;
            if (data.result!.consumerName != null) {
              customerAddress = data.result!.consumerName!;
            }
            if (data.result!.consumerNumber != null) {
              consumerNumber = data.result!.consumerNumber!;
            }
          } else {
            electricityState = "";
            selectDistrictValue = null;
            Utils.showToast("Service Provider Incorrect", context);
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
    setState(() {});
  }

  Widget digitalBillFields(DataProvider productProvider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 4.0),
              child: Text(
                "Digital Verification",
                style: TextStyle(color: Colors.black, fontSize: 18),
              ),
            ),
            SizedBox(height: 15),
            Stack(
              children: [
                TextField(
                  enabled: true,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  controller: _customerIvrsCl,
                  textCapitalization: TextCapitalization.characters,
                  maxLines: 1,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp((r'[A-Z0-9]'))),
                    LengthLimitingTextInputFormatter(11)
                  ],
                  cursorColor: Colors.black,
                  decoration: const InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: kPrimaryColor,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                      hintText: "Customer IVRS",
                      labelText: "Customer IVRS  ",
                      fillColor: textFiledBackgroundColour,
                      filled: true,
                      border: OutlineInputBorder(
                        borderSide:
                        BorderSide(color: kPrimaryColor, width: 1.0),
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      )),
                  onChanged: (text) async {
                    print('TextField value: $text (${text.length})');
                    isOwnerShipProofEditable = true;
                    isElectriCityDistrictEdit = true;
                    isElectriCityServiceEdit = true;
                    if (text.length >= 10) {
                      // Make API Call to validate PAN card
                      setState(() {
                        selectServiceProviderValue = null;
                        selectServiceProviderList.clear();
                      });

                      getIvrsNumberExist(
                        context,
                        productProvider,
                        _customerIvrsCl,
                      );
                    } else {
                      setState(() {
                        selectServiceProviderValue = null;
                        selectServiceProviderList.clear();
                        selectDistrictList.clear();
                        selectDistrictValue = null;
                        customerName = "";
                        customerAddress = "";
                        consumerNumber = "";
                        electricityServiceProvider = "";
                        electricityState = "";
                      });
                    }
                  },
                ),
              ],
            ),
            SizedBox(height: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                isOwnerShipProofEditable && isElectriCityServiceEdit
                    ? selectServiceProviderList.isNotEmpty
                    ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 15),
                    Padding(
                      padding: const EdgeInsets.only(left: 4.0),
                      child: Text(
                        "Select Service Provider",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                    SizedBox(height: 8),
                    DropdownButtonFormField2<
                        ElectricityServiceProviderListResModel>(
                      isExpanded: true,
                      decoration: InputDecoration(
                        contentPadding:
                        const EdgeInsets.symmetric(vertical: 16),
                        fillColor: textFiledBackgroundColour,
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                              color: kPrimaryColor, width: 1),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                              color: kPrimaryColor, width: 1),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                              color: kPrimaryColor, width: 1),
                        ),
                      ),
                      hint: const Text(
                        'Select service provider',
                        style: TextStyle(
                          color: blueColor,
                          fontSize: 14.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      items: getDropDownOptionServiceList(
                          selectServiceProviderList),
                      onChanged:
                          (ElectricityServiceProviderListResModel?
                      value) {
                        setState(() {
                          selectServiceProviderValue = value;
                          selectServiceProviderCode = value!.code;
                          selectedStateValue = value.state.toString();
                          selectDistrictList.clear();
                          electricityServiceProvider =
                              value!.serviceProvider!.toString();
                          customerName = "";
                          customerAddress = "";
                          consumerNumber = "";
                          isCustomerName = false;
                        });
                        getKarzaElectricityState(
                            context, productProvider);
                      },
                      buttonStyleData: const ButtonStyleData(
                        padding: EdgeInsets.only(right: 8),
                      ),
                      dropdownStyleData: const DropdownStyleData(
                        maxHeight: 200,
                      ),
                      menuItemStyleData: MenuItemStyleData(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0),
                        customHeights: _getCustomItemsHeightsService(
                            selectServiceProviderList),
                      ),
                      iconStyleData: const IconStyleData(
                        openMenuIcon: Icon(Icons.arrow_drop_up),
                      ),
                    ),
                  ],
                )
                    : Container()
                    : Column(
                  children: [
                    const SizedBox(height: 15),
                    TextField(
                      showCursor: false,
                      readOnly: true,
                      enabled: true,
                      controller: _electryCityServiceCl,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      maxLines: 1,
                      cursorColor: Colors.black,
                      decoration: const InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: kPrimaryColor,
                            ),
                            borderRadius:
                            BorderRadius.all(Radius.circular(10.0)),
                          ),
                          hintText: "Select Service Provider",
                          labelText: "Service Provider",
                          fillColor: textFiledBackgroundColour,
                          filled: true,
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: kPrimaryColor, width: 1.0),
                            borderRadius:
                            BorderRadius.all(Radius.circular(10.0)),
                          )),
                      onTap: () {
                        setState(() {
                          isOwnerShipProofEditable = true;
                          isElectriCityServiceEdit = true;
                          isElectriCityDistrictEdit = true;
                          selectDistrictList.clear();
                        });
                      },
                    ),
                  ],
                ),
                isOwnerShipProofEditable && isElectriCityDistrictEdit
                    ? selectDistrictList.isNotEmpty
                    ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 15),
                    Padding(
                      padding: const EdgeInsets.only(left: 4.0),
                      child: Text(
                        "Select District",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField2<
                        ElectricityStateResModel>(
                      // value: selectDistrictValue != null ? selectDistrictValue : null,
                      isExpanded: true,
                      decoration: InputDecoration(
                        contentPadding:
                        const EdgeInsets.symmetric(vertical: 16),
                        fillColor: textFiledBackgroundColour,
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                              color: kPrimaryColor, width: 1),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                              color: kPrimaryColor, width: 1),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                              color: kPrimaryColor, width: 1),
                        ),
                      ),
                      hint: const Text(
                        'Select District',
                        style: TextStyle(
                          color: blueColor,
                          fontSize: 14.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      items: getDropDownOptionDisticList(
                          selectDistrictList),
                      onChanged: (ElectricityStateResModel? value) {
                        setState(() {
                          selectDistrictValue = value;
                          customerName = "";
                          customerAddress = "";
                          consumerNumber = "";
                          electricityState =
                              value!.districtName!.toString();
                          isCustomerName = false;
                        });
                        getKarzaElectricityAuthentication(
                            context,
                            productProvider,
                            selectDistrictValue!.districtName
                                .toString());
                      },
                      buttonStyleData: const ButtonStyleData(
                        padding: EdgeInsets.only(right: 8),
                      ),
                      dropdownStyleData: const DropdownStyleData(
                        maxHeight: 200,
                      ),
                      menuItemStyleData: MenuItemStyleData(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0),
                        customHeights: _getCustomItemsHeightsDistic(
                            selectDistrictList),
                      ),
                      iconStyleData: const IconStyleData(
                        openMenuIcon: Icon(Icons.arrow_drop_up),
                      ),
                    ),
                  ],
                )
                    : Container()
                    : Column(
                  children: [
                    SizedBox(height: 20),
                    TextField(
                      showCursor: false,
                      readOnly: true,
                      enabled: true,
                      controller: _electryDistrictCl,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      maxLines: 1,
                      cursorColor: Colors.black,
                      decoration: const InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: kPrimaryColor,
                            ),
                            borderRadius:
                            BorderRadius.all(Radius.circular(10.0)),
                          ),
                          hintText: "Select District",
                          labelText: "Select District",
                          fillColor: textFiledBackgroundColour,
                          filled: true,
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: kPrimaryColor, width: 1.0),
                            borderRadius:
                            BorderRadius.all(Radius.circular(10.0)),
                          )),
                      onTap: () {
                        setState(() {
                          isOwnerShipProofEditable = true;
                          isElectriCityDistrictEdit = true;
                          getKarzaElectricityState(
                              context, productProvider);
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
            isCustomerName
                ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.only(left: 4.0),
                  child: Text(
                    "Name (As per IVRS No.)",
                    style: TextStyle(color: Colors.grey, fontSize: 15),
                  ),
                ),
                SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.only(left: 4.0),
                  child: Text(
                    "$customerName",
                    style: TextStyle(color: Colors.black, fontSize: 15),
                  ),
                ),
                SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.only(left: 4.0),
                  child: Text(
                    "Address : $customerAddress",
                    style: TextStyle(color: Colors.black, fontSize: 15),
                  ),
                ),
              ],
            )
                : Container(),
          ],
        ),
      ],
    );
  }
}

class ValidationResult {
  final PersonalDetailsRequestModel postData;
  final bool isValid;

  ValidationResult(this.postData, this.isValid);
}
