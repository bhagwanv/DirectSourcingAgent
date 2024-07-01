import 'package:cupertino_date_time_picker_loki/cupertino_date_time_picker_loki.dart';
import 'package:direct_sourcing_agent/api/ApiService.dart';
import 'package:direct_sourcing_agent/api/FailureException.dart';
import 'package:direct_sourcing_agent/providers/DataProvider.dart';
import 'package:direct_sourcing_agent/shared_preferences/shared_pref.dart';
import 'package:direct_sourcing_agent/utils/common_elevted_button.dart';
import 'package:direct_sourcing_agent/utils/common_text_field.dart';
import 'package:direct_sourcing_agent/utils/customer_sequence_logic.dart';
import 'package:direct_sourcing_agent/utils/utils_class.dart';
import 'package:direct_sourcing_agent/view/connector/model/ConnectorInfoReqModel.dart';
import 'package:direct_sourcing_agent/view/connector/model/ConnectorInfoResponce.dart';
import 'package:direct_sourcing_agent/view/splash/model/GetLeadResponseModel.dart';
import 'package:direct_sourcing_agent/view/splash/model/LeadCurrentRequestModel.dart';
import 'package:direct_sourcing_agent/view/splash/model/LeadCurrentResponseModel.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../utils/constant.dart';
import '../../utils/custom_radio_button.dart';
import '../personal_info/EmailOtpScreen.dart';
import '../personal_info/model/EmailExistRespoce.dart';
import '../personal_info/model/SendOtpOnEmailResponce.dart';

class Connector_signup extends StatefulWidget {
  int? activityId;
  int? subActivityId;

  Connector_signup(
      {required this.activityId, required this.subActivityId, super.key});

  @override
  State<Connector_signup> createState() => ConnectorSignup();
}

class ConnectorSignup extends State<Connector_signup> {
  var updateData = true;
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
  final TextEditingController _LanguagesController = TextEditingController();
  final TextEditingController _refranceNameController = TextEditingController();
  final TextEditingController _refranceContectController =
      TextEditingController();
  final TextEditingController _refranceLocationController =
      TextEditingController();
  final TextEditingController _pincodeController = TextEditingController();
  final TextEditingController _satateController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();

  String minDateTime = '2010-05-12';
  String maxDateTime = '2030-11-25';
  String initDateTime = '2021-08-31';

  final bool _showTitle = true;
  bool isWorkingWithParty = false;
  final DateTimePickerLocale _locale = DateTimePickerLocale.en_us;
  final String _format = 'yyyy-MMMM-dd';
  String workingWithParty = "No";

  DateTime? _dateTime;
  String? slectedDate = "";
  ConnectorInfoResponce? connectorInfoResponceModel;

  var isValidEmail = false;


  void _handleRadioValueWorkingWithPartyChanged(String value) {
    setState(() {
      isWorkingWithParty = true;
      workingWithParty = value;
    });
  }


