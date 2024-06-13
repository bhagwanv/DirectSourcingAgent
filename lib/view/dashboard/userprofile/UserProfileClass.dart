import 'dart:io';

import 'package:direct_sourcing_agent/providers/DataProvider.dart';
import 'package:direct_sourcing_agent/shared_preferences/shared_pref.dart';
import 'package:direct_sourcing_agent/utils/common_elevted_button.dart';
import 'package:direct_sourcing_agent/utils/common_text_field.dart';
import 'package:direct_sourcing_agent/utils/constant.dart';
import 'package:direct_sourcing_agent/utils/utils_class.dart';
import 'package:direct_sourcing_agent/view/dashboard/userprofile/CreateUserWidgets.dart';
import 'package:direct_sourcing_agent/view/login_screen/login_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_download_manager/flutter_download_manager.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class UserProfileClass extends StatefulWidget {
  /*final int activityId;
  final int subActivityId;
*/
  const UserProfileClass({
    super.key,
    /* required this.activityId,
    required this.subActivityId,*/
  });

  @override
  State<UserProfileClass> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileClass> {
  final TextEditingController _MobileNoController = TextEditingController();
  final TextEditingController _PanCardNoController = TextEditingController();
  final TextEditingController _AdharcardNOController = TextEditingController();
  final TextEditingController _AddreshController = TextEditingController();
  final TextEditingController _PayOutController = TextEditingController();
  final TextEditingController _WorkingLocationController =
      TextEditingController();
  String? role;
  String? type;
  String? user_name;
  String? user_panNumber;
  String? user_aadharNumber;
  String? user_mobile;
  String? user_address;
  String? user_workingLocation;
  String? user_selfie;
  int? user_payout;
  String? doc_sign_url;

  @override
  void initState() {
    super.initState();

    getUserData(
        _MobileNoController,
        _PanCardNoController,
        _AdharcardNOController,
        _AddreshController,
        _PayOutController,
        _WorkingLocationController);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        top: true,
        bottom: true,
        child: Scaffold(
            backgroundColor: Colors.white,
            body: SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30.0, vertical: 0.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 35,
                      ),
                      Row(
                        children: [
                          Spacer(),
                          SizedBox(
                            width: 50,
                          ),
                          Center(
                            child: Text(
                              "Profile",
                              style: GoogleFonts.urbanist(
                                fontSize: 20,
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Spacer(),
                          (role == "Connector" && type == "Connector")
                              ? Container()
                              : Container(
                                  height: 40,
                                  width: 110,
                                  child: CommonElevatedButton(
                                    onPressed: () async {

                                      showModalBottomSheet(
                                        context: context,
                                        isScrollControlled: true,
                                        backgroundColor: Colors.white,
                                        builder: (context) {
                                          return Padding(
                                            padding: EdgeInsets.only(
                                              bottom: MediaQuery.of(context).viewInsets.bottom,
                                            ),
                                            child: SingleChildScrollView(
                                              child: Container(
                                                padding: EdgeInsets.all(16.0), // Adjust the padding as needed
                                                child: CreateUserWidgets(user_payout: user_payout),
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                    },
                                    text: "Create",
                                    upperCase: true,
                                  ),
                                ),
                        ],
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      Row(
                        children: [
                          user_selfie != null
                              ? Container(
                                  width: 90,
                                  height: 90,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.rectangle,
                                    borderRadius: BorderRadius.circular(10),
                                    image: DecorationImage(
                                        image: NetworkImage(user_selfie!),
                                        //  image: NetworkImage("https://csg10037ffe956af864.blob.core.windows.net/scaleupfiles/d1e100eb-626f-4e19-b611-e87694de6467.jpg"),
                                        fit: BoxFit.fill),
                                  ),
                                )
                              : Container(),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              user_name != null
                                  ? Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: Text(
                                        user_name!,
                                        style: GoogleFonts.urbanist(
                                          fontSize: 20,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    )
                                  : Container()
                            ],
                          )
                        ],
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      CommonTextField(
                        controller: _MobileNoController,
                        enabled: false,
                        inputFormatter: [
                          FilteringTextInputFormatter.allow(
                              RegExp((r'[A-Z0-9]'))),
                          LengthLimitingTextInputFormatter(10)
                        ],
                        keyboardType: TextInputType.number,
                        hintText: "Mobile Number",
                        labelText: "Mobile Number",
                      ),
                      SizedBox(
                        height: 16.0,
                      ),
                      CommonTextField(
                        controller: _PanCardNoController,
                        hintText: "PAN number",
                        labelText: "PAN number ",
                        enabled: false,
                        textCapitalization: TextCapitalization.characters,
                        inputFormatter: [
                          FilteringTextInputFormatter.allow(
                              RegExp((r'[A-Z0-9]'))),
                          LengthLimitingTextInputFormatter(10)
                        ],
                      ),
                      SizedBox(
                        height: 16.0,
                      ),
                      CommonTextField(
                        inputFormatter: [
                          LengthLimitingTextInputFormatter(17),
                          // Limit to 10 characters
                        ],
                        keyboardType: TextInputType.number,
                        controller: _AdharcardNOController,
                        maxLines: 1,
                        hintText: "Aadhaar ",
                        labelText: "Aadhaar",
                        enabled: false,
                      ),
                      SizedBox(
                        height: 16.0,
                      ),
                      CommonTextField(
                        controller: _AddreshController,
                        hintText: "Address",
                        labelText: "Address",
                        enabled: false,
                        textCapitalization: TextCapitalization.characters,
                      ),
                      SizedBox(
                        height: 16.0,
                      ),
                      CommonTextField(
                        controller: _PayOutController,
                        hintText: "Payout %",
                        labelText: "Payout %",
                        enabled: false,
                      ),
                      SizedBox(
                        height: 16.0,
                      ),
                      CommonTextField(
                        controller: _WorkingLocationController,
                        hintText: "Working Location",
                        labelText: "Working Location",
                        enabled: false,
                      ),
                      const SizedBox(
                        height: 30.0,
                      ),
                      type == "DSA" ?
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: kPrimaryColor,
                            // text color
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () {
                            /*if(doc_sign_url!=null) {
                              _startDownload(doc_sign_url!);
                            }else{
                              Utils.showToast("Document Not Availble", context);
                            }*/
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.download, size: 24),
                              SizedBox(height: 0, width: 10),
                              Text(
                                'Download Agreement',
                                style: GoogleFonts.urbanist(
                                  fontSize: 14,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                              )
                            ],
                          )) : Container(),
                      const SizedBox(
                        height: 30.0,
                      ),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.red,
                            // text color
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () {
                            logOut();
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.logout, size: 24),
                              SizedBox(height: 0, width: 10),
                              Text(
                                'Log out',
                                style: GoogleFonts.urbanist(
                                  fontSize: 14,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          )),
                      SizedBox(
                        height: 30.0,
                      ),
                    ],
                  ),
                ),
              ),
            )));
  }

  Future<void> logOut() async {
    final prefsUtil = await SharedPref.getInstance();
    prefsUtil.clear();
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }

  Future<void> _showProgressNotification() async {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
    const int maxProgress = 5;
    for (int i = 0; i <= maxProgress; i++) {
      await Future<void>.delayed(const Duration(seconds: 1), () async {
        final AndroidNotificationDetails androidPlatformChannelSpecifics =
            AndroidNotificationDetails('progress channel', 'progress channel',
                channelShowBadge: false,
                importance: Importance.max,
                priority: Priority.high,
                onlyAlertOnce: true,
                showProgress: true,
                maxProgress: maxProgress,
                progress: i);
        final NotificationDetails platformChannelSpecifics =
            NotificationDetails(android: androidPlatformChannelSpecifics);
        await flutterLocalNotificationsPlugin.show(
            0,
            'PDF file has been download',
            'progress notification body',
            platformChannelSpecifics,
            payload: 'item x');
      });
    }
  }

  Future<void> getUserData(
      TextEditingController mobileNoController,
      TextEditingController panCardNoController,
      TextEditingController adharcardNOController,
      TextEditingController addreshController,
      TextEditingController payOutController,
      TextEditingController workingLocationController) async {
    final prefsUtil = await SharedPref.getInstance();
    role = prefsUtil.getString(ROLE);
    type = prefsUtil.getString(TYPE);
    user_name = prefsUtil.getString(USER_NAME);
    user_panNumber = prefsUtil.getString(USER_PAN_NUMBER);
    user_aadharNumber = prefsUtil.getString(USER_ADHAR_NO);
    user_mobile = prefsUtil.getString(USER_MOBILE_NO);
    user_address = prefsUtil.getString(USER_ADDRESS);
    user_workingLocation = prefsUtil.getString(USER_WORKING_LOCTION);
    user_selfie = prefsUtil.getString(USER_SELFI);
    user_payout = prefsUtil.getInt(USER_PAY_OUT);
    doc_sign_url = prefsUtil.getString(USER_DOC_SiGN_URL);

    if (user_mobile != null) {
      mobileNoController.text = user_mobile!;
    }
    if (user_panNumber != null) {
      panCardNoController.text = user_panNumber!;
    }
    if (user_aadharNumber != null && user_aadharNumber!.isNotEmpty) {
      adharcardNOController.text =
          "XXXXXXX${user_aadharNumber!.substring(user_aadharNumber!.length - 5)}";
    }
    if (user_address != null) {
      addreshController.text = user_address!;
    }
    if (user_payout != null) {
      payOutController.text = user_payout!.toString();
    }
    if (user_workingLocation != null) {
      workingLocationController.text = user_workingLocation!;
    }
    setState(() {});
  }
}
