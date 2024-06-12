import 'dart:ffi';

import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:direct_sourcing_agent/utils/loader.dart';
import 'package:direct_sourcing_agent/utils/utils_class.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
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
import 'package:simple_month_year_picker/simple_month_year_picker.dart';

import '../../../api/ApiService.dart';
import '../../../api/FailureException.dart';
import '../../../providers/DataProvider.dart';
import '../../../shared_preferences/shared_pref.dart';
import '../../../utils/constant.dart';
import '../Lead_screen/model/DSADashboardLeadListReqModel.dart';
import '../Lead_screen/model/DsaDashboardLeadList.dart';
import '../home/DsaSalesAgentList.dart';
import 'model/GetDSADashboardPayoutListReqModel.dart';
import 'model/LoanPayoutDetailList.dart';



class PayOutScreen extends StatefulWidget {
  const PayOutScreen({super.key});

  @override
  State<PayOutScreen> createState() => _PayOutScreenState();
}

class _PayOutScreenState extends State<PayOutScreen> {
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
  var skip = 0;
  var take = 10;
  var startDate = "";
  var endDate = "";
  String maxDateTime = '';
  bool loading = false;


  var payoutOverviewTotalDisbursedAmount = "0";
  var payoutOverviewPayoutAmount = "0";

  var loanOverviewSuccessRate = 0;
  var loanOverviewProgrssSuccessRate = null;

  final List<DsaSalesAgentList> dsaSalesAgentList = [];
  final List<LoanPayoutDetailList> loanPayoutDetailList = [];
  ScrollController _scrollController = ScrollController();

  String? selecteddsaSalesAgentValue;

