import 'dart:ffi';
import 'dart:ui';

import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:direct_sourcing_agent/utils/loader.dart';
import 'package:direct_sourcing_agent/utils/utils_class.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
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
import '../../../utils/CustomMonthYearPicker.dart';
import '../../../utils/constant.dart';
import '../home/DsaSalesAgentList.dart';
import '../home/GetDSADashboardDetailsReqModel.dart';
import 'model/DSADashboardLeadListReqModel.dart';
import 'model/DsaDashboardLeadList.dart';
import 'package:url_launcher/url_launcher.dart';

class LeadScreen extends StatefulWidget {
  const LeadScreen({super.key});

  @override
  State<LeadScreen> createState() => _LeadScreenState();
}

class _LeadScreenState extends State<LeadScreen> {
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




  var payoutOverviewTotalDisbursedAmount = "";
  var payoutOverviewPayoutAmount = "";

  var loanOverviewSuccessRate = 0;
  var loanOverviewProgrssSuccessRate = null;

  final List<DsaSalesAgentList> dsaSalesAgentList = [];
  final List<DsaDashboardLeadList> dsaDashboardLead = [];
  final List<DsaDashboardLeadList> dsaDashboardLeadFinal = [];
  ScrollController _scrollController = ScrollController();

  String? selecteddsaSalesAgentValue;

  final browser = MyInAppBrowser();

  final settings = InAppBrowserClassSettings(
      browserSettings: InAppBrowserSettings(hideUrlBar: true),
      webViewSettings: InAppWebViewSettings(
          javaScriptEnabled: true, isInspectable: kDebugMode,clearCache:true));
  String? companyID;
  String? productCode;
  String? UserToken;
  String? LeadCreateMobileNo;

