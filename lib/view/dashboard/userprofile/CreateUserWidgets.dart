
import 'package:direct_sourcing_agent/utils/common_elevted_button.dart';
import 'package:direct_sourcing_agent/utils/common_text_field.dart';
import 'package:direct_sourcing_agent/utils/constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class CreateUserWidgets extends StatefulWidget{
  @override
  State<CreateUserWidgets> createState() => _CreateUserWidgetsState();
}

class _CreateUserWidgetsState extends State<CreateUserWidgets> {
  final TextEditingController _UserNameController = TextEditingController();

  final TextEditingController _MobileNumberController = TextEditingController();

  final TextEditingController _EmailController = TextEditingController();

  final TextEditingController _PayOutController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SingleChildScrollView(
      child: Padding(padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 0.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: 25,
          ),
          Row(
            children: [
              Spacer(),
              SizedBox(
                width: 50,
              ),
              Center(
                child: Text(
                  "Create New User",
                  style: GoogleFonts.urbanist(
                    fontSize: 20,
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Spacer(),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),

            ],
          ),
          SizedBox(
            height: 25,
          ),

          CommonTextField(
            controller: _UserNameController,
            hintText: "User Name",
            labelText: "User Name ",
          ),

          SizedBox(
            height: 16.0,
          ),

          CommonTextField(
            controller: _EmailController,
            keyboardType: TextInputType.emailAddress,
            hintText: "Email ID",
            labelText: "Email ID",
          ),

          SizedBox(
            height: 16.0,
          ),

          CommonTextField(
            controller: _MobileNumberController,
            inputFormatter: [
              FilteringTextInputFormatter.allow(
                  RegExp((r'[A-Z0-9]'))),
              LengthLimitingTextInputFormatter(10)
            ],
            keyboardType: TextInputType.number,
            hintText: "Mobile Number",
            labelText: "Mobile Number",
          ),

          SizedBox(
            height: 16.0,
          ),

          CommonTextField(
            controller: _PayOutController,
            hintText: "Payout %",
            labelText: "Payout %",
          ),

          SizedBox(
            height: 30.0,
          ),

          SizedBox(
            height: 80.0,
          ),

        Padding(
          padding: const EdgeInsets.only(left: 30, right: 30, top: 90),
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

        )],
      ),
    ),);
  }
}