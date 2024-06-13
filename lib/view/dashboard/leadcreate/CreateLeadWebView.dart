import 'dart:io';

import 'package:direct_sourcing_agent/providers/DataProvider.dart';
import 'package:direct_sourcing_agent/shared_preferences/shared_pref.dart';
import 'package:direct_sourcing_agent/utils/ImagePicker.dart';
import 'package:direct_sourcing_agent/utils/constant.dart';
import 'package:direct_sourcing_agent/utils/utils_class.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

class WebViewExample extends StatefulWidget {
  final String? mobileNumber;
  final String? companyID;
  final String? productID;
  String? token;

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
  bool checkCamera = false;
  bool openCameraOnly = false;
  late String _cameraPhotoPath;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();

    /* late final PlatformWebViewControllerCreationParams params;
    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      params = WebKitWebViewControllerCreationParams(
        allowsInlineMediaPlayback: true,
        mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
      );
    } else {
      params = const PlatformWebViewControllerCreationParams();
    }

    final WebViewController controller = WebViewController.fromPlatformCreationParams(params);
     _controller = WebViewController.fromPlatformCreationParams(params, onPermissionRequest: (resources) async {
      return resources.grant();
    });
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
            _controller.runJavaScript("_callJavaScriptFunction('${widget.token}')");
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
        )
      )
      ..addJavaScriptChannel(
        '"cameraPermission"',
        onMessageReceived: (JavaScriptMessage message) {
          print("Call Method$message");
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

    _controller = controller;*/

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
        WebViewController.fromPlatformCreationParams(
      params,
      onPermissionRequest: (resources) async {
        return resources.grant();
      },
    );


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
            controller
                .runJavaScript("_callJavaScriptFunction('${widget.token}')");
            /* controller.runJavaScript(
              'openCameraOnly.postMessage("User Agent: " + navigator.userAgent);',
            );*/

          /*  controller.runJavaScript('''
      document.addEventListener('click', (event) => {
     openCameraOnly.postMessage("false");
      });
    ''');*/
          },
          onNavigationRequest: (NavigationRequest request) {
            return NavigationDecision.navigate;
          },
          onHttpError: (HttpResponseError error) {
            debugPrint('Error occurred on page: ${error.response?.statusCode}');
          },
          onUrlChange: (UrlChange change) {
            debugPrint('URL changed to ${change.url}');
          },
          onHttpAuthRequest: (HttpAuthRequest request) {
            debugPrint('Camera');
          },
        ),
      )

      ..addJavaScriptChannel(
        'openCameraOnly',
        onMessageReceived: (JavaScriptMessage message) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message.message)),
          );
          bool enable = message.message == 'true';
          setState(() {
            openCameraOnly = enable;
          });
          if (openCameraOnly) {
            _showFileChooser();
          } else {
            bottomSheetMenu(context);
          }
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
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text('Create Lead'),
          // This drop down menu demonstrates that Flutter widgets can be shown over the web view.
        ),
        body: WebViewWidget(controller: _controller),
       /* floatingActionButton: FloatingActionButton(
          onPressed: () {
            _controller.runJavaScript(
                "cameraPermission('${bottomSheetMenu(context)}')");
          },
        )*/);
  }

  bottomSheetMenu(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (builder) {
          return ImagePickerWidgets(onImageSelected: _onImageSelected);
        });
  }

  void _onImageSelected(File imageFile) async {
    // Handle the selected image here
    // For example, you can setState to update UI with the selected image;
    Utils.onLoading(context, "");
    await Provider.of<DataProvider>(context, listen: false)
        .postSingleFile(imageFile, true, "", "");
    // Navigator.pop(context);
    Navigator.of(context, rootNavigator: true).pop();
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

  Future<File> createImageFile() async {
    final directory = await getApplicationDocumentsDirectory();
    final path = directory.path;
    final file = File('$path/temp_photo.jpg');
    return file;
  }

  Future<void> _showFileChooser() async {
    if (openCameraOnly) {
      final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
      if (photo != null) {
        setState(() {
          _cameraPhotoPath = photo.path;
        });
      }
    } else {
      // You can add more functionality here to handle other file types if needed
      final XFile? file = await _picker.pickImage(source: ImageSource.gallery);
      if (file != null) {
        setState(() {
          _cameraPhotoPath = file.path;
        });
      }
    }
  }
}

