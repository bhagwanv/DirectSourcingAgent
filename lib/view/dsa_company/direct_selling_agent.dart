import 'dart:io';

import 'package:cupertino_date_time_picker_loki/cupertino_date_time_picker_loki.dart';
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
import '../../utils/customer_sequence_logic.dart';
import '../../utils/utils_class.dart';
import '../aadhaar_screen/components/CheckboxTerm.dart';
import '../personal_info/EmailOtpScreen.dart';
import '../personal_info/model/CityResponce.dart';
import '../personal_info/model/EmailExistRespoce.dart';
import '../personal_info/model/ReturnObject.dart';
import '../personal_info/model/SendOtpOnEmailResponce.dart';
import '../splash/model/GetLeadResponseModel.dart';
import '../splash/model/LeadCurrentRequestModel.dart';
import '../splash/model/LeadCurrentResponseModel.dart';
import 'model/CustomerDetailUsingGSTResponseModel.dart';
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
  final TextEditingController _businessDocumentNumberController =
      TextEditingController();

  bool _isSelected1 = false;
  bool _isSelected2 = false;
  bool _isGstSelected1 = false;
  bool _isGstSelected2 = false;
  var isPresentlyworking = "";
  var isGSTRegistered = "";
  var isValidEmail = false;
  var isEmailClear = false;
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

  void _handleCheckboxChange(int index, bool? value) {
    setState(() {
      isWorkingWithOtherChange = true;
      if (index == 1) {
        isPresentlyworking = "Yes";
        _isSelected1 = value!;
        _isSelected2 = !value;
      } else if (index == 2) {
        isPresentlyworking = "No";
        _isSelected2 = value!;
        _isSelected1 = !value;
      }
    });
  }

  void _handleGstCheckboxChange(int index, bool? value) {
    setState(() {
      isGstStatusChange = true;
      if (index == 1) {
        isGSTRegistered = "Yes";
        _isGstSelected1 = value!;
        _isGstSelected2 = !value;
      } else if (index == 2) {
        isGSTRegistered = "No";
        _gstController.text = "";
        _isGstSelected2 = value!;
        _isGstSelected1 = !value;
      }
    });
  }

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

  List<CityResponce?> citylist = [];
  var cityCallInitial = true;

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
  String? selectedChooseBusinessProofValue = null;

  var gstUpdate = false;
  var setStateListFirstTime = true;
  var setCityListFirstTime = true;
  CustomerDetailUsingGstResponseModel? getCustomerDetailUsingGSTData;
  GetDsaPersonalDetailResModel? getDsaPersonalDetailData;

  List<DropdownMenuItem<String>> _addDividersAfterItems(List<String> items) {
    final List<DropdownMenuItem<String>> menuItems = [];
    for (final String item in items) {
      menuItems.addAll(
        [
          DropdownMenuItem<String>(
            value: item,
            child: Text(
              item,
              style: const TextStyle(
                fontSize: 16,
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

  DateTime date = DateTime.now().subtract(const Duration(days: 1));

  String minDateTime = '2010-05-12';
  String maxDateTime = '2030-11-25';
  String initDateTime = '2021-08-31';

  final bool _showTitle = true;
  final DateTimePickerLocale _locale = DateTimePickerLocale.en_us;
  final String _format = 'yyyy-MMMM-dd';

  DateTime? _dateTime;
  String? selectedDate = "";

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
      return DropdownButtonFormField2<ReturnObject?>(
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
        hint: const Text(
          'State',
          style: TextStyle(
            color: blueColor,
            fontSize: 14.0,
            fontWeight: FontWeight.w500,
          ),
        ),
        items: getAllState(productProvider.getAllStateData!.returnObject!),
        onChanged: (ReturnObject? value) {
          setState(() {
            citylist.clear();
            setStateListFirstTime = false;
            Provider.of<DataProvider>(context, listen: false)
                .getAllCity(value!.id!);
            selectedStateValue = value.id!.toString();
            selectedCompanyCity = null;
            selectedCompanyState = value;
            companyCityId = null;
            companyStateId = null;
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
          customHeights: _getCustomItemsHeights2(
              productProvider.getAllStateData!.returnObject!),
        ),
        iconStyleData: const IconStyleData(
          openMenuIcon: Icon(Icons.arrow_drop_up),
        ),
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
      return DropdownButtonFormField2<CityResponce>(
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
        hint: const Text(
          'City',
          style: TextStyle(
            color: blueColor,
            fontSize: 14.0,
            fontWeight: FontWeight.w500,
          ),
        ),
        items: getAllCity(citylist),
        onChanged: (CityResponce? value) {
          setState(() {
            selectedCompanyCity = value;
            setCityListFirstTime = false;
            companyCityId = null;
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
          customHeights: _getCustomItemsHeights3(citylist),
        ),
        iconStyleData: const IconStyleData(
          openMenuIcon: Icon(Icons.arrow_drop_up),
        ),
      );
    } else {
      return Container();
    }
  }

  @override
  void initState() {
    super.initState();
    getDSAPersonalDetail(context);
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
            if (dataProvider.getDsaPersonalDetailData == null) {
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30.0, vertical: 0.0),
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
                        enabled: updateData,
                        hintText: "Full Name",
                        labelText: "Full Name",
                      ),
                      const SizedBox(
                        height: 16.0,
                      ),
                      CommonTextField(
                        controller: _fatherOrHusbandNameCl,
                        enabled: updateData,
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
                            padding:
                                EdgeInsets.only(top: 16.0, right: 8.0),
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
                        enabled: updateData,
                        keyboardType: TextInputType.number,
                        hintText: "Age",
                        labelText: "Age",
                      ),
                      const SizedBox(
                        height: 16.0,
                      ),
                      CommonTextField(
                        controller: _addressCl,
                        enabled: updateData,
                        hintText: "Address",
                        labelText: "Address",
                      ),
                      const SizedBox(
                        height: 16.0,
                      ),
                      CommonTextField(
                        controller: _pinCodeCl,
                        enabled: updateData,
                        keyboardType: TextInputType.number,
                        hintText: "PIN Code",
                        labelText: "PIN Code",
                      ),
                      const SizedBox(
                        height: 16.0,
                      ),
                      CommonTextField(
                        controller: _cityCl,
                        enabled: updateData,
                        hintText: "City",
                        labelText: "City",
                      ),
                      const SizedBox(
                        height: 16.0,
                      ),
                      CommonTextField(
                        controller: _stateCl,
                        enabled: updateData,
                        hintText: "State",
                        labelText: "State",
                      ),
                      const SizedBox(
                        height: 16.0,
                      ),
                      CommonTextField(
                        controller: _alternetMobileNumberCl,
                        enabled: updateData,
                        inputFormatter: [
                          FilteringTextInputFormatter.allow(
                              RegExp((r'[A-Z0-9]'))),
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
                            hintText: "E Mail id",
                            labelText: "E Mail id",
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      CommonTextField(
                        controller: _presentOccupationCl,
                        enabled: updateData,
                        hintText: "Present Occupation",
                        labelText: "Present Occupation",
                      ),
                      const SizedBox(
                        height: 16.0,
                      ),
                      CommonTextField(
                        controller: _currentEmploymentCl,
                        keyboardType: TextInputType.number,
                        enabled: updateData,
                        hintText: "No of years in current employment",
                        labelText: "No of years in current employment",
                      ),
                      const SizedBox(
                        height: 16.0,
                      ),
                      CommonTextField(
                        controller: _qualificationCl,
                        enabled: updateData,
                        hintText: "Qualification",
                        labelText: "Qualification",
                      ),
                      const SizedBox(
                        height: 16.0,
                      ),
                      CommonTextField(
                        controller: _languagesKnownCl,
                        enabled: updateData,
                        hintText: "Languages Known",
                        labelText: "Languages Known",
                      ),
                      const SizedBox(
                        height: 16.0,
                      ),
                      CommonTextField(
                        controller: _locationCl,
                        enabled: updateData,
                        hintText: "Location",
                        labelText: "Location",
                      ),
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
                        children: [
                          Expanded(
                            child: CheckboxTerm(
                              content: "Yes",
                              isChecked: _isSelected1,
                              onChanged: (bool? value) {
                                _handleCheckboxChange(1, value);
                              },
                            ),
                          ),
                          Expanded(
                            child: CheckboxTerm(
                              content: "No",
                              isChecked: _isSelected2,
                              onChanged: (bool? value) {
                                _handleCheckboxChange(2, value);
                              },
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
                        enabled: updateData,
                        hintText: "Names",
                        labelText: "Names",
                      ),
                      const SizedBox(
                        height: 16.0,
                      ),
                      CommonTextField(
                        controller: _referenceContactNoCl,
                        enabled: updateData,
                        inputFormatter: [
                          FilteringTextInputFormatter.allow(
                              RegExp((r'[A-Z0-9]'))),
                          LengthLimitingTextInputFormatter(10)
                        ],
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: CheckboxTerm(
                              content: "GST Registered",
                              isChecked: _isGstSelected1,
                              onChanged: (bool? value) {
                                _handleGstCheckboxChange(1, value);
                              },
                            ),
                          ),
                          Expanded(
                            child: CheckboxTerm(
                              content: "Not GST Registered",
                              isChecked: _isGstSelected2,
                              onChanged: (bool? value) {
                                _handleGstCheckboxChange(2, value);
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 16.0,
                      ),
                      Stack(
                        children: [
                          CommonTextField(
                              controller: _gstController,
                              hintText: "GST Number",
                              keyboardType: TextInputType.text,
                              enabled: updateData,
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
                                    await getCustomerDetailUsingGST(context,
                                        _gstController.text, dataProvider);
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
                              onTap: () {},
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
                      DropdownButtonFormField2<String>(
                        isExpanded: true,
                        decoration: InputDecoration(
                          fillColor: textFiledBackgroundColour,
                          filled: true,
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 16, horizontal: 8),
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
                            borderSide: const BorderSide(
                                color: kPrimaryColor, width: 1),
                          ),
                        ),
                        hint: const Text(
                          'Firm Type',
                          style: TextStyle(
                            color: blueColor,
                            fontSize: 16.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        items: _addDividersAfterItems(businessTypeList),
                        value: selectedFirmTypeValue,
                        onChanged: (String? value) {
                          selectedFirmTypeValue = value;
                        },
                        buttonStyleData: const ButtonStyleData(
                          padding: EdgeInsets.only(right: 8),
                        ),
                        dropdownStyleData: const DropdownStyleData(
                          maxHeight: 200,
                        ),
                        menuItemStyleData: MenuItemStyleData(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          customHeights:
                              _getCustomItemsHeights(businessTypeList),
                        ),
                        iconStyleData: const IconStyleData(
                          openMenuIcon: Icon(Icons.arrow_drop_up),
                        ),
                      ),
                      const SizedBox(
                        height: 16.0,
                      ),
                      DropdownButtonFormField2<String>(
                        isExpanded: true,
                        decoration: InputDecoration(
                          fillColor: textFiledBackgroundColour,
                          filled: true,
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 16, horizontal: 8),
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
                            borderSide: const BorderSide(
                                color: kPrimaryColor, width: 1),
                          ),
                        ),
                        hint: const Text(
                          'Business Document',
                          style: TextStyle(
                            color: blueColor,
                            fontSize: 16.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        items: _addDividersAfterItems(chooseBusinessProofList),
                        value: selectedBusinessTypeValue,
                        onChanged: (String? value) {
                          selectedBusinessTypeValue = value;
                        },
                        buttonStyleData: const ButtonStyleData(
                          padding: EdgeInsets.only(right: 8),
                        ),
                        dropdownStyleData: const DropdownStyleData(
                          maxHeight: 200,
                        ),
                        menuItemStyleData: MenuItemStyleData(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          customHeights:
                              _getCustomItemsHeights(chooseBusinessProofList),
                        ),
                        iconStyleData: const IconStyleData(
                          openMenuIcon: Icon(Icons.arrow_drop_up),
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
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
                      ),
                      const SizedBox(
                        height: 16.0,
                      ),
                      CommonTextField(
                        controller: _companyNameCl,
                        enabled: updateData,
                        hintText: "Company Name",
                        labelText: "Company Name",
                      ),
                      const SizedBox(
                        height: 16.0,
                      ),
                      CommonTextField(
                        controller: _companyAddressCl,
                        enabled: updateData,
                        hintText: "Address",
                        labelText: "Address",
                      ),
                      const SizedBox(
                        height: 16.0,
                      ),
                      CommonTextField(
                        controller: _companyPinCodeCodeCl,
                        enabled: updateData,
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
                        onPressed: () {},
                        text: 'Next',
                        upperCase: true,
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              );
            } else {
              if (dataProvider.getDsaPersonalDetailData != null) {
                dataProvider.getDsaPersonalDetailData!.when(
                  success: (data) {
                    getDsaPersonalDetailData = data;
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
                    }
                    if (data.presentOccupation != null) {
                      _presentOccupationCl.text = data.presentOccupation!;
                    }
                    if (data.noOfYearsInCurrentEmployment != null) {
                      _currentEmploymentCl.text =
                          data.noOfYearsInCurrentEmployment!;
                    }
                    if (data.qualification != null) {
                      _qualificationCl.text = data.qualification!;
                    }
                    if (data.languagesKnown != null) {
                      _languagesKnownCl.text = data.languagesKnown!;
                    }
                    if (data.workingLocation != null) {
                      _locationCl.text = data.workingLocation!;
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
              if (dataProvider.getpostDSABusineesDoumentSingleFileData !=
                      null &&
                  !isImageDelete) {
                if (dataProvider
                        .getpostDSABusineesDoumentSingleFileData!.filePath !=
                    null) {
                  image = dataProvider
                      .getpostDSABusineesDoumentSingleFileData!.filePath!;
                  print("atul$image");
                  businessProofDocId = dataProvider
                      .getpostDSABusineesDoumentSingleFileData!.docId!;
                }
              }
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30.0, vertical: 0.0),
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
                        enabled: updateData,
                        hintText: "Full Name",
                        labelText: "Full Name",
                      ),
                      const SizedBox(
                        height: 16.0,
                      ),
                      CommonTextField(
                        controller: _fatherOrHusbandNameCl,
                        enabled: updateData,
                        hintText: "Father’s / Husband’s Name",
                        labelText: "Father’s / Husband’s Name",
                      ),
                      const SizedBox(
                        height: 16.0,
                      ),
                      CommonTextField(
                        controller: _ageCl,
                        enabled: updateData,
                        keyboardType: TextInputType.number,
                        hintText: "Age",
                        labelText: "Age",
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
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 16.0, right: 8.0),
                            child: const Align(
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
                        enabled: updateData,
                        keyboardType: TextInputType.number,
                        hintText: "Age",
                        labelText: "Age",
                      ),
                      const SizedBox(
                        height: 16.0,
                      ),
                      CommonTextField(
                        controller: _addressCl,
                        enabled: updateData,
                        hintText: "Address",
                        labelText: "Address",
                      ),
                      const SizedBox(
                        height: 16.0,
                      ),
                      CommonTextField(
                        controller: _pinCodeCl,
                        enabled: updateData,
                        keyboardType: TextInputType.number,
                        hintText: "PIN Code",
                        labelText: "PIN Code",
                      ),
                      const SizedBox(
                        height: 16.0,
                      ),
                      CommonTextField(
                        controller: _cityCl,
                        enabled: updateData,
                        hintText: "City",
                        labelText: "City",
                      ),
                      const SizedBox(
                        height: 16.0,
                      ),
                      CommonTextField(
                        controller: _stateCl,
                        enabled: updateData,
                        hintText: "State",
                        labelText: "State",
                      ),
                      const SizedBox(
                        height: 16.0,
                      ),
                      CommonTextField(
                        controller: _alternetMobileNumberCl,
                        enabled: updateData,
                        inputFormatter: [
                          FilteringTextInputFormatter.allow(
                              RegExp((r'[A-Z0-9]'))),
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
                            hintText: "E Mail id",
                            labelText: "E Mail id",
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      CommonTextField(
                        controller: _presentOccupationCl,
                        enabled: updateData,
                        hintText: "Present Occupation",
                        labelText: "Present Occupation",
                      ),
                      const SizedBox(
                        height: 16.0,
                      ),
                      CommonTextField(
                        controller: _currentEmploymentCl,
                        keyboardType: TextInputType.number,
                        enabled: updateData,
                        hintText: "No of years in current employment",
                        labelText: "No of years in current employment",
                      ),
                      const SizedBox(
                        height: 16.0,
                      ),
                      CommonTextField(
                        controller: _qualificationCl,
                        enabled: updateData,
                        hintText: "Qualification",
                        labelText: "Qualification",
                      ),
                      const SizedBox(
                        height: 16.0,
                      ),
                      CommonTextField(
                        controller: _languagesKnownCl,
                        enabled: updateData,
                        hintText: "Languages Known",
                        labelText: "Languages Known",
                      ),
                      const SizedBox(
                        height: 16.0,
                      ),
                      CommonTextField(
                        controller: _locationCl,
                        enabled: updateData,
                        hintText: "Location",
                        labelText: "Location",
                      ),
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
                        children: [
                          Expanded(
                            child: CheckboxTerm(
                              content: "Yes",
                              isChecked: _isSelected1,
                              onChanged: (bool? value) {
                                isWorkingWithOtherChange = true;
                                _handleCheckboxChange(1, value);
                              },
                            ),
                          ),
                          Expanded(
                            child: CheckboxTerm(
                              content: "No",
                              isChecked: _isSelected2,
                              onChanged: (bool? value) {
                                isWorkingWithOtherChange = true;
                                _handleCheckboxChange(2, value);
                              },
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
                        enabled: updateData,
                        hintText: "Names",
                        labelText: "Names",
                      ),
                      const SizedBox(
                        height: 16.0,
                      ),
                      CommonTextField(
                        controller: _referenceContactNoCl,
                        enabled: updateData,
                        inputFormatter: [
                          FilteringTextInputFormatter.allow(
                              RegExp((r'[A-Z0-9]'))),
                          LengthLimitingTextInputFormatter(10)
                        ],
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: CheckboxTerm(
                              content: "GST Registered",
                              isChecked: _isGstSelected1,
                              onChanged: (bool? value) {
                                isGstStatusChange = true;
                                _handleGstCheckboxChange(1, value);
                              },
                            ),
                          ),
                          Expanded(
                            child: CheckboxTerm(
                              content: "Not GST Registered",
                              isChecked: _isGstSelected2,
                              onChanged: (bool? value) {
                                isGstStatusChange = true;
                                _handleGstCheckboxChange(2, value);
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 16.0,
                      ),
                      Stack(
                        children: [
                          CommonTextField(
                              controller: _gstController,
                              hintText: "GST Number",
                              keyboardType: TextInputType.text,
                              enabled: updateData,
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
                                    await getCustomerDetailUsingGST(context,
                                        _gstController.text, dataProvider);
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
                                  updateData = true;
                                  isImageDelete = true;
                                  gstUpdate = true;
                                  setCityListFirstTime = false;
                                  _gstController.text = "";
                                  _businessDocumentNumberController.text = "";
                                  selectedDate = "";
                                  businessProofDocId = null;
                                  selectedFirmTypeValue = null;
                                  selectedStateValue = null;
                                  selectedCityValue = null;
                                  selectedChooseBusinessProofValue = null;
                                  isClearData = true;
                                  gstNumber = "";
                                  image = "";
                                  isGstFilled = false;
                                  companyCityId = null;
                                  companyStateId = null;
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
                      DropdownButtonFormField2<String>(
                        isExpanded: true,
                        decoration: InputDecoration(
                          fillColor: textFiledBackgroundColour,
                          filled: true,
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 16, horizontal: 8),
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
                            borderSide: const BorderSide(
                                color: kPrimaryColor, width: 1),
                          ),
                        ),
                        hint: const Text(
                          'Firm Type',
                          style: TextStyle(
                            color: blueColor,
                            fontSize: 16.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        items: _addDividersAfterItems(businessTypeList),
                        value: selectedFirmTypeValue,
                        onChanged: (String? value) {
                          selectedFirmTypeValue = value;
                        },
                        buttonStyleData: const ButtonStyleData(
                          padding: EdgeInsets.only(right: 8),
                        ),
                        dropdownStyleData: const DropdownStyleData(
                          maxHeight: 200,
                        ),
                        menuItemStyleData: MenuItemStyleData(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          customHeights:
                              _getCustomItemsHeights(businessTypeList),
                        ),
                        iconStyleData: const IconStyleData(
                          openMenuIcon: Icon(Icons.arrow_drop_up),
                        ),
                      ),
                      const SizedBox(
                        height: 16.0,
                      ),
                      DropdownButtonFormField2<String>(
                        isExpanded: true,
                        decoration: InputDecoration(
                          fillColor: textFiledBackgroundColour,
                          filled: true,
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 16, horizontal: 8),
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
                            borderSide: const BorderSide(
                                color: kPrimaryColor, width: 1),
                          ),
                        ),
                        hint: const Text(
                          'Business Document',
                          style: TextStyle(
                            color: blueColor,
                            fontSize: 16.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        items: _addDividersAfterItems(chooseBusinessProofList),
                        value: selectedBusinessTypeValue,
                        onChanged: (String? value) {
                          selectedBusinessTypeValue = value;
                        },
                        buttonStyleData: const ButtonStyleData(
                          padding: EdgeInsets.only(right: 8),
                        ),
                        dropdownStyleData: const DropdownStyleData(
                          maxHeight: 200,
                        ),
                        menuItemStyleData: MenuItemStyleData(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          customHeights:
                              _getCustomItemsHeights(chooseBusinessProofList),
                        ),
                        iconStyleData: const IconStyleData(
                          openMenuIcon: Icon(Icons.arrow_drop_up),
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
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
                      ),
                      const SizedBox(
                        height: 16.0,
                      ),
                      CommonTextField(
                        controller: _companyNameCl,
                        enabled: updateData,
                        hintText: "Company Name",
                        labelText: "Company Name",
                      ),
                      const SizedBox(
                        height: 16.0,
                      ),
                      CommonTextField(
                        controller: _companyAddressCl,
                        enabled: updateData,
                        hintText: "Address",
                        labelText: "Address",
                      ),
                      const SizedBox(
                        height: 16.0,
                      ),
                      CommonTextField(
                        controller: _companyPinCodeCodeCl,
                        enabled: updateData,
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
                          if (_fullNameCl.text.isEmpty) {
                            Utils.showToast("Please Enter Full Name", context);
                          } else if (_fatherOrHusbandNameCl.text.isEmpty) {
                            Utils.showToast(
                                "Please Enter Father  Name", context);
                          } else if (selectedDate!.isEmpty) {
                            Utils.showToast("Please Select Date ", context);
                          } else if (_ageCl.text.isEmpty) {
                            Utils.showToast("Please Enter Age ", context);
                          } else if (_addressCl.text.isEmpty) {
                            Utils.showToast("Please Enter Address", context);
                          } else if (_pinCodeCl.text.isEmpty) {
                            Utils.showToast("Please Enter Pin Code ", context);
                          } else if (_cityCl.text.isEmpty) {
                            Utils.showToast("Please Enter City", context);
                          } else if (_stateCl.text.isEmpty) {
                            Utils.showToast("Please Enter State", context);
                          } else if (_alternetMobileNumberCl.text.isEmpty) {
                            Utils.showToast(
                                "Please Enter AlterNet Mobile Number ",
                                context);
                          } else if (_emailIDCl.text.isEmpty) {
                            Utils.showToast("Enter Email", context);
                          } else if (_presentOccupationCl.text.isEmpty) {
                            Utils.showToast(
                                "Please Enter Present Occupation ", context);
                          } else if (_currentEmploymentCl.text.isEmpty) {
                            Utils.showToast(
                                "Please Enter No of years in current employment",
                                context);
                          } else if (_qualificationCl.text.isEmpty) {
                            Utils.showToast(
                                "Please Enter Qualification", context);
                          } else if (_languagesKnownCl.text.isEmpty) {
                            Utils.showToast(
                                "Please Enter Languages Known", context);
                          } else if (_locationCl.text.isEmpty) {
                            Utils.showToast("Please Enter Location", context);
                          } else if (isPresentlyworking.isEmpty) {
                            Utils.showToast(
                                "Please Select  Presently working with other Party/bank/NBFC /Financial Institute?",
                                context);
                          } else if (_referenceNames.text.isEmpty) {
                            Utils.showToast(
                                "Please Enter Reference Name", context);
                          } else if (_referenceContactNoCl.text.isEmpty) {
                            Utils.showToast(
                                "Please Enter Reference Contact Number",
                                context);
                          } else if (isGSTRegistered.isEmpty) {
                            Utils.showToast(
                                "Please select GST Registered or Non GST Registered ",
                                context);
                          } else if (selectedFirmTypeValue == null) {
                            Utils.showToast("Please Select Firm Type", context);
                          } else if (selectedBusinessTypeValue == null) {
                            Utils.showToast(
                                "Please Select Business Type", context);
                          } else if (image.isEmpty) {
                            Utils.showToast("Please Upload Document", context);
                          } else if (_companyNameCl.text.isEmpty) {
                            Utils.showToast(
                                "Please Enter Company Name", context);
                          } else if (_companyAddressCl.text.isEmpty) {
                            Utils.showToast(
                                "Please Enter Company Address", context);
                          } else if (_companyPinCodeCodeCl.text.isEmpty) {
                            Utils.showToast(
                                "Please Enter Company Address PinCode",
                                context);
                          } else if (_companyCityCl.text.isEmpty) {
                            Utils.showToast(
                                "Please Enter Company City", context);
                          } else if (_companyStateCl.text.isEmpty) {
                            Utils.showToast(
                                "Please Enter Company State", context);
                          } else {
                            await postLeadDSAPersonalDetail(
                                context, dataProvider);
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
          }),
        ),
      ),
    );
  }

  void bottomSheetMenu(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (builder) {
          return ImagePickerWidgets(onImageSelected: _onImageSelected);
        });
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

  void getDSAPersonalDetail(BuildContext) async {
    final prefsUtil = await SharedPref.getInstance();
    String? userId = prefsUtil.getString(USER_ID);
    final String? productCode = prefsUtil.getString(PRODUCT_CODE);
    Provider.of<DataProvider>(context, listen: false)
        .getDsaPersonalDetail(userId!, productCode!);
    Provider.of<DataProvider>(context, listen: false).getAllState();
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
            selectedChooseBusinessProofValue = "GST Certificate";
            _businessDocumentNumberController.text =
                getCustomerDetailUsingGSTData!.busGSTNO!;
            companyStateId = getCustomerDetailUsingGSTData!.stateId.toString();
            companyCityId = getCustomerDetailUsingGSTData!.cityId.toString();
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
      languagesKnown: _languagesKnownCl.text,
      workingWithOther: isPresentlyworking,
      referneceName: _referenceNames.text,
      referneceContact: _referenceContactNoCl.text,
      workingLocation: _locationCl.text,
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

     Utils.onLoading(context, "Loading...");
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
        prefsUtil.getInt(COMPANY_ID)!,
        prefsUtil.getInt(PRODUCT_ID)!,
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
}
