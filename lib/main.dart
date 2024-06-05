import 'package:direct_sourcing_agent/providers/auth_provider/DataProvider.dart';
import 'package:direct_sourcing_agent/view/aadhaar_screen/aadhaar_screen.dart';
import 'package:direct_sourcing_agent/view/login_screen/login_screen.dart';
import 'package:direct_sourcing_agent/view/pancard_screen/PancardScreen.dart';
import 'package:direct_sourcing_agent/view/splash/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp( ChangeNotifierProvider(
    create: (context) => DataProvider(),
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Scaleup App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      //home: AadhaarScreen(activityId: 2, subActivityId: 2),
      home: AadhaarScreen(activityId: 2, subActivityId: 2),
      //home: LoginScreen(activityId: 2, subActivityId: 2,MobileNumber: "9522392801",companyID: 1,ProductID: 1,),
    );
  }
}
