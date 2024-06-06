import 'package:direct_sourcing_agent/utils/common_elevted_button.dart';
import 'package:direct_sourcing_agent/utils/common_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../utils/constant.dart';
import '../aadhaar_screen/components/CheckboxTerm.dart';

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
  final TextEditingController _alternetMobileNumberController = TextEditingController();
  final TextEditingController _emailIDController = TextEditingController();
  final TextEditingController _presentEmpolymentController = TextEditingController();
  final TextEditingController _refranceNameController = TextEditingController();
  final TextEditingController _refranceContectController = TextEditingController();
  final TextEditingController _refranceLocationController = TextEditingController();
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


  @override
  Widget build(BuildContext context) {
    bool isTermsChecks = false;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 22),
                Center(
                  child: Text('Sign Up',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.urbanist(
                        fontSize: 16,
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                      )),
                ),
                SizedBox(height: 27),
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
                  enabled: updateData,
                  hintText: "Full Name",
                  labelText: "Full Name",
                ),
                SizedBox(height: 20),
                CommonTextField(
                  controller: _fatherNameController,
                  enabled: updateData,
                  hintText: "Father Name ",
                  labelText: "Father Name",
                ),
                SizedBox(height: 20),
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
                           'Date of Birth',
                            style: const TextStyle(fontSize: 16.0),
                          ),
                          const Icon(Icons.date_range,color: kPrimaryColor,),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                CommonTextField(
                  controller: _ageController,
                  enabled: updateData,
                  keyboardType: TextInputType.number,
                  hintText: "Age",
                  labelText: "Age",
                ),
                SizedBox(height: 20),
        
                CommonTextField(
                  controller: _addreshController,
                  enabled: updateData,
                  hintText: "Address",
                  labelText: "Address",
                ),
        
                SizedBox(height: 20),
                CommonTextField(
                  controller: _alternetMobileNumberController,
                  enabled: updateData,
                  inputFormatter: [FilteringTextInputFormatter.allow(RegExp((r'[A-Z0-9]'))),
                    LengthLimitingTextInputFormatter(10)],
                  keyboardType: TextInputType.number,
                  hintText: "Alternate Contact Number",
                  labelText: "Alternate Contact Number",
                ),
        
                SizedBox(height: 20),
                CommonTextField(
                  controller: _emailIDController,
                  enabled: updateData,
                  keyboardType: TextInputType.emailAddress,
                  hintText: "E Mail id",
                  labelText: "E Mail id",
                ),
        
                SizedBox(height: 20),
                CommonTextField(
                  controller: _presentEmpolymentController,
                  enabled: updateData,
                  hintText: "Present Employment",
                  labelText: "Present Employment",
                ),
        
                SizedBox(height: 20),
        
                Text("Presently working with other Party/bank/NBFC \nFinancial Institute?",
                  style: GoogleFonts.urbanist(
                  fontSize: 14,
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
                )),
                SizedBox(height: 10),
        
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
                        content: "NO",
                        isChecked: _isSelected2,
                        onChanged: (bool? value) {
                          _handleCheckboxChange(2, value);
                        },
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
                  enabled: updateData,
                  hintText: "Name",
                  labelText: "Name",
                ),
        
                SizedBox(height: 20),
                CommonTextField(
                  controller: _refranceContectController,
                  enabled: updateData,
                  inputFormatter: [FilteringTextInputFormatter.allow(RegExp((r'[A-Z0-9]'))),
                    LengthLimitingTextInputFormatter(10)],
                  keyboardType: TextInputType.number,
                  hintText: "Contact No",
                  labelText: "Contact No",
                ),
        
                SizedBox(height: 20),
        
                CommonTextField(
                  controller: _refranceLocationController,
                  enabled: updateData,
                  hintText: "Location",
                  labelText: "Location",
                ),
        
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.only(left:10,right:10,top: 20),
                  child: Column(
                    children: [
                      CommonElevatedButton(
                        onPressed: () async {
        
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
        ),
      ),
    );
  }
  
}