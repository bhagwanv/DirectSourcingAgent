import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../utils/common_text_field.dart';
import '../../utils/utils_class.dart';
import '../aadhaar_screen/components/CheckboxTerm.dart';

class direct_selling_agent extends StatefulWidget {
  int? activityId;
  int? subActivityId;

  direct_selling_agent(
      {required this.activityId, required this.subActivityId, super.key});

  @override
  State<direct_selling_agent> createState() => DirectSellingAgent();
}

class DirectSellingAgent extends State<direct_selling_agent> {
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
  }

