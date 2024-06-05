import 'package:direct_sourcing_agent/view/login_screen/login_screen.dart';
import 'package:flutter/material.dart';
import '../../shared_preferences/shared_pref.dart';
import '../../utils/constant.dart';

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
      body:
      Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Spacer(),
            Image.asset('assets/images/scaleup_logo.png'), // Replace with your logo image path
            const SizedBox(height: 20),
            const Text(
              'Scaleup',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.normal,
              ),
            ),
            const Spacer(),
            const CustomCircularLoader(),
            const Spacer(),
            const SizedBox(height: 40),
            Image.asset('assets/images/made_in_india.png'), // Replace with your "Made in India" image path
            const SizedBox(height: 20),
            const Icon(Icons.check_circle, color: Colors.green),
            const Text(
              '100% Safe & Secure',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Copyright 2024 Scaleup. All rights reserved.',
              style: TextStyle(
                fontSize: 12,
              ),
            ),
            const Row(
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
            const SizedBox(height: 16)
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
          MaterialPageRoute(builder: (context) => const LoginScreen()),
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
class CustomCircularLoader extends StatelessWidget {
  const CustomCircularLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36,
      height: 36,
      child: CircularProgressIndicator(
        strokeWidth: 3,
        valueColor: AlwaysStoppedAnimation(kPrimaryColor),
      ),
    );
  }
}