import 'dart:ffi';

import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:direct_sourcing_agent/utils/loader.dart';
import 'package:direct_sourcing_agent/utils/utils_class.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:simple_month_year_picker/simple_month_year_picker.dart';

import '../../../api/ApiService.dart';
import '../../../api/FailureException.dart';
import '../../../providers/DataProvider.dart';
import '../../../shared_preferences/shared_pref.dart';
import '../../../utils/CustomMonthYearPicker.dart';
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
  bool isAgentSelected = false;
  var type = "";

  var payoutOverviewTotalDisbursedAmount = "0";
  var payoutOverviewPayoutAmount = "0";

  var loanOverviewSuccessRate = 0;
  var loanOverviewProgrssSuccessRate = null;

  final List<DsaSalesAgentList> dsaSalesAgentList = [];
  final List<LoanPayoutDetailList> loanPayoutDetailList = [];
  final List<LoanPayoutDetailList> loanPayoutDetailfinalList = [];
  ScrollController _scrollController = ScrollController();

  String? selecteddsaSalesAgentValue;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _refreshIndicatorKey.currentState?.show());
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

  Future<void> _handleRefresh() async {
    getDSADashboardPayoutList(context);
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

                    if (getDSADashboardPayoutListData.response != null) {
                      if (getDSADashboardPayoutListData.response!.totalDisbursedAmount != null) {
                        payoutOverviewTotalDisbursedAmount =
                            getDSADashboardPayoutListData
                                .response!.totalDisbursedAmount!
                                .toString();
                      }
                      if (getDSADashboardPayoutListData
                              .response!.totalPayoutAmount !=
                          null) {
                        payoutOverviewPayoutAmount =
                            getDSADashboardPayoutListData
                                .response!.totalPayoutAmount!
                                .toString();
                      }

                      if (getDSADashboardPayoutListData.response!.loanPayoutDetailList != null) {
                        if (getDSADashboardPayoutListData.response!.loanPayoutDetailList!.isNotEmpty) {
                          loanPayoutDetailList.clear();
                          loanPayoutDetailList.addAll(
                              getDSADashboardPayoutListData.response!
                                  as Iterable<LoanPayoutDetailList>);
                          loanPayoutDetailfinalList.addAll(loanPayoutDetailList);
                        } else {
                          loading = false;
                        }
                      }
                    } else {
                     /* loanPayoutDetailList.clear();
                      loanPayoutDetailList.add(LoanPayoutDetailList(loanId: "AMLAAYAIR100000006422",disbursmentAmount: 10,disbursmentDate: "2024-06-01T18:30:00.000Z",status: "pending",mobileNo: "12345 67890",payoutAmount: 100,profileImage: "",fullName: "atul"));
                      loanPayoutDetailList.add(LoanPayoutDetailList(loanId: "AMLAAYAIR100000006422",disbursmentAmount: 10,disbursmentDate: "2024-06-01T18:30:00.000Z",status: "pending",mobileNo: "12345 67890",payoutAmount: 100,profileImage: "",fullName: "Mukesh Kumar PAtel dfdfgd fdsfdfd fdsfd fdfdf fdfgd fgdgdg dgdgd "));
                      loanPayoutDetailfinalList.addAll(loanPayoutDetailList);*/
                      loading = false;
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
              return Padding(
                padding: const EdgeInsets.all(10),
                child:RefreshIndicator(
                    key: _refreshIndicatorKey,
                    onRefresh: _handleRefresh,
                    child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Center(
                    child: Padding(
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
                                showCustomMonthYearPicker(
                                    context, productProvider);
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
                  type != null && type == "DSA"
                      ? DropdownButtonFormField2<DsaSalesAgentList>(
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
                          hint: Text(
                            'All Agents ',
                            style: GoogleFonts.urbanist(
                              fontSize: 15,
                              color: light_black,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          items:
                              _addDividersAfterItems(dsaSalesAgentList),
                          onChanged: (DsaSalesAgentList? value) {
                            selecteddsaSalesAgentValue = value!.fullName;
                            dateTime(context);
                            getDSADashboardPayoutList(context);
                            setState(() {
                              loanPayoutDetailfinalList.clear();
                              productProvider.disposePayOutScreenData();
                              isAgentSelected = true;
                            });
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
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8.0),
                            customHeights: _getCustomItemsHeights3(
                                dsaSalesAgentList),
                          ),
                          iconStyleData: const IconStyleData(
                            openMenuIcon: Icon(Icons.arrow_drop_up),
                          ),
                        )
                      : Container(),
                  const SizedBox(
                    height: 20.0,
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                            const SizedBox(width: 16,),
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
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  Expanded(
                      child: loanPayoutDetailfinalList != null && loanPayoutDetailfinalList.isNotEmpty
                          ? _myListView(context,
                              loanPayoutDetailfinalList, productProvider)
                          : ListView(
                        children: [
                          Container(
                            height: 400,
                            alignment: Alignment.center,
                            child: Text('No data available'),
                          ),
                        ],
                      ),)
                ]))
              );
            }
          }),
        ));
  }

  Future<void> getDSADashboardPayoutList(BuildContext) async {
    final prefsUtil = await SharedPref.getInstance();
    type = prefsUtil.getString(TYPE)!;
    print("type$type");

    if (isAgentSelected) {
      dsaSalesAgentList.forEach((agent) {
        if (agent.fullName == selecteddsaSalesAgentValue) {
          setState(() {
            skip = 0;
            agentUserId = agent.userId!;
          });
        }
      });
    }

    var model = GetDsaDashboardPayoutListReqModel(
        agentUserId: agentUserId,
        startDate: startDate,
        endDate: endDate,
        skip: skip,
        take: take);

    if (isLoading) {
      await Provider.of<DataProvider>(context, listen: false)
          .getDSADashboardPayoutList(model);
    } else {
      Utils.onLoading(context, "");
      await Provider.of<DataProvider>(context, listen: false)
          .getDSADashboardPayoutList(model);
      Navigator.of(context, rootNavigator: true).pop();
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
          productProvider.disposePayOutScreenData();
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

  Widget _myListView(
      BuildContext context,
      List<LoanPayoutDetailList> loanPayoutDetailList,
      DataProvider productProvider) {
    return ListView.builder(
      controller: _scrollController,
      itemCount: loanPayoutDetailList.length,
      itemBuilder: (context, index) {
        if (index < loanPayoutDetailList.length) {
          LoanPayoutDetailList loanPayoutDetail = loanPayoutDetailList![index];

          // Null check for each property before accessing it
          String? leadID = loanPayoutDetail.loanId.toString() ??
              ''; // Default value if anchorName is null
          String? disbursmentDate = loanPayoutDetail.disbursmentDate != null
              ? Utils.dateMonthAndYearFormat(
                  loanPayoutDetail.disbursmentDate.toString())
              : "";
          String? name = loanPayoutDetail.fullName ?? '';
          String? status = loanPayoutDetail.status.toString() ?? '';
          String? mobile = loanPayoutDetail.mobileNo ?? '';
          String? profileImage = loanPayoutDetail.profileImage.toString() ?? '';
          String? disbursmentAmount =
              loanPayoutDetail.disbursmentAmount.toString() ?? '';
          String? payoutAmount = loanPayoutDetail.payoutAmount.toString() ?? '';

          return GestureDetector(
            onTap: () async {},
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
                            Text("Lead ID: $leadID",
                                style: GoogleFonts.urbanist(
                                  fontSize: 12,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                )),
                            Text("Dis. Date: $disbursmentDate",
                                style: GoogleFonts.urbanist(
                                  fontSize: 12,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                )),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Container(
                                    child: profileImage.isNotEmpty
                                        ? ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            // Adjust the value to change the roundness
                                            child: Image.network(
                                              profileImage,
                                              height: 70,
                                              width: 70,
                                              fit: BoxFit.cover,
                                            ),
                                          )
                                        : ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            // Adjust the value to change the roundness
                                            child: Container(
                                              color: light_gry,
                                              height: 70,
                                              width: 70,
                                            ),
                                          )),
                                SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: Column(
                                    children: [
                                      Text(" Borrower Name ",
                                          style: GoogleFonts.urbanist(
                                            fontSize: 10,
                                            color: dark_gry,
                                            fontWeight: FontWeight.w500,
                                          )),
                                      Text("$name",
                                          style: GoogleFonts.urbanist(
                                            fontSize: 10,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w600,
                                          )),
                                    ],
                                  ),
                                ),
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
                                    Text("Status: ",
                                        style: GoogleFonts.urbanist(
                                          fontSize: 10,
                                          color: Colors.grey,
                                          fontWeight: FontWeight.w500,
                                        )),
                                    Text("$status",
                                        style: GoogleFonts.urbanist(
                                          fontSize: 12,
                                          color: lightredColor,
                                          fontWeight: FontWeight.w600,
                                        )),
                                  ],
                                ),
                                Row(
                                  children: [
                                    SvgPicture.asset(
                                      'assets/icons/ic_call_calling.svg',
                                      semanticsLabel: 'Edit Icon SVG',
                                    ),
                                    Text(" +91 $mobile",
                                        style: GoogleFonts.urbanist(
                                          fontSize: 12,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w600,
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
                                Flexible(
                                  child: Column(
                                    children: [
                                      Text("Dis. Amount",
                                          style: GoogleFonts.urbanist(
                                            fontSize: 10,
                                            color: Colors.grey,
                                            fontWeight: FontWeight.w500,
                                          )),
                                      Text("₹$disbursmentAmount",
                                          style: GoogleFonts.urbanist(
                                            fontSize: 15,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w800,
                                          )),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 16,),
                                Flexible(
                                  child: Column(
                                    children: [
                                      Text("Payout Amount",
                                          style: GoogleFonts.urbanist(
                                            fontSize: 10,
                                            color: Colors.grey,
                                            fontWeight: FontWeight.w500,
                                          )),
                                      Text("₹$payoutAmount",
                                          style: GoogleFonts.urbanist(
                                            fontSize: 15,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w800,
                                          )),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
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
    DateTime firstDay = new DateTime(
      DateTime.now().year,
      DateTime.now().month,
      1 + 1,
    ); //

    startDate =
        DateFormat("yyyy-MM-ddTHH:mm:ss.SSS'Z'").format(firstDay.toUtc());
    print("Formatted Date: $startDate");

    endDate = DateFormat("yyyy-MM-ddTHH:mm:ss.SSS'Z'").format(now.toUtc());
    print("Formatted Date: $endDate");

    String maxDateTimeFormate = DateFormat("yyyy-MM-dd").format(now.toUtc());
    print("Formatted Datesasa: $maxDateTimeFormate");
    maxDateTime = maxDateTimeFormate;
  }

  Future<void> showCustomMonthYearPicker(
      BuildContext context, DataProvider productProvider) async {
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
        Utils.showToast("Future dates are disabled", context);
      } else {
        DateTime startOfMonth = DateTime(selectedYear, selectedMonth, 1 + 1);
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

        if (isOk) {
          setState(() {
            agentUserId = "";
            isAgentSelected = false;
            loanPayoutDetailfinalList.clear();
            productProvider.disposePayOutScreenData();
            skip = 0;
            startDate = DateFormat("yyyy-MM-ddTHH:mm:ss.SSS'Z'")
                .format(startOfMonth.toUtc());
            endDate = DateFormat("yyyy-MM-ddTHH:mm:ss.SSS'Z'")
                .format(endOfMonth.toUtc());
          });

          getDSADashboardPayoutList(context);
        }
      }
    }
  }
}
