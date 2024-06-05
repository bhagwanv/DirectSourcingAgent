import 'dart:io';

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
import '../../providers/DataProvider.dart';
import '../../shared_preferences/shared_pref.dart';
import '../../utils/common_elevted_button.dart';
import '../../utils/common_text_field.dart';
import '../../utils/constant.dart';
import '../../utils/utils_class.dart';
import '../aadhaar_screen/components/CheckboxTerm.dart';
import '../personal_info/EmailOtpScreen.dart';
import '../personal_info/model/CityResponce.dart';
import '../personal_info/model/EmailExistRespoce.dart';
import '../personal_info/model/ReturnObject.dart';
import '../personal_info/model/SendOtpOnEmailResponce.dart';

class direct_selling_agent extends StatefulWidget {
  int? activityId;
  int? subActivityId;
  final String? pageType;

  direct_selling_agent(
      {required this.activityId, required this.subActivityId, super.key, this.pageType});

  @override
  State<direct_selling_agent> createState() => DirectSellingAgent();
}


class DirectSellingAgent extends State<direct_selling_agent> {

  bool _isSelected1 = false;
  bool _isSelected2 = false;
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
  var isValidEmail = false;
  var isEmailClear = false;



  var isLoading = false;
  final TextEditingController _gstController = TextEditingController();
  final TextEditingController _businessNameController = TextEditingController();
  final TextEditingController _addressLineController = TextEditingController();
  final TextEditingController _addressLine2Controller = TextEditingController();
  final TextEditingController _pinCodeController = TextEditingController();
  final TextEditingController _emailIDCl = TextEditingController();
  final TextEditingController _businessDocumentNumberController =
  TextEditingController();
  String? selectedStateValue;
  String? selectedCityValue;

  var gstNumber = "";
  var image = "";
  int? businessProofDocId;

  var isClearData = false;
  var isImageDelete = false;
  var isGstFilled = false;

  var updateData = true;

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

  void _onImageSelected(File imageFile) async {
    isImageDelete = false;
    Utils.onLoading(context, "");
    await Provider.of<DataProvider>(context, listen: false)
        .postBusineesDoumentSingleFile(imageFile, true, "", "");

    setState(() {
      Navigator.pop(context);
    });
  }

  final List<String> businessTypeList = [
    'Proprietorship',
    'Partnership',
    'Pvt Ltd',
    'HUF',
    'LLP'
  ];
  String? selectedBusinessTypeValue;

  final List<String> monthlySalesTurnoverList = [
    'Upto 3 Lacs',
    '3 Lacs - 10 Lacs',
    '10 Lacs - 25 Lacs',
    'Above 25 Lacs'
  ];
  String? selectedMonthlySalesTurnoverValue;

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
  //final DateTimePickerLocale _locale = DateTimePickerLocale.en_us;
  final String _format = 'yyyy-MMMM-dd';

  DateTime? _dateTime;
  String? slectedDate = "";

  /// Display date picker.
  /*void _showDatePicker(BuildContext context) {
    DatePicker.showDatePicker(
      context,
      pickerTheme: DateTimePickerTheme(
        cancel: const Icon(
          Icons.close,
          color: Colors.black38,
        ),
        title: 'Business Incorporation Date',
        titleTextStyle: const TextStyle(fontSize: 14),
        showTitle: _showTitle,
        selectionOverlayColor: Colors.blue,
        // showTitle: false,
        // titleHeight: 80,
        // confirm: const Text('确定', style: TextStyle(color: Colors.blue)),
      ),
      minDateTime: DateTime.parse(minDateTime),
      maxDateTime: DateTime.parse(maxDateTime),
      initialDateTime: _dateTime,
      dateFormat: _format,
      locale: _locale,
      onClose: () => debugPrint("----- onClose -----"),
      onCancel: () => debugPrint('onCancel'),
      onChange: (dateTime, List<int> index) {
        setState(() {
          _dateTime = dateTime;
        });
      },
      onConfirm: (dateTime, List<int> index) {
        setState(() {
          _dateTime = dateTime;
          slectedDate = Utils.dateFormate(context, _dateTime.toString());
          if (kDebugMode) {
            print("$_dateTime");
          }
        });
      },
    );
  }*/

