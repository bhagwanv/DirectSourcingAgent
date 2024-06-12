import 'package:direct_sourcing_agent/providers/DataProvider.dart';
import 'package:direct_sourcing_agent/providers/ThemeProvider.dart';
import 'package:direct_sourcing_agent/utils/constant.dart';
import 'package:direct_sourcing_agent/view/agreement_screen/Agreementscreen.dart';
import 'package:direct_sourcing_agent/view/connector/Connector_signup.dart';
import 'package:direct_sourcing_agent/view/dashboard/bottom_navigation.dart';
import 'package:direct_sourcing_agent/view/dsa_company/direct_selling_agent.dart';
import 'package:direct_sourcing_agent/view/profile_type/ProfileTypes.dart';
import 'package:direct_sourcing_agent/view/splash/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() async {
  runApp( MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => DataProvider()),
      ChangeNotifierProvider(create: (_) => ThemeProvider())
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return MaterialApp(
      theme: themeProvider.themeData,
      debugShowCheckedModeBanner: false,
      title: 'Scaleup App',
      home:  SplashScreen(),
     // home: Connector_signup (activityId: 1, subActivityId: 0,),
    );
  }
}
