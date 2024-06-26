
import 'package:direct_sourcing_agent/providers/DataProvider.dart';
import 'package:direct_sourcing_agent/providers/ThemeProvider.dart';
import 'package:direct_sourcing_agent/utils/firebase_options.dart';
import 'package:direct_sourcing_agent/view/CongratulationScreen.dart';
import 'package:direct_sourcing_agent/view/aadhaar_screen/aadhaar_screen.dart';
import 'package:direct_sourcing_agent/view/agreement_screen/Agreementscreen.dart';
import 'package:direct_sourcing_agent/view/bank_details_screen/BankDetailsScreen.dart';
import 'package:direct_sourcing_agent/view/connector/Connector_signup.dart';
import 'package:direct_sourcing_agent/view/dsa_company/direct_selling_agent.dart';
import 'package:direct_sourcing_agent/view/splash/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

// ...

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Permission.camera.request();
  await Permission.microphone.request();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
      //home:  CongratulationScreen(transactionReqNo: '', amount: null, mobileNo: '', loanAccountId: 0, creditDay: 0,),
    );
  }
}
