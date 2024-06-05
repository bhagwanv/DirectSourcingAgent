import 'package:direct_sourcing_agent/providers/auth_provider/DataProvider.dart';
import 'package:direct_sourcing_agent/utils/constant.dart';
import 'package:direct_sourcing_agent/view/connector/Connector_signup.dart';
import 'package:direct_sourcing_agent/view/dsa_company/direct_selling_agent.dart';
import 'package:direct_sourcing_agent/view/profile_type/ProfileTypes.dart';
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
        colorScheme: ColorScheme.fromSeed(seedColor:kPrimaryColor),
        useMaterial3: true,
      ),
      home:  Connector_signup(activityId: 2,subActivityId: 2,),
    );
  }
}