  @override
  void initState() {
    super.initState();
    //Api Call
   // getPersonalDetailAndStateApi(context);
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
        backgroundColor: Colors.white,
        body: SafeArea(
          top: true,
          bottom: true,
          child:
          Consumer<DataProvider>(builder: (context, productProvider, child) {
            if (productProvider.getLeadPANData == null && isLoading) {
              return  Utils.onLoading(context, "");
            } else {
             /* if (productProvider.getLeadBusinessDetailData != null &&
                  isLoading) {
                Navigator.of(context, rootNavigator: true).pop();
                isLoading = false;
              }
              if (productProvider.getLeadBusinessDetailData != null) {
                if (productProvider.getLeadBusinessDetailData?.businessName !=
                    null &&
                    productProvider.getLeadBusinessDetailData?.doi != null &&
                    !isClearData &&
                    !isImageDelete) {
                  if (productProvider.getLeadBusinessDetailData!.busGSTNO !=
                      null) {
                    _gstController.text =
                    productProvider.getLeadBusinessDetailData!.busGSTNO!;
                    gstNumber =
                    productProvider.getLeadBusinessDetailData!.busGSTNO!;
                  }

                  _businessNameController.text =
                  productProvider.getLeadBusinessDetailData!.businessName!;
                  _addressLineController.text =
                  productProvider.getLeadBusinessDetailData!.addressLineOne!;
                  slectedDate = Utils.dateFormate(
                      context, productProvider.getLeadBusinessDetailData!.doi!);
                  _addressLine2Controller.text =
                  productProvider.getLeadBusinessDetailData!.addressLineTwo!;
                  _pinCodeController.text = productProvider
                      .getLeadBusinessDetailData!.zipCode!
                      .toString();
                  _businessDocumentNumberController.text = productProvider
                      .getLeadBusinessDetailData!.buisnessDocumentNo!;
                  image = productProvider
                      .getLeadBusinessDetailData!.buisnessProofUrl!;
                  selectedBusinessTypeValue =
                  productProvider.getLeadBusinessDetailData!.busEntityType!;
                  selectedStateValue = productProvider
                      .getLeadBusinessDetailData!.stateId!
                      .toString();
                  selectedCityValue = productProvider
                      .getLeadBusinessDetailData!.cityId!
                      .toString();
                  selectedMonthlySalesTurnoverValue = productProvider
                      .getLeadBusinessDetailData!.incomeSlab!
                      .toString();
                  businessProofDocId = productProvider
                      .getLeadBusinessDetailData!.buisnessProofDocId!;
                  if(productProvider
                      .getLeadBusinessDetailData!.buisnessProof != null) {
                    selectedChooseBusinessProofValue = productProvider
                        .getLeadBusinessDetailData!.buisnessProof!;
                  }
                } else {
                  updateData = true;
                }
              }

              if (productProvider.getCustomerDetailUsingGSTData != null) {
                if (productProvider.getCustomerDetailUsingGSTData!.busGSTNO !=
                    null &&
                    !gstUpdate) {
                  if (productProvider
                      .getCustomerDetailUsingGSTData!.busGSTNO!.isNotEmpty) {
                    slectedDate = Utils.dateFormate(context,
                        productProvider.getCustomerDetailUsingGSTData!.doi!);
                    if (productProvider
                        .getCustomerDetailUsingGSTData!.buisnessProofDocId !=
                        0) {
                      businessProofDocId = productProvider
                          .getCustomerDetailUsingGSTData!.buisnessProofDocId!;
                    }
                    if (productProvider
                        .getCustomerDetailUsingGSTData!.buisnessProofUrl !=
                        null) {
                      image = productProvider
                          .getCustomerDetailUsingGSTData!.buisnessProofUrl!;
                    }

                    if (productProvider
                        .getCustomerDetailUsingGSTData!.buisnessProof !=
                        null) {
                      print("yha pr aaya ");
                      selectedChooseBusinessProofValue = productProvider
                          .getCustomerDetailUsingGSTData!.buisnessProof!;
                    }
                    if (productProvider
                        .getCustomerDetailUsingGSTData!.buisnessProof !=
                        null) {
                      if (productProvider
                          .getCustomerDetailUsingGSTData!.busEntityType !=
                          null) {
                        selectedBusinessTypeValue = productProvider
                            .getCustomerDetailUsingGSTData!.busEntityType!;
                      }
                    }
                    updateData = false;
                  }
                }
              }

              if (productProvider.getAllCityData != null) {
                citylist = productProvider.getAllCityData!;
              }

              if (productProvider.getpostBusineesDoumentSingleFileData != null &&
                  !isImageDelete) {
                if (productProvider.getpostBusineesDoumentSingleFileData!.filePath != null) {
                  image = productProvider.getpostBusineesDoumentSingleFileData!.filePath!;
                  businessProofDocId = productProvider.getpostBusineesDoumentSingleFileData!.docId!;
                }
              }*/


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
                              isChecked: _isSelected1,
                              onChanged: (bool? value) {
                                _handleCheckboxChange(1, value);
                              },
                            ),
                          ),
                          Expanded(
                            child: CheckboxTerm(
                              content: "Not GST Registered",
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
                                    //await getCustomerDetailUsingGST(context, _gstController.text);
                                   /* if (productProvider.getCustomerDetailUsingGSTData != null) {
                                      if (productProvider
                                          .getCustomerDetailUsingGSTData!
                                          .busGSTNO !=
                                          null) {
                                        updateData = false;
                                        gstUpdate = false;
                                        cityCallInitial = true;
                                        _gstController.text = productProvider
                                            .getCustomerDetailUsingGSTData!
                                            .busGSTNO!;
                                        gstNumber = productProvider
                                            .getCustomerDetailUsingGSTData!
                                            .busGSTNO!;
                                        _businessNameController.text =
                                        productProvider
                                            .getCustomerDetailUsingGSTData!
                                            .businessName!;
                                        _addressLineController.text =
                                        productProvider
                                            .getCustomerDetailUsingGSTData!
                                            .addressLineOne!;
                                        _addressLine2Controller.text =
                                        productProvider
                                            .getCustomerDetailUsingGSTData!
                                            .addressLineTwo!;
                                        _pinCodeController.text = productProvider
                                            .getCustomerDetailUsingGSTData!
                                            .zipCode!
                                            .toString();
                                        //chooseBusinessProofList!.first;
                                        isGstFilled=true;
                                        selectedChooseBusinessProofValue = "GST Certificate";
                                        _businessDocumentNumberController.text = productProvider.getCustomerDetailUsingGSTData!.busGSTNO!;
                                      } else {
                                        Utils.showToast(
                                            productProvider
                                                .getCustomerDetailUsingGSTData!
                                                .message!,
                                            context);
                                      }
                                    }*/
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
                                // print('Edit icon tapped');
                                setState(() {
                                  updateData = true;
                                  isImageDelete = true;
                                  gstUpdate = true;
                                  setCityListFirstTime = false;
                                  _gstController.text = "";
                                  _businessNameController.text = "";
                                  _addressLineController.text = "";
                                  _addressLine2Controller.text = "";
                                  _pinCodeController.text = "";
                                  _businessDocumentNumberController.text = "";
                                  slectedDate = "";
                                  businessProofDocId = null;
                                  selectedBusinessTypeValue = null;
                                  selectedStateValue = null;
                                  selectedCityValue = null;
                                  selectedMonthlySalesTurnoverValue = null;
                                  selectedChooseBusinessProofValue = null;
                                  isClearData = true;
                                  gstNumber = "";
                                  image = "";
                                  businessProofDocId = null;
                                  isGstFilled=false;
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
                        hint: const Text(
                          'Firm Type',
                          style: TextStyle(
                            color: blueColor,
                            fontSize: 16.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        items: _addDividersAfterItems(businessTypeList),
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
                          customHeights: _getCustomItemsHeights(businessTypeList),
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
                        hint: const Text(
                          'Business Document',
                          style: TextStyle(
                            color: blueColor,
                            fontSize: 16.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        items: _addDividersAfterItems(businessTypeList),
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
                          customHeights: _getCustomItemsHeights(businessTypeList),
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
                                  border:
                                  Border.all(color: const Color(0xff0196CE))),
                              width: double.infinity,
                              child: GestureDetector(
                                onTap: () {
                                  // bottomSheetMenu(context);
                                },
                                child: Container(
                                  height: 148,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Container(
                                    child: (image.isNotEmpty)
                                        ? image.contains(".pdf")
                                        ? Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                      MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.picture_as_pdf),
                                      ],
                                    )
                                        : ClipRRect(
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
                                            'supports : PDF, JPG, JPEG',
                                            style: TextStyle(
                                                fontSize: 12,
                                                color:
                                                Color(0xffCACACA))),
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
                              child: SvgPicture.asset(
                                  'assets/icons/delete_icon.svg'),
                            )
                                : Container(),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 16.0,
                      ),

                      CommonTextField(
                        controller: _addressLineController,
                        enabled: updateData,
                        hintText: "Company Name",
                        labelText: "Company Name",
                      ),
                      const SizedBox(
                        height: 16.0,
                      ),

                      CommonTextField(
                        controller: _addressLine2Controller,
                        enabled: updateData,
                        hintText: "Full Name",
                        labelText: "Full Name",
                      ),
                      const SizedBox(
                        height: 16.0,
                      ),
                      CommonTextField(
                        controller: _pinCodeController,
                        enabled: updateData,
                        hintText: "Father’s / Husband’s Name",
                        labelText: "Father’s / Husband’s Name",
                      ),
                      const SizedBox(
                        height: 16.0,
                      ),
                      InkWell(
                        onTap: updateData
                            ? () {
                          //_showDatePicker(context);
                        }
                            : null,
                        // Set onTap to null when field is disabled
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: textFiledBackgroundColour,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: kPrimaryColor),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  slectedDate!.isNotEmpty ? '$slectedDate' : 'Date of Birth',
                                  style: const TextStyle(fontSize: 16.0),
                                ),
                                const Icon(Icons.date_range),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 16.0,
                      ),

                      CommonTextField(
                        controller: _pinCodeController,
                        enabled: updateData,
                        hintText: "Age",
                        labelText: "Age",
                      ),
                      const SizedBox(
                        height: 16.0,
                      ),

                      const SizedBox(
                        height: 16.0,
                      ),

                      CommonTextField(
                        controller: _pinCodeController,
                        enabled: updateData,
                        hintText: "Address",
                        labelText: "Address",
                      ),
                      const SizedBox(
                        height: 16.0,
                      ),

                      const SizedBox(
                        height: 16.0,
                      ),

                      CommonTextField(
                        controller: _pinCodeController,
                        enabled: updateData,
                        hintText: "State",
                        labelText: "State",
                      ),
                      const SizedBox(
                        height: 16.0,
                      ),

                      const SizedBox(
                        height: 16.0,
                      ),

                      CommonTextField(
                        controller: _pinCodeController,
                        enabled: updateData,
                        hintText: "City",
                        labelText: "City",
                      ),
                      const SizedBox(
                        height: 16.0,
                      ),

                      CommonTextField(
                        controller: _pinCodeController,
                        enabled: updateData,
                        hintText: "Alternate Contact Number",
                        labelText: "Alternate Contact Number",
                      ),
                      const SizedBox(
                        height: 16.0,
                      ),

                      SizedBox(height: 16),
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
                      SizedBox(height: 16),
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
                      SizedBox(height: 16),

                      CommonTextField(
                        controller: _pinCodeController,
                        enabled: updateData,
                        hintText: "Present Occupation",
                        labelText: "Present Occupation",
                      ),
                      const SizedBox(
                        height: 16.0,
                      ),

                      SizedBox(height: 16),

                      CommonTextField(
                        controller: _pinCodeController,
                        enabled: updateData,
                        hintText: "No of years in current employment",
                        labelText: "No of years in current employment",
                      ),
                      const SizedBox(
                        height: 16.0,
                      ),
                      CommonTextField(
                        controller: _pinCodeController,
                        enabled: updateData,
                        hintText: "Qualification",
                        labelText: "Qualification",
                      ),
                      const SizedBox(
                        height: 16.0,
                      ),

                      CommonTextField(
                        controller: _pinCodeController,
                        enabled: updateData,
                        hintText: "Languages Known",
                        labelText: "Languages Known",
                      ),
                      const SizedBox(
                        height: 16.0,
                      ),


                      Text('Presently working with other Party/bank/NBFC /Financial Institute? ',
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
                        controller: _pinCodeController,
                        enabled: updateData,
                        hintText: "Names",
                        labelText: "Names",
                      ),
                      const SizedBox(
                        height: 16.0,
                      ),
                      CommonTextField(
                        controller: _pinCodeController,
                        enabled: updateData,
                        hintText: "Contact No. ",
                        labelText: "Contact No.",
                      ),
                      const SizedBox(
                        height: 16.0,
                      ),
                      CommonTextField(
                        controller: _pinCodeController,
                        enabled: updateData,
                        hintText: "Location",
                        labelText: "Location",
                      ),
                      const SizedBox(height: 54.0),

                      CommonElevatedButton(
                        onPressed: () async {
                          if (_businessNameController.text.isEmpty) {
                            Utils.showToast(
                                "Please Enter Business Name (As Per Doc)",
                                context);
                          } else if (_addressLineController.text.isEmpty) {
                            Utils.showToast(
                                "Please Enter Address Line 1", context);
                          } else if (_addressLine2Controller.text.isEmpty) {
                            Utils.showToast(
                                "Please Enter Address Line 2", context);
                          } else if (_pinCodeController.text.isEmpty) {
                            Utils.showToast("Please Enter Pin Code", context);
                          } else if (selectedBusinessTypeValue == null) {
                            Utils.showToast(
                                "Please Select Business Type", context);
                          } else if (selectedMonthlySalesTurnoverValue == null) {
                            Utils.showToast("Please Select Income Slab", context);
                          } else if (_businessDocumentNumberController
                              .text.isEmpty) {
                            Utils.showToast(
                                "Please Enter Business Document Number", context);
                          } else if (businessProofDocId == null) {
                            Utils.showToast("Please Select Proof", context);
                          } else if (slectedDate!.isEmpty) {
                            Utils.showToast(
                                "Please Select Incorporation Date", context);
                          } else {
                            //await postLeadBuisnessDetail(context,productProvider);

                            /* if (productProvider.getPostLeadBuisnessDetailData !=
                                null) {
                              if (productProvider
                                  .getPostLeadBuisnessDetailData!.isSuccess!) {
                                fetchData(context);
                              } else {
                                Utils.showToast(
                                    productProvider
                                        .getPostLeadBuisnessDetailData!.message!,
                                    context);
                              }
                            }*/
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

  Widget buildStateField(DataProvider productProvider) {
    ReturnObject? initialData;

    /*if (!gstUpdate && productProvider.getCustomerDetailUsingGSTData != null) {
      if (productProvider.getCustomerDetailUsingGSTData!.stateId != null &&
          productProvider.getCustomerDetailUsingGSTData!.stateId != 0 &&
          productProvider.getCustomerDetailUsingGSTData!.cityId != null &&
          productProvider.getCustomerDetailUsingGSTData!.cityId != 0) {
        setStateListFirstTime = true;
        if (productProvider.getAllStateData != null) {
          var allStates = productProvider.getAllStateData!.returnObject!;
          if (setStateListFirstTime) {
            initialData = allStates.firstWhere(
                    (element) =>
                element?.id ==
                    productProvider.getCustomerDetailUsingGSTData!.stateId,
                orElse: () => null);
            selectedStateValue = productProvider
                .getCustomerDetailUsingGSTData!.stateId!
                .toString();
          }

          if (cityCallInitial) {
            citylist.clear();
            Provider.of<DataProvider>(context, listen: false).getAllCity(
                productProvider.getCustomerDetailUsingGSTData!.stateId!);
            cityCallInitial = false;
          }
        }
      }
    } else {
      if (productProvider.getLeadBusinessDetailData!.stateId != null &&
          productProvider.getLeadBusinessDetailData!.stateId! != 0) {
        if (productProvider.getAllStateData != null) {
          var allStates = productProvider.getAllStateData!.returnObject!;
          if (setStateListFirstTime) {
            initialData = allStates.firstWhere(
                    (element) =>
                element?.id ==
                    productProvider.getLeadBusinessDetailData!.stateId,
                orElse: () => null);
            selectedStateValue =
                productProvider.getLeadBusinessDetailData!.stateId!.toString();
          }
        }
        if (cityCallInitial) {
          citylist.clear();
          Provider.of<DataProvider>(context, listen: false)
              .getAllCity(productProvider.getLeadBusinessDetailData!.stateId!);
          cityCallInitial = false;
        }
      } else {
        setStateListFirstTime = false;
      }
    }*/
    if (productProvider.getAllStateData != null) {
      return DropdownButtonFormField2<ReturnObject?>(
        isExpanded: true,
        value: initialData,
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
        onChanged: setStateListFirstTime
            ? null
            : (ReturnObject? value) {
          citylist.clear();
          setStateListFirstTime = false;
          Provider.of<DataProvider>(context, listen: false)
              .getAllCity(value!.id!);
          selectedStateValue = value.id!.toString();
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

/*  Widget buildCityField(DataProvider productProvider) {
    if (productProvider.getAllCityData != null) {
      CityResponce? initialData;
      if (!gstUpdate && productProvider.getCustomerDetailUsingGSTData != null) {
        if (productProvider.getCustomerDetailUsingGSTData!.cityId != null &&
            productProvider.getCustomerDetailUsingGSTData!.cityId != 0) {
          setCityListFirstTime = true;
          if (setCityListFirstTime) {
            initialData = citylist.firstWhere(
                    (element) =>
                element?.id ==
                    productProvider.getCustomerDetailUsingGSTData!.cityId,
                orElse: () => CityResponce());
            selectedCityValue = productProvider
                .getCustomerDetailUsingGSTData!.cityId!
                .toString();
          }
        }
      } else {
        if (productProvider.getLeadBusinessDetailData!.cityId != 0) {
          if (setCityListFirstTime) {
            initialData = citylist.firstWhere(
                    (element) =>
                element?.id ==
                    productProvider.getLeadBusinessDetailData!.cityId,
                orElse: () => CityResponce());
            selectedCityValue =
                productProvider.getLeadBusinessDetailData!.cityId!.toString();
          }
        } else {
          setCityListFirstTime = false;
        }
      }

      return DropdownButtonFormField2<CityResponce>(
        isExpanded: true,
        value: initialData,
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
        onChanged: setCityListFirstTime
            ? null
            : (CityResponce? value) {
          selectedCityValue = value!.id.toString();
          setState(() {
            setCityListFirstTime = false;
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

  Future<void> getCustomerDetailUsingGST(
      BuildContext context, String gstNumber) async {
    Utils.onLoading(context, "");
    await Provider.of<DataProvider>(context, listen: false)
        .getCustomerDetailUsingGST(gstNumber);
    Navigator.of(context, rootNavigator: true).pop();
  }

  Future<void> postLeadBuisnessDetail(BuildContext context, DataProvider productProvider) async {
    final prefsUtil = await SharedPref.getInstance();
    Utils.onLoading(context, "");

    var postLeadBuisnessDetailRequestModel = PostLeadBuisnessDetailRequestModel(
      leadId: prefsUtil.getInt(LEADE_ID),
      userId: prefsUtil.getString(USER_ID),
      activityId: widget.activityId,
      subActivityId: widget.subActivityId,
      busName: _businessNameController.text.toString(),
      doi: slectedDate.toString(),
      busGSTNO: gstNumber,
      busEntityType: selectedBusinessTypeValue,
      busAddCorrLine1: _addressLineController.text.toString(),
      busAddCorrLine2: _addressLine2Controller.text.toString(),
      busAddCorrCity: selectedCityValue,
      busAddCorrState: selectedStateValue,
      busAddCorrPincode: _pinCodeController.text.toString(),
      buisnessMonthlySalary: 0,
      incomeSlab: selectedMonthlySalesTurnoverValue,
      companyId: prefsUtil.getInt(COMPANY_ID),
      buisnessDocumentNo: _businessDocumentNumberController.text.toString(),
      buisnessProofDocId: businessProofDocId,
      buisnessProof: selectedChooseBusinessProofValue,
    );
    debugPrint("Post DATA:: ${postLeadBuisnessDetailRequestModel.toJson()}");
    await Provider.of<DataProvider>(context, listen: false)
        .postLeadBuisnessDetail(postLeadBuisnessDetailRequestModel);
    Navigator.of(context, rootNavigator: true).pop();

    if (productProvider.getPostLeadBuisnessDetailData != null) {
      productProvider.getPostLeadBuisnessDetailData!.when(
        success: (data) {
          // Handle successful response
          if (data.isSuccess != null) {
            if (data.isSuccess!) {
              fetchData(context);
            } else {
              Utils.showToast(
                  data.message!,
                  context);
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

  void bottomSheetMenu(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (builder) {
          return ImagePickerFileWidgets(onImageSelected: _onImageSelected);
        });
  }

  Future<void> getPersonalDetailAndStateApi(BuildContext context) async {
    final prefsUtil = await SharedPref.getInstance();
    final String? userId = prefsUtil.getString(USER_ID);
    final String? productCode = prefsUtil.getString(PRODUCT_CODE);

    await Provider.of<DataProvider>(context, listen: false)
        .getLeadBusinessDetail(userId!,productCode!);

    await Provider.of<DataProvider>(context, listen: false).getAllState();
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

      final leadCurrentActivityAsyncData =
      await ApiService().leadCurrentActivityAsync(leadCurrentRequestModel)
      as LeadCurrentResponseModel?;

      final getLeadData = await ApiService().getLeads(
        prefsUtil.getString(LOGIN_MOBILE_NUMBER)!,
        prefsUtil.getInt(COMPANY_ID)!,
        prefsUtil.getInt(PRODUCT_ID)!,
        prefsUtil.getInt(LEADE_ID)!,
      ) as GetLeadResponseModel?;

      customerSequence(context, getLeadData, leadCurrentActivityAsyncData, "push");
    } catch (error) {
      if (kDebugMode) {
        print('Error occurred during API call: $error');
      }
    }

  }*/
}

/*class DirectSellingAgent extends State<direct_selling_agent> {
  bool _isSelected1 = false;
  bool _isSelected2 = false;

  final TextEditingController _gstController = TextEditingController();
  var updateData = false;

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
  Widget build(BuildContext context) {
    bool isTermsChecks = false;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
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
                        isChecked: _isSelected1,
                        onChanged: (bool? value) {
                          _handleCheckboxChange(1, value);
                        },
                      ),
                    ),
                    Expanded(
                      child: CheckboxTerm(
                        content: "Not GST Registered",
                        isChecked: _isSelected2,
                        onChanged: (bool? value) {
                          _handleCheckboxChange(2, value);
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 30),





              ],
            ),
          ),
        ),
      ),
    );
  }
  }*/

