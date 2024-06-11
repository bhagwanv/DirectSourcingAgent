import 'package:direct_sourcing_agent/shared_preferences/shared_pref.dart';
import 'package:direct_sourcing_agent/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

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
        body: Container());
  }

  String _constructUrl() {
    String baseUrl = "https://customer-uat.scaleupfin.com/#/lead";
    String mobileNumber = widget.mobileNumber ?? "";
    String companyId = widget.companyID?.toString() ?? "";
    String productId = widget.productID?.toString() ?? "";
    String token = widget.productID?.toString() ?? "";
    return "$baseUrl/$mobileNumber/$companyId/$productId/true";
  }

  Future<void> getUserData() async {
    final prefsUtil = await SharedPref.getInstance();
    companyID = prefsUtil.getInt(COMPANY_ID);
    productID = prefsUtil.getInt(PRODUCT_ID);
  }
}

class WebViewExample extends StatefulWidget {
  final String? mobileNumber;
  final String? companyID;
  final String? productID;
  final String? token;

  WebViewExample(
      {required this.mobileNumber,
      required this.companyID,
      required this.productID,
      required this.token});

  @override
  State<WebViewExample> createState() => _WebViewExampleState();
}

class _WebViewExampleState extends State<WebViewExample> {
  late final WebViewController _controller;
  int? companyID;
  int? productID;
  String? token;

  @override
  void initState() {
    super.initState();

    late final PlatformWebViewControllerCreationParams params;
    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      params = WebKitWebViewControllerCreationParams(
        allowsInlineMediaPlayback: true,
        mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
      );
    } else {
      params = const PlatformWebViewControllerCreationParams();
    }

    final WebViewController controller =
        WebViewController.fromPlatformCreationParams(params);
    controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            debugPrint('WebView is loading (progress : $progress%)');
          },
          onPageStarted: (String url) {
            debugPrint('Page started loading: $url');
          },
          onPageFinished: (String url) {
            debugPrint('Page finished loading: $url');
          },
          onWebResourceError: (WebResourceError error) {
            debugPrint('''
Page resource error:
  code: ${error.errorCode}
  description: ${error.description}
  errorType: ${error.errorType}
  isForMainFrame: ${error.isForMainFrame}
          ''');
          },
          onNavigationRequest: (NavigationRequest request) {
            return NavigationDecision.navigate;
          },
          onHttpError: (HttpResponseError error) {
            debugPrint('Error occurred on page: ${error.response?.statusCode}');
          },
          onUrlChange: (UrlChange change) {
            debugPrint('url change to ${change.url}');
          },
          onHttpAuthRequest: (HttpAuthRequest request) {},
        ),
      )
      ..addJavaScriptChannel(
        '"_callJavaScriptFunction(' "123" ')"',
        onMessageReceived: (JavaScriptMessage message) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message.message)),
          );
        },
      )
      ..loadRequest(Uri.parse(_constructUrl()));

    // #docregion platform_features
    if (controller.platform is AndroidWebViewController) {
      AndroidWebViewController.enableDebugging(true);
      (controller.platform as AndroidWebViewController)
          .setMediaPlaybackRequiresUserGesture(false);
    }
    // #enddocregion platform_features

    _controller = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.green,
        appBar: AppBar(
          title: const Text('Flutter WebView example'),
          // This drop down menu demonstrates that Flutter widgets can be shown over the web view.
        ),
        body: WebViewWidget(controller: _controller),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            print("Hello");
            String valueToSend = "Hello from Flutter!";
            _controller.runJavaScript("_callJavaScriptFunction('$token')");
          },
        ));
  }

  String _constructUrl() {
    String baseUrl = "https://customer-qa.scaleupfin.com/#/lead";
    String mobileNumber = widget.mobileNumber ?? "";
    String companyId = widget.companyID?.toString() ?? "";
    String productId = widget.productID?.toString() ?? "";
    return "$baseUrl/$mobileNumber/$companyId/$productId/true";
  }

  Future<void> getUserData() async {
    final prefsUtil = await SharedPref.getInstance();
    companyID = prefsUtil.getInt(COMPANY_ID);
    productID = prefsUtil.getInt(PRODUCT_ID);
  }
}
