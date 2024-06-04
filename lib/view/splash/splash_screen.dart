import 'package:direct_sourcing_agent/view/dashboard/bottom_navigation.dart';
import 'package:direct_sourcing_agent/view/login_screen/login_screen.dart';
import 'package:flutter/material.dart';

import '../../shared_preferences/shared_pref.dart';
import '../../utils/constant.dart';
import '../dashboard/home/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _isLoggedIn = true;

  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Spacer(),
            Image.asset('assets/images/scaleup_logo.png'), // Replace with your logo image path
            SizedBox(height: 20),
            Text(
              'Scaleup',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            Spacer(),
            SizedBox(height: 40),
            Image.asset('assets/images/made_in_india.png'), // Replace with your "Made in India" image path
            SizedBox(height: 20),
            Icon(Icons.check_circle, color: Colors.green),
            Text(
              '100% Safe & Secure',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Copyright 2024 Scaleup. All rights reserved.',
              style: TextStyle(
                fontSize: 12,
              ),
            ),
            Row(
                mainAxisAlignment:MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
              Text(
                'Powered by ',
                style: TextStyle(
                  fontSize: 12,
                ),
              ),
              Text(
                'ShopGirana E-Trading Pvt. Ltd.',
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 12,
                ),
              ),
            ]
            ),
            SizedBox(height: 16)
          ],
        ),
      ),
    );
  }

  _checkLoginStatus() async {
    final prefs = await SharedPref.getInstance();
  //  final isLoggedIn = prefs.getBool(IS_LOGGED_IN)?? false;
    setState(() {
      _isLoggedIn = true;
    });
    Future.delayed(Duration(seconds: 3), () {
      if (_isLoggedIn) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen(activityId: 0, subActivityId: 0)),
        );
      } else {
       /* Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );*/
      }
    });
  }
}
