import 'dart:io';

import 'package:dio/dio.dart';
import 'package:direct_sourcing_agent/providers/DataProvider.dart';
import 'package:direct_sourcing_agent/shared_preferences/shared_pref.dart';
import 'package:direct_sourcing_agent/utils/common_elevted_button.dart';
import 'package:direct_sourcing_agent/utils/common_text_field.dart';
import 'package:direct_sourcing_agent/utils/constant.dart';
import 'package:direct_sourcing_agent/utils/utils_class.dart';
import 'package:direct_sourcing_agent/view/dashboard/userprofile/CreateUserWidgets.dart';
import 'package:direct_sourcing_agent/view/login_screen/login_screen.dart';
import 'package:direct_sourcing_agent/view/splash/splash_screen.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_download_manager/flutter_download_manager.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as Path;

import '../../../utils/directory_path.dart';

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
  double? user_payout;
  String? doc_sign_url;
  var savedDir = "";
  bool dowloading = false;
  bool fileExists = false;
  double progress = 0;
  String fileName = "";
  late String filePath;
  late CancelToken cancelToken;
  var getPathFile = DirectoryPath();

  @override
  void initState() {
    super.initState();
    getApplicationSupportDirectory().then((value) => savedDir = value.path);

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
                          (type == "DSA")
                              ? ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: Colors.white,
                                    backgroundColor: kPrimaryColor,
                                    // text color
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 10),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  onPressed: () async {
                                    showModalBottomSheet(
                                      context: context,
                                      isScrollControlled: true,
                                      backgroundColor: Colors.white,
                                      builder: (context) {
                                        return Padding(
                                          padding: EdgeInsets.only(
                                            bottom: MediaQuery.of(context)
                                                .viewInsets
                                                .bottom,
                                          ),
                                          child: SingleChildScrollView(
                                            child: Container(
                                              padding: EdgeInsets.all(16.0),
                                              // Adjust the padding as needed
                                              child: CreateUserWidgets(
                                                  user_payout: user_payout),
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Create user',
                                        style: GoogleFonts.urbanist(
                                          fontSize: 14,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ))
                              : Container(),
                        ],
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      Row(
                        children: [
                          user_selfie != null && user_selfie!.isNotEmpty
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
                              : Container(
                                  width: 90,
                                  height: 90,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.rectangle,
                                    borderRadius: BorderRadius.circular(10),
                                    color: light_gry,
                                  ),
                                ),
                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                user_name != null
                                    ? Padding(
                                        padding:
                                            const EdgeInsets.only(left: 10),
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
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
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
                      (type != "DSAUser") ?
                      Column(
                        children: [
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
                        ],
                      ) : Container(),
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
                      type == "DSA"
                          ? TileList(
                              fileUrl:
                                  doc_sign_url != null ? doc_sign_url! : "")
                          : Container(),
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
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5.0),
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
                            ),
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
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => SplashScreen()),
        (Route route) => false);
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
    user_payout = prefsUtil.getDouble(USER_PAY_OUT);
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

  Future<void> downloadFile(String docUrl) async {
    var dl = DownloadManager();
    bool dirDownloadExists = true;
    var directory;
    if (Platform.isIOS) {
      directory = await getDownloadsDirectory();
    } else {
      directory = "/storage/emulated/0/Download/";

      dirDownloadExists = await Directory(directory).exists();
      if (dirDownloadExists) {
        directory = "/storage/emulated/0/Download/";
      } else {
        directory = "/storage/emulated/0/Downloads/";
      }
    }

    var currentDate = "Scaleup_dsa" + convertCurrentDateTimeToString();
    final path = '$directory$currentDate.pdf';
    dl.addDownload(docUrl, path);
    Utils.showBottomToast("$path");
    await dl.whenDownloadComplete(docUrl);
    //  _showProgressNotification();
  }

  String convertCurrentDateTimeToString() {
    return DateFormat('yyyyMMdd_kkmmss').format(DateTime.now());
  }
}

class TileList extends StatefulWidget {
  TileList({super.key, required this.fileUrl});

  final String fileUrl;

  @override
  State<TileList> createState() => _TileListState();
}

class _TileListState extends State<TileList> {
  bool dowloading = false;
  bool fileExists = false;
  double progress = 0;
  String fileName = "";
  late String filePath;
  late CancelToken cancelToken;
  var getPathFile = DirectoryPath();

  startDownload() async {
    cancelToken = CancelToken();
    var storePath = await getPathFile.getPath();
    filePath = '$storePath/$fileName';
    setState(() {
      dowloading = true;
      progress = 0;
    });

    try {
      await Dio().download(widget.fileUrl, filePath,
          onReceiveProgress: (count, total) {
        setState(() {
          progress = (count / total);
        });
      }, cancelToken: cancelToken);
      setState(() {
        dowloading = false;
        fileExists = true;
      });
    } catch (e) {
      print(e);
      setState(() {
        dowloading = false;
      });
    }
  }

  cancelDownload() {
    cancelToken.cancel();
    setState(() {
      dowloading = false;
    });
  }

  checkFileExit() async {
    var storePath = await getPathFile.getPath();
    filePath = '$storePath/$fileName';
    bool fileExistCheck = await File(filePath).exists();
    setState(() {
      fileExists = fileExistCheck;
    });
  }

  openfile() {
    OpenFile.open(filePath);
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      fileName = Path.basename(widget.fileUrl);
    });
    checkFileExit();
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: kPrimaryColor,
        // text color
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      onPressed: () {
        fileExists && dowloading == false
            ? openfile()
            : widget.fileUrl.isNotEmpty
                ? startDownload()
                : Utils.showBottomToast("Document not found!!");
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            fileExists
                ? const Icon(
              Icons.picture_as_pdf,
              color: Colors.white,
            )
                : dowloading
                ? Stack(
              alignment: Alignment.center,
              children: [
                CircularProgressIndicator(
                  value: progress,
                  strokeWidth: 3,
                  backgroundColor: Colors.grey,
                  valueColor: const AlwaysStoppedAnimation<Color>(
                      Colors.blue),
                ),
                Text(
                  "${(progress * 100).toStringAsFixed(2)}",
                  style: TextStyle(fontSize: 12),
                )
              ],
            )
                : const Icon(Icons.download),
            SizedBox(width: 12.0,),
            fileExists
                ? Text(
                    'Open Agreement',
                    style: GoogleFonts.urbanist(
                      fontSize: 14,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  )
                : Text(
                    'Download Agreement',
                    style: GoogleFonts.urbanist(
                      fontSize: 14,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
