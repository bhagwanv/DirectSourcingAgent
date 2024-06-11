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
  InAppWebViewController? webViewController;
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
        title: Text("InAppWebView Example"),
      ),
      body: Column(
        children: [
          Expanded(
            child: InAppWebView(
              initialUrlRequest: URLRequest(
                url: WebUri("https://www.youtube.com/watch?v=kQDd1AhGIHk"),
              ),
              initialSettings: InAppWebViewSettings(
                useHybridComposition: true, // Adjust settings as needed
              ),
              onWebViewCreated: (controller) {
                webViewController = controller;
              },
              onLoadStart: (controller, url) {
                print("Page started loading: $url");
              },
              onLoadStop: (controller, url) async {
                print("Page finished loading: $url");
                if (webViewController != null) {
                  // Replace 'yourFunctionName()' with the actual JavaScript function you want to call
                  String jsResult = await webViewController!.evaluateJavascript(
                      source: "yourJavaScriptFunction()");
                  setState(() {
                    result = jsResult;
                  });
                }
              },
              onLoadError: (controller, url, code, message) {
                print("Failed to load: $url, Error: $code, Message: $message");
              },
            ),
          ),

        ],
      ),
    );
  }



  String _constructUrl() {
    String baseUrl = "https://customer-uat.scaleupfin.com/#/lead";
    String mobileNumber = widget.mobileNumber ?? "";
    String companyId = widget.companyID?.toString() ?? "";
    String productId = widget.productID?.toString() ?? "";
    return "$baseUrl/$mobileNumber/$companyId/$productId/true";
   //return "https://customer-uat.scaleupfin.com/#/lead/8959311437/108/8/true";
  }

 /* void _injectJavaScript() {
    _controller.runJavaScript('''
    function yourJavaScriptFunction() {
      // Your JavaScript code here
      return 'Hello from JavaScript';
    }
    yourJavaScriptFunction();
  ''').then((result) {
      print('JavaScript injection result:');
    }).catchError((error) {
      print('JavaScript injection error: $error');
    });
  }


  // Method to call JavaScript function
  void _callJavaScriptFunction() async {
    final result = await _controller.runJavaScriptReturningResult('yourJavaScriptFunction()');
    print("bhagwan$result"); // Handle the result from JavaScript
  }
*/
  Future<void> getUserData() async{
    final prefsUtil = await SharedPref.getInstance();
    companyID = prefsUtil.getInt(COMPANY_ID);
    productID = prefsUtil.getInt(PRODUCT_ID);
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyInAppWebView(),
    );
  }
}

class MyInAppWebView extends StatefulWidget {
  @override
  _MyInAppWebViewState createState() => _MyInAppWebViewState();
}

class _MyInAppWebViewState extends State<MyInAppWebView> {
  InAppWebViewController? webView;
 String result = "Result will be shown here";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("InAppWebView Example"),
      ),
      body: Column(
        children: [
          Expanded(
            child: InAppWebView(
              initialUrlRequest: URLRequest(
                url: WebUri(
                    "https://customer-uat.scaleupfin.com/#/lead/8959311437/SCA010/BusinessLoan/true"),
              ),
              initialOptions: InAppWebViewGroupOptions(
                android: AndroidInAppWebViewOptions(
                  useHybridComposition: true,
                ),
              ),
              onWebViewCreated: (controller) {
                webView = controller;
              },
              onLoadStart: (controller, url)async {
                print("Page started loading: $url");
                if (webView != null) {
                  // Replace 'yourFunctionName()' with the actual JavaScript function you want to call
                  String jsResult = await webView!.evaluateJavascript(
                      source: "yourFunctionName()");
                  setState(() {
                    result = jsResult;
                  });
                }

              },
              onLoadStop: (controller, url) {
                print("Page finished loading: $url");
              },
            ),
          ),
        ],
      ),
    );
  }
}
