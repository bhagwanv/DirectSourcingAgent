import 'dart:ui';
import 'package:direct_sourcing_agent/providers/DataProvider.dart';
import 'package:direct_sourcing_agent/providers/ThemeProvider.dart';
import 'package:direct_sourcing_agent/utils/PermissionPage.dart';
import 'package:direct_sourcing_agent/utils/firebase_options.dart';
import 'package:direct_sourcing_agent/view/splash/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';


final navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _initializeFirebase();
  _initializeErrorHandling();
  runApp( MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => DataProvider()),
      ChangeNotifierProvider(create: (_) => ThemeProvider())
    ],
    child: MyApp(),
  ));
}

Future<void> _initializeFirebase() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}

void _initializeErrorHandling() {
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

  // Pass uncaught asynchronous errors to Crashlytics
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return MaterialApp(
      theme: themeProvider.themeData,
      debugShowCheckedModeBanner: false,
      title: 'Scaleup App',
      home:  const SplashScreen(),
     // home:  DirectSellingAgent(activityId: 0, subActivityId: 0),
    );

  }
}
