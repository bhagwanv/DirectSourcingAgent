import 'package:direct_sourcing_agent/providers/DataProvider.dart';
import 'package:direct_sourcing_agent/shared_preferences/shared_pref.dart';
import 'package:direct_sourcing_agent/utils/common_elevted_button.dart';
import 'package:direct_sourcing_agent/utils/common_text_field.dart';
import 'package:direct_sourcing_agent/utils/constant.dart';
import 'package:direct_sourcing_agent/utils/utils_class.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'CreateLeadWebView.dart';

class CreateLeadWidgets extends StatefulWidget {
  @override
  State<CreateLeadWidgets> createState() => _CreateLeadWidgetsState();
}

class _CreateLeadWidgetsState extends State<CreateLeadWidgets> {
  final TextEditingController _MobileNumberController = TextEditingController();
  String? companyID;
  String? productCode;
  String? UserToken;

  @override
  void initState() {
    // TODO: implement initState
    getUserData();
  }
  @override
  Widget build(BuildContext context) {
    return Consumer<DataProvider>(builder: (context, productProvider, child) {
      return SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 0.0),
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
                      "Create Lead",
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
                controller: _MobileNumberController,
                hintText: "Mobile Number",
                labelText: "Mobile Number ",
                  keyboardType: TextInputType.number,
              ),
              SizedBox(
                height: 16.0,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 30, right: 30, top: 30),
                child: Column(
                  children: [
                    CommonElevatedButton(
                      onPressed: () async {
                        if (_MobileNumberController.text.toString().isEmpty) {
                          Utils.showToast("Please Mobile Number", context);
                        } else {

                          Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) =>  WebViewExample(mobileNumber: _MobileNumberController.text.toString(),companyID: companyID,productID: productCode,token: UserToken,)),
                          );

                        }
                      },
                      text: "Create Lead",
                      upperCase: true,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      );
    });
  }

  Future<void> getUserData()async {
    final prefsUtil = await SharedPref.getInstance();
    companyID = prefsUtil.getString(COMPANY_CODE);
    productCode = prefsUtil.getString(PRODUCT_CODE);
    UserToken = prefsUtil.getString(TOKEN);

  }
}
