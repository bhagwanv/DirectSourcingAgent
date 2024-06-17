
import 'package:direct_sourcing_agent/providers/DataProvider.dart';
import 'package:direct_sourcing_agent/shared_preferences/shared_pref.dart';
import 'package:direct_sourcing_agent/utils/common_elevted_button.dart';
import 'package:direct_sourcing_agent/utils/common_text_field.dart';
import 'package:direct_sourcing_agent/utils/constant.dart';
import 'package:direct_sourcing_agent/utils/loader.dart';
import 'package:direct_sourcing_agent/utils/utils_class.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';


class CreateLeadWidgets extends StatefulWidget {
  @override
  State<CreateLeadWidgets> createState() => _CreateLeadWidgetsState();
}

class _CreateLeadWidgetsState extends State<CreateLeadWidgets> {
  final TextEditingController _MobileNumberController = TextEditingController();
  String? companyID;
  String? productCode;
  String? UserToken;
  final browser = MyInAppBrowser();

  final settings = InAppBrowserClassSettings(
      browserSettings: InAppBrowserSettings(hideUrlBar: true),
      webViewSettings: InAppWebViewSettings(
          javaScriptEnabled: true, isInspectable: kDebugMode,clearCache:true));

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
              const SizedBox(
                height: 25,
              ),
              Row(
                children: [
                  Spacer(),
                  const SizedBox(
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
                inputFormatter: [
                  FilteringTextInputFormatter.allow(
                      RegExp((r'[0-9]'))),
                  LengthLimitingTextInputFormatter(10)
                ],
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
                        if (_MobileNumberController.text.trim().toString().isEmpty || _MobileNumberController.text.trim().length < 10 ) {
                          Utils.showToast("Please enter valid mobile number", context);
                        } else if (!Utils.isPhoneNoValid(_MobileNumberController.text.trim())) {
                          Utils.showToast("Please enter valid mobile number", context);
                        }else {
                          openInAppBrowser(UserToken!,context);

                         /* Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                                builder: (context) =>  WebViewExample(mobileNumber: _MobileNumberController.text.toString(),companyID: companyID,productID: productCode,token: UserToken,)),
                          );*/


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

  void openInAppBrowser(String token, BuildContext _context) {
    browser.token=token;
    browser.context=_context;
    browser.openUrlRequest(
      urlRequest: URLRequest(url: WebUri(_constructUrl())),
      settings: settings,

    );
  }

  String _constructUrl() {
    String baseUrl = "https://customer-qa.scaleupfin.com/#/lead";
    String mobileNumber = _MobileNumberController.text.toString() ?? "";
    String companyId = companyID?.toString() ?? "";
    String productId = productCode?.toString() ?? "";
    return "$baseUrl/$mobileNumber/$companyId/$productId/true";
  }

}

class MyInAppBrowser extends InAppBrowser {
  var token;
  var context;


  MyInAppBrowser();
  @override
  Future onBrowserCreated() async {
    Navigator.of(context, rootNavigator: true).pop();
  }

  @override
  Future onLoadStart(url) async {
    print("Started $url");
    Loader();
  }

  @override
  Future onLoadStop(url) async {
    print("Stopped $token");
    await webViewController?.evaluateJavascript(source: "_callJavaScriptFunction('${token}')");
  }

  @override
  void onProgressChanged(progress) {
    print("Progress: $progress");
  }

  @override
  void onExit() {
   print("Browser  closed!");
  }
}
