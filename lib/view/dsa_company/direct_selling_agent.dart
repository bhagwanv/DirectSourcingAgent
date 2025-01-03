import 'dart:io';

import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:cupertino_date_time_picker_loki/cupertino_date_time_picker_loki.dart';
import 'package:direct_sourcing_agent/utils/loader.dart';
import 'package:direct_sourcing_agent/view/dsa_company/model/EducationMasterListResponse.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../api/ApiService.dart';
import '../../api/FailureException.dart';
import '../../providers/DataProvider.dart';
import '../../shared_preferences/shared_pref.dart';
import '../../utils/ImagePicker.dart';
import '../../utils/common_elevted_button.dart';
import '../../utils/common_text_field.dart';
import '../../utils/constant.dart';
import '../../utils/custom_radio_button.dart';
import '../../utils/customer_sequence_logic.dart';
import '../../utils/utils_class.dart';
import '../connector/model/ConnectorInfoReqModel.dart';
import '../connector/model/ConnectorInfoResponce.dart';
import '../personal_info/model/CityResponce.dart';
import '../personal_info/model/EmailExistRespoce.dart';
import '../personal_info/model/ReturnObject.dart';
import '../personal_info/model/SendOtpOnEmailResponce.dart';
import '../splash/model/GetLeadResponseModel.dart';
import '../splash/model/LeadCurrentRequestModel.dart';
import '../splash/model/LeadCurrentResponseModel.dart';
import 'EmailOtpScreen.dart';
import 'model/CustomerDetailUsingGSTResponseModel.dart';
import 'model/DSAGSTExistResModel.dart';
import 'model/EducationMasterListResponse.dart';
import 'model/GetDsaPersonalDetailResModel.dart';
import 'model/PostLeadDSAPersonalDetailReqModel.dart';

class DirectSellingAgent extends StatefulWidget {
  int? activityId;
  int? subActivityId;
  final String? pageType;

  DirectSellingAgent(
      {required this.activityId,
      required this.subActivityId,
      super.key,
      this.pageType});

  @override
  State<DirectSellingAgent> createState() => _DirectSellingAgent();
}

class _DirectSellingAgent extends State<DirectSellingAgent> {
  //dsa
  final TextEditingController _gstController = TextEditingController();
  final TextEditingController _fullNameCl = TextEditingController();
  final TextEditingController _fatherOrHusbandNameCl = TextEditingController();
  final TextEditingController _ageCl = TextEditingController();
  final TextEditingController _dobCl = TextEditingController();
  final TextEditingController _addressCl = TextEditingController();
  final TextEditingController _pinCodeCl = TextEditingController();
  final TextEditingController _cityCl = TextEditingController();
  final TextEditingController _stateCl = TextEditingController();
  final TextEditingController _alternetMobileNumberCl = TextEditingController();
  final TextEditingController _currentEmploymentCl = TextEditingController();
  final TextEditingController _emailIDCl = TextEditingController();
  final TextEditingController _qualificationCl = TextEditingController();
  final TextEditingController _languagesKnownCl = TextEditingController();
  final TextEditingController _locationCl = TextEditingController();
  final TextEditingController _referenceContactNoCl = TextEditingController();
  final TextEditingController _referenceNames = TextEditingController();
  final TextEditingController _companyAddressCl = TextEditingController();
  final TextEditingController _companyNameCl = TextEditingController();
  final TextEditingController _companyPinCodeCodeCl = TextEditingController();
  final TextEditingController _companyStateCl = TextEditingController();
  final TextEditingController _companyCityCl = TextEditingController();
  final TextEditingController _presentOccupationCl = TextEditingController();

  var isPresentlyworking = "No";
  var isGSTRegistered = "Yes";
  var isValidEmail = false;
  var isValidGST = false;
  var isLoading = false;
  var gstNumber = "";
  var image = "";
  int? businessProofDocId;
  var isClearData = false;
  var isImageDelete = false;
  var isGstFilled = false;
  var updateData = true;
  var isWorkingWithOtherChange = false;
  var isGstStatusChange = false;
  String? selectedStateValue;
  String? selectedCityValue;
  String? cityId;
  String? stateId;

  String? selectedCompanyStateValue;
  String? selectedCompanyCityValue;
  String? companyCityId;
  String? companyStateId;

  CityResponce? selectedCompanyCity = null;
  ReturnObject? selectedCompanyState = null;

  CityResponce? selectedWorkingLocationCity = null;
  ReturnObject? selectedWorkingLocationState = null;
  int? WorkingLocationCityId;
  int? WorkingLocationStateId;
  var WorkingLocationcityCallInitial = true;
  List<CityResponce?> workingLocationCityList = [];

  List<CityResponce?> citylist = [];
  var cityCallInitial = true;
  final List<String> businessTypeList = [
    'Proprietorship',
    'Partnership',
    'Pvt Ltd',
    'HUF',
    'LLP'
  ];
  String? selectedBusinessTypeValue;
  String? selectedFirmTypeValue;

  final List<String> chooseBusinessProofList = [
    'GST Certificate',
    'Udyog Aadhaar Certificate',
    'Shop Establishment Certificate',
    'Trade License',
    'Others'
  ];

  var gstUpdate = true;
  var setStateListFirstTime = true;
  var setCityListFirstTime = true;
  CustomerDetailUsingGstResponseModel? getCustomerDetailUsingGSTData;
  GetDsaPersonalDetailResModel? getDsaPersonalDetailData;

  DateTime date = DateTime.now().subtract(const Duration(days: 1));

  String minDateTime = '2010-05-12';
  String maxDateTime = '2030-11-25';
  String initDateTime = '2021-08-31';

  String? selectedDate = "";
  String? profileTypeDSA = "";
  bool DSAPersonalDetailAPICAll = true;
  bool ConnectorPersonalDetailAPICAll = true;

  void _handleRadioValueChanged(String value) {
    setState(() {
      isGstStatusChange = true;
      _gstController.clear();
      _companyNameCl.clear();
      _companyAddressCl.clear();
      _companyPinCodeCodeCl.clear();
      isGSTRegistered = value;
      companyCityId = null;
      companyStateId = null;
      selectedCompanyCity = null;
      selectedCompanyState = null;

      isImageDelete = true;
      gstUpdate = true;
      setCityListFirstTime = false;
      businessProofDocId = null;
      selectedFirmTypeValue = null;
      selectedStateValue = null;
      selectedCityValue = null;
      selectedBusinessTypeValue = null;
      isClearData = true;
      gstNumber = "";
      image = "";
      isGstFilled = false;
      if (value == "No") {
        chooseBusinessProofList.removeAt(0);
      } else {
        chooseBusinessProofList.insert(0, 'GST Certificate');
      }
    });
  }

