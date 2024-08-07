import 'package:cupertino_date_time_picker_loki/cupertino_date_time_picker_loki.dart';
import 'package:direct_sourcing_agent/utils/loader.dart';
import 'package:direct_sourcing_agent/utils/utils_class.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';

import '../../../api/ApiService.dart';
import '../../../api/FailureException.dart';
import '../../../providers/DataProvider.dart';
import '../../../shared_preferences/shared_pref.dart';
import '../../../utils/CustomMonthYearPicker.dart';
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
  double leadOverviewSuccessRate = 0.0;
  double leadOverviewProgrssSuccessRate = 0.0;

  double loanOverviewSuccessRate = 0.0;
  double loanOverviewProgrssSuccessRate = 0.0;

  var agentUserId = "";

  var leadOverviewSubmitted = "";
  var leadOverviewrejected = "";
  var leadOverviewPending = "";
  var leadOverviewTotalLeads = "";

  var loanOverviewTotalLoans = "";
  var loanOverviewRejected = "";
  var loanOverviewPending = "";
  var loanOverviewApproved = "";

  var payoutOverviewTotalDisbursedAmount = "0";
  var payoutOverviewPayoutAmount = "0";
  final List<DsaSalesAgentList> dsaSalesAgentList = [];
  String? selecteddsaSalesAgentValue;

  String maxDateTime = '';

  final bool _showTitle = true;
  final DateTimePickerLocale _locale = DateTimePickerLocale.en_us;
  final String _format = 'yyyy-MMMM-dd';
  String workingWithParty = "";

  DateTime? _dateTime;
  String? slectedDate = "";

  var startDate = "";
  var endDate = "";
  var selectedMonthName = "";
  String? userType;
  bool isAgentSelected = false;

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _refreshIndicatorKey.currentState?.show());
    dateTime(context);
    //Api Call
    getDSADashboardDetails(context);
  }

  Future<void> _handleRefresh() async {
    getDSADashboardDetails(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: RefreshIndicator(
          key: _refreshIndicatorKey,
          onRefresh: _handleRefresh,
          child: ListView(
            children: [
              Consumer<DataProvider>(
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

                        if (getDSADashboardDetailsData.response != null) {
                          if (getDSADashboardDetailsData.response!.leadOverviewData!.successRate != null) {

                              leadOverviewSuccessRate = getDSADashboardDetailsData.response!.leadOverviewData!.successRate!.toDouble();
                              leadOverviewProgrssSuccessRate = getDSADashboardDetailsData.response!.leadOverviewData!.successRate!.toDouble();

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
                                  .response!.loanOverviewData!.successRate!.toDouble();
                              loanOverviewProgrssSuccessRate =
                              getDSADashboardDetailsData
                                  .response!.loanOverviewData!.successRate!.toDouble();

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
                            payoutOverviewPayoutAmount =
                                getDSADashboardDetailsData
                                    .response!.payoutOverviewData!.payoutAmount!
                                    .toStringAsFixed(2).toString();
                          }
                          if (getDSADashboardDetailsData.response!
                                  .payoutOverviewData!.totalDisbursedAmount !=
                              null) {
                            payoutOverviewTotalDisbursedAmount =
                                getDSADashboardDetailsData.response!
                                    .payoutOverviewData!.totalDisbursedAmount!
                                    .toStringAsFixed(2).toString();
                          }
                        }
                      },
                      failure: (exception) {
                        // Handle failure
                        if (exception is ApiException) {
                          if (exception.statusCode == 401) {
                            Utils.showToast(exception.errorMessage, context);
                            productProvider.disposeAllProviderData();
                            ApiService().handle401(context);
                          }
                        }
                      },
                    );
                  }
                  return SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 20, right: 20, top: 15),
                              child: Center(
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
                                      onTap: () async {
                                        print("date ");
                                        showCustomMonthYearPicker(context);
                                        //print('Selected date: $selectedDate');
                                      },
                                      child: Container(
                                        alignment: Alignment.centerRight,
                                        child: Row(
                                          children: [
                                            Text(
                                              " $selectedMonthName",
                                              style: GoogleFonts.urbanist(
                                                fontSize: 16,
                                                color: Colors.black,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            SizedBox(width: 8.0,),
                                            SvgPicture.asset(
                                              'assets/icons/ic_document_filter.svg',
                                              semanticsLabel: 'Edit Icon SVG',
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 15.0,
                            ),
                            userType != null && userType == "DSA"
                                ? DropdownButtonFormField2<DsaSalesAgentList>(
                                    isExpanded: true,
                                    decoration: InputDecoration(
                                      fillColor: light_gry,
                                      filled: true,
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              vertical: 5, horizontal: 5),
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
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
                                    hint: Text(
                                      'All Agents ',
                                      style: GoogleFonts.urbanist(
                                        fontSize: 15,
                                        color: light_black,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    items: _addDividersAfterItems(dsaSalesAgentList),
                                    onChanged:
                                        (DsaSalesAgentList? value) async {
                                      selecteddsaSalesAgentValue =
                                          value!.fullName;
                                      setState(() {
                                        isAgentSelected = true;
                                        leadOverviewSuccessRate = 0.0;
                                        leadOverviewProgrssSuccessRate = 0.0;
                                        loanOverviewSuccessRate = 0.0;
                                        loanOverviewProgrssSuccessRate = 0.0;
                                      });
                                      await dateTime(context);
                                      await getDSADashboardDetails(context);

                                    },
                              dropdownStyleData: DropdownStyleData(
                                maxHeight: 400,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              menuItemStyleData: const MenuItemStyleData(
                                padding: EdgeInsets.only(left: 16, right: 16, bottom: 16),
                              ),
                              iconStyleData: const IconStyleData(
                                icon: Padding(
                                  padding: EdgeInsets.only(right: 10),
                                  child: Icon(Icons.keyboard_arrow_down),
                                ), // Down arrow icon when closed
                                openMenuIcon: Padding(
                                  padding: EdgeInsets.only(right: 10),
                                  child: Icon(Icons.keyboard_arrow_up),
                                ), // Up arrow icon when open
                              ),
                                  )
                                : Container(),
                            const SizedBox(
                              height: 20.0,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Text('Lead Overview',
                                  textAlign: TextAlign.left,
                                  style: GoogleFonts.urbanist(
                                    fontSize: 15,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w500,
                                  )),
                            ),
                            const SizedBox(
                              height: 5.0,
                            ),
                            Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              elevation: 2,
                              color: Colors.white,
                              child: Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: kPrimaryColor,
                                  borderRadius: BorderRadius.circular(
                                      10), // Adjust the value to change the roundness
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const SizedBox(
                                        width: 5.0,
                                      ),
                                      Container(
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
                                        progressColor: whiteColor,
                                        backgroundColor: dark_blue,
                                        center: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "$leadOverviewSuccessRate%",
                                              style: GoogleFonts.urbanist(
                                                fontSize: 20,
                                                color: whiteColor,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                            Text(
                                              "Success Rate",
                                              style: GoogleFonts.urbanist(
                                                fontSize: 8,
                                                color: whiteColor,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      )),
                                      SizedBox(height: 20),
                                      Container(
                                        width: 140,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text('Total Leads',
                                                    textAlign: TextAlign.left,
                                                    style: GoogleFonts.urbanist(
                                                      fontSize: 12,
                                                      color: whiteColor,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    )),
                                                SizedBox(height: 15),
                                                Text('Pending',
                                                    textAlign: TextAlign.left,
                                                    style: GoogleFonts.urbanist(
                                                      fontSize: 12,
                                                      color: whiteColor,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    )),
                                                SizedBox(height: 15),
                                                Text('Rejected',
                                                    textAlign: TextAlign.left,
                                                    style: GoogleFonts.urbanist(
                                                      fontSize: 12,
                                                      color: whiteColor,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    )),
                                                SizedBox(height: 15),
                                                Text('Submitted',
                                                    textAlign: TextAlign.left,
                                                    style: GoogleFonts.urbanist(
                                                      fontSize: 12,
                                                      color: whiteColor,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    )),
                                              ],
                                            ),
                                            Flexible(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text('$leadOverviewTotalLeads',
                                                      textAlign: TextAlign.left,
                                                      style: GoogleFonts.urbanist(
                                                        fontSize: 12,
                                                        color: whiteColor,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      )),
                                                  SizedBox(height: 15),
                                                  Text('$leadOverviewPending',
                                                      textAlign: TextAlign.left,
                                                      style: GoogleFonts.urbanist(
                                                        fontSize: 12,
                                                        color: whiteColor,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      )),
                                                  SizedBox(height: 15),
                                                  Text('$leadOverviewrejected',
                                                      textAlign: TextAlign.left,
                                                      style: GoogleFonts.urbanist(
                                                        fontSize: 12,
                                                        color: whiteColor,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      )),
                                                  SizedBox(height: 15),
                                                  Text('$leadOverviewSubmitted',
                                                      textAlign: TextAlign.left,
                                                      style: GoogleFonts.urbanist(
                                                        fontSize: 12,
                                                        color: whiteColor,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      )),
                                                ],
                                              ),
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
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w500,
                                  )),
                            ),
                            const SizedBox(
                              height: 5.0,
                            ),
                            Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              elevation: 2,
                              color: Colors.white,
                              child: Container(
                                width: double.infinity,
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
                                        width: 2,
                                      ),
                                      Container(
                                          child: CircularPercentIndicator(
                                        radius: 55.0,
                                        lineWidth: 12.0,
                                        percent:
                                            loanOverviewProgrssSuccessRate ==
                                                    null
                                                ? 0.0
                                                : loanOverviewProgrssSuccessRate.toDouble() / 100,
                                        circularStrokeCap:
                                            CircularStrokeCap.round,
                                        progressColor: kPrimaryColor,
                                        backgroundColor: dark_blue,
                                        center: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "$loanOverviewSuccessRate%",
                                              style: GoogleFonts.urbanist(
                                                fontSize: 20,
                                                color: kPrimaryColor,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                            Text(
                                              "Success Rate",
                                              style: GoogleFonts.urbanist(
                                                fontSize: 8,
                                                color: kPrimaryColor,
                                                fontWeight: FontWeight.w500,
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
                                                Text('Total Loan',
                                                    textAlign: TextAlign.left,
                                                    style: GoogleFonts.urbanist(
                                                      fontSize: 12,
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    )),
                                                SizedBox(height: 15),
                                                Text('Disbursement Pending ',
                                                    textAlign: TextAlign.left,
                                                    style: GoogleFonts.urbanist(
                                                      fontSize: 12,
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    )),
                                                SizedBox(height: 15),
                                                Text('Disbursement Approved',
                                                    textAlign: TextAlign.left,
                                                    style: GoogleFonts.urbanist(
                                                      fontSize: 12,
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    )),
                                                SizedBox(height: 15),
                                                Text('Disbursement Rejected ',
                                                    textAlign: TextAlign.left,
                                                    style: GoogleFonts.urbanist(
                                                      fontSize: 12,
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    )),
                                              ],
                                            ),
                                            Flexible(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text('$loanOverviewTotalLoans',
                                                      textAlign: TextAlign.left,
                                                      style: GoogleFonts.urbanist(
                                                        fontSize: 12,
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      )),
                                                  SizedBox(height: 15),
                                                  Text('$loanOverviewPending',
                                                      textAlign: TextAlign.left,
                                                      style: GoogleFonts.urbanist(
                                                        fontSize: 12,
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      )),
                                                  SizedBox(height: 15),
                                                  Text('$loanOverviewApproved',
                                                      textAlign: TextAlign.left,
                                                      style: GoogleFonts.urbanist(
                                                        fontSize: 12,
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      )),
                                                  SizedBox(height: 15),
                                                  Text('$loanOverviewRejected',
                                                      textAlign: TextAlign.left,
                                                      style: GoogleFonts.urbanist(
                                                        fontSize: 12,
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      )),
                                                ],
                                              ),
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
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w500,
                                  )),
                            ),
                            const SizedBox(
                              height: 5.0,
                            ),
                            Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              elevation: 4,
                              color: Colors.white,
                              child: Container(
                                width: double.infinity,
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
                                    children: [
                                      Flexible(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                                '₹$payoutOverviewTotalDisbursedAmount',
                                                textAlign: TextAlign.left,
                                                style: GoogleFonts.urbanist(
                                                  fontSize: 20,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w800,
                                                )),
                                            Text('Total Disbursed Amount',
                                                textAlign: TextAlign.left,
                                                style: GoogleFonts.urbanist(
                                                  fontSize: 12,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w500,
                                                )),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 16,
                                      ),
                                      Flexible(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text('₹$payoutOverviewPayoutAmount',
                                                textAlign: TextAlign.left,
                                                style: GoogleFonts.urbanist(
                                                  fontSize: 20,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w800,
                                                )),
                                            Text('Payout Amount',
                                                textAlign: TextAlign.left,
                                                style: GoogleFonts.urbanist(
                                                  fontSize: 12,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w500,
                                                )),
                                          ],
                                        ),
                                      ),
                                    ],
                                  )),
                                ),
                              ),
                            const SizedBox(
                              height: 32,
                            )
                          ]),
                    ),
                  );
                }
              }),
            ],
          ),
        ));
  }

  Future<void> getDSADashboardDetails(BuildContext context) async {
    final prefsUtil = await SharedPref.getInstance();
    userType = prefsUtil.getString(TYPE);
    if (selecteddsaSalesAgentValue != null) {
      print("atul $isAgentSelected");
    if (isAgentSelected) {

      dsaSalesAgentList.forEach((agent) {
        if (agent.fullName == selecteddsaSalesAgentValue) {
          setState(() {

            agentUserId = agent.userId!;

            print("atul $agentUserId");
          });
        }
      });
    }
    }

    var model = GetDsaDashboardDetailsReqModel(
        agentUserId: agentUserId, startDate: startDate, endDate: endDate);

    if (isLoading) {
      await Provider.of<DataProvider>(context, listen: false).getDSADashboardDetails(model);
    } else {
      Utils.onLoading(context, "");
      await Provider.of<DataProvider>(context, listen: false)
          .getDSADashboardDetails(model);
      Navigator.of(context, rootNavigator: true).pop();
    }
  }

  Future<void> dateTime(BuildContext) async {
    DateTime now = DateTime.now();

    /* DateTime startOfMonth  = DateTime(now.year, now.month - 1, now.day,
        now.hour, now.minute, now.second, now.millisecond, now.microsecond);
    if (startOfMonth.month == 0) {
      startOfMonth = DateTime(now.year - 1, 12, now.day, now.hour, now.minute,
          now.second, now.millisecond, now.microsecond);
    }
    startDate =
        DateFormat("yyyy-MM-ddTHH:mm:ss.SSS'Z'").format(startOfMonth.toUtc());
    print("Formatted Date: $startDate");*/

    DateTime firstDay = new DateTime(
      DateTime.now().year,
      DateTime.now().month,
      1 + 1,
    ); //

    startDate =
        DateFormat("yyyy-MM-ddTHH:mm:ss.SSS'Z'").format(firstDay.toUtc());
    print("Formatted Date: $startDate");
    String monthName = DateFormat("MMM").format(firstDay.toUtc());
    selectedMonthName = monthName;

    endDate = DateFormat("yyyy-MM-ddTHH:mm:ss.SSS'Z'").format(now.toUtc());
    print("Formatted Date: $endDate");

    String maxDateTimeFormate = DateFormat("yyyy-MM-dd").format(now.toUtc());
    print("Formatted Datesasa: $maxDateTimeFormate");
    maxDateTime = maxDateTimeFormate;
  }

  Future<void> getDSASalesAgentList(
    BuildContext context,
    DataProvider productProvider,
  ) async {
    // Utils.onLoading(context, "");;

    await Provider.of<DataProvider>(context, listen: false)
        .getDSASalesAgentList();
    // Navigator.of(context, rootNavigator: true).pop();

    if (productProvider.getDSASalesAgentListData != null) {
      productProvider.getDSASalesAgentListData!.when(
        success: (data) {
          // Handle successful response
          var getDSASalesAgentListData = data;
          if (getDSASalesAgentListData.result != null) {
            dsaSalesAgentList.clear();
            dsaSalesAgentList.addAll(
                getDSASalesAgentListData.result as Iterable<DsaSalesAgentList>);
          }
        },
        failure: (exception) {
          // Handle failure
          if (exception is ApiException) {
            if (exception.statusCode == 401) {
              productProvider.disposeAllProviderData();
              ApiService().handle401(context);
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
              style: GoogleFonts.urbanist(
                fontSize: 15,
                color: blackSmall,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          /*// If it's not the last item, add Divider after it.
          if (item != list.last)
            const DropdownMenuItem<DsaSalesAgentList>(
              enabled: false,
              child: Divider(
                height: 0.1,
              ),
            ),*/
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

  Future<void> showCustomMonthYearPicker(BuildContext context) async {
    var isOk = true;
    // Current Date
    DateTime now = DateTime.now();
    // Define the onCancel callback
    void onCancel() {
      print("Picker was cancelled");
      setState(() {
        isOk = false;
      });
    }

    void onOk() {
      print("Picker was ok");
      setState(() {
        isOk = true;
      });
    }

    // Show the month-year picker dialog
    final selectedDate = await CustomMonthYearPicker.showMonthYearPickerDialog(
      context: context,
      titleTextStyle: TextStyle(),
      monthTextStyle: TextStyle(),
      yearTextStyle: TextStyle(),
      disableFuture: true,
      backgroundColor: Colors.grey[200],
      selectionColor: kPrimaryColor,
      barrierDismissible: false,
      onCancel: onCancel,
      onOk: onOk,
    );

    if (selectedDate != null) {
      int selectedYear = selectedDate.year;
      int selectedMonth = selectedDate.month;
      if (selectedYear > now.year ||
          (selectedYear == now.year && selectedMonth > now.month)) {
        Utils.showToast("Future dates are not allowed", context);
      } else {
        DateTime startOfMonth = DateTime(selectedYear, selectedMonth, 1 + 1);
        DateTime endOfMonth;
        if (selectedYear == now.year && selectedMonth == now.month) {
          // If the selected month is the current month, set end date to current date
          endOfMonth = now;
        } else {
          // Otherwise, set it to the last day of the selected month
          endOfMonth = (selectedMonth < 12)
              ? DateTime(selectedYear, selectedMonth + 1, 1)
              : DateTime(selectedYear + 1, 1, 0);
        }

        if (isOk) {
          setState(() {
            isAgentSelected =false;
            startDate = DateFormat("yyyy-MM-ddTHH:mm:ss.SSS'Z'")
                .format(startOfMonth.toUtc());
            endDate = DateFormat("yyyy-MM-ddTHH:mm:ss.SSS'Z'")
                .format(endOfMonth.toUtc());
            print("Start DATe ${startDate}");
            String monthName = DateFormat("MMM").format(startOfMonth.toUtc());
            selectedMonthName = monthName;
            isAgentSelected = true;
            leadOverviewSuccessRate = 0.0;
            leadOverviewProgrssSuccessRate = 0.0;
            loanOverviewSuccessRate = 0.0;
            loanOverviewProgrssSuccessRate = 0.0;
          });

          getDSADashboardDetails(context);
        }
      }
    }
  }
}