  @override
  void initState() {
    super.initState();
    getUserData();
    //Api Call
    dateTime(context);
    getDSADashboardLead(context);


    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        // Load more data if not already loading
        if (loading) {
          skip += 10;
          getDSADashboardLead(context);
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
            if (productProvider.getDSADashboardLeadListData == null &&
                isLoading) {
              return Loader();
            } else {
              if (productProvider.getDSADashboardLeadListData != null &&
                  isLoading) {
                Navigator.of(context, rootNavigator: true).pop();
                isLoading = false;
                getDSASalesAgentList(context, productProvider);
              }

                  if (productProvider.getDSADashboardLeadListData != null) {
                    productProvider.getDSADashboardLeadListData!.when(
                      success: (data) {
                        // Handle successful response
                        var getDSADashboardLeadListData = data;
                        print("sdfdskf1${dsaDashboardLead.length}");
                        if (getDSADashboardLeadListData.response != null) {
                          if (getDSADashboardLeadListData.response!.isNotEmpty) {
                            dsaDashboardLead.clear();
                            dsaDashboardLead.addAll(getDSADashboardLeadListData.response!);
                            dsaDashboardLeadFinal.addAll(dsaDashboardLead);
                            print("sdfdskf2${dsaDashboardLead.length}");
                          } else {
                            loading = false;
                          }
                        }else{
                          loading = false;
                        }
                       // productProvider.disposeLeadScreenData();
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
                    child: Container(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 10),
                              Center(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 20, right: 20, top: 15),
                                  child: Center(
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment
                                          .center,
                                      children: [
                                        Expanded(
                                          child: Container(
                                            alignment: Alignment.center,
                                            child: Text(
                                              "Lead",
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
                                            showCustomMonthYearPicker(context,productProvider);
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
                              type!=null && type=="DSA"?
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
                                hint: Text(
                                  'All Agents ',
                                  style: GoogleFonts.urbanist(
                                    fontSize: 15,
                                    color: light_black,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                items: _addDividersAfterItems(
                                    dsaSalesAgentList),
                                onChanged: (DsaSalesAgentList? value) {
                                  selecteddsaSalesAgentValue = value!.fullName;
                                  setState(() {
                                    dsaDashboardLeadFinal.clear();
                                    productProvider.disposeLeadScreenData();
                                    isAgentSelected=true;
                                  });
                                  dateTime(context);
                                  getDSADashboardLead(context);

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
                                  customHeights:
                                  _getCustomItemsHeights3(dsaSalesAgentList),
                                ),
                                iconStyleData: const IconStyleData(
                                  openMenuIcon: Icon(Icons.arrow_drop_up),
                                ),
                              ):Container(),
                              const SizedBox(
                                height: 20.0,
                              ),
                              Expanded(
                                  child: dsaDashboardLeadFinal != null
                                      ? _myListView(
                                      context, dsaDashboardLeadFinal,
                                      productProvider)
                                      : Container())
                            ])),
                  );
                }
              }),
        ));
  }

  Future<void> getDSADashboardLead(BuildContext) async {
    final prefsUtil = await SharedPref.getInstance();
    type = prefsUtil.getString(TYPE)!;
    print("type$type");
    if(isAgentSelected){
      dsaSalesAgentList.forEach((agent) {
        if (agent.fullName == selecteddsaSalesAgentValue) {
          setState(() {
            skip = 0;
            agentUserId = agent.userId!;
          });
        }
      });
    }


    var model = DsaDashboardLeadListReqModel(
        agentUserId: agentUserId,
        startDate: startDate,
        endDate: endDate,
        skip: skip,
        take: take);

    if (isLoading) {
      await Provider.of<DataProvider>(context, listen: false)
          .getDSADashboardLeadList(model);
    } else {
      Utils.onLoading(context, "");
      await Provider.of<DataProvider>(context, listen: false)
          .getDSADashboardLeadList(model);
      Navigator.of(context, rootNavigator: true).pop();
    }

    setState(() {
      loading = true;
    });
  }

  Future<void> getDSASalesAgentList(BuildContext context,
      DataProvider productProvider,) async {
   // Utils.onLoading(context, "");
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
          productProvider.disposeLeadScreenData();
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

  Widget _myListView(BuildContext context,
      List<DsaDashboardLeadList> dsaDashboardLeadList,
      DataProvider productProvider) {
    if (dsaDashboardLeadList == null || dsaDashboardLeadList!.isEmpty) {
      // Return a widget indicating that the list is empty or null
      return Center(
        child: Text('Data Not available'),
      );
    }

    return ListView.builder(
      controller: _scrollController,
      itemCount: dsaDashboardLeadFinal!.length,
      itemBuilder: (context, index) {
        if (index < dsaDashboardLeadList.length) {
          DsaDashboardLeadList dsaDashboardLead = dsaDashboardLeadList![index];

          // Null check for each property before accessing it
          String? leadID = dsaDashboardLead.leadId.toString() ?? ''; // Default value if anchorName is null
          String createdDate = dsaDashboardLead.createdDate != null ? Utils.dateMonthAndYearFormat(dsaDashboardLead.createdDate.toString()) : "";
          String name = dsaDashboardLead.fullName ?? '';
          String status = dsaDashboardLead.status.toString() ?? '';
          LeadCreateMobileNo = dsaDashboardLead.mobileNo ?? '';
          String? profileImage = dsaDashboardLead.profileImage.toString() ?? '';

          return GestureDetector(
            onTap: () async {
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
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                    "Lead ID : $leadID",
                                    style: GoogleFonts.urbanist(
                                      fontSize: 12,
                                      color: Colors.black,
                                      fontWeight: FontWeight
                                          .w500,
                                    )),
                                Spacer(),
                                Text(
                                    "Created Date: $createdDate",
                                    style: GoogleFonts.urbanist(
                                      fontSize: 12,
                                      color: Colors.black,
                                      fontWeight: FontWeight
                                          .w500,
                                    )),
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
                                    Container(
                                      child: profileImage.isNotEmpty ? ClipRRect(
                                        borderRadius: BorderRadius.circular(5), // Adjust the value to change the roundness
                                        child: Image.network(
                                          profileImage,
                                          height: 70,
                                          width: 70,
                                          fit: BoxFit.cover,
                                        ),
                                      ) : ClipRRect(
                                        borderRadius: BorderRadius.circular(5), // Adjust the value to change the roundness
                                        child: Container (
                                          color: light_gry,
                                          height: 70,
                                          width: 70,
                                        ),
                                      )
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
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    openInAppBrowser(UserToken!,context, dsaDashboardLead.mobileNo.toString());
                                  },
                                  child: Card(
                                    color: kPrimaryColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          8), // Set the card radius
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        "RESUME",
                                        style: GoogleFonts.urbanist(
                                          fontSize: 12,
                                          color: whiteColor,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
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
                                    Text(
                                        "Status :",
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

                                    GestureDetector(onTap: (){
                                      _makePhoneCall("tel:${dsaDashboardLead.mobileNo}");
                                    },child: Text(
                                        " +91 $LeadCreateMobileNo",
                                        style: GoogleFonts.urbanist(
                                          fontSize: 12,
                                          color: Colors.black,
                                          fontWeight: FontWeight
                                              .w600,
                                        )),)

                                  ],
                                ),
                              ],
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

  Future<void> _makePhoneCall(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }


  Future<void> dateTime(BuildContext) async {
    DateTime now = DateTime.now();
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


  Future<void> showCustomMonthYearPicker(BuildContext context, DataProvider productProvider) async {
    var isOk=true;
    // Current Date
    DateTime now = DateTime.now();
    // Define the onCancel callback
    void onCancel() {
      print("Picker was cancelled");
      setState(() {
        isOk=false;      });
    }
    void onOk() {
      print("Picker was ok");
      setState(() {
        isOk=true;
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
        barrierDismissible:false,
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

        if(isOk){
          setState(() {
            isAgentSelected=false;
            productProvider.disposeLeadScreenData();
            dsaDashboardLeadFinal.clear();
            agentUserId="";
            skip = 0;
            startDate = DateFormat("yyyy-MM-ddTHH:mm:ss.SSS'Z'").format(
                startOfMonth.toUtc());
            endDate = DateFormat("yyyy-MM-ddTHH:mm:ss.SSS'Z'").format(
                endOfMonth.toUtc());
          });

           getDSADashboardLead(context);
        }
      }
    }
  }

  void openInAppBrowser(String token, BuildContext _context, String mobile) {
    browser.token=token;
    browser.context=_context;
    browser.openUrlRequest(
      urlRequest: URLRequest(url: WebUri(_constructUrl(mobile))),
      settings: settings,



    );
  }
  Future<void> getUserData()async {
    final prefsUtil = await SharedPref.getInstance();
    companyID = prefsUtil.getString(COMPANY_CODE);
    productCode = prefsUtil.getString(PRODUCT_CODE);
    UserToken = prefsUtil.getString(TOKEN);

  }

  String _constructUrl(String mobile) {
    String baseUrl = "https://customer-qa.scaleupfin.com/#/lead";
    String mobileNumber = mobile ?? "";
    String companyId = companyID?.toString() ?? "";
    String productId = productCode?.toString() ?? "";
    return "$baseUrl/$mobileNumber/$companyId/$productId/true";
  }
}
class MyInAppBrowser extends InAppBrowser {
  var token;
  var context;


  MyInAppBrowser();
  @override
  Future onBrowserCreated() async {
   // Navigator.of(context, rootNavigator: true).pop();
  }

  @override
  Future onLoadStart(url) async {
    print("Started $url");
    Loader();
  }

  @override
  Future onLoadStop(url) async {
    print("Stopped $token");
    await webViewController?.evaluateJavascript(source: "_callJavaScriptFunction('${token}')");
  }

  @override
  void onProgressChanged(progress) {
    print("Progress: $progress");
  }

  @override
  void onExit() {
    print("Browser  closed!");
  }
}