  void _showDatePicker(BuildContext context) {
    DatePicker.showDatePicker(
      context,
      pickerTheme: DateTimePickerTheme(
        cancel: const Icon(
          Icons.close,
          color: Colors.black38,
        ),
        title: 'Date of Birth',
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
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getConnectorInfoApi();
  }

  @override
  Widget build(BuildContext context) {
    bool isTermsChecks = false;
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
          child: SingleChildScrollView(
            child: Consumer<DataProvider>(
                builder: (context, productProvider, child) {
              if (productProvider.getConnectorInfoData == null) {
                return Container();
              } else {
                if (productProvider.getConnectorInfoData != null) {
                  //Navigator.of(context, rootNavigator: true).pop();
                  if (productProvider.getConnectorInfoData != null) {
                    productProvider.getConnectorInfoData!.when(
                      success: (data) {
                        connectorInfoResponceModel = data;
          
                        if (updateData) {
                          _firstNameController.text =
                              connectorInfoResponceModel!.fullName!;
                          _fatherNameController.text =
                              connectorInfoResponceModel!.fatherName!;
                          slectedDate = Utils.dateFormate(
                              context, connectorInfoResponceModel!.dob!);
                          _ageController.text =
                              connectorInfoResponceModel!.age.toString();
                          _addreshController.text =
                              connectorInfoResponceModel!.address!;
          
                          if (connectorInfoResponceModel?.referenceName != null) {
                            _refranceNameController.text =
                                connectorInfoResponceModel!.referenceName!;
                          }
          
                          if (connectorInfoResponceModel!.referneceContact !=
                              null) {
                            _refranceContectController.text =
                                connectorInfoResponceModel!.referneceContact!;
                          }
          
                          if (connectorInfoResponceModel!.languagesKnown !=
                              null) {
                            _LanguagesController.text =
                                connectorInfoResponceModel!.languagesKnown!;
                          }
          
                          if (connectorInfoResponceModel!.workingLocation !=
                              null) {
                            _refranceLocationController.text =
                                connectorInfoResponceModel!.workingLocation!;
                          }
          
                          if (connectorInfoResponceModel!.presentEmployment !=
                              null) {
                            _presentEmpolymentController.text =
                                connectorInfoResponceModel!.presentEmployment!;
                          }
          
                          if (connectorInfoResponceModel!.emailId != null) {
                            _emailIDController.text =
                                connectorInfoResponceModel!.emailId!;
                            isValidEmail=true;
                          }
          
                          if (connectorInfoResponceModel!.emailId != null) {
                            _alternetMobileNumberController.text =
                                connectorInfoResponceModel!.alternatePhoneNo!;
                          }
          
                          if (connectorInfoResponceModel!.state != null) {
                            _satateController.text =
                                connectorInfoResponceModel!.state!;
                          }
          
                          if (connectorInfoResponceModel!.city != null) {
                            _cityController.text =
                                connectorInfoResponceModel!.city!;
                          }
          
                          if (connectorInfoResponceModel!.pincode != null) {
                            _pincodeController.text =
                                connectorInfoResponceModel!.pincode!.toString();
                          }
                          if (connectorInfoResponceModel!.workingWithOther != null && !isWorkingWithParty) {
                            workingWithParty = connectorInfoResponceModel!.workingWithOther!.toString();
                          }
                          updateData = false;
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
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
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
                      InkWell(
                        onTap: false
                            ? () {
                                _showDatePicker(context);
                              }
                            : null,
                        // Set onTap to null when field is disabled
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: textFiledBackgroundColour,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: kPrimaryLightColor),
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
                            RegExp(
                                r'^0+'), //users can't type 0 at 1st position
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
                      (isValidEmail )
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
                              if (_emailIDController.text.isEmpty) {
                                Utils.showToast("Please Enter Email ID", context);
                              } else if (!Utils.validateEmail(_emailIDController.text)) {
                                Utils.showToast("Please Enter Valid Email ID", context);
                              } else {
                                callEmailIDExist(context, _emailIDController.text);
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
                      SizedBox(height: 25),
                      CommonTextField(
                        controller: _presentEmpolymentController,
                        enabled: true,
                        hintText: "Present Employment",
                        labelText: "Present Employment",
                        keyboardType: TextInputType.text,
                        inputFormatter: [
                          FilteringTextInputFormatter.allow(
                              RegExp((r'[A-Za-z ]'))),
                        ],
                      ),
                      SizedBox(height: 20),
                      CommonTextField(
                        controller: _LanguagesController,
                        enabled: true,
                        hintText: "Languages Known",
                        labelText: "Languages Known",
                        keyboardType: TextInputType.text,
                        inputFormatter: [
                          FilteringTextInputFormatter.allow(
                              RegExp((r'[A-Za-z, ]'))),
                        ],
                      ),
                      SizedBox(height: 20),
                      CommonTextField(
                        controller: _refranceLocationController,
                        enabled: true,
                        hintText: "Location",
                        labelText: "Location",
                        inputFormatter: [
                          FilteringTextInputFormatter.allow(
                              RegExp((r'[A-Za-z,0-9 ]'))),
                        ],
                      ),
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
                            RegExp(
                                r'^0+'), //users can't type 0 at 1st position
                          ),
                        ],
                        keyboardType: TextInputType.number,
                        hintText: "Contact No",
                        labelText: "Contact No",
                      ),
                      SizedBox(height: 20),
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 10, right: 10, top: 20),
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
                );
              }
            }),
          ),
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
          _emailIDController.text = result['Email'];
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
    final String? productCode = prefsUtil.getString(PRODUCT_CODE);
    EmailExistRespoce data;
    data = await ApiService().emailExist(userId!, emailID, productCode!) as EmailExistRespoce;
    Navigator.of(context, rootNavigator: true).pop();
    if (data.isSuccess!) {
      isValidEmail = false;
      Utils.showToast(data.message!, context);
    } else {
     // callSendOptEmail(context, _emailIDController.text);
      setState(() {
        isValidEmail = true;
      });
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
    } else if (!Utils.validateEmail(_emailIDController.text)|| !isValidEmail ) {
      Utils.showToast("Please enter Valid Email ID", context);
    } else if (_presentEmpolymentController.text.trim().isEmpty) {
      Utils.showToast("Please Enter present Employment", context);
    } else if (_LanguagesController.text.trim().isEmpty) {
      Utils.showToast("Please Enter Languages", context);
    } else if (workingWithParty.isEmpty) {
      Utils.showToast("Please Select Party", context);
    } else if (_refranceNameController.text.trim().isEmpty) {
      Utils.showToast("Please Enter Reference Name ", context);
    } else if (_refranceContectController.text.trim().isEmpty) {
      Utils.showToast("Please Enter Reference Contact No ", context);
    } else if (!Utils.isPhoneNoValid(_refranceContectController.text.trim())) {
      Utils.showToast("Please Enter Valid Reference Contact No", context);
    } else if (_refranceLocationController.text.trim().isEmpty) {
      Utils.showToast("Please Enter Reference Location", context);
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
          languagesKnown: _LanguagesController.text.toString(),
          workingWithOther: workingWithParty,
          referenceName: _refranceNameController.text.toString(),
          referneceContact: _refranceContectController.text.toString(),
          WorkingLocation: _refranceLocationController.text.toString(),
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

  void getConnectorInfoApi() async {
    final prefsUtil = await SharedPref.getInstance();
    String? userId = prefsUtil.getString(USER_ID);
    final String? productCode = prefsUtil.getString(PRODUCT_CODE);
    Provider.of<DataProvider>(context, listen: false)
        .getConnectorInfo(userId!, productCode!);
  }
}
