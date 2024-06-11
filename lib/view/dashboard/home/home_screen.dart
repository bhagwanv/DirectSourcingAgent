import 'dart:ffi';

import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:cupertino_date_time_picker_loki/cupertino_date_time_picker_loki.dart';
import 'package:direct_sourcing_agent/utils/loader.dart';
import 'package:direct_sourcing_agent/utils/utils_class.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:getwidget/colors/gf_color.dart';
import 'package:getwidget/components/progress_bar/gf_progress_bar.dart';
import 'package:getwidget/types/gf_progress_type.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';

import '../../../api/ApiService.dart';
import '../../../api/FailureException.dart';
import '../../../providers/DataProvider.dart';
import '../../../shared_preferences/shared_pref.dart';
import '../../../utils/constant.dart';
import 'DsaSalesAgentList.dart';
import 'GetDSADashboardDetailsReqModel.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var isLoading = true;
  var leadOverviewSuccessRate = 0;
  var leadOverviewProgrssSuccessRate = null;
  var agentUserId = "";

  var leadOverviewSubmitted = "";
  var leadOverviewrejected = "";
  var leadOverviewPending = "";
  var leadOverviewTotalLeads = "";

  var loanOverviewTotalLoans = "";
  var loanOverviewRejected = "";
  var loanOverviewPending = "";
  var loanOverviewApproved = "";

  var payoutOverviewTotalDisbursedAmount = "";
  var payoutOverviewPayoutAmount = "";

  var loanOverviewSuccessRate = 0;
  var loanOverviewProgrssSuccessRate = null;

  final List<DsaSalesAgentList> dsaSalesAgentList = [];
  String? selecteddsaSalesAgentValue;

  String minDateTime = '2010-05-12';
  String maxDateTime = '2030-11-25';


  final bool _showTitle = true;
  final DateTimePickerLocale _locale = DateTimePickerLocale.en_us;
  final String _format = 'yyyy-MMMM-dd';
  String workingWithParty = "";

  DateTime? _dateTime;
  String? slectedDate = "";

 var startDate="";
 var endDate="";

  @override
  void initState() {
    super.initState();
    //Api Call
    getDSADashboardDetails(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          top: true,
          bottom: true,
          child: Consumer<DataProvider>(
              builder: (context, productProvider, child) {
            if (productProvider.getDSADashboardDetailsData == null &&
                isLoading) {
              return Loader();
            } else {
              if (productProvider.getDSADashboardDetailsData != null &&
                  isLoading) {
                Navigator.of(context, rootNavigator: true).pop();
                isLoading = false;
                getDSASalesAgentList(context, productProvider);
              }

              if (productProvider.getDSADashboardDetailsData != null) {
                productProvider.getDSADashboardDetailsData!.when(
                  success: (data) {
                    // Handle successful response
                    var getDSADashboardDetailsData = data;

                    if (getDSADashboardDetailsData
                            .response!.leadOverviewData!.successRate !=
                        null) {
                      leadOverviewSuccessRate = getDSADashboardDetailsData
                          .response!.leadOverviewData!.successRate;
                      leadOverviewProgrssSuccessRate =
                          getDSADashboardDetailsData
                              .response!.leadOverviewData!.successRate;
                    }
                    if (getDSADashboardDetailsData
                            .response!.leadOverviewData!.totalLeads !=
                        null) {
                      leadOverviewTotalLeads = getDSADashboardDetailsData
                          .response!.leadOverviewData!.totalLeads!
                          .toString();
                    }
                    if (getDSADashboardDetailsData
                            .response!.leadOverviewData!.pending !=
                        null) {
                      leadOverviewPending = getDSADashboardDetailsData
                          .response!.leadOverviewData!.pending!
                          .toString();
                    }
                    if (getDSADashboardDetailsData
                            .response!.leadOverviewData!.rejected !=
                        null) {
                      leadOverviewrejected = getDSADashboardDetailsData
                          .response!.leadOverviewData!.rejected!
                          .toString();
                    }
                    if (getDSADashboardDetailsData
                            .response!.leadOverviewData!.submitted !=
                        null) {
                      leadOverviewSubmitted = getDSADashboardDetailsData
                          .response!.leadOverviewData!.submitted!
                          .toString();
                    }

                    if (getDSADashboardDetailsData
                            .response!.loanOverviewData!.successRate !=
                        null) {
                      loanOverviewSuccessRate = getDSADashboardDetailsData
                          .response!.loanOverviewData!.successRate;
                      loanOverviewProgrssSuccessRate =
                          getDSADashboardDetailsData
                              .response!.loanOverviewData!.successRate;
                    }
                    if (getDSADashboardDetailsData
                            .response!.loanOverviewData!.totalLoans !=
                        null) {
                      loanOverviewTotalLoans = getDSADashboardDetailsData
                          .response!.loanOverviewData!.totalLoans
                          .toString();
                    }
                    if (getDSADashboardDetailsData
                            .response!.loanOverviewData!.pending !=
                        null) {
                      loanOverviewPending = getDSADashboardDetailsData
                          .response!.loanOverviewData!.pending
                          .toString();
                    }
                    if (getDSADashboardDetailsData
                            .response!.loanOverviewData!.rejected !=
                        null) {
                      loanOverviewRejected = getDSADashboardDetailsData
                          .response!.loanOverviewData!.rejected
                          .toString();
                    }
                    if (getDSADashboardDetailsData
                            .response!.loanOverviewData!.approved !=
                        null) {
                      loanOverviewApproved = getDSADashboardDetailsData
                          .response!.loanOverviewData!.approved
                          .toString();
                    }

                    if (getDSADashboardDetailsData
                            .response!.payoutOverviewData!.payoutAmount !=
                        null) {
                      payoutOverviewPayoutAmount = getDSADashboardDetailsData
                          .response!.payoutOverviewData!.payoutAmount!
                          .toString();
                    }
                    if (getDSADashboardDetailsData.response!.payoutOverviewData!
                            .totalDisbursedAmount !=
                        null) {
                      payoutOverviewTotalDisbursedAmount =
                          getDSADashboardDetailsData.response!
                              .payoutOverviewData!.totalDisbursedAmount!
                              .toString();
                    }
                  },
                  failure: (exception) {
                    // Handle failure
                    if (exception is ApiException) {
                      if (exception.statusCode == 401) {
                        Utils.showToast(exception.errorMessage, context);
                        productProvider.disposeAllProviderData();
                        ApiService().handle401(context);
                      } else {
                        Utils.showToast("Something went Wrong", context);
                      }
                    }
                  },
                );
              }
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Container(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                        SizedBox(height: 10),
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Container(
                                    alignment: Alignment.center,
                                    child: Text(
                                      "Dashboard",
                                      style: GoogleFonts.urbanist(
                                        fontSize: 20,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    // Handle your tap here
                                    print("Container clicked");
                                    _showDatePicker(context);
                                  },
                                  child: Container(
                                    alignment: Alignment.centerRight,
                                    child: SvgPicture.asset(
                                      'assets/icons/ic_document_filter.svg',
                                      semanticsLabel: 'Edit Icon SVG',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        DropdownButtonFormField2<DsaSalesAgentList>(
                          isExpanded: true,
                          decoration: InputDecoration(
                            fillColor: light_gry,
                            filled: true,
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 5),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
                                    color: light_dark_gry, width: 0)),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                  color: light_dark_gry, width: 0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                  color: light_dark_gry, width: 0),
                            ),
                          ),
                          hint: const Text(
                            'All Agents ',
                            style: TextStyle(
                              color: blueColor,
                              fontSize: 14.0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          items: _addDividersAfterItems(dsaSalesAgentList),
                          onChanged: (DsaSalesAgentList? value) {
                            selecteddsaSalesAgentValue = value!.fullName;
                            getDSADashboardDetails(context);
                            /*  setState(() {

                              });*/
                          },
                          buttonStyleData: const ButtonStyleData(
                            padding: EdgeInsets.only(right: 8),
                          ),
                          dropdownStyleData: const DropdownStyleData(
                            maxHeight: 200,
                          ),
                          menuItemStyleData: MenuItemStyleData(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            customHeights:
                                _getCustomItemsHeights3(dsaSalesAgentList),
                          ),
                          iconStyleData: const IconStyleData(
                            openMenuIcon: Icon(Icons.arrow_drop_up),
                          ),
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Text('Lead Overview',
                              textAlign: TextAlign.left,
                              style: GoogleFonts.urbanist(
                                fontSize: 15,
                                color: Colors.black,
                                fontWeight: FontWeight.w400,
                              )),
                        ),
                        const SizedBox(
                          height: 5.0,
                        ),
                        Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          elevation: 10,
                          color: Colors.white,
                          child: Container(
                            width: double.infinity,
                            height: 190,
                            decoration: BoxDecoration(
                              color: kPrimaryColor,
                              borderRadius: BorderRadius.circular(
                                  10), // Adjust the value to change the roundness
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Container(
                                      width: 80,
                                      child: CircularPercentIndicator(
                                        radius: 55.0,
                                        lineWidth: 12.0,
                                        percent:
                                            loanOverviewProgrssSuccessRate ==
                                                    null
                                                ? 0.0
                                                : loanOverviewProgrssSuccessRate
                                                        .toDouble() /
                                                    100,
                                        circularStrokeCap:
                                            CircularStrokeCap.round,
                                        progressColor: whiteColor,
                                        backgroundColor: dark_blue,
                                        center: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "$loanOverviewSuccessRate %",
                                              style: GoogleFonts.urbanist(
                                                fontSize: 25,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            Text(
                                              "Success Rate",
                                              style: GoogleFonts.urbanist(
                                                fontSize: 12,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                      )),
                                  SizedBox(height: 20),
                                  Container(
                                    width: 180,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(height: 20),
                                            Text('Total Leads',
                                                textAlign: TextAlign.left,
                                                style: GoogleFonts.urbanist(
                                                  fontSize: 12,
                                                  color: whiteColor,
                                                  fontWeight: FontWeight.w400,
                                                )),
                                            SizedBox(height: 20),
                                            Text('Pending',
                                                textAlign: TextAlign.left,
                                                style: GoogleFonts.urbanist(
                                                  fontSize: 12,
                                                  color: whiteColor,
                                                  fontWeight: FontWeight.w400,
                                                )),
                                            SizedBox(height: 20),
                                            Text('Rejected',
                                                textAlign: TextAlign.left,
                                                style: GoogleFonts.urbanist(
                                                  fontSize: 12,
                                                  color: whiteColor,
                                                  fontWeight: FontWeight.w400,
                                                )),
                                            SizedBox(height: 20),
                                            Text('Submitted',
                                                textAlign: TextAlign.left,
                                                style: GoogleFonts.urbanist(
                                                  fontSize: 12,
                                                  color: whiteColor,
                                                  fontWeight: FontWeight.w400,
                                                )),
                                          ],
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(height: 20),
                                            Text('$leadOverviewTotalLeads',
                                                textAlign: TextAlign.left,
                                                style: GoogleFonts.urbanist(
                                                  fontSize: 12,
                                                  color: whiteColor,
                                                  fontWeight: FontWeight.w400,
                                                )),
                                            SizedBox(height: 20),
                                            Text('$leadOverviewPending',
                                                textAlign: TextAlign.left,
                                                style: GoogleFonts.urbanist(
                                                  fontSize: 12,
                                                  color: whiteColor,
                                                  fontWeight: FontWeight.w400,
                                                )),
                                            SizedBox(height: 20),
                                            Text('$leadOverviewrejected',
                                                textAlign: TextAlign.left,
                                                style: GoogleFonts.urbanist(
                                                  fontSize: 12,
                                                  color: whiteColor,
                                                  fontWeight: FontWeight.w400,
                                                )),
                                            SizedBox(height: 20),
                                            Text('$leadOverviewSubmitted',
                                                textAlign: TextAlign.left,
                                                style: GoogleFonts.urbanist(
                                                  fontSize: 12,
                                                  color: whiteColor,
                                                  fontWeight: FontWeight.w400,
                                                )),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Text('Loan Overview',
                              textAlign: TextAlign.left,
                              style: GoogleFonts.urbanist(
                                fontSize: 15,
                                color: Colors.black,
                                fontWeight: FontWeight.w400,
                              )),
                        ),
                        const SizedBox(
                          height: 5.0,
                        ),
                        Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          elevation: 10,
                          color: Colors.white,
                          child: Container(
                            width: double.infinity,
                            height: 190,
                            decoration: BoxDecoration(
                              color: whiteColor,
                              borderRadius: BorderRadius.circular(
                                  10), // Adjust the value to change the roundness
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Container(
                                      width: 80,
                                      child: CircularPercentIndicator(
                                        radius: 55.0,
                                        lineWidth: 12.0,
                                        percent:
                                            leadOverviewProgrssSuccessRate ==
                                                    null
                                                ? 0.0
                                                : leadOverviewProgrssSuccessRate
                                                        .toDouble() /
                                                    100,
                                        circularStrokeCap:
                                            CircularStrokeCap.round,
                                        progressColor: kPrimaryColor,
                                        backgroundColor: dark_blue,
                                        center: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "$leadOverviewSuccessRate %",
                                              style: GoogleFonts.urbanist(
                                                fontSize: 25,
                                                color: kPrimaryColor,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            Text(
                                              "Success Rate",
                                              style: GoogleFonts.urbanist(
                                                fontSize: 12,
                                                color: kPrimaryColor,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                      )),
                                  SizedBox(height: 20),
                                  Container(
                                    width: 180,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(height: 20),
                                            Text('Total Loan',
                                                textAlign: TextAlign.left,
                                                style: GoogleFonts.urbanist(
                                                  fontSize: 12,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w400,
                                                )),
                                            SizedBox(height: 20),
                                            Text('Disbursement Pending ',
                                                textAlign: TextAlign.left,
                                                style: GoogleFonts.urbanist(
                                                  fontSize: 12,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w400,
                                                )),
                                            SizedBox(height: 20),
                                            Text('Disbursement Approved',
                                                textAlign: TextAlign.left,
                                                style: GoogleFonts.urbanist(
                                                  fontSize: 12,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w400,
                                                )),
                                            SizedBox(height: 20),
                                            Text('Disbursement Rejected ',
                                                textAlign: TextAlign.left,
                                                style: GoogleFonts.urbanist(
                                                  fontSize: 12,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w400,
                                                )),
                                          ],
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(height: 20),
                                            Text('$loanOverviewTotalLoans',
                                                textAlign: TextAlign.left,
                                                style: GoogleFonts.urbanist(
                                                  fontSize: 12,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w400,
                                                )),
                                            SizedBox(height: 20),
                                            Text('$loanOverviewPending',
                                                textAlign: TextAlign.left,
                                                style: GoogleFonts.urbanist(
                                                  fontSize: 12,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w400,
                                                )),
                                            SizedBox(height: 20),
                                            Text('$loanOverviewApproved',
                                                textAlign: TextAlign.left,
                                                style: GoogleFonts.urbanist(
                                                  fontSize: 12,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w400,
                                                )),
                                            SizedBox(height: 20),
                                            Text('$loanOverviewRejected',
                                                textAlign: TextAlign.left,
                                                style: GoogleFonts.urbanist(
                                                  fontSize: 12,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w400,
                                                )),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Text('Payout Overview',
                              textAlign: TextAlign.left,
                              style: GoogleFonts.urbanist(
                                fontSize: 15,
                                color: Colors.black,
                                fontWeight: FontWeight.w400,
                              )),
                        ),
                        const SizedBox(
                          height: 5.0,
                        ),
                        Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          elevation: 10,
                          color: Colors.white,
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: whiteColor,
                              borderRadius: BorderRadius.circular(
                                  10), // Adjust the value to change the roundness
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                            '₹$payoutOverviewTotalDisbursedAmount',
                                            textAlign: TextAlign.left,
                                            style: GoogleFonts.urbanist(
                                              fontSize: 20,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w400,
                                            )),
                                        Text('Total Disbursed Amount',
                                            textAlign: TextAlign.left,
                                            style: GoogleFonts.urbanist(
                                              fontSize: 12,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w400,
                                            )),
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text('₹$payoutOverviewPayoutAmount',
                                            textAlign: TextAlign.left,
                                            style: GoogleFonts.urbanist(
                                              fontSize: 20,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w400,
                                            )),
                                        Text('Payout Amount',
                                            textAlign: TextAlign.left,
                                            style: GoogleFonts.urbanist(
                                              fontSize: 12,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w400,
                                            )),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ])),
                ),
              );
            }
          }),
        ));
  }

  Future<void> getDSADashboardDetails(BuildContext) async {
    final prefsUtil = await SharedPref.getInstance();
    String? userId = prefsUtil.getString(USER_ID);
    final String? productCode = prefsUtil.getString(PRODUCT_CODE);

    DateTime now = DateTime.now();
     startDate =
        DateFormat("yyyy-MM-ddTHH:mm:ss.SSS'Z'").format(now.toUtc());
    print("Formatted Date: $startDate");

    DateTime oneMonthBefore = DateTime(now.year, now.month - 1, now.day,
        now.hour, now.minute, now.second, now.millisecond, now.microsecond);
    if (oneMonthBefore.month == 0) {
      oneMonthBefore = DateTime(now.year - 1, 12, now.day, now.hour, now.minute,
          now.second, now.millisecond, now.microsecond);
    }
     endDate =
        DateFormat("yyyy-MM-ddTHH:mm:ss.SSS'Z'").format(oneMonthBefore.toUtc());
    print("Formatted Date: $endDate");

    String maxDateTimeFormate =
    DateFormat("yyyy-MM-dd").format(now.toUtc());
    print("Formatted Datesasa: $maxDateTimeFormate");

    maxDateTime = maxDateTimeFormate;
        dsaSalesAgentList.forEach((agent) {
      if (agent.fullName == selecteddsaSalesAgentValue) {
        setState(() {
          agentUserId = agent.userId!;
          print("userId${agent.userId!}");
          print("fullName${agent.fullName!}");
        });
      }
    });

    var model = GetDsaDashboardDetailsReqModel(
        agentUserId: agentUserId,
        startDate: startDate,
        endDate: endDate);

    await Provider.of<DataProvider>(context, listen: false)
        .getDSADashboardDetails(model);
  }

  Future<void> getDSASalesAgentList(
    BuildContext context,
    DataProvider productProvider,
  ) async {
    // Loader();

    await Provider.of<DataProvider>(context, listen: false)
        .getDSASalesAgentList();
    //Navigator.of(context, rootNavigator: true).pop();

    if (productProvider.getDSASalesAgentListData != null) {
      productProvider.getDSASalesAgentListData!.when(
        success: (data) {
          // Handle successful response
          var getDSASalesAgentListData = data;
          if (getDSASalesAgentListData.result != null) {
            dsaSalesAgentList.clear();
            dsaSalesAgentList.addAll(
                getDSASalesAgentListData.result as Iterable<DsaSalesAgentList>);
          } else {}
        },
        failure: (exception) {
          // Handle failure
          if (exception is ApiException) {
            if (exception.statusCode == 401) {
              productProvider.disposeAllProviderData();
              ApiService().handle401(context);
            } else {
              Utils.showToast(exception.errorMessage, context);
            }
          }
        },
      );
    }
    setState(() {});
  }

  List<DropdownMenuItem<DsaSalesAgentList>> _addDividersAfterItems(
      List<DsaSalesAgentList?> list) {
    final List<DropdownMenuItem<DsaSalesAgentList>> menuItems = [];
    for (final DsaSalesAgentList? item in list) {
      menuItems.addAll(
        [
          DropdownMenuItem<DsaSalesAgentList>(
            value: item,
            child: Text(
              item!.fullName.toString(),
              // Assuming 'name' is the property to display
              style: const TextStyle(
                fontSize: 14,
              ),
            ),
          ),
          // If it's not the last item, add Divider after it.
          if (item != list.last)
            const DropdownMenuItem<DsaSalesAgentList>(
              enabled: false,
              child: Divider(
                height: 0.1,
              ),
            ),
        ],
      );
    }
    return menuItems;
  }

  List<double> _getCustomItemsHeights3(List<DsaSalesAgentList?> items) {
    final List<double> itemsHeights = [];
    for (int i = 0; i < (items.length * 2) - 1; i++) {
      if (i.isEven) {
        itemsHeights.add(40);
      }
      //Dividers indexes will be the odd indexes
      if (i.isOdd) {
        itemsHeights.add(4);
      }
    }
    return itemsHeights;
  }

  void _showDatePicker(BuildContext context) {
    DatePicker.showDatePicker(
      context,
      pickerTheme: DateTimePickerTheme(
        cancel: const Icon(
          Icons.close,
          color: Colors.black38,
        ),
        title: 'Calender',
        titleTextStyle: const TextStyle(fontSize: 14),
        showTitle: _showTitle,
        selectionOverlayColor: Colors.blue,
        // showTitle: false,
        // titleHeight: 80,
        // confirm: const Text('确定', style: TextStyle(color: Colors.blue)),
      ),
      minDateTime: DateTime.parse(minDateTime),
      maxDateTime: DateTime.parse(maxDateTime),
      initialDateTime: _dateTime,
      dateFormat: _format,
      locale: _locale,
      onClose: () => debugPrint("----- onClose -----"),
      onCancel: () => debugPrint('onCancel'),
      onChange: (dateTime, List<int> index) {
        setState(() {
          _dateTime = dateTime;
        });
      },
      onConfirm: (dateTime, List<int> index) {
        setState(() {
          _dateTime = dateTime;
          slectedDate = Utils.dateFormate(context, _dateTime.toString());

          endDate=DateFormat("yyyy-MM-ddTHH:mm:ss.SSS'Z'").format(_dateTime!);
          print("endDate$endDate");

          if (kDebugMode) {
            print("$_dateTime");
          }
        });
      },
    );
  }
}
