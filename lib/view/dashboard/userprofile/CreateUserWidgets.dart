import 'package:direct_sourcing_agent/api/ApiService.dart';
import 'package:direct_sourcing_agent/api/FailureException.dart';
import 'package:direct_sourcing_agent/providers/DataProvider.dart';
import 'package:direct_sourcing_agent/utils/common_elevted_button.dart';
import 'package:direct_sourcing_agent/utils/common_text_field.dart';
import 'package:direct_sourcing_agent/utils/constant.dart';
import 'package:direct_sourcing_agent/utils/utils_class.dart';
import 'package:direct_sourcing_agent/view/dashboard/userprofile/model/CreateDSAUserReqModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class CreateUserWidgets extends StatefulWidget {
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
                  FilteringTextInputFormatter.allow(RegExp((r'[A-Z0-9]'))),
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
                        if (_UserNameController.text.toString().isEmpty) {
                          Utils.showToast("Please Enter User Name", context);
                        } else if (_EmailController.text.toString().isEmpty) {
                          Utils.showToast("Please Enter Email ID", context);
                        } else if (_MobileNumberController.text
                            .toString()
                            .isEmpty) {
                          Utils.showToast(
                              "Please Enter Mobile Number", context);
                        } else if (_PayOutController.text.toString().isEmpty) {
                          Utils.showToast("Please Enter Pay Out", context);
                        } else {
                          Utils.onLoading(context, "");
                          var model =CreateDSAUserReqModel(mobileNumber: _MobileNumberController.text.toString(),fullName:_UserNameController.text.toString() ,emailId:_EmailController.text.toString() ,payoutPercenatge:int.parse(_PayOutController.text.toString()));
                          await Provider.of<DataProvider>(context, listen: false).createDSAUser(model);
                          Navigator.of(context, rootNavigator: true).pop();

                          if (productProvider.getCreatDSAUserData != null) {
                            productProvider.getCreatDSAUserData!.when(
                              success: (CommanResponceModel) async {
                                // Handle successful response
                                var model = CommanResponceModel;
                                if (model.isSuccess!) {
                                  Navigator.pop(context);
                                } else {
                                  Utils.showToast(model.message!, context);
                                }
                              },
                              failure: (exception) {
                                if (exception is ApiException) {
                                  if (exception.statusCode == 401) {
                                    productProvider.disposeAllProviderData();
                                    ApiService().handle401(context);
                                  } else {
                                    Utils.showToast(exception.errorMessage, context);
                                  }
                                }
                              },
                            );
                          }

                        }
                      },
                      text: "Next",
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
}

