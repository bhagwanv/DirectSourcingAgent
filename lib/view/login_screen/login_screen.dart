import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider/DataProvider.dart';
import '../../utils/constant.dart';
import '../../utils/utils_class.dart';
import 'components/LoginForm.dart';

class LoginScreen extends StatelessWidget {
  final int activityId;
  final int subActivityId;
  final int? companyID;
  final int?  ProductID;
  final String?  MobileNumber;
  final String?  pageType;

  const LoginScreen(
      {super.key, required this.activityId, required this.subActivityId, this.companyID, this.ProductID,this.MobileNumber, this.pageType});

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
              top: false,
              child: Consumer<DataProvider>(builder: (context, productProvider, child) {
                      return SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  LoginScreenTopImage(),
                  Row(
                    children: [
                      Spacer(),
                      Expanded(
                        flex: 8,
                        child: LoginForm(
                          productProvider: productProvider,
                          activityId: activityId,
                          subActivityId: subActivityId,
                          companyID: companyID,
                          ProductID: ProductID,
                            MobileNumber:MobileNumber
                        ),
                      ),
                      Spacer(),
                    ],
                  ),
                ],
              ),
                      );
                    }),
            ),
      ),
    );
  }
}

class LoginScreenTopImage extends StatelessWidget {
  const LoginScreenTopImage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 100, left: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 30, top: 50),
            child: Text(
              "Enter\nPhone Number",
              style: TextStyle(fontWeight: FontWeight.w400, fontSize: 35.5),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 50, left: 30),
            child: Text(
              "Please Enter Your registered number.",
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 15,
                  color: Colors.black),
              textAlign: TextAlign.start,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 10, left: 30),
            child: Text(
              "Enter Your Number",
              style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  color: gryColor),
              textAlign: TextAlign.start,
            ),
          ),
          Row(
            children: [
              Spacer(),
            ],
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }
}
