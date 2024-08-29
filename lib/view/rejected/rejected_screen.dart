import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';

import '../../utils/common_elevted_button.dart';
import '../../utils/constant.dart';
import '../../utils/utils_class.dart';

class RejectedScreen extends StatelessWidget {
  final String? pageType;
  const RejectedScreen({super.key, this.pageType});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        debugPrint("didPop1: $didPop");
        if (didPop) {
          return;
        }
        if(pageType == "pushReplacement" ) {
          final bool shouldPop = await Utils().onback(context);
          if (shouldPop) {
            SystemNavigator.pop();
          }
        } else {
          SystemNavigator.pop();
        }
      },
      child: Scaffold(
        backgroundColor: whiteColor,
        body: SafeArea(
          top: true,
          bottom: true,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(30),
              child: Column(
                children: [
                  const SizedBox(height: 50),
                  Container(
                    alignment: Alignment.center,
                    child: SvgPicture.asset('assets/images/rejected.svg'),
                  ),
                  const SizedBox(height: 60),
                  const Padding(
                    padding: EdgeInsets.only(left: 5, right: 5),
                    child: Column(
                      children: [
                        Text(
                          "Rejected",
                          style: TextStyle(color: kPrimaryColor, fontSize: 32, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Column(
                    children: [
                      Text(
                        "We can not proceed wth your application as per our internal policy.",
                        style: TextStyle(color: Colors.black, fontSize: 14),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                  const SizedBox(height: 80),
                  CommonElevatedButton(
                    onPressed: () {
                      SystemNavigator.pop();
                    },
                    text: "Back to home",
                    upperCase: true,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
