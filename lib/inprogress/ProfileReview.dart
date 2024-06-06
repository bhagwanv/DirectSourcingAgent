import 'package:direct_sourcing_agent/providers/DataProvider.dart';
import 'package:direct_sourcing_agent/shared_preferences/shared_pref.dart';
import 'package:direct_sourcing_agent/utils/constant.dart';
import 'package:direct_sourcing_agent/utils/utils_class.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import '../../api/ApiService.dart';
import '../../api/FailureException.dart';
import 'package:provider/provider.dart';
import '../../utils/common_elevted_button.dart';
import 'model/InProgressScreenModel.dart';

class ProfileReview extends StatefulWidget {
  final String? pageType;

  ProfileReview({super.key, this.pageType});

  @override
  State<ProfileReview> createState() => _ProfileReviewState();
}

class _ProfileReviewState extends State<ProfileReview> {
  var isLoading = true;
  InProgressScreenModel? inProgressScreenModel = null;
  String leadCode = "";

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      callApi(context);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        debugPrint("didPop1: $didPop");
        if (didPop) {
          return;
        }
        if (widget.pageType == "pushReplacement") {
          final bool shouldPop = await Utils().onback(context);
          if (shouldPop) {
            SystemNavigator.pop();
          }
        } else {
          SystemNavigator.pop();
        }
      },
      child: Scaffold(
        body: Consumer<DataProvider>(builder: (context, productProvider, child) {
          if (productProvider.InProgressScreenData == null && isLoading) {
            return Container();
          } else {
            if (productProvider.InProgressScreenData != null && isLoading) {
              //Navigator.of(context, rootNavigator: true).pop();
              isLoading = false;
            }

            if (productProvider.InProgressScreenData != null) {
              productProvider.InProgressScreenData!.when(
                success: (InProgressScreenData) async {
                  if (InProgressScreenData != null &&
                      InProgressScreenData.isSuccess!) {
                    inProgressScreenModel = InProgressScreenData;
                    if (inProgressScreenModel!.result!.leadCode != null) {
                      leadCode = inProgressScreenModel!.result!.leadCode!;
                    }
                  }
                },
                failure: (exception) {
                  if (exception is ApiException) {
                    if(exception.statusCode==401){
                      productProvider.disposeAllProviderData();
                      ApiService().handle401(context);
                    }else{
                      Utils.showToast(exception.errorMessage,context);
                    }
                  }
                },
              );
            }

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(30),
                child: Column(
                  children: [
                    const SizedBox(height: 50),
                    Container(
                      alignment: Alignment.center,
                      child: SvgPicture.asset(
                          'assets/images/profile_view_pendding.svg'),
                    ),
                    const SizedBox(height: 60),
                    Padding(
                      padding: EdgeInsets.only(left: 5, right: 5),
                      child: Column(
                        children: [
                          Text(
                            leadCode,
                            style:
                                TextStyle(color: kPrimaryColor, fontSize: 20),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Padding(
                      padding: EdgeInsets.only(left: 5, right: 5),
                      child: Column(
                        children: [
                          Text(
                            "Your profile is under review",
                            style:
                                TextStyle(color: kPrimaryColor, fontSize: 20),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Padding(
                      padding: EdgeInsets.only(left: 50, right: 50, top: 10),
                      child: Column(
                        children: [
                          Text(
                            "Your profile has been submitted & will be reviewed by our team You will be notified if any additional information is required ",
                            style: TextStyle(color: Colors.black, fontSize: 14),
                            textAlign: TextAlign.justify,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 70),
                    CommonElevatedButton(
                      onPressed: () {
                        SystemNavigator.pop();
                      },
                      text: "Back to home",
                      upperCase: true,
                    ),
                  ],
                ),
              ),
            );
          }
        }),
      ),
    );
  }

  Future<void> callApi(BuildContext context) async {
    final prefsUtil = await SharedPref.getInstance();
    final int? leadId = prefsUtil.getInt(LEADE_ID);
    Provider.of<DataProvider>(context, listen: false).leadDataOnInProgressScreen(context, leadId!);
  }
}
