import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../api/ApiService.dart';
import '../../api/FailureException.dart';
import '../../providers/DataProvider.dart';
import '../../shared_preferences/shared_pref.dart';
import '../../utils/common_elevted_button.dart';
import '../../utils/constant.dart';
import '../../utils/customer_sequence_logic.dart';
import '../../utils/utils_class.dart';
import '../splash/model/GetLeadResponseModel.dart';
import '../splash/model/LeadCurrentRequestModel.dart';
import '../splash/model/LeadCurrentResponseModel.dart';

class AgreementScreen extends StatefulWidget {
  final int activityId;
  final int subActivityId;
  final String? pageType;

  const AgreementScreen(
      {super.key,
      required this.activityId,
      required this.subActivityId,
      this.pageType});

  @override
  State<AgreementScreen> createState() => _AgreementScreenState();
}

class _AgreementScreenState extends State<AgreementScreen> {
  bool ischeckBoxCheck = false;
  var isLoading = true;
  var content = "";
  var isSubmit = false;
  var isCheckStatus = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      callApi(context, isSubmit);
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    isCheckStatus = false;
  }

  @override
  Widget build(BuildContext context) {
    final dataProvider = Provider.of<DataProvider>(context);

    if (!isCheckStatus) {
      if (dataProvider.dSAGenerateAgreementData != null) {
        dataProvider.dSAGenerateAgreementData!.when(
          success: (data) {
            content = data.response.toString();
          },
          failure: (exception) {
            if (exception is ApiException) {
              if (exception.statusCode == 401) {
                ApiService().handle401(context);
              } else {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  content = "";
                  Utils.showToast("Something went wrong", context);
                });
              }
            }
          },
        );
      }
    }
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
        body: SafeArea(
          top: true,
          bottom: true,
          child: Consumer<DataProvider>(
              builder: (context, productProvider, child) {
            return isSubmit
                ? Stack(
                  children: [
                    Positioned.fill(
                      child: Column(
                        children: [
                          Center(
                            child: Text(
                              "Agreement",
                              style: GoogleFonts.urbanist(
                                fontSize: 30,
                                color: blackSmall,
                                fontWeight: FontWeight.w400,
                              ),
                              textAlign: TextAlign.start,
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 74.0),
                              child: WebViewWidget(
                                controller: WebViewController()
                                  ..setJavaScriptMode(JavaScriptMode.unrestricted)
                                  ..setBackgroundColor(const Color(0x00000000))
                                  ..setNavigationDelegate(
                                    NavigationDelegate(
                                      onProgress: (int progress) {
                                        // Show a progress indicator while the page is loading
                                        CircularProgressIndicator();
                                      },
                                      onPageStarted: (String url) {},
                                      onPageFinished: (String url) {},
                                      onWebResourceError: (WebResourceError error) {},
                                    ),
                                  )
                                  ..loadRequest(Uri.parse(content)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      bottom: 8.0, // Adjust this value if you need more or less space
                      left: 16.0, // Adjust these values to position the button horizontally
                      right: 16.0,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CommonElevatedButton(
                            onPressed: () async {
                              isCheckStatus = true;
                              await checkESignDocumentStatus(context, productProvider);
                            },
                            text: 'Next',
                            upperCase: true,
                          ),
                        ],
                      ),
                    ),
                  ],
                )
                : Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30.0, vertical: 0.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Text(
                            "Agreement",
                            style: GoogleFonts.urbanist(
                              fontSize: 30,
                              color: blackSmall,
                              fontWeight: FontWeight.w400,
                            ),
                            textAlign: TextAlign.start,
                          ),
                        ),
                        const SizedBox(
                          height: 8.0,
                        ),
                        Expanded(
                          child: SingleChildScrollView(
                            child: HtmlWidget(
                              content// If HtmlWidget supports webView
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 8.0,
                        ),
                        Container(
                          child: CommonElevatedButton(
                            onPressed: () async {
                              isSubmit = true;
                              content = "";
                              dataProvider.disposeDSAGenerateAgreementData();
                              callApi(context, isSubmit);
                              // content = "https://app.karza.in/test/esign/initial-consent/9b03ed73-6064-42f7-a74f-cbbbb57f3827";
                            },
                            text: 'Proceed to E-sign',
                            upperCase: true,
                          ),
                        ),
                        const SizedBox(
                          height: 8.0,
                        ),
                      ],
                    ),
                  );
          }),
        ),
      ),
    );
  }

  Future<void> checkESignDocumentStatus(
    BuildContext context,
    DataProvider productProvider,
  ) async {
    final prefsUtil = await SharedPref.getInstance();
    final int? leadId = prefsUtil.getInt(LEADE_ID);

    Utils.onLoading(context, "");
    await Provider.of<DataProvider>(context, listen: false)
        .checkESignDocumentStatus(leadId.toString());
    Navigator.of(context, rootNavigator: true).pop();
    if (productProvider.checkESignResponseModelData != null) {
      productProvider.checkESignResponseModelData!.when(
        success: (data) {
          if (data.status!) {
            fetchData(context);
          }
        },
        failure: (exception) {
          // Handle failure
          if (exception is ApiException) {
            if (exception.statusCode == 401) {
              productProvider.disposeAllProviderData();
              ApiService().handle401(context);
            } else {
              Utils.showToast("Something went Wrong", context);
            }
          }
        },
      );
    }
  }

  void callApi(BuildContext context, bool isSubmit) async {
    final prefsUtil = await SharedPref.getInstance();
    final int? leadId = prefsUtil.getInt(LEADE_ID);
    final int? productId = prefsUtil.getInt(PRODUCT_ID);
    final int? companyId = prefsUtil.getInt(COMPANY_ID);
    final String? userMobileNumber = prefsUtil.getString(LOGIN_MOBILE_NUMBER);
    Provider.of<DataProvider>(context, listen: false).dSAGenerateAgreement(
        context,
        leadId!.toString(),
        productId.toString(),
        companyId.toString(),
        isSubmit);
  }

  Future<void> fetchData(BuildContext context) async {
    final prefsUtil = await SharedPref.getInstance();
    try {
      LeadCurrentResponseModel? leadCurrentActivityAsyncData;
      var leadCurrentRequestModel = LeadCurrentRequestModel(
        companyId: prefsUtil.getInt(COMPANY_ID),
        productId: prefsUtil.getInt(PRODUCT_ID),
        leadId: prefsUtil.getInt(LEADE_ID),
        userId: prefsUtil.getString(USER_ID),
        mobileNo: prefsUtil.getString(LOGIN_MOBILE_NUMBER),
        activityId: widget.activityId,
        subActivityId: widget.subActivityId,
        monthlyAvgBuying: 0,
        vintageDays: 0,
        isEditable: true,
      );
      leadCurrentActivityAsyncData = await ApiService()
              .leadCurrentActivityAsync(leadCurrentRequestModel, context)
          as LeadCurrentResponseModel?;

      GetLeadResponseModel? getLeadData;
      getLeadData = await ApiService().getLeads(
          prefsUtil.getString(LOGIN_MOBILE_NUMBER)!,
          prefsUtil.getInt(PRODUCT_ID)!,
          prefsUtil.getInt(COMPANY_ID)!,
          prefsUtil.getInt(LEADE_ID)!) as GetLeadResponseModel?;

      customerSequence(
          context, getLeadData, leadCurrentActivityAsyncData, "push");
    } catch (error) {
      if (kDebugMode) {
        print('Error occurred during API call: $error');
      }
    }
  }

/* Future<void> callAggrementDetailsApi(
      bool accept,
      BuildContext context,
      bool isSubmit,
      ) async {
    final prefsUtil = await SharedPref.getInstance();
    final int? leadId = prefsUtil.getInt(LEADE_ID);
    final int? companyID = prefsUtil.getInt(COMPANY_ID);
   // Utils.onLoading(context,"");
    aggrementDetails = await ApiService().GetAgreemetDetail(leadId!, accept, companyID!);
  //  Navigator.of(context, rootNavigator: true).pop();

    if(isSubmit){
      await fetchData(context);
    }else{
      */ /*setState(() {
      });*/ /*
    }
  }*/
}
