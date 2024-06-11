import 'package:direct_sourcing_agent/shared_preferences/shared_pref.dart';
import 'package:direct_sourcing_agent/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:webview_flutter/webview_flutter.dart';

class CreateLeadWebView extends StatefulWidget {
  final String? mobileNumber;
  final String? companyID;
  final String? productID;

  CreateLeadWebView({
    required this.mobileNumber,
    required this.companyID,
    required this.productID,
  });
  @override
  _CreateLeadWebViewState createState() => _CreateLeadWebViewState();
}

class _CreateLeadWebViewState extends State<CreateLeadWebView> {
  WebViewController? webViewController;
  String result = "Result will be shown here";
  int? companyID;
  int? productID;



  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getUserData();
    print(_constructUrl());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Lead"),
      ),
      body:WebViewWidget(
          controller: webViewController= WebViewController()
            ..setJavaScriptMode(JavaScriptMode.unrestricted)
            ..setBackgroundColor(const Color(0x00000000))
            ..addJavaScriptChannel("_callJavaScriptFunction", onMessageReceived: (JavaScriptMessage message)
            {
              Text(message.message);
            })
            ..setNavigationDelegate(
              NavigationDelegate(
                onProgress: (int progress) {
                  CircularProgressIndicator();
                },
                onPageStarted: (String url)async {
                  // webViewController?.evaluateJavascript(source:"yourJavaScriptFunction('Hello from Flutter!')" );
                },
                onPageFinished: (String url) {

                  webViewController?.runJavaScript('''
    (function() {
      function _callJavaScriptFunction() {
        // Your JavaScript code here
        return 'Hello from JavaScript';
      }
      return _callJavaScriptFunction(); })(); ''').then((result) {
                    print('JavaScript injection result:');
                  }).catchError((error) {
                    print('JavaScript injection error: $error');
                  });



                  //_injectJavaScript();
                },
              ),
              
            )
            ..loadRequest(
                Uri.parse(_constructUrl()))),
      floatingActionButton: FloatingActionButton(
        //backgroundColor: Colors.transparent,
        onPressed: () async {
         print("Bhagwan"+result.toString());
        },
      ),
    );
  }




  String _constructUrl() {
    String baseUrl = "https://customer-uat.scaleupfin.com/#/lead";
    String mobileNumber = widget.mobileNumber ?? "";
    String companyId = widget.companyID?.toString() ?? "";
    String productId = widget.productID?.toString() ?? "";
    return "$baseUrl/$mobileNumber/$companyId/$productId/true";
  }

  void _injectJavaScript() {
    webViewController?.runJavaScript('''
    (function() {
      function _callJavaScriptFunction() {
        // Your JavaScript code here
        return 'Hello from JavaScript';
      }
      return _callJavaScriptFunction(); })(); ''').then((result) {
      print('JavaScript injection result:');
    }).catchError((error) {
      print('JavaScript injection error: $error');
    });
  }

  // Method to call JavaScript function
  void _callJavaScriptFunction() async {
    final result = await webViewController!.runJavaScriptReturningResult('yourJavaScriptFunction()');
    print("bhagwan$result"); // Handle the result from JavaScript
  }
  Future<void> getUserData() async{
    final prefsUtil = await SharedPref.getInstance();
    companyID = prefsUtil.getInt(COMPANY_ID);
    productID = prefsUtil.getInt(PRODUCT_ID);
  }
}