  void _handleRadioValueWorkingWithOtherChanged(String value) {
    setState(() {
      isWorkingWithOtherChange = true;
      isPresentlyworking = value;
    });
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
              style: GoogleFonts.urbanist(
                fontSize: 15,
                color: blackSmall,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          /*if (item != items.last)
            const DropdownMenuItem<ReturnObject>(
              enabled: false,
              child: Divider(
                height: 0.1,
              ),
            ),*/
        ],
      );
    }
    return menuItems;
  }

  void _onImageSelected(File imageFile) async {
    isImageDelete = false;
    Utils.onLoading(context, "");
    await Provider.of<DataProvider>(context, listen: false)
        .postDSABusineesDoumentSingleFile(imageFile, true, "", "");
    Navigator.of(context, rootNavigator: true).pop();
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
              style: GoogleFonts.urbanist(
                fontSize: 15,
                color: blackSmall,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          // If it's not the last item, add Divider after it.
          /* if (item != list.last)
            const DropdownMenuItem<CityResponce>(
              enabled: false,
              child: Divider(
                height: 0.1,
              ),
            ),*/
        ],
      );
    }
    return menuItems;
  }

  Widget buildStateField(DataProvider productProvider) {
    if (productProvider.getAllStateData != null) {
      if (productProvider.getAllStateData != null) {
        var allStates = productProvider.getAllStateData!.returnObject!;
        if (companyStateId != null) {
          selectedCompanyState = allStates.firstWhere(
              (element) => element?.id == int.parse(companyStateId!),
              orElse: () => null);

          if (cityCallInitial) {
            citylist.clear();
            Provider.of<DataProvider>(context, listen: false)
                .getAllCity(int.parse(companyStateId!));
            cityCallInitial = false;
          }
        }
      }
      return Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: DropdownButtonFormField2<ReturnObject?>(
              isExpanded: true,
              value: selectedCompanyState,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(vertical: 16),
                fillColor: textFiledBackgroundColour,
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: kPrimaryColor, width: 1),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: kPrimaryColor, width: 1),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: kPrimaryColor, width: 1),
                ),
              ),
              hint: Text(
                'State',
                style: GoogleFonts.urbanist(
                  fontSize: 15,
                  color: blackSmall,
                  fontWeight: FontWeight.w400,
                ),
              ),
              items:
                  getAllState(productProvider.getAllStateData!.returnObject!),
              onChanged: isGstFilled
                  ? null
                  : (ReturnObject? value) {
                      setState(() {
                        citylist.clear();
                        setStateListFirstTime = false;
                        Provider.of<DataProvider>(context, listen: false)
                            .getAllCity(value!.id!);
                        selectedStateValue = value.id!.toString();
                        selectedCompanyCity = null;
                        selectedCompanyState = value;
                        _companyStateCl.text = value!.id.toString();
                        companyCityId = null;
                        companyStateId = null;
                      });
                    },
              dropdownStyleData: DropdownStyleData(
                maxHeight: 400,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              menuItemStyleData: const MenuItemStyleData(
                padding: EdgeInsets.only(left: 16, right: 16, bottom: 16),
              ),
              iconStyleData: const IconStyleData(
                icon: Padding(
                  padding: EdgeInsets.only(right: 10),
                  child: Icon(Icons.keyboard_arrow_down),
                ), // Down arrow icon when closed
                openMenuIcon: Padding(
                  padding: EdgeInsets.only(right: 10),
                  child: Icon(Icons.keyboard_arrow_up),
                ), // Up arrow icon when open
              ),
            ),
          ),
          Positioned(
            top: 0, // Adjust the vertical position as needed
            left: 16, // Adjust the horizontal position as needed
            child: Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: Text(
                  'State', // Your label text
                  style: GoogleFonts.urbanist(
                    fontSize: 12,
                    color: Colors.grey[900], // Adjust color as needed
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    } else {
      return Container();
    }
  }

  Widget buildCityField(DataProvider productProvider) {
    if (productProvider.getAllCityData != null &&
        productProvider.getAllCityData!.isNotEmpty) {
      citylist = productProvider.getAllCityData!;
      print("companyCityId:: ${companyCityId}");
      print("cityCallInitial:: ${cityCallInitial}");
      if (companyCityId != null) {
        selectedCompanyCity = citylist.firstWhere(
            (element) => element?.id == int.parse(companyCityId!),
            orElse: () => CityResponce());
      }
      return Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: DropdownButtonFormField2<CityResponce>(
              isExpanded: true,
              value: selectedCompanyCity,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(vertical: 16),
                fillColor: textFiledBackgroundColour,
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: kPrimaryColor, width: 1),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: kPrimaryColor, width: 1),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: kPrimaryColor, width: 1),
                ),
              ),
              hint: Text(
                'City',
                style: GoogleFonts.urbanist(
                  fontSize: 15,
                  color: blackSmall,
                  fontWeight: FontWeight.w400,
                ),
              ),
              items: getAllCity(citylist),
              onChanged: isGstFilled
                  ? null
                  : (CityResponce? value) {
                      setState(() {
                        selectedCompanyCity = value;
                        setCityListFirstTime = false;
                        _companyCityCl.text = value!.id.toString();
                        companyCityId = null;
                      });
                    },
              dropdownStyleData: DropdownStyleData(
                maxHeight: 400,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              menuItemStyleData: const MenuItemStyleData(
                padding: EdgeInsets.only(left: 16, right: 16, bottom: 16),
              ),
              iconStyleData: IconStyleData(
                icon: Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Icon(Icons.keyboard_arrow_down),
                ), // Down arrow icon when closed
                openMenuIcon: Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Icon(Icons.keyboard_arrow_up),
                ), // Up arrow icon when open
              ),
            ),
          ),
          Positioned(
            top: 0, // Adjust the vertical position as needed
            left: 16, // Adjust the horizontal position as needed
            child: Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: Text(
                  'City', // Your label text
                  style: GoogleFonts.urbanist(
                    fontSize: 12,
                    color: Colors.grey[900], // Adjust color as needed
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    } else {
      return Container();
    }
  }

  Widget buildWorkingLocationStateField(DataProvider productProvider) {
    if (productProvider.getWorkingLocationAllStateData != null) {
      if (productProvider.getWorkingLocationAllStateData != null) {
        var allStates =
            productProvider.getWorkingLocationAllStateData!.returnObject!;
        print("WorkingLocationStateId : $WorkingLocationStateId");
        if (WorkingLocationStateId != null) {
          selectedWorkingLocationState = allStates.firstWhere(
              (element) => element?.id == WorkingLocationStateId!,
              orElse: () => null);

          if (WorkingLocationcityCallInitial) {
            workingLocationCityList.clear();
            Provider.of<DataProvider>(context, listen: false)
                .getWorkingLocationAllCity(WorkingLocationStateId!);
            WorkingLocationcityCallInitial = false;
          }
        }
      }
      return Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: DropdownButtonFormField2<ReturnObject?>(
              isExpanded: true,
              value: selectedWorkingLocationState,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(vertical: 16),
                fillColor: textFiledBackgroundColour,
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: kPrimaryColor, width: 1),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: kPrimaryColor, width: 1),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: kPrimaryColor, width: 1),
                ),
              ),
              hint: Text(
                'State',
                style: GoogleFonts.urbanist(
                  fontSize: 15,
                  color: blackSmall,
                  fontWeight: FontWeight.w400,
                ),
              ),
              items: getAllState(productProvider
                  .getWorkingLocationAllStateData!.returnObject!),
              onChanged: (ReturnObject? value) {
                setState(() {
                  workingLocationCityList.clear();
                  Provider.of<DataProvider>(context, listen: false)
                      .getWorkingLocationAllCity(value!.id!);
                  selectedWorkingLocationState = value;
                  selectedWorkingLocationCity = null;
                  WorkingLocationCityId = null;
                  WorkingLocationStateId = null;
                });
              },
              dropdownStyleData: DropdownStyleData(
                maxHeight: 400,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              menuItemStyleData: const MenuItemStyleData(
                padding: EdgeInsets.only(left: 16, right: 16, bottom: 16),
              ),
              iconStyleData: const IconStyleData(
                icon: Padding(
                  padding: EdgeInsets.only(right: 10),
                  child: Icon(Icons.keyboard_arrow_down),
                ), // Down arrow icon when closed
                openMenuIcon: Padding(
                  padding: EdgeInsets.only(right: 10),
                  child: Icon(Icons.keyboard_arrow_up),
                ), // Up arrow icon when open
              ),
            ),
          ),
          Positioned(
            top: 0, // Adjust the vertical position as needed
            left: 16, // Adjust the horizontal position as needed
            child: Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: Text(
                  'State', // Your label text
                  style: GoogleFonts.urbanist(
                    fontSize: 12,
                    color: Colors.grey[900], // Adjust color as needed
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    } else {
      return Container();
    }
  }

  Widget buildWorkingLocationCityField(DataProvider productProvider) {
    if (productProvider.getWorkingLocationAllCityData != null &&
        productProvider.getWorkingLocationAllCityData!.isNotEmpty) {
      workingLocationCityList = productProvider.getWorkingLocationAllCityData!;
      if (WorkingLocationCityId != null) {
        selectedWorkingLocationCity = workingLocationCityList.firstWhere(
            (element) => element?.id == WorkingLocationCityId!,
            orElse: () => CityResponce());
      }
      return Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: DropdownButtonFormField2<CityResponce>(
              isExpanded: true,
              value: selectedWorkingLocationCity,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(vertical: 16),
                fillColor: textFiledBackgroundColour,
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: kPrimaryColor, width: 1),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: kPrimaryColor, width: 1),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: kPrimaryColor, width: 1),
                ),
              ),
              hint: Text(
                'City',
                style: GoogleFonts.urbanist(
                  fontSize: 15,
                  color: blackSmall,
                  fontWeight: FontWeight.w400,
                ),
              ),
              items: getAllCity(workingLocationCityList),
              onChanged: (CityResponce? value) {
                setState(() {
                  selectedWorkingLocationCity = value;
                  WorkingLocationCityId = null;
                });
              },
              dropdownStyleData: DropdownStyleData(
                maxHeight: 400,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              menuItemStyleData: const MenuItemStyleData(
                padding: EdgeInsets.only(left: 16, right: 16, bottom: 16),
              ),
              iconStyleData: IconStyleData(
                icon: Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Icon(Icons.keyboard_arrow_down),
                ), // Down arrow icon when closed
                openMenuIcon: Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Icon(Icons.keyboard_arrow_up),
                ), // Up arrow icon when open
              ),
            ),
          ),
          Positioned(
            top: 0, // Adjust the vertical position as needed
            left: 16, // Adjust the horizontal position as needed
            child: Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: Text(
                  'City', // Your label text
                  style: GoogleFonts.urbanist(
                    fontSize: 12,
                    color: Colors.grey[900], // Adjust color as needed
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    } else {
      return Container();
    }
  }

  List<String> languageList = [];
  List<String> selectedLanguageList = [];

  List<QualificationList> _qualificationList = [];
  QualificationList? initialQualification = null;

  final FocusNode _focusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();

  //connector
  var connectorUpdateData = true;
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _fatherNameController = TextEditingController();
  final TextEditingController _dateoFBirthController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _addreshController = TextEditingController();
  final TextEditingController _alternetMobileNumberController =
      TextEditingController();
  final TextEditingController _emailIDController = TextEditingController();
  final TextEditingController _presentEmpolymentController =
      TextEditingController();
  final TextEditingController _refranceNameController = TextEditingController();
  final TextEditingController _refranceContectController =
      TextEditingController();
  final TextEditingController _refranceLocationController =
      TextEditingController();
  final TextEditingController _pincodeController = TextEditingController();
  final TextEditingController _satateController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();

  bool isWorkingWithParty = false;
  String workingWithParty = "No";

  String? slectedDate = "";
  ConnectorInfoResponce? connectorInfoResponceModel;

  void _handleRadioValueWorkingWithPartyChanged(String value) {
    setState(() {
      isWorkingWithParty = true;
      workingWithParty = value;
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        // Scroll to the top when the keyboard is opened
        _scrollController.animateTo(
          0.0,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    });
    dSAPersonalInfoApi(context);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) {
          return;
        }
        final bool shouldPop = await Utils().onback(context);
        if (shouldPop) {
          SystemNavigator.pop();
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          top: true,
          bottom: true,
          child:
              Consumer<DataProvider>(builder: (context, dataProvider, child) {
            if (dataProvider.getDSAPersonalInfoData != null) {
              dataProvider.getDSAPersonalInfoData!.when(
                success: (data) {
                  if (data.status!) {
                    profileTypeDSA = data.dsaType!;
                  } else {
                    Utils.showToast(data.message!, context);
                  }
                },
                failure: (exception) {
                  if (exception is ApiException) {
                    if (exception.statusCode == 401) {
                      dataProvider.disposeAllProviderData();
                      ApiService().handle401(context);
                    } else {
                      Utils.showToast(exception.errorMessage, context);
                    }
                  }
                },
              );
            }
            return profileTypeDSA!.isNotEmpty
                ? profileTypeDSA == "DSA"
                    ? Dsa(dataProvider)
                    : Connector(dataProvider)
                : Loader();
          }),
        ),
      ),
    );
  }

  void bottomSheetMenu(
      BuildContext context, bool camera, bool gallery, bool pdf) {
    showModalBottomSheet(
        context: context,
        builder: (builder) {
          return ImagePickerWidgets(
            onImageSelected: _onImageSelected,
            camera: true,
            gallery: true,
            pdf: true,
          );
        });
  }

  void callEmailIDExist(BuildContext context, String emailID) async {
    Utils.onLoading(context, "");
    final prefsUtil = await SharedPref.getInstance();
    final String? userId = prefsUtil.getString(USER_ID);
    final String? productCode = prefsUtil.getString(PRODUCT_CODE);
    EmailExistRespoce data;
    data = await ApiService().emailExist(userId!, emailID, productCode!)
        as EmailExistRespoce;
    if (data.isSuccess!) {
      Navigator.of(context, rootNavigator: true).pop();
      isValidEmail = false;
      Utils.showToast(data.message!, context);
    } else {
      callSendOptEmail(context, emailID);
    }
  }

  void callSendOptEmail(BuildContext context, String emailID) async {
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

  Future<void> callDSAGSTExist(
      BuildContext context, String gst, DataProvider dataProvider) async {
    Utils.onLoading(context, "");
    final prefsUtil = await SharedPref.getInstance();
    final String? userId = prefsUtil.getString(USER_ID);
    final String? productCode = prefsUtil.getString(PRODUCT_CODE);
    DsagstExistResModel data;
    data = await ApiService().getDSAGSTExist(userId!, gst, productCode!)
        as DsagstExistResModel;
    Navigator.of(context, rootNavigator: true).pop();
    if (data.status!) {
      Utils.showToast(data.message!, context);
    } else {
      setState(() {
        isValidGST = true;
      });
      await getCustomerDetailUsingGST(
          context, _gstController.text, dataProvider);
    }
  }

  Future<void> getCustomerDetailUsingGST(BuildContext context, String gstNumber,
      DataProvider productProvider) async {
    Utils.onLoading(context, "");
    await Provider.of<DataProvider>(context, listen: false)
        .getCustomerDetailUsingGST(gstNumber);
    Navigator.of(context, rootNavigator: true).pop();

    if (productProvider.getCustomerDetailUsingGSTData != null) {
      productProvider.getCustomerDetailUsingGSTData!.when(
        success: (data) {
          getCustomerDetailUsingGSTData = data;
          Provider.of<DataProvider>(context, listen: false).getAllState();
          if (getCustomerDetailUsingGSTData!.busGSTNO != null) {
            gstUpdate = false;
            cityCallInitial = true;
            _gstController.text = getCustomerDetailUsingGSTData!.busGSTNO!;
            gstNumber = getCustomerDetailUsingGSTData!.busGSTNO!;
            _companyNameCl.text = getCustomerDetailUsingGSTData!.businessName!;
            _companyAddressCl.text =
                getCustomerDetailUsingGSTData!.addressLineOne!;
            _companyPinCodeCodeCl.text =
                getCustomerDetailUsingGSTData!.zipCode!.toString();
            _companyCityCl.text =
                getCustomerDetailUsingGSTData!.cityId.toString();
            _companyStateCl.text =
                getCustomerDetailUsingGSTData!.stateId.toString();
            isGstFilled = true;
            companyStateId = getCustomerDetailUsingGSTData!.stateId.toString();
            companyCityId = getCustomerDetailUsingGSTData!.cityId.toString();
            selectedBusinessTypeValue = "GST Certificate";
          } else {
            Utils.showToast(getCustomerDetailUsingGSTData!.message!, context);
          }
        },
        failure: (exception) {
          // Handle failure
          if (exception is ApiException) {
            if (exception.statusCode == 401) {
              Utils.showToast(exception.errorMessage, context);
              productProvider.disposeAllProviderData();
              ApiService().handle401(context);
            } else {
              Utils.showToast("Something went Wrong", context);
            }
          }
        },
      );
    }
  }

  Future<void> postLeadDSAPersonalDetail(
    BuildContext context,
    DataProvider productProvider,
  ) async {
    final prefsUtil = await SharedPref.getInstance();
    final String? userId = prefsUtil.getString(USER_ID);
    final int? companyId = prefsUtil.getInt(COMPANY_ID);
    final int? leadId = prefsUtil.getInt(LEADE_ID);
    final String? userMobileNumber = prefsUtil.getString(LOGIN_MOBILE_NUMBER);

    var postLeadDsaPersonalDetailReqModel = PostLeadDsaPersonalDetailReqModel(
      leadId: leadId,
      activityId: widget.activityId,
      subActivityId: widget.subActivityId,
      userId: userId,
      companyId: companyId,
      leadMasterId: leadId,
      gstRegistrationStatus: isGSTRegistered,
      gstNumber: _gstController.text,
      firmType: selectedFirmTypeValue,
      buisnessDocument: selectedBusinessTypeValue,
      documentId: businessProofDocId.toString(),
      companyName: _companyNameCl.text,
      fullName: _fullNameCl.text,
      fatherOrHusbandName: _fatherOrHusbandNameCl.text,
      alternatePhoneNo: _alternetMobileNumberCl.text,
      emailId: _emailIDCl.text,
      presentOccupation: _presentOccupationCl.text,
      noOfYearsInCurrentEmployment: _currentEmploymentCl.text,
      qualification: _qualificationCl.text,
      languagesKnown: selectedLanguageList.join(', '),
      workingWithOther: isPresentlyworking,
      referneceName: _referenceNames.text,
      referneceContact: _referenceContactNoCl.text,
      workingLocation: selectedWorkingLocationCity!.name!.toString(),
      address: _addressCl.text,
      city: cityId,
      state: stateId,
      pincode: _pinCodeCl.text,
      mobileNo: userMobileNumber,
      companyAddress: _companyAddressCl.text,
      companyCity: selectedCompanyCity!.id.toString(),
      companyState: selectedCompanyState!.id.toString(),
      companyPincode: _companyPinCodeCodeCl.text,
    );

    print("saveData${postLeadDsaPersonalDetailReqModel.toJson().toString()}");

    Utils.onLoading(context, "");
    await Provider.of<DataProvider>(context, listen: false)
        .postLeadDSAPersonalDetail(postLeadDsaPersonalDetailReqModel);
    Navigator.of(context, rootNavigator: true).pop();
    if (productProvider.getpostLeadDSAPersonalDetailData != null) {
      productProvider.getpostLeadDSAPersonalDetailData!.when(
        success: (data) {
          // Handle successful response
          var getpostLeadDSAPersonalDetailData = data;
          if (getpostLeadDSAPersonalDetailData.isSuccess!) {
            fetchData(context);
          }
        },
        failure: (exception) {
          // Handle failure
          if (exception is ApiException) {
            if (exception.statusCode == 401) {
              productProvider.disposeAllProviderData();
              ApiService().handle401(context);
            } else {
              Utils.showToast("Something went Wrong", context);
            }
          }
        },
      );
    }
  }

  void submitConnectorApi(
      BuildContext context, DataProvider productProvider) async {
    if (_firstNameController.text.trim().isEmpty) {
      Utils.showToast("Please Enter Full Name", context);
    } else if (_fatherNameController.text.trim().isEmpty) {
      Utils.showToast("Please Enter Father Name", context);
    } else if (slectedDate!.isEmpty) {
      Utils.showToast("Please Select Date Of Birth", context);
    } else if (_ageController.text.trim().isEmpty) {
      Utils.showToast("Please Enter age", context);
    } else if (_addreshController.text.trim().isEmpty) {
      Utils.showToast("Please Enter Address", context);
    } else if (_pincodeController.text.trim().isEmpty) {
      Utils.showToast("Please Enter Pin Code", context);
    } else if (_satateController.text.trim().isEmpty) {
      Utils.showToast("Please Enter State", context);
    } else if (_cityController.text.trim().isEmpty) {
      Utils.showToast("Please Enter City", context);
    } else if (_alternetMobileNumberController.text.trim().isEmpty) {
      Utils.showToast("Please Enter Alternate Mobile Number", context);
    } else if (!Utils.isPhoneNoValid(
        _alternetMobileNumberController.text.trim())) {
      Utils.showToast("Please Enter Valid Alternate Mobile Number", context);
    } else if (_emailIDController.text.trim().isEmpty) {
      Utils.showToast("Please Enter Email ID", context);
    } else if (!Utils.validateEmail(_emailIDController.text)) {
      Utils.showToast("Please enter Valid Email ID", context);
    } else if (!isValidEmail) {
      Utils.showToast("Please verify Email Id", context);
    } else if (_presentEmpolymentController.text.trim().isEmpty) {
      Utils.showToast("Please Enter present Employment", context);
    } else if (selectedLanguageList.isEmpty) {
      Utils.showToast("Please select known Languages", context);
    } else if (workingWithParty.isEmpty) {
      Utils.showToast("Please Select Party", context);
    } else if (_refranceNameController.text.trim().isEmpty) {
      Utils.showToast("Please Enter Reference Name ", context);
    } else if (_refranceContectController.text.trim().isEmpty) {
      Utils.showToast("Please Enter Reference Contact No ", context);
    } else if (!Utils.isPhoneNoValid(_refranceContectController.text.trim())) {
      Utils.showToast("Please Enter Valid Reference Contact No", context);
    } else if (selectedWorkingLocationCity == null) {
      Utils.showToast("Please enter working Location", context);
    } else {
      Utils.onLoading(context, "");
      final prefsUtil = await SharedPref.getInstance();
      int? leadID = prefsUtil.getInt(LEADE_ID);
      String? userID = prefsUtil.getString(USER_ID);
      int? companyID = prefsUtil.getInt(COMPANY_ID);
      final String? loginMobilNumber = prefsUtil.getString(LOGIN_MOBILE_NUMBER);
      var submitModel = ConnectorInfoReqModel(
          leadId: leadID,
          activityId: widget.activityId,
          subActivityId: widget.subActivityId,
          userId: userID,
          companyId: companyID,
          leadMasterId: leadID,
          fullName: _firstNameController.text.toString(),
          fatherName: _fatherNameController.text.toString(),
          alternatePhoneNo: _alternetMobileNumberController.text.toString(),
          emailId: _emailIDController.text.toString(),
          presentEmployment: _presentEmpolymentController.text.toString(),
          languagesKnown: selectedLanguageList.join(', '),
          workingWithOther: workingWithParty,
          referenceName: _refranceNameController.text.toString(),
          referneceContact: _refranceContectController.text.toString(),
          WorkingLocation: selectedWorkingLocationCity!.id!.toString(),
          currentAddressId: 0,
          mobileNo: loginMobilNumber,
          City: connectorInfoResponceModel!.cityId.toString(),
          State: connectorInfoResponceModel!.stateId!.toString(),
          Pincode: connectorInfoResponceModel!.pincode!.toString(),
          Address: connectorInfoResponceModel!.address!);
      print(submitModel.toJson().toString());
      await productProvider.submitConnectorData(submitModel);
      Navigator.of(context, rootNavigator: true).pop();
      if (productProvider.getConnectorSubmitData != null) {
        productProvider.getConnectorSubmitData!.when(
          success: (data) {
            if (data.isSuccess!) {
              fetchData(context);
            } else {
              Utils.showToast(data.message!, context);
            }
          },
          failure: (exception) {
            if (exception is ApiException) {
              if (exception.statusCode == 401) {
                Utils.showToast(exception.errorMessage, context);
                productProvider.disposeAllProviderData();
                ApiService().handle401(context);
              }
            }
          },
        );
      }
    }
  }

  Future<void> fetchData(BuildContext context) async {
    final prefsUtil = await SharedPref.getInstance();
    final activityId = widget.activityId;
    final subActivityId = widget.subActivityId;

    try {
      final leadCurrentRequestModel = LeadCurrentRequestModel(
        companyId: prefsUtil.getInt(COMPANY_ID),
        productId: prefsUtil.getInt(PRODUCT_ID),
        leadId: prefsUtil.getInt(LEADE_ID),
        mobileNo: prefsUtil.getString(LOGIN_MOBILE_NUMBER),
        activityId: activityId,
        subActivityId: subActivityId,
        userId: prefsUtil.getString(USER_ID),
        monthlyAvgBuying: 0,
        vintageDays: 0,
        isEditable: true,
      );

      final leadCurrentActivityAsyncData = await ApiService()
              .leadCurrentActivityAsync(leadCurrentRequestModel, context)
          as LeadCurrentResponseModel?;

      final getLeadData = await ApiService().getLeads(
        prefsUtil.getString(LOGIN_MOBILE_NUMBER)!,
        prefsUtil.getInt(PRODUCT_ID)!,
        prefsUtil.getInt(COMPANY_ID)!,
        prefsUtil.getInt(LEADE_ID)!,
      ) as GetLeadResponseModel?;

      customerSequence(
          context, getLeadData, leadCurrentActivityAsyncData, "push");
    } catch (error) {
      if (kDebugMode) {
        print('Error occurred during API call: $error');
      }
    }
  }

  void dSAPersonalInfoApi(BuildContext context) async {
    final prefsUtil = await SharedPref.getInstance();
    String? userId = prefsUtil.getString(USER_ID);
    Utils.onLoading(context, "");
    final String? productCode = prefsUtil.getString(PRODUCT_CODE);
    Provider.of<DataProvider>(context, listen: false)
        .getDSAPersonalInfo(context, userId!, productCode!);
  }

  void getDSAPersonalDetail(BuildContext) async {
    final prefsUtil = await SharedPref.getInstance();
    String? userId = prefsUtil.getString(USER_ID);
    final String? productCode = prefsUtil.getString(PRODUCT_CODE);
    Provider.of<DataProvider>(context, listen: false)
        .getDsaPersonalDetail(userId!, productCode!);
    Provider.of<DataProvider>(context, listen: false).getAllState();
    Provider.of<DataProvider>(context, listen: false).getEducationMasterList();
    Provider.of<DataProvider>(context, listen: false).getLangauageMasterList();
    Provider.of<DataProvider>(context, listen: false)
        .getWorkingLocationAllState();
    Navigator.of(context, rootNavigator: true).pop();
    DSAPersonalDetailAPICAll = false;
  }

  void getConnectorInfoApi() async {
    final prefsUtil = await SharedPref.getInstance();
    String? userId = prefsUtil.getString(USER_ID);
    final String? productCode = prefsUtil.getString(PRODUCT_CODE);
    Provider.of<DataProvider>(context, listen: false)
        .getConnectorInfo(userId!, productCode!);
    Provider.of<DataProvider>(context, listen: false).getAllState();
    Provider.of<DataProvider>(context, listen: false).getEducationMasterList();
    Provider.of<DataProvider>(context, listen: false).getLangauageMasterList();
    Provider.of<DataProvider>(context, listen: false)
        .getWorkingLocationAllState();
    Navigator.of(context, rootNavigator: true).pop();
    ConnectorPersonalDetailAPICAll = false;
  }

  // This should be a call to the api or service or similar
  Future<List<String>> _getLanguageSearchRequestData(String query) async {
    return await Future.delayed(const Duration(seconds: 1), () {
      return languageList.where((e) {
        return e.toLowerCase().contains(query.toLowerCase());
      }).toList();
    });
  }

  Widget Dsa(DataProvider dataProvider) {
    if (DSAPersonalDetailAPICAll) {
      Navigator.of(context, rootNavigator: true).pop();
      getDSAPersonalDetail(context);
    }
    if (dataProvider.getDsaPersonalDetailData != null) {
      dataProvider.getDsaPersonalDetailData!.when(
        success: (data) {
          getDsaPersonalDetailData = data;
          if (updateData) {
            if (data.fullName != null) {
              _fullNameCl.text = data.fullName!;
            }
            if (data.fatherOrHusbandName != null) {
              _fatherOrHusbandNameCl.text = data.fatherOrHusbandName!;
            }
            if (data.dob != null) {
              var formateDob = Utils.dateFormate(context, data.dob!);
              selectedDate = data.dob!;
              _dobCl.text = formateDob;
            }
            if (data.age != null) {
              _ageCl.text = data.age!.toString();
            }
            if (data.address != null) {
              _addressCl.text = data.address!;
            }
            if (data.pinCode != null) {
              _pinCodeCl.text = data.pinCode!.toString();
            }
            if (data.city != null) {
              _cityCl.text = data.city!;
            }

            if (data.state != null) {
              _stateCl.text = data.state!;
            }
            if (data.alternatePhoneNo != null) {
              _alternetMobileNumberCl.text = data.alternatePhoneNo!;
            }
            if (data.emailId != null) {
              _emailIDCl.text = data.emailId!;
              isValidEmail = true;
            }
            if (data.presentOccupation != null) {
              _presentOccupationCl.text = data.presentOccupation!;
            }
            if (data.noOfYearsInCurrentEmployment != null) {
              _currentEmploymentCl.text = data.noOfYearsInCurrentEmployment!;
            }
            if (data.qualification != null) {
              _qualificationCl.text = data.qualification!;
            } else {
              _qualificationCl.text = "";
            }
            if (data.languagesKnown != null) {
              selectedLanguageList = data.languagesKnown!.split(', ');
            }
            if (data.workingLocation != null) {
              _locationCl.text = data.workingLocation!;
            }
            if (data.workingLocationCityId != null) {
              WorkingLocationCityId = data.workingLocationCityId!;
            }
            if (data.workingLocationStateId != null) {
              WorkingLocationStateId = data.workingLocationStateId!;
            }
            if (data.referneceName != null) {
              _referenceNames.text = data.referneceName!;
            }
            if (data.referneceContact != null) {
              _referenceContactNoCl.text = data.referneceContact!;
            }
            if (data.gstNumber != null) {
              _gstController.text = data.gstNumber!;
              gstNumber = data.gstNumber!;
              gstUpdate = false;
              isValidGST = true;
              isGstFilled = true;
            }
            if (data.firmType != null) {
              selectedFirmTypeValue = data.firmType!;
            }
            if (data.buisnessDocument != null) {
              selectedBusinessTypeValue = data.buisnessDocument!;
            }

            if (data.companyName != null) {
              _companyNameCl.text = data.companyName!;
            }

            if (data.cityId != null) {
              cityId = data.cityId!;
            }

            if (data.stateId != null) {
              stateId = data.stateId!;
            }

            if (data.buisnessDocImg != null && !isImageDelete) {
              image = data.buisnessDocImg!;
              businessProofDocId = int.parse(data.documentId!.toString());
            }

            if (data.companyAddress != null) {
              _companyAddressCl.text = data.companyAddress!;
            }
            if (data.companyPinCode != null) {
              _companyPinCodeCodeCl.text = data.companyPinCode!;
            }

            if (setStateListFirstTime) {
              if (data.companyState != null) {
                _companyStateCl.text = data.companyState!;
              }
              if (data.companyStateId != null) {
                companyStateId = data.companyStateId!;
              }
              if (setCityListFirstTime && setStateListFirstTime) {
                if (data.companyCity != null) {
                  _companyCityCl.text = data.companyCity!;
                }

                if (data.companyCityId != null) {
                  companyCityId = data.companyCityId!;
                }
              }
            }

            if (data.workingWithOther != null) {
              if (!isWorkingWithOtherChange) {
                isPresentlyworking = data.workingWithOther!;
              }
            }
            if (data.gstStatus != null) {
              if (!isGstStatusChange) {
                isGSTRegistered = data.gstStatus!;
              }
            }

            updateData = false;
          }
        },
        failure: (exception) {
          if (exception is ApiException) {
            if (exception.statusCode == 401) {
              ApiService().handle401(context);
            } else {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Utils.showToast(exception.errorMessage, context);
              });
            }
          }
        },
      );
    }
    if (dataProvider.getpostDSABusineesDoumentSingleFileData != null &&
        !isImageDelete) {
      if (dataProvider.getpostDSABusineesDoumentSingleFileData!.filePath !=
          null) {
        image = dataProvider.getpostDSABusineesDoumentSingleFileData!.filePath!;
        businessProofDocId =
            dataProvider.getpostDSABusineesDoumentSingleFileData!.docId!;
      }
    }

    if (dataProvider.getEducationMasterListResponseData != null) {
      if (dataProvider.getEducationMasterListResponseData!.returnObject !=
          null) {
        _qualificationList =
            dataProvider.getEducationMasterListResponseData!.returnObject!;
        if (_qualificationList.isNotEmpty &&
            _qualificationCl.text.trim().isNotEmpty) {
          initialQualification = _qualificationList.firstWhere(
            (element) => element?.name == _qualificationCl.text.toString(),
          );
        }
      }
    }

    if (dataProvider.getLangauageMasterListResponseData != null) {
      if (dataProvider.getLangauageMasterListResponseData!.returnObject !=
          null) {
        languageList = dataProvider
            .getLangauageMasterListResponseData!.returnObject!
            .map((language) => language.name ?? '')
            .toList();
      }
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 0.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 30),
            Center(
              child: Text('Sign Up',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.urbanist(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  )),
            ),
            const SizedBox(
              height: 16.0,
            ),
            Center(
              child: Text('Please enter below details',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.urbanist(
                    fontSize: 15,
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                  )),
            ),
            const SizedBox(
              height: 16.0,
            ),
            CommonTextField(
              controller: _fullNameCl,
              enabled: false,
              hintText: "Full Name",
              labelText: "Full Name",
            ),
            const SizedBox(
              height: 16.0,
            ),
            CommonTextField(
              controller: _fatherOrHusbandNameCl,
              enabled: false,
              hintText: "Father’s / Husband’s Name",
              labelText: "Father’s / Husband’s Name",
            ),
            const SizedBox(
              height: 16.0,
            ),
            Stack(
              children: [
                CommonTextField(
                  controller: _dobCl,
                  enabled: false,
                  keyboardType: TextInputType.number,
                  hintText: "Date of Birth",
                  labelText: "Date of Birth",
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 16.0, right: 8.0),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Icon(
                      Icons.date_range,
                      color: kPrimaryColor,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 16.0,
            ),
            CommonTextField(
              controller: _ageCl,
              enabled: false,
              keyboardType: TextInputType.number,
              hintText: "Age",
              labelText: "Age",
            ),
            const SizedBox(
              height: 16.0,
            ),
            CommonTextField(
              controller: _addressCl,
              enabled: false,
              hintText: "Address",
              labelText: "Address",
            ),
            const SizedBox(
              height: 16.0,
            ),
            CommonTextField(
              controller: _pinCodeCl,
              enabled: false,
              inputFormatter: [
                FilteringTextInputFormatter.allow(RegExp((r'[0-9]'))),
                LengthLimitingTextInputFormatter(6)
              ],
              keyboardType: TextInputType.number,
              hintText: "PIN Code",
              labelText: "PIN Code",
            ),
            const SizedBox(
              height: 16.0,
            ),
            CommonTextField(
              controller: _cityCl,
              enabled: false,
              hintText: "City",
              labelText: "City",
            ),
            const SizedBox(
              height: 16.0,
            ),
            CommonTextField(
              controller: _stateCl,
              enabled: false,
              hintText: "State",
              labelText: "State",
            ),
            const SizedBox(
              height: 16.0,
            ),
            CommonTextField(
              controller: _alternetMobileNumberCl,
              enabled: true,
              inputFormatter: [
                FilteringTextInputFormatter.allow(RegExp((r'[0-9]'))),
                LengthLimitingTextInputFormatter(10)
              ],
              keyboardType: TextInputType.number,
              hintText: "Alternate Contact Number",
              labelText: "Alternate Contact Number",
            ),
            SizedBox(height: 16),
            Stack(
              children: [
                CommonTextField(
                  controller: _emailIDCl,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  enabled: !isValidEmail,
                  hintText: "E-mail ID",
                  labelText: "E-mail ID",
                  maxLines: 1,
                ),
                _emailIDCl.text.isNotEmpty
                    ? Positioned(
                        right: 0,
                        top: 0,
                        bottom: 0,
                        child: Container(
                          child: IconButton(
                            onPressed: () => setState(() {
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
            Text(
              "*Please enter correct email, we will send the agreement document on this email.",
              style: GoogleFonts.urbanist(
                fontSize: 10,
                color: Colors.red,
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.justify,
            ),
            (isValidEmail)
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
                          Utils.showToast(
                              "Please Enter Valid Email ID", context);
                        } else {
                          callEmailIDExist(context, _emailIDCl.text);
                        }
                      },
                      child: Text('Click here to Verify',
                          style: GoogleFonts.urbanist(
                            fontSize: 16,
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                            fontWeight: FontWeight.w400,
                          )),
                    )),
            SizedBox(height: 16),
            CommonTextField(
              controller: _presentOccupationCl,
              enabled: true,
              hintText: "Present Occupation",
              labelText: "Present Occupation",
            ),
            const SizedBox(
              height: 16.0,
            ),
            CommonTextField(
              controller: _currentEmploymentCl,
              keyboardType: TextInputType.number,
              enabled: true,
              inputFormatter: [
                FilteringTextInputFormatter.allow(RegExp((r'[0-9]'))),
                LengthLimitingTextInputFormatter(3)
              ],
              hintText: "No of years in current employment",
              labelText: "No of years in current employment",
            ),
            const SizedBox(
              height: 16.0,
            ),
            /*CommonTextField(
              controller: _qualificationCl,
              enabled: true,
              hintText: "Qualification",
              labelText: "Qualification",
              keyboardType: TextInputType.text,
              inputFormatter: [
                FilteringTextInputFormatter.allow(RegExp((r'[A-Za-z ]'))),
              ],
            ),*/
            Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(11),
                      color: kPrimaryColor,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(1.0),
                      child: CustomDropdown<QualificationList>(
                        hintText: 'Select Qualification',
                        items: _qualificationList,
                        initialItem: initialQualification,
                        onChanged: (value) {
                          print('changing value to: $value');
                          _qualificationCl.text = value.toString();
                        },
                        decoration: CustomDropdownDecoration(
                          headerStyle: GoogleFonts.urbanist(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.w400,
                          ),
                          hintStyle: GoogleFonts.urbanist(
                            fontSize: 16,
                            color: Colors.grey,
                            fontWeight: FontWeight.w400,
                          ),
                          closedBorderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 0, // Adjust the vertical position as needed
                  left: 16, // Adjust the horizontal position as needed
                  child: Container(
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: Text(
                        'Qualification', // Your label text
                        style: GoogleFonts.urbanist(
                          fontSize: 12,
                          color: Colors.grey[900], // Adjust color as needed
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 16.0,
            ),
            /*CommonTextField(
              controller: _languagesKnownCl,
              enabled: true,
              hintText: "Languages Known",
              labelText: "Languages Known",
              inputFormatter: [
                FilteringTextInputFormatter.allow(RegExp((r'[A-Za-z, ]'))),
              ],
            ),*/
            Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(11),
                      color: kPrimaryColor,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(1.0),
                      child: CustomDropdown<String>.multiSelectSearchRequest(
                        futureRequest: _getLanguageSearchRequestData,
                        items: languageList,
                        initialItems: selectedLanguageList,
                        decoration: CustomDropdownDecoration(
                          headerStyle: GoogleFonts.urbanist(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.w400,
                          ),
                          hintStyle: GoogleFonts.urbanist(
                            fontSize: 16,
                            color: Colors.grey,
                            fontWeight: FontWeight.w400,
                          ),
                          closedBorderRadius: BorderRadius.circular(10),
                        ),
                        hintText: 'Select Language',
                        // Attach the ScrollController
                        onListChanged: (value) {
                          print('changing value to: $value');
                          selectedLanguageList = value;
                        },
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 0, // Adjust the vertical position as needed
                  left: 16, // Adjust the horizontal position as needed
                  child: Container(
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: Text(
                        'Language', // Your label text
                        style: GoogleFonts.urbanist(
                          fontSize: 12,
                          color: Colors.grey[900], // Adjust color as needed
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20.0,
            ),
            /*CommonTextField(
              controller: _locationCl,
              enabled: true,
              hintText: "Location",
              labelText: "Location",
            ),*/
            Text('Working Location ',
                textAlign: TextAlign.left,
                style: GoogleFonts.urbanist(
                  fontSize: 14,
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
                )),
            const SizedBox(
              height: 8.0,
            ),
            buildWorkingLocationStateField(dataProvider),
            const SizedBox(
              height: 16.0,
            ),
            buildWorkingLocationCityField(dataProvider),
            const SizedBox(
              height: 16.0,
            ),
            Text(
                'Presently working with other Party/bank/NBFC /Financial Institute? ',
                textAlign: TextAlign.left,
                style: GoogleFonts.urbanist(
                  fontSize: 14,
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
                )),
            const SizedBox(
              height: 16.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: CustomRadioButton(
                    value: 'Yes',
                    groupValue: isPresentlyworking,
                    onChanged: _handleRadioValueWorkingWithOtherChanged,
                    text: "Yes",
                  ),
                ),
                SizedBox(height: 20),
                Expanded(
                  child: CustomRadioButton(
                    value: 'No',
                    groupValue: isPresentlyworking,
                    onChanged: _handleRadioValueWorkingWithOtherChanged,
                    text: "No",
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 16.0,
            ),
            Text('Reference ',
                textAlign: TextAlign.left,
                style: GoogleFonts.urbanist(
                  fontSize: 14,
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
                )),
            const SizedBox(
              height: 16.0,
            ),
            CommonTextField(
              controller: _referenceNames,
              enabled: true,
              hintText: "Names",
              labelText: "Names",
              inputFormatter: [
                FilteringTextInputFormatter.allow(RegExp((r'[A-Za-z ]'))),
              ],
            ),
            const SizedBox(
              height: 16.0,
            ),
            CommonTextField(
              controller: _referenceContactNoCl,
              enabled: true,
              inputFormatter: [
                FilteringTextInputFormatter.allow(RegExp((r'[0-9]'))),
                LengthLimitingTextInputFormatter(10)
              ],
              keyboardType: TextInputType.number,
              hintText: "Contact No. ",
              labelText: "Contact No.",
            ),
            const SizedBox(
              height: 16.0,
            ),
            Text('GST Registration Status ',
                textAlign: TextAlign.left,
                style: GoogleFonts.urbanist(
                  fontSize: 14,
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
                )),
            const SizedBox(
              height: 8.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: CustomRadioButton(
                    value: 'Yes',
                    groupValue: isGSTRegistered,
                    onChanged: _handleRadioValueChanged,
                    text: "GST Registered",
                  ),
                ),
                SizedBox(height: 20),
                Expanded(
                  child: CustomRadioButton(
                    value: 'No',
                    groupValue: isGSTRegistered,
                    onChanged: _handleRadioValueChanged,
                    text: "Non GST Registered",
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 16.0,
            ),
            Stack(
              children: [
                isGSTRegistered == "No"
                    ? Container()
                    : CommonTextField(
                        controller: _gstController,
                        hintText: "GST Number",
                        keyboardType: TextInputType.text,
                        enabled: gstUpdate,
                        labelText: "GST Number",
                        textCapitalization: TextCapitalization.characters,
                        inputFormatter: [
                          FilteringTextInputFormatter.allow(
                              RegExp((r'[A-Z0-9]'))),
                          LengthLimitingTextInputFormatter(15)
                        ],
                        onChanged: (text) async {
                          if (text.length == 15) {
                            try {
                              Utils.hideKeyBored(context);

                              await callDSAGSTExist(
                                  context, _gstController.text, dataProvider);
                            } catch (error) {
                              debugPrint('Error: $error');
                            }
                          }
                        }),
                Positioned(
                  top: 0,
                  right: 0,
                  bottom: 0,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        isGstStatusChange = true;
                        _gstController.clear();
                        _companyNameCl.clear();
                        _companyAddressCl.clear();
                        _companyPinCodeCodeCl.clear();
                        companyCityId = null;
                        companyStateId = null;
                        selectedCompanyCity = null;
                        selectedCompanyState = null;
                        isValidGST = false;
                        isImageDelete = true;
                        gstUpdate = true;
                        setCityListFirstTime = false;
                        businessProofDocId = null;
                        selectedFirmTypeValue = null;
                        selectedStateValue = null;
                        selectedCityValue = null;
                        selectedBusinessTypeValue = null;
                        isClearData = true;
                        gstNumber = "";
                        image = "";
                        isGstFilled = false;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      child: SvgPicture.asset(
                        'assets/icons/edit_icon.svg',
                        semanticsLabel: 'Edit Icon SVG',
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 16.0,
            ),
            Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: DropdownButtonFormField2<String>(
                    isExpanded: true,
                    decoration: InputDecoration(
                      fillColor: textFiledBackgroundColour,
                      filled: true,
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 16, horizontal: 8),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide:
                            const BorderSide(color: kPrimaryColor, width: 1),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide:
                            const BorderSide(color: kPrimaryColor, width: 1),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide:
                            const BorderSide(color: kPrimaryColor, width: 1),
                      ),
                    ),
                    hint: Text(
                      'Firm Type',
                      style: GoogleFonts.urbanist(
                        fontSize: 15,
                        color: blackSmall,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    items: businessTypeList.map((String item) {
                      return DropdownMenuItem<String>(
                        value: item,
                        child: Text(
                          item,
                          style: GoogleFonts.urbanist(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      );
                    }).toList(),
                    value: selectedFirmTypeValue,
                    onChanged: (String? value) {
                      selectedFirmTypeValue = value;
                    },
                    dropdownStyleData: DropdownStyleData(
                      maxHeight: 400,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    menuItemStyleData: const MenuItemStyleData(
                      padding: EdgeInsets.only(left: 16, right: 16, bottom: 16),
                    ),
                    iconStyleData: IconStyleData(
                      icon: Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Icon(Icons.keyboard_arrow_down),
                      ), // Down arrow icon when closed
                      openMenuIcon: Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Icon(Icons.keyboard_arrow_up),
                      ), // Up arrow icon when open
                    ),
                  ),
                ),
                Positioned(
                  top: 0, // Adjust the vertical position as needed
                  left: 16, // Adjust the horizontal position as needed
                  child: Container(
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: Text(
                        'Firm Type', // Your label text
                        style: GoogleFonts.urbanist(
                          fontSize: 12,
                          color: Colors.grey[900], // Adjust color as needed
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 16.0,
            ),
            Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: DropdownButtonFormField2<String>(
                    isExpanded: true,
                    decoration: InputDecoration(
                      fillColor: textFiledBackgroundColour,
                      filled: true,
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 16, horizontal: 8),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide:
                            const BorderSide(color: kPrimaryColor, width: 1),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide:
                            const BorderSide(color: kPrimaryColor, width: 1),
                      ),
                      enabledBorder: gstUpdate
                          ? OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                  color: kPrimaryColor, width: 1),
                            )
                          : OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide:
                                  const BorderSide(color: gryColor, width: 1),
                            ),
                    ),
                    hint: Text(
                      'Business Document',
                      style: GoogleFonts.urbanist(
                        fontSize: 15,
                        color: blackSmall,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    items: chooseBusinessProofList.map((String item) {
                      return DropdownMenuItem<String>(
                        value: item,
                        child: Text(
                          item,
                          style: GoogleFonts.urbanist(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      );
                    }).toList(),
                    value: selectedBusinessTypeValue,
                    onChanged: gstUpdate
                        ? (String? value) {
                            selectedBusinessTypeValue = value;
                          }
                        : null,
                    dropdownStyleData: DropdownStyleData(
                      maxHeight: 400,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    menuItemStyleData: const MenuItemStyleData(
                      padding: EdgeInsets.only(left: 16, right: 16, bottom: 16),
                    ),
                    iconStyleData: IconStyleData(
                      icon: Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Icon(Icons.keyboard_arrow_down),
                      ), // Down arrow icon when closed
                      openMenuIcon: Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Icon(Icons.keyboard_arrow_up),
                      ), // Up arrow icon when open
                    ),
                  ),
                ),
                Positioned(
                  top: 0, // Adjust the vertical position as needed
                  left: 16, // Adjust the horizontal position as needed
                  child: Container(
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: Text(
                        'Business Document', // Your label text
                        style: GoogleFonts.urbanist(
                          fontSize: 12,
                          color: Colors.grey[900], // Adjust color as needed
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            Stack(
              children: [
                Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: const Color(0xff0196CE))),
                    width: double.infinity,
                    child: GestureDetector(
                      onTap: () {
                        bottomSheetMenu(context, true, true, true);
                      },
                      child: Container(
                        height: 148,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: const Color(0xffEFFAFF),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Container(
                          child: (image.isNotEmpty)
                              ? image.contains(".pdf")
                                  ? const Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.picture_as_pdf),
                                      ],
                                    )
                                  : ClipRRect(
                                      borderRadius: BorderRadius.circular(8.0),
                                      child: Image.network(
                                        image,
                                        fit: BoxFit.cover,
                                        width: double.infinity,
                                        height: 148,
                                      ),
                                    )
                              : (image.isNotEmpty)
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(8.0),
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
                                          'Upload Document',
                                          style: TextStyle(
                                              color: Color(0xff0196CE),
                                              fontSize: 12),
                                        ),
                                        const Text('Supports : JPEG, PNG, PDF',
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: Color(0xffCACACA))),
                                      ],
                                    ),
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
                  child: image.isNotEmpty
                      ? Container(
                          padding: const EdgeInsets.all(4),
                          alignment: Alignment.topRight,
                          child:
                              SvgPicture.asset('assets/icons/delete_icon.svg'),
                        )
                      : Container(),
                ),
              ],
            ),
            /* Stack(
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
                                    color: Colors.white,
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
                                                  'Upload Document',
                                                  style: TextStyle(
                                                      color: Color(0xff0196CE),
                                                      fontSize: 12),
                                                ),
                                                const Text(
                                                    'Supports : JPEG, PNG',
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        color:
                                                            Color(0xffCACACA))),
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
                      ),*/
            const SizedBox(
              height: 16.0,
            ),
            CommonTextField(
              controller: _companyNameCl,
              enabled: !isGstFilled,
              hintText: "Company Name",
              labelText: "Company Name",
            ),
            const SizedBox(
              height: 16.0,
            ),
            CommonTextField(
              controller: _companyAddressCl,
              enabled: !isGstFilled,
              hintText: "Address",
              labelText: "Address",
            ),
            const SizedBox(
              height: 16.0,
            ),
            CommonTextField(
              controller: _companyPinCodeCodeCl,
              enabled: !isGstFilled,
              inputFormatter: [
                FilteringTextInputFormatter.allow(RegExp((r'[0-9]'))),
                LengthLimitingTextInputFormatter(6)
              ],
              keyboardType: TextInputType.number,
              hintText: "PIN Code",
              labelText: "PIN Code",
            ),
            const SizedBox(
              height: 16.0,
            ),
            buildStateField(dataProvider),
            const SizedBox(
              height: 16.0,
            ),
            buildCityField(dataProvider),
            const SizedBox(height: 54.0),
            CommonElevatedButton(
              onPressed: () async {
                if (_fullNameCl.text.trim().isEmpty) {
                  Utils.showToast("Please enter Full Name", context);
                } else if (_fatherOrHusbandNameCl.text.trim().isEmpty) {
                  Utils.showToast("Please enter Father  Name", context);
                } else if (selectedDate!.isEmpty) {
                  Utils.showToast("Please Select Date ", context);
                } else if (_ageCl.text.trim().isEmpty) {
                  Utils.showToast("Please enter Age ", context);
                } else if (_addressCl.text.trim().isEmpty) {
                  Utils.showToast("Please enter Address", context);
                } else if (_pinCodeCl.text.trim().isEmpty) {
                  Utils.showToast("Please enter Pin Code ", context);
                } else if (_cityCl.text.trim().isEmpty) {
                  Utils.showToast("Please enter City", context);
                } else if (_stateCl.text.trim().isEmpty) {
                  Utils.showToast("Please enter State", context);
                } else if (_alternetMobileNumberCl.text.trim().isEmpty) {
                  Utils.showToast(
                      "Please enter Alternate Mobile Number ", context);
                } else if (_emailIDCl.text.trim().isEmpty) {
                  Utils.showToast("Enter email address", context);
                } else if (!Utils.validateEmail(_emailIDCl.text)) {
                  Utils.showToast("Please enter Valid Email ID", context);
                } else if (!isValidEmail) {
                  Utils.showToast("Please verify Email Id", context);
                } else if (_presentOccupationCl.text.trim().isEmpty) {
                  Utils.showToast("Please enter Present Occupation ", context);
                } else if (_currentEmploymentCl.text.trim().isEmpty) {
                  Utils.showToast(
                      "Please enter No of years in current employment",
                      context);
                } else if (_qualificationCl.text.trim().isEmpty) {
                  Utils.showToast("Please enter Qualification", context);
                } else if (selectedLanguageList.isEmpty) {
                  Utils.showToast("Please select known Language", context);
                } else if (selectedWorkingLocationCity == null) {
                  Utils.showToast("Please enter Working Location", context);
                } else if (isPresentlyworking.isEmpty) {
                  Utils.showToast(
                      "Please Select  Presently working with other Party/bank/NBFC /Financial Institute?",
                      context);
                } else if (_referenceNames.text.trim().isEmpty) {
                  Utils.showToast("Please enter Reference Name", context);
                } else if (!Utils.isPhoneNoValid(
                    _referenceContactNoCl.text.trim())) {
                  Utils.showToast(
                      "Please enter valid reference contact number", context);
                } else if (isGSTRegistered.isEmpty) {
                  Utils.showToast(
                      "Please select GST Registered or Non GST Registered ",
                      context);
                } else if (isGSTRegistered == "Yes" &&
                    _gstController.text.trim().isEmpty) {
                  Utils.showToast("Please enter valid GST number", context);
                } else if (isGSTRegistered == "Yes" && !isValidGST) {
                  Utils.showToast("This GST number is already exist", context);
                } else if (isGSTRegistered == "Yes" && !isGstFilled) {
                  Utils.showToast("Please enter valid GST number", context);
                } else if (selectedFirmTypeValue == null) {
                  Utils.showToast("Please Select Firm Type", context);
                } else if (selectedBusinessTypeValue == null) {
                  Utils.showToast("Please Select Business Type", context);
                } else if (businessProofDocId == 0 ||
                    businessProofDocId == null) {
                  Utils.showToast("Please Upload Document", context);
                } else if (_companyNameCl.text.trim().isEmpty) {
                  Utils.showToast("Please enter Company Name", context);
                } else if (_companyAddressCl.text.trim().isEmpty) {
                  Utils.showToast("Please enter Company Address", context);
                } else if (_companyPinCodeCodeCl.text.trim().isEmpty) {
                  Utils.showToast(
                      "Please enter Company Address PinCode", context);
                } else if (_companyStateCl.text.trim().isEmpty) {
                  Utils.showToast("Please enter Company State", context);
                } else if (_companyCityCl.text.trim().isEmpty) {
                  Utils.showToast("Please enter Company City", context);
                } else {
                  await postLeadDSAPersonalDetail(context, dataProvider);
                }
              },
              text: 'Next',
              upperCase: true,
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget Connector(DataProvider productProvider) {
    if (ConnectorPersonalDetailAPICAll) {
      Navigator.of(context, rootNavigator: true).pop();
      getConnectorInfoApi();
    }
    if (productProvider.getConnectorInfoData != null) {
      if (productProvider.getConnectorInfoData != null) {
        productProvider.getConnectorInfoData!.when(
          success: (data) {
            connectorInfoResponceModel = data;

            if (connectorUpdateData) {
              _firstNameController.text = connectorInfoResponceModel!.fullName!;
              _fatherNameController.text =
                  connectorInfoResponceModel!.fatherName!;
              slectedDate =
                  Utils.dateFormate(context, connectorInfoResponceModel!.dob!);
              _ageController.text = connectorInfoResponceModel!.age.toString();
              _addreshController.text = connectorInfoResponceModel!.address!;

              if (connectorInfoResponceModel?.referenceName != null) {
                _refranceNameController.text =
                    connectorInfoResponceModel!.referenceName!;
              }

              if (connectorInfoResponceModel!.referneceContact != null) {
                _refranceContectController.text =
                    connectorInfoResponceModel!.referneceContact!;
              }

              if (connectorInfoResponceModel!.languagesKnown != null) {
                selectedLanguageList =
                    connectorInfoResponceModel!.languagesKnown!.split(', ');
              }

              if (connectorInfoResponceModel!.workingLocation != null) {
                _refranceLocationController.text =
                    connectorInfoResponceModel!.workingLocation!;
              }

              if (data.workingLocationCityId != null) {
                WorkingLocationCityId = data.workingLocationCityId!;
              }
              if (data.workingLocationStateId != null) {
                WorkingLocationStateId = data.workingLocationStateId!;
              }

              if (connectorInfoResponceModel!.presentEmployment != null) {
                _presentEmpolymentController.text =
                    connectorInfoResponceModel!.presentEmployment!;
              }

              if (connectorInfoResponceModel!.emailId != null) {
                _emailIDController.text = connectorInfoResponceModel!.emailId!;
                isValidEmail = true;
              }

              if (connectorInfoResponceModel!.emailId != null) {
                _alternetMobileNumberController.text =
                    connectorInfoResponceModel!.alternatePhoneNo!;
              }

              if (connectorInfoResponceModel!.state != null) {
                _satateController.text = connectorInfoResponceModel!.state!;
              }

              if (connectorInfoResponceModel!.city != null) {
                _cityController.text = connectorInfoResponceModel!.city!;
              }

              if (connectorInfoResponceModel!.pincode != null) {
                _pincodeController.text =
                    connectorInfoResponceModel!.pincode!.toString();
              }
              if (connectorInfoResponceModel!.workingWithOther != null &&
                  !isWorkingWithParty) {
                workingWithParty =
                    connectorInfoResponceModel!.workingWithOther!.toString();
              }
              connectorUpdateData = false;
            }
          },
          failure: (exception) {
            if (exception is ApiException) {
              if (exception.statusCode == 401) {
                productProvider.disposeAllProviderData();
                ApiService().handle401(context);
              }
            }
          },
        );
      }
    }

    if (productProvider.getLangauageMasterListResponseData != null) {
      if (productProvider.getLangauageMasterListResponseData!.returnObject !=
          null) {
        languageList = productProvider
            .getLangauageMasterListResponseData!.returnObject!
            .map((language) => language.name ?? '')
            .toList();
      }
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 30),
            Center(
              child: Text('Sign Up',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.urbanist(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  )),
            ),
            SizedBox(height: 30),
            Center(
              child: Text('Please enter below details',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.urbanist(
                    fontSize: 15,
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                  )),
            ),
            SizedBox(height: 30),
            CommonTextField(
              controller: _firstNameController,
              enabled: false,
              hintText: "Full Name",
              labelText: "Full Name",
            ),
            SizedBox(height: 20),
            CommonTextField(
              controller: _fatherNameController,
              enabled: false,
              hintText: "Father Name ",
              labelText: "Father Name",
            ),
            SizedBox(height: 20),
            Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: InkWell(
                    onTap: false ? () {} : null,
                    // Set onTap to null when field is disabled
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: textFiledBackgroundColour,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: gryColor),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              slectedDate!.isNotEmpty
                                  ? '$slectedDate'
                                  : 'Date of Birth',
                              style: const TextStyle(fontSize: 16.0),
                            ),
                            const Icon(
                              Icons.date_range,
                              color: kPrimaryColor,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 0, // Adjust the vertical position as needed
                  left: 16, // Adjust the horizontal position as needed
                  child: Container(
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: Text(
                        'Date of birth', // Your label text
                        style: GoogleFonts.urbanist(
                          fontSize: 12,
                          color: Colors.grey[900], // Adjust color as needed
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            CommonTextField(
              controller: _ageController,
              enabled: false,
              keyboardType: TextInputType.number,
              inputFormatter: [
                FilteringTextInputFormatter.allow(RegExp((r'[0-9]'))),
              ],
              hintText: "Age",
              labelText: "Age",
            ),
            SizedBox(height: 20),
            CommonTextField(
              controller: _addreshController,
              enabled: false,
              hintText: "Address",
              labelText: "Address",
            ),
            SizedBox(height: 20),
            CommonTextField(
              controller: _pincodeController,
              enabled: false,
              inputFormatter: [
                FilteringTextInputFormatter.allow(RegExp((r'[0-9]'))),
                LengthLimitingTextInputFormatter(6)
              ],
              keyboardType: TextInputType.number,
              hintText: "Pin Code",
              labelText: "Pin Code",
            ),
            SizedBox(height: 20),
            CommonTextField(
              controller: _satateController,
              enabled: false,
              hintText: "State",
              labelText: "State",
            ),
            SizedBox(height: 20),
            CommonTextField(
              controller: _cityController,
              enabled: false,
              hintText: "City",
              labelText: "City",
            ),
            SizedBox(height: 20),
            CommonTextField(
              controller: _alternetMobileNumberController,
              enabled: true,
              inputFormatter: [
                FilteringTextInputFormatter.allow(RegExp((r'[0-9]'))),
                LengthLimitingTextInputFormatter(10),
                FilteringTextInputFormatter.deny(
                  RegExp(r'^0+'), //users can't type 0 at 1st position
                ),
              ],
              keyboardType: TextInputType.number,
              hintText: "Alternate Contact Number",
              labelText: "Alternate Contact Number",
            ),
            SizedBox(height: 20),
            Stack(
              children: [
                CommonTextField(
                  controller: _emailIDController,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  enabled: !isValidEmail,
                  hintText: "E-mail ID",
                  labelText: "E-mail ID",
                  maxLines: 1,
                ),
                _emailIDController.text.isNotEmpty
                    ? Positioned(
                        right: 0,
                        top: 0,
                        bottom: 0,
                        child: Container(
                          child: IconButton(
                            onPressed: () => setState(() {
                              isValidEmail = false;
                              _emailIDController.clear();
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
            Text(
              "*Please enter correct email, we will send the agreement document on this email.",
              style: GoogleFonts.urbanist(
                fontSize: 10,
                color: Colors.red,
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.justify,
            ),
            SizedBox(height: 16),
            (isValidEmail)
                ? Container(
                    child: Row(
                      children: [
                        Text(
                          'VERIFIED',
                          style: GoogleFonts.urbanist(
                            fontSize: 16,
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                            fontWeight: FontWeight.w400,
                          ),
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
                        if (_emailIDController.text.isEmpty) {
                          Utils.showToast("Please Enter Email ID", context);
                        } else if (!Utils.validateEmail(
                            _emailIDController.text)) {
                          Utils.showToast(
                              "Please Enter Valid Email ID", context);
                        } else {
                          callEmailIDExist(context, _emailIDController.text);
                        }
                      },
                      child: Text('Click here to Verify',
                          style: GoogleFonts.urbanist(
                            fontSize: 16,
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                            fontWeight: FontWeight.w400,
                          )),
                    ),
                  ),
            SizedBox(height: 25),
            CommonTextField(
              controller: _presentEmpolymentController,
              enabled: true,
              hintText: "Present Employment",
              labelText: "Present Employment",
              keyboardType: TextInputType.text,
              inputFormatter: [
                FilteringTextInputFormatter.allow(RegExp((r'[A-Za-z ]'))),
              ],
            ),
            SizedBox(height: 20),
            /*CommonTextField(
              controller: _LanguagesController,
              enabled: true,
              hintText: "Languages Known",
              labelText: "Languages Known",
              keyboardType: TextInputType.text,
              inputFormatter: [
                FilteringTextInputFormatter.allow(RegExp((r'[A-Za-z, ]'))),
              ],
            ),*/
            Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(11),
                      color: kPrimaryColor,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(1.0),
                      child: CustomDropdown<String>.multiSelectSearchRequest(
                        futureRequest: _getLanguageSearchRequestData,
                        items: languageList,
                        initialItems: selectedLanguageList,
                        decoration: CustomDropdownDecoration(
                          headerStyle: GoogleFonts.urbanist(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.w400,
                          ),
                          hintStyle: GoogleFonts.urbanist(
                            fontSize: 16,
                            color: Colors.grey,
                            fontWeight: FontWeight.w400,
                          ),
                          closedBorderRadius: BorderRadius.circular(10),
                        ),
                        hintText: 'Select Language',
                        // Attach the ScrollController
                        onListChanged: (value) {
                          print('changing value to: $value');
                          selectedLanguageList = value;
                        },
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 0, // Adjust the vertical position as needed
                  left: 16, // Adjust the horizontal position as needed
                  child: Container(
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: Text(
                        'Language', // Your label text
                        style: GoogleFonts.urbanist(
                          fontSize: 12,
                          color: Colors.grey[900], // Adjust color as needed
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Text('Working Location ',
                textAlign: TextAlign.left,
                style: GoogleFonts.urbanist(
                  fontSize: 14,
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
                )),
            const SizedBox(
              height: 8.0,
            ),
            buildWorkingLocationStateField(productProvider),
            const SizedBox(
              height: 16.0,
            ),
            buildWorkingLocationCityField(productProvider),
            /*CommonTextField(
              controller: _refranceLocationController,
              enabled: true,
              hintText: "Location",
              labelText: "Location",
              inputFormatter: [
                FilteringTextInputFormatter.allow(RegExp((r'[A-Za-z,0-9 ]'))),
              ],
            ),*/
            SizedBox(height: 20),
            Text(
                "Presently working with other Party/bank/NBFC \nFinancial Institute?",
                style: GoogleFonts.urbanist(
                  fontSize: 14,
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
                )),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: CustomRadioButton(
                    value: 'Yes',
                    groupValue: workingWithParty,
                    onChanged: _handleRadioValueWorkingWithPartyChanged,
                    text: "Yes",
                  ),
                ),
                SizedBox(height: 20),
                Expanded(
                  child: CustomRadioButton(
                    value: 'No',
                    groupValue: workingWithParty,
                    onChanged: _handleRadioValueWorkingWithPartyChanged,
                    text: "No",
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Text("Reference",
                style: GoogleFonts.urbanist(
                  fontSize: 14,
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
                )),
            SizedBox(height: 20),
            CommonTextField(
              controller: _refranceNameController,
              enabled: true,
              hintText: "Name",
              labelText: "Name",
            ),
            SizedBox(height: 20),
            CommonTextField(
              controller: _refranceContectController,
              enabled: true,
              inputFormatter: [
                FilteringTextInputFormatter.allow(RegExp((r'[0-9]'))),
                LengthLimitingTextInputFormatter(10),
                FilteringTextInputFormatter.deny(
                  RegExp(r'^0+'), //users can't type 0 at 1st position
                ),
              ],
              keyboardType: TextInputType.number,
              hintText: "Contact No",
              labelText: "Contact No",
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Column(
                children: [
                  CommonElevatedButton(
                    onPressed: () async {
                      submitConnectorApi(context, productProvider);
                    },
                    text: "Next",
                    upperCase: true,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