  @override
  void initState() {
    super.initState();
    //Api Call
    dateTime(context);
    getDSADashboardPayoutList(context);


    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        // Load more data if not already loading
        if (loading) {
          skip += 10;
          getDSADashboardPayoutList(context);
        }
      }
    });
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
                if (productProvider.getDSADashboardPayoutListData == null &&
                    isLoading) {
                  return Loader();
                } else {
                  if (productProvider.getDSADashboardPayoutListData != null &&
                      isLoading) {
                    Navigator.of(context, rootNavigator: true).pop();
                    isLoading = false;
                    getDSASalesAgentList(context, productProvider);
                  }

                  if (productProvider.getDSADashboardPayoutListData != null) {
                    productProvider.getDSADashboardPayoutListData!.when(
                      success: (data) {
                        // Handle successful response
                        var getDSADashboardPayoutListData = data;

                      //  loanPayoutDetailList.add(LoanPayoutDetailList(loanId: "AMLAAYAIR100000006422",disbursmentAmount: 10,disbursmentDate: "3 June 2024",status: "pending",mobileNo: "12345 67890",payoutAmount: 100,profileImage: ""));

                        if (getDSADashboardPayoutListData.response != null) {
                          if(getDSADashboardPayoutListData.response!.loanPayoutDetailList != null){
                            if(getDSADashboardPayoutListData.response!.loanPayoutDetailList!.isNotEmpty){
                              loanPayoutDetailList.addAll(getDSADashboardPayoutListData
                                  .response! as Iterable<LoanPayoutDetailList>);
                              print("aaa${loanPayoutDetailList.length}");
                            }else{
                              loading=false;
                            }
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
                          } else {
                            Utils.showToast("Something went Wrong", context);
                          }
                        }
                      },
                    );
                  }
                  return Padding(
                    padding: const EdgeInsets.all(10),
                    child: Container(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 20,right: 20,top: 15),
                                  child: Center(
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment
                                          .center,
                                      children: [
                                        Expanded(
                                          child: Container(
                                            alignment: Alignment.center,
                                            child: Text(
                                              "Payout",
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
                              ),
                              const SizedBox(
                                height: 15.0,
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
                                hint:  Text(
                                  'All Agents ',
                                  style: GoogleFonts.urbanist(
                                    fontSize: 15,
                                    color: light_black,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                items: _addDividersAfterItems(dsaSalesAgentList),
                                onChanged: (DsaSalesAgentList? value) {
                                  selecteddsaSalesAgentValue = value!.fullName;
                                  dateTime(context);
                                  getDSADashboardPayoutList(context);
                                  //getDSADashboardDetails(context);
                                  /*   setState(() {

                            });*/
                                },
                                buttonStyleData: const ButtonStyleData(
                                  padding: EdgeInsets.only(right: 8),
                                ),
                                dropdownStyleData: const DropdownStyleData(
                                  maxHeight: 200,
                                ),
                                menuItemStyleData: MenuItemStyleData(
                                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
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
                              Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                elevation: 5,
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
                                                    fontWeight: FontWeight
                                                        .w800,
                                                  )),
                                              Text('Total Disbursed Amount',
                                                  textAlign: TextAlign.left,
                                                  style: GoogleFonts.urbanist(
                                                    fontSize: 12,
                                                    color: Colors.black,
                                                    fontWeight: FontWeight
                                                        .w500,
                                                  )),
                                            ],
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                  '₹$payoutOverviewPayoutAmount',
                                                  textAlign: TextAlign.left,
                                                  style: GoogleFonts.urbanist(
                                                    fontSize: 20,
                                                    color: Colors.black,
                                                    fontWeight: FontWeight
                                                        .w800,
                                                  )),
                                              Text('Payout Amount',
                                                  textAlign: TextAlign.left,
                                                  style: GoogleFonts.urbanist(
                                                    fontSize: 12,
                                                    color: Colors.black,
                                                    fontWeight: FontWeight
                                                        .w500,
                                                  )),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 20.0,
                              ),
                              Expanded(
                                  child: loanPayoutDetailList != null
                                      ? _myListView(
                                      context, loanPayoutDetailList, productProvider)
                                      : Container())
                            ])),
                  );
                }
              }),
        ));
  }

  Future<void> getDSADashboardPayoutList(BuildContext) async {
    final prefsUtil = await SharedPref.getInstance();
    String? userId = prefsUtil.getString(USER_ID);
    final String? productCode = prefsUtil.getString(PRODUCT_CODE);

    dsaSalesAgentList.forEach((agent) {
      if (agent.fullName == selecteddsaSalesAgentValue) {
        setState(() {
          skip=0;
          agentUserId = agent.userId!;
          print("userId${agent.userId!}");
          print("fullName${agent.fullName!}");
        });
      }
    });

    var model = GetDsaDashboardPayoutListReqModel(
        agentUserId: agentUserId, startDate: startDate, endDate: endDate, skip: skip, take: take);

    if(isLoading){
      await Provider.of<DataProvider>(context, listen: false)
          .getDSADashboardPayoutList(model);
    }else{
      await Provider.of<DataProvider>(context, listen: false)
          .getDSADashboardPayoutList(model);
    }

    setState(() {
      loading = true;
    });
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
            print("list${dsaSalesAgentList.length}");
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

  Widget _myListView(BuildContext context,
      List<LoanPayoutDetailList> loanPayoutDetailList, DataProvider productProvider) {
    if (loanPayoutDetailList == null || loanPayoutDetailList!.isEmpty) {
      // Return a widget indicating that the list is empty or null
      return Center(
        child: Text('No transactions available'),
      );
    }

    return ListView.builder(
      controller: _scrollController,
      itemCount: loanPayoutDetailList!.length,
      itemBuilder: (context, index) {
        if (index < loanPayoutDetailList.length) {
          LoanPayoutDetailList loanPayoutDetail = loanPayoutDetailList![index];

          // Null check for each property before accessing it
          String leadID = loanPayoutDetail.loanId.toString() ??
              ''; // Default value if anchorName is null
          String disbursmentDate =  loanPayoutDetail.disbursmentDate != null
              ? Utils.convertDateTime(loanPayoutDetail.disbursmentDate.toString())
              : "Not generated yet.";
          String name = loanPayoutDetail.fullName ?? '';
          String status = loanPayoutDetail.status.toString() ?? '';
          String? mobile = loanPayoutDetail.mobileNo ?? '';
          String? profileImage = loanPayoutDetail.profileImage.toString() ?? '';

          String? disbursmentAmount = loanPayoutDetail.disbursmentAmount.toString() ?? '';
          String? payoutAmount = loanPayoutDetail.payoutAmount.toString() ?? '';

          return GestureDetector(
            onTap: () async {
              // transactionList.clear();
              /*await getTransactionBreakup(context, productProvider, invoiceId);
              _showDialog(context, productProvider, transactionList);*/
            },
            child: Card(
              child: Container(
                decoration: BoxDecoration(
                  color: whiteColor,
                  borderRadius: BorderRadius.circular(12.0),
                  // Set border radius
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 3,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Flexible(
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[

                            Text(
                              "Lead ID: $leadID",
                                style: GoogleFonts.urbanist(
                                  fontSize: 12,
                                  color: Colors.black,
                                  fontWeight: FontWeight
                                      .w500,
                                )),

                            Text(
                              "Dis. Date: $disbursmentDate",
                                style: GoogleFonts.urbanist(
                                  fontSize: 12,
                                  color: Colors.black,
                                  fontWeight: FontWeight
                                      .w500,
                                )),

                            SizedBox(
                              height: 10,
                            ),
                            Row(
                             // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                profileImage.isNotEmpty?
                                Image.network(
                                  profileImage,
                                  height: 80,
                                  width: 80,
                                ):SvgPicture.asset(
                                  'assets/images/dummy_image.svg',
                                  semanticsLabel: 'Edit Icon SVG',
                                  height: 80,
                                  width: 80,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Column(
                                  children: [
                                    Text(
                                      " Borrower Name ",
                                        style: GoogleFonts.urbanist(
                                          fontSize: 10,
                                          color: dark_gry,
                                          fontWeight: FontWeight
                                              .w500,
                                        )),
                                    Text(
                                      "$name",
                                        style: GoogleFonts.urbanist(
                                          fontSize: 10,
                                          color: Colors.black,
                                          fontWeight: FontWeight
                                              .w600,
                                        )),
                                  ],
                                ),
                               /* Card(
                                  color: kPrimaryColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        8), // Set the card radius
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      "VIEW DETAILS",
                                        style: GoogleFonts.urbanist(
                                          fontSize: 12,
                                          color: Colors.black,
                                          fontWeight: FontWeight
                                              .w500,
                                        ),
                                    ),
                                  ),
                                ),*/
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      "Status: ",
                                        style: GoogleFonts.urbanist(
                                          fontSize: 10,
                                          color: Colors.grey,
                                          fontWeight: FontWeight
                                              .w500,
                                        )),
                                    Text(
                                      "$status",
                                        style: GoogleFonts.urbanist(
                                          fontSize: 12,
                                          color: lightredColor,
                                          fontWeight: FontWeight
                                              .w600,
                                        )),
                                  ],
                                ),
                                Row(
                                  children: [
                                    SvgPicture.asset(
                                      'assets/icons/ic_call_calling.svg',
                                      semanticsLabel: 'Edit Icon SVG',
                                    ),

                                    Text(
                                      " +91 $mobile",
                                        style: GoogleFonts.urbanist(
                                          fontSize: 12,
                                          color: Colors.black,
                                          fontWeight: FontWeight
                                              .w600,
                                        )),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),

                            SvgPicture.asset(
                              'assets/icons/ic_divider_line.svg',
                              semanticsLabel: 'Edit Icon SVG',
                              width: 400,
                            ),

                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  children: [
                                    Text(
                                      "Dis. Amount",
                                        style: GoogleFonts.urbanist(
                                          fontSize: 10,
                                          color: Colors.grey,
                                          fontWeight: FontWeight
                                              .w500,
                                        )),
                                    Text(
                                      "₹$disbursmentAmount",
                                        style: GoogleFonts.urbanist(
                                          fontSize: 15,
                                          color: Colors.black,
                                          fontWeight: FontWeight
                                              .w800,
                                        )),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Text(
                                      "Payout Amount",
                                        style: GoogleFonts.urbanist(
                                          fontSize: 10,
                                          color: Colors.grey,
                                          fontWeight: FontWeight
                                              .w500,
                                        )),
                                    Text(
                                      "₹$payoutAmount",
                                        style: GoogleFonts.urbanist(
                                          fontSize: 15,
                                          color: Colors.black,
                                          fontWeight: FontWeight
                                              .w800,
                                        )),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
          ;
        }
      },
    );
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
      DateTime
          .now()
          .year,
      DateTime
          .now()
          .month,
      1 + 1,
    ); //

    startDate =
        DateFormat("yyyy-MM-ddTHH:mm:ss.SSS'Z'").format(firstDay.toUtc());
    print("Formatted Date: $startDate");

    endDate =
        DateFormat("yyyy-MM-ddTHH:mm:ss.SSS'Z'").format(now.toUtc());
    print("Formatted Date: $endDate");


    String maxDateTimeFormate =
    DateFormat("yyyy-MM-dd").format(now.toUtc());
    print("Formatted Datesasa: $maxDateTimeFormate");
    maxDateTime = maxDateTimeFormate;
  }


  Future<void> showCustomMonthYearPicker(BuildContext context) async {
    // Current Date
    DateTime now = DateTime.now();

    // Show the month-year picker dialog
    final selectedDate = await SimpleMonthYearPicker.showMonthYearPickerDialog(
        context: context,
        titleTextStyle: TextStyle(), // Customize as needed
        monthTextStyle: TextStyle(), // Customize as needed
        yearTextStyle: TextStyle(),  // Customize as needed
        disableFuture: true,
        backgroundColor: Colors.grey[200], // Set the background color
        selectionColor: kPrimaryColor // Set the selected button color// Disable future years and months
    );

    if (selectedDate != null) {
      // Get the selected year and month
      int selectedYear = selectedDate.year;
      int selectedMonth = selectedDate.month;

      // Check if the selected date is in the future
      if (selectedYear > now.year || (selectedYear == now.year && selectedMonth > now.month)) {
        // Handle future month selection, which should not happen due to disableFuture:true
        Utils.showToast("Future dates are disabled", context);
      } else {
        // Calculate the first date of the selected month
        DateTime startOfMonth = DateTime(selectedYear, selectedMonth, 1+1);

        // Calculate the end date
        DateTime endOfMonth;
        if (selectedYear == now.year && selectedMonth == now.month) {
          // If the selected month is the current month, set end date to current date
          endOfMonth = now;
        } else {
          // Otherwise, set it to the last day of the selected month
          endOfMonth = (selectedMonth < 12)
              ? DateTime(selectedYear, selectedMonth + 1, 0)
              : DateTime(selectedYear + 1, 1, 0);
        }
        loanPayoutDetailList.clear();
        skip=0;
        startDate = DateFormat("yyyy-MM-ddTHH:mm:ss.SSS'Z'").format(startOfMonth.toUtc());
        endDate = DateFormat("yyyy-MM-ddTHH:mm:ss.SSS'Z'").format(endOfMonth.toUtc());
        print('Start date: $startDate');
        print('End date: $endDate');
        getDSADashboardPayoutList(context);

      }
    }
  }
}
