
import 'package:direct_sourcing_agent/api/ApiService.dart';
import 'package:direct_sourcing_agent/api/FailureException.dart';
import 'package:direct_sourcing_agent/providers/DataProvider.dart';
import 'package:direct_sourcing_agent/shared_preferences/shared_pref.dart';
import 'package:direct_sourcing_agent/utils/common_elevted_button.dart';
import 'package:direct_sourcing_agent/utils/common_text_field.dart';
import 'package:direct_sourcing_agent/utils/constant.dart';
import 'package:direct_sourcing_agent/utils/utils_class.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../utils/myWebBrowser.dart';

class CreateLeadWidgets extends StatefulWidget {

  final String productType;
  const CreateLeadWidgets({super.key, required this.productType});

  @override
  State<CreateLeadWidgets> createState() => _CreateLeadWidgetsState();
}

class _CreateLeadWidgetsState extends State<CreateLeadWidgets> {
  final TextEditingController _MobileNumberController = TextEditingController();
  String? createLeadBaseUrl;
  String? companyID;
  String? UserToken;
  String? UserID;
  final browser = MyInAppBrowser();

  final settings = InAppBrowserClassSettings(
    browserSettings: InAppBrowserSettings(
      hideUrlBar: true,
    ),
    webViewSettings: InAppWebViewSettings(
      userAgent: "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36",
      javaScriptEnabled: true,
      isInspectable: kDebugMode,
      clearCache: true,
      geolocationEnabled: true,
      allowFileAccess: true, // Allows access to files
      allowContentAccess: true, // Allows access to content
      mediaPlaybackRequiresUserGesture: false, // For autoplay
      allowsInlineMediaPlayback: true, // Allows inline playback of media
      useWideViewPort: true, // Makes the web view more adaptable
      allowUniversalAccessFromFileURLs: true, // Enables universal access
      domStorageEnabled: true,

    ),
  );

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
                  const Spacer(),
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
                  FilteringTextInputFormatter.allow(RegExp((r'[0-9]'))),
                  LengthLimitingTextInputFormatter(10)
                ],
                keyboardType: TextInputType.number,
              ),
              const SizedBox(
                height: 16.0,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 30, right: 30, top: 30),
                child: Column(
                  children: [
                    CommonElevatedButton(
                      onPressed: () async {
                        if (_MobileNumberController.text
                                .trim()
                                .toString()
                                .isEmpty ||
                            _MobileNumberController.text.trim().length < 10) {
                          Utils.showToast(
                              "Please enter valid mobile number", context);
                        } else if (!Utils.isPhoneNoValid(
                            _MobileNumberController.text.trim())) {
                          Utils.showToast(
                              "Please enter valid mobile number", context);
                        } else {
                          Utils.onLoading(context, "");
                          await Provider.of<DataProvider>(context, listen: false).getCheckLeadCreatePermission(_MobileNumberController.text.trim());
                          Navigator.of(context, rootNavigator: true).pop();
                          if (productProvider.getLeadCreatePermission != null) {
                            productProvider.getLeadCreatePermission!.when(
                              success: (data) {
                                if (data.status!) {
                                  openInAppBrowser(UserToken!, context,UserID!);
                                } else {
                                  Utils.showToast(data.message!, context);
                                }
                              },
                              failure: (exception) {
                                // Handle failure
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

  Future<void> getUserData() async {
    final prefsUtil = await SharedPref.getInstance();
    createLeadBaseUrl = prefsUtil.getString(CREATE_LEAD_BASE_URL);
    companyID = prefsUtil.getString(COMPANY_CODE);
   // productCode = prefsUtil.getString(PRODUCT_CODE);
    UserToken = prefsUtil.getString(TOKEN);
    UserID = prefsUtil.getString(USER_ID);
    print("productType-${widget.productType}");
  }

  void openInAppBrowser(String token, BuildContext _context,String userID) {
    browser.token = token;
    browser.context = _context;
    browser.UserID = userID;
    browser.openUrlRequest(
      urlRequest: URLRequest(url: WebUri(_constructUrl())),
      settings: settings,

    );

  }

  String _constructUrl() {
    String baseUrl = createLeadBaseUrl?.toString() ?? "";
    String mobileNumber = _MobileNumberController.text.toString() ?? "";
    String companyId = companyID?.toString() ?? "";
    String productId =  widget.productType?.toString() ?? "";
    return "$baseUrl/$mobileNumber/$companyId/$productId/true";
     }
}
