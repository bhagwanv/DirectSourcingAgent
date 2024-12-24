import 'package:direct_sourcing_agent/utils/constant.dart';
import 'package:direct_sourcing_agent/utils/utils_class.dart';
import 'package:direct_sourcing_agent/view/splash/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../providers/DataProvider.dart';
import '../shared_preferences/shared_pref.dart';
import '../view/otp_screens/OtpScreen.dart';
import 'MixpanelManager.dart';
import 'MixpannelEventName.dart';

class PermissionPage extends StatefulWidget {

  final String? userOtp;
  final String? userLoginMobile;
  const PermissionPage({super.key, this.userOtp,this.userLoginMobile});

  @override
  _PermissionPageState createState() => _PermissionPageState();
}

class _PermissionPageState extends State<PermissionPage> with WidgetsBindingObserver {
  bool _cameraGranted = false;
  bool _microphoneGranted = false;
  //bool _smsGranted = false;
  bool _permissionsRequested = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    if (WidgetsBinding.instance.lifecycleState != null) {
      _checkPermision();
    }
    var mixpanelData = {
      'Screen': 'Permission Screen',
    };
    MixpanelManager().trackEvent(MixpannelEventName.permissionAsk, mixpanelData);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    setState(() {
      _checkPermision();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) {
          return;
        }
        final bool shouldPop = await Utils().onback(context);
        if (shouldPop) {
          SystemNavigator.pop();
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child:
              Consumer<DataProvider>(builder: (context, dataProvider, child) {
            return Padding(
              padding: const EdgeInsets.only(
                  left: 24.0, right: 24.0, top: 0.0, bottom: 8.0),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 44.0),
                            child: Text(
                              'Please Allow Access',
                              textAlign: TextAlign.start,
                              style: GoogleFonts.urbanist(
                                fontSize: 22,
                                color: blackSmall,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'To enhance your experience on MyApp',
                            textAlign: TextAlign.start,
                            style: GoogleFonts.urbanist(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          SizedBox(height: 24),
                          _buildPermissionItem(
                              granted: _cameraGranted,
                              title: 'Camera Permission',
                              description: 'To take photos and videos',
                              isMandatory: true,
                              icon: "assets/icons/permission_cammera_icon.png"),
                          _buildPermissionItem(
                              granted: _microphoneGranted,
                              title: 'Microphone Permission',
                              description: 'To record audio',
                              isMandatory: true,
                              icon: "assets/icons/microphone_icon.png"),
                         /* _buildPermissionItem(
                              granted: _smsGranted,
                              title: 'SMS Permission',
                              description: 'To detect due bills',
                              isMandatory: true,
                              icon: "assets/icons/sms_icon.png"),*/
                         /* _buildPermissionItem(
                              granted: _smsGranted,
                              title: 'Auto Fetch Permission',
                              description:
                                  'To detect generated bills instantly',
                              isMandatory: true,
                              icon: "assets/icons/phone_icon.png"),*/
                          SizedBox(height: 72),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0.0,
                    left: 0.0,
                    right: 0.0,
                    child: Container(
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              if (_cameraGranted &&
                                  _microphoneGranted) {
                                var mixpanelData = {
                                  'Screen': 'Permission Screen',
                                };
                                MixpanelManager().trackEvent(
                                    MixpannelEventName.permissionGranted,
                                    mixpanelData);
                                _navigateToHome(dataProvider);
                              } else {
                                _requestPermissions();
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: kPrimaryColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                            child: Text(
                              _permissionsRequested &&
                                      _cameraGranted &&
                                      _microphoneGranted
                                  ? 'Continue'
                                  : 'Allow Access',
                              style: GoogleFonts.urbanist(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }

  Future<void> _checkPermision() async {
    PermissionStatus cameraPermissionStatus = await Permission.camera.status;
    PermissionStatus microphonePermissionStatus =
        await Permission.microphone.status;
    //PermissionStatus smsPermissionStatus = await Permission.sms.status;

    if (cameraPermissionStatus.isGranted) {
      _cameraGranted = true;
    }

    if (microphonePermissionStatus.isGranted) {
      _microphoneGranted = true;
    }

    /*if (smsPermissionStatus.isGranted) {
      _smsGranted = true;
    }*/
    setState(() {});
  }

  Future<void> _requestPermissions() async {
    setState(() {
      _permissionsRequested = true;
    });
    _cameraGranted = await _requestPermission(Permission.camera);
    _microphoneGranted = await _requestPermission(Permission.microphone);
   // _smsGranted = await _requestPermission(Permission.sms);
  }

  Future<bool> _requestPermission(Permission permission) async {
    var status = await permission.status;
    if (status.isDenied || status.isRestricted) {
      final permissionStatus = await permission.request();
      return permissionStatus.isGranted;
    } else if (status.isPermanentlyDenied) {
      openAppSettings();
    }
    setState(() {});
    return status.isGranted;
  }

  void _navigateToHome(DataProvider dataProvider) async {
    final prefsUtil = await SharedPref.getInstance();
    var mobileNumber = await prefsUtil.getString(LOGIN_MOBILE_NUMBER);
    Utils.onLoading(context, "");
    await Provider.of<DataProvider>(context, listen: false)
        .genrateOtp(context, mobileNumber!);
    if (dataProvider.genrateOptData != null) {
      Navigator.of(context, rootNavigator: true).pop();
      dataProvider.genrateOptData!.when(
        success: (data) async {
          if (!data.status!) {
            Utils.showToast(data.message!, context);
          } else {
            var mixpanelData = {
              'Button Name': 'Continue',
              'Screen': 'Permission Screen',
              'Mobile Number':
              mobileNumber,
            };
            MixpanelManager().trackEvent(
                MixpannelEventName.otpSent, mixpanelData);
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return  OtpScreen(userOtp: data.otp!,userLoginMobile:mobileNumber);
                },
              ),
            );
          }
        },
        failure: (exception) {},
      );
    }
    dataProvider.disposeAllProviderData();
  }

  Widget _buildPermissionItem({
    required bool granted,
    required String title,
    required String description,
    required bool isMandatory,
    required String icon,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 8.0),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 12.0),
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xff0196CE))),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Container(
                      width: 40, // Set the desired width
                      height: 40,
                      child: Image.asset(
                        icon, // Path to your PNG icon
                        width: 40, // Set the desired width
                        height: 40, // Set the desired height
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                  title,
                                  style: GoogleFonts.urbanist(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Text(
                            description,
                            style: GoogleFonts.urbanist(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 16),
                    Icon(
                      granted ? Icons.check : Icons.warning_amber_rounded,
                      color:
                          granted ? Colors.green.shade300 : Colors.red.shade300,
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (isMandatory)
            Positioned(
              top: 0, // Adjust as needed
              right: 10, // Adjust as needed
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'MANDATORY',
                  style: GoogleFonts.urbanist(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
