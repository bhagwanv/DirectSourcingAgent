

import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider/DataProvider.dart';
import '../../utils/common_elevted_button.dart';
import '../aadhaar_screen/components/CheckboxTerm.dart';

class ProfileTypes extends StatefulWidget{

  final int activityId;
  final int subActivityId;
  final String?  pageType;


  ProfileTypes(
      {super.key, required this.activityId, required this.subActivityId, this.pageType});


  @override
  State<ProfileTypes> createState() => _ProfileTypesState();

}

class _ProfileTypesState extends State<ProfileTypes>{
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
      body: SafeArea( child: Column(crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 40),
           Center(
           child: Text(
            'Choose Profile Type',
            textAlign: TextAlign.start,
            style: TextStyle(fontSize: 16, color: Colors.black,fontWeight:FontWeight.bold ),
                   ),
         ),
          const SizedBox(height: 70),
          Padding(
            padding: const EdgeInsets.only(left: 20,right: 20),
            child: CheckboxTerm(
              content:
              "DSA (Direct Selling Agent):",
              isChecked: _isSelected1,
              onChanged: (bool? value) {
                isTermsChecks = value!;
                _handleCheckboxChange(1, isTermsChecks);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 52,right: 30),
            child: Text(
              "If you are representing a registered entity such as a Pvt Ltd Company, HUF, LLC, Proprietorship, or any other registered firm type, you can onboard with us as a DSA. As a DSA, you will facilitate loan applications and earn higher commissions based on successful disbursements.",
              textAlign: TextAlign.justify,
              style: GoogleFonts.urbanist(
              fontSize: 12,
              color: Colors.black,
              fontWeight: FontWeight.w300,
            ),
            ),
          ),

          const SizedBox(height: 50),
          Padding(
            padding: const EdgeInsets.only(left: 20,right: 20),
            child: CheckboxTerm(
              content:
              "Connector",
              isChecked: _isSelected2,
              onChanged: (bool? value) {
                isTermsChecks = value!;
                _handleCheckboxChange(2, isTermsChecks);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 52,right: 30),
            child: Text(
              "If you are an individual without any formal firm registration, you can join us as a Connector. As a Connector, you can refer potential loan applicants and earn commissions based on successful disbursements.",
              textAlign: TextAlign.justify,
              style: GoogleFonts.urbanist(
                fontSize: 12,
                color: Colors.black,
                fontWeight: FontWeight.w300,
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(left:30,right:30,top: 80),
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

          ],),),
    );
  }



}