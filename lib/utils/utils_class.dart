import 'package:direct_sourcing_agent/utils/constant.dart';
import 'package:direct_sourcing_agent/view/splash/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'adhar_faild_widgets.dart';
import 'kyc_faild_widgets.dart';

enum ValueType {
  boolean,
  string,
  integer,
  unknown,
}

class Utils {
  static void showToast(String msg, BuildContext context) {

    Widget okButton = TextButton(
      child: Text("OK", style: GoogleFonts.urbanist(
        fontSize: 16,
        color: kPrimaryColor,
        fontWeight: FontWeight.w700,
      ),),
      onPressed: () {
        Navigator.of(context).pop(false);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(
        "Alert",
        style: GoogleFonts.urbanist(
        fontSize: 20,
        color: Colors.black,
        fontWeight: FontWeight.w700,
      ),
      ),
      content: Text(msg, textAlign: TextAlign.justify, style: GoogleFonts.urbanist(
        fontSize: 16,
        color: Colors.black,
        fontWeight: FontWeight.w400,
      ),),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  static void internetConectivityDilog(String msg, BuildContext context) {

    Widget okButton = TextButton(
      child: Text("Retry", style: GoogleFonts.urbanist(
        fontSize: 16,
        color: kPrimaryColor,
        fontWeight: FontWeight.w700,
      ),),
      onPressed: () {
        Navigator.of(context).pop(false);
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => SplashScreen(),
          ),
        );
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(
        "Alert",
        style: GoogleFonts.urbanist(
          fontSize: 20,
          color: Colors.black,
          fontWeight: FontWeight.w700,
        ),
      ),
      content: Text(msg, textAlign: TextAlign.justify, style: GoogleFonts.urbanist(
        fontSize: 16,
        color: Colors.black,
        fontWeight: FontWeight.w400,
      ),),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  static void showBottomToast(String msg) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  static removeTrailingZeros(String n) {
    return n.replaceAll(RegExp(r"([.]*0+)(?!.*\d)"), "");
  }




  static void showBottomSheet(
      BuildContext context, String msg, String imagePath) {
    showModalBottomSheet(
        context: context,
        builder: (builder) {
          return Container(
              child: KycFailedWidgets(message: msg, imagePath: imagePath));
        });
  }

  static void showBottomSheetKeyFailed(BuildContext context, String msg,
      String imagePath, int activityId, int subActivityId) {
    showModalBottomSheet(
        context: context,
        builder: (builder) {
          return Container(child: AdharFailedWidgets(
            message: msg,
            imagePath: imagePath,
            activityId: activityId,
            subActivityId: subActivityId,
          ));
        });
  }

  static bool isPhoneNoValid(String? phoneNo) {
    if (phoneNo == null) return false;

    // Regular expression to check the basic phone number format
    final regExp = RegExp(r'(^(?:[+0]9)?[0-9]{10,12}$)');
    if (!regExp.hasMatch(phoneNo)) {
      return false;
    }

    // List of invalid phone numbers
    const invalidNumbers = {
      '0000000000',
      '1111111111',
      '2222222222',
      '3333333333',
      '4444444444',
      '5555555555',
    };

    // Check if the phone number is in the list of invalid numbers
    if (invalidNumbers.contains(phoneNo)) {
      return false;
    }

    return true;
  }

  static bool validateEmail(String value) {
    return RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(value);
  }

  static bool isValidIFSCCode(String? ifscCode) {
    if (ifscCode == null) return false;
    final regExp = RegExp(r"^[A-Z]{4}[a-zA-Z0-9]{7}$");
    return regExp.hasMatch(ifscCode);
  }

  static bool isValidIFSCode(String str) {
    RegExp regex = RegExp(r'^[A-Z]{4}0[A-Z0-9a-z]{6}$');
    return regex.hasMatch(str);
  }

  static void showMsgDialog(
    BuildContext context,
    String title,
    String msg,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(msg),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  /* static  onLoading(BuildContext context, String msg) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => WillPopScope(
        onWillPop: () async => false,
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            // mainAxisSize: MainAxisSize.max,
            children: [
              SizedBox(width: 20.0,height: 60.0),
              new CircularProgressIndicator(),
              SizedBox(width: 20.0,height: 60.0),
              new Text(msg),
            ],
          ),
        ),
      ),
    );
  }*/

  static onLoading(BuildContext context, String msg) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => WillPopScope(
        onWillPop: () async => false,
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(width: 20.0, height: 60.0),
              // Replace CircularProgressIndicator with your custom image
              Image.asset(
                'assets/images/scalup_loder.gif',
                width: 200.0,
                height: 200.0,
                // Adjust width and height according to your image size
              ),
              SizedBox(width: 20.0, height: 60.0),
              Text(msg),
            ],
          ),
        ),
      ),
    );
  }

  static void hideKeyBored(BuildContext context) {
    FocusScope.of(context).requestFocus(new FocusNode());
  }

  static String dateFormate(BuildContext context, String date) {
    String inputString = date;
    DateTime dateTime = DateTime.parse(inputString);
    String formattedDate = DateFormat('dd/MM/yyyy').format(dateTime);
    return formattedDate;
  }

  static String convertDateTime(String dateTimeString) {
    DateTime dateTime = DateTime.parse(dateTimeString);

    // Format date to "12/04/2024" format
    String date = DateFormat('MM/dd/yyyy').format(dateTime);

    // Format time to "05:35 PM" format
    String time = DateFormat('hh:mm a').format(dateTime);

    return '$date | $time';
  }

  static String dateMonthFormate(String date) {
    String inputString = date;

    // Parse the input string into a DateTime object
    DateTime dateTime = DateTime.parse(inputString);

    // Format the DateTime into "dd/MM/yyyy" using intl package
    String formattedDate = DateFormat('dd MMM').format(dateTime);

    return formattedDate;
  }

  static String dateMonthAndYearFormat(String date) {
    // Parse the input string into a DateTime object
    DateTime dateTime = DateTime.parse(date);

    // Format the DateTime into "MMMM d, yyyy"
   // String formattedDate = DateFormat('MMMM d, yyyy').format(dateTime);
    String formattedDate = DateFormat('d MMMM yyyy').format(dateTime);
    return formattedDate;
  }

  Future<bool> onback(BuildContext context) async {
    bool? exitApp = await showDialog(
      context: context,
      builder: ((context) {
        return AlertDialog(
          title: Text('Are you sure?'),
          content: Text('Do you want to exit an App'),
          actions: <Widget>[
            GestureDetector(
              onTap: () => Navigator.of(context).pop(false),
              child: Text("NO"),
            ),
            SizedBox(height: 16),
            GestureDetector(
              onTap: () async {
                /*SharedPref preferences = await SharedPref.getInstance();
                await preferences.clear();*/
                Navigator.of(context).pop(true);
              },
              child: Text("YES"),
            ),
          ],
        );
      }),
    );

    return exitApp ?? false;
  }

  String? extractOTP(String message) {
    RegExp otpRegExp = RegExp(r'\b\d{6}\b'); // Regex to match exactly 6 digits
    Match? match = otpRegExp.firstMatch(message);
    if (match != null) {
      return match.group(0); // Extract the matched OTP
    } else {
      return null; // No OTP found
    }
  }
}
