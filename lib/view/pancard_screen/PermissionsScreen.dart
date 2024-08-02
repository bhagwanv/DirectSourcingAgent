import 'package:direct_sourcing_agent/utils/constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../shared_preferences/shared_pref.dart';

class PermissionsScreen extends StatefulWidget {
  const PermissionsScreen({super.key});

  @override
  State<PermissionsScreen> createState() => _PermissionsScreenState();
}

class _PermissionsScreenState extends State<PermissionsScreen> {

  String? termsAndConditonUrl;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUrl();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          top: true,
          bottom: true,
          child: Stack(children: [
            termsAndConditonUrl!=null?Padding(
              padding: const EdgeInsets.all(15.0),
              child: WebViewWidget(
                controller: WebViewController()
                  ..setJavaScriptMode(JavaScriptMode.unrestricted)
                  ..setBackgroundColor(const Color(0x00000000))
                  ..setNavigationDelegate(
                    NavigationDelegate(
                      onProgress: (int progress) {
                        // Show a progress indicator while the page is loading
                        const CircularProgressIndicator();
                      },
                      onPageStarted: (String url) {},
                      onPageFinished: (String url) {},
                      onWebResourceError: (WebResourceError error) {},
                    ),
                  )
                  ..loadRequest(Uri.parse(termsAndConditonUrl!)),
              ),
            ):Container(),
            Positioned(
              top: 10.0,
              right: 10.0,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.black),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
          ],)

          ),
    );
  }

  void getUrl() async{
    final prefsUtil = await SharedPref.getInstance();
    setState(() {
      termsAndConditonUrl = prefsUtil.getString(Terms_And_Condition)!;
    });
  }
}



