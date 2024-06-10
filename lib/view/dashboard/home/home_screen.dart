import 'dart:ffi';

import 'package:convex_bottom_bar/convex_bottom_bar.dart';
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
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';

import '../../../api/ApiService.dart';
import '../../../api/FailureException.dart';
import '../../../providers/DataProvider.dart';
import '../../../shared_preferences/shared_pref.dart';
import '../../../utils/constant.dart';
import 'GetDSADashboardDetailsReqModel.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var isLoading = false;
  var leadOverviewSuccessRate = 0;
  var leadOverviewProgrssSuccessRate = null;

  var leadOverviewSubmitted="";
  var leadOverviewrejected="";
  var leadOverviewPending="";
  var leadOverviewTotalLeads="";

  var loanOverviewTotalLoans="";
  var loanOverviewRejected="";
  var loanOverviewPending="";
  var loanOverviewApproved="";

  var payoutOverviewTotalDisbursedAmount="";
  var payoutOverviewPayoutAmount="";


  var loanOverviewSuccessRate = 0;
  var loanOverviewProgrssSuccessRate = null;

  final List<String> businessTypeList = [
    'Proprietorship',
    'Partnership',
    'Pvt Ltd',
    'HUF',
    'LLP'
  ];
  String? selectedFirmTypeValue;

  @override
  void initState() {
    super.initState();
    //Api Call
  //  getDSADashboardDetails(context);
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
              return Utils.onLoading(context, "");
            } else {
              if (productProvider.getDSADashboardDetailsData != null &&
                  isLoading) {
                Navigator.of(context, rootNavigator: true).pop();
                isLoading = false;
              }

              if (productProvider.getDSADashboardDetailsData != null) {
                productProvider.getDSADashboardDetailsData!.when(
                  success: (data) {
                    // Handle successful response
                    var getDSADashboardDetailsData = data;

                    if(getDSADashboardDetailsData.response!.leadOverviewData!.successRate!=null){
                      leadOverviewSuccessRate=getDSADashboardDetailsData.response!.leadOverviewData!.successRate;
                      leadOverviewProgrssSuccessRate=getDSADashboardDetailsData.response!.leadOverviewData!.successRate;
                    }
                    if(getDSADashboardDetailsData.response!.leadOverviewData!.totalLeads!=null){
                      leadOverviewTotalLeads=getDSADashboardDetailsData.response!.leadOverviewData!.totalLeads!.toString();
                    }
                    if(getDSADashboardDetailsData.response!.leadOverviewData!.pending!=null){
                      leadOverviewPending=getDSADashboardDetailsData.response!.leadOverviewData!.pending!.toString();
                    }
                    if(getDSADashboardDetailsData.response!.leadOverviewData!.rejected!=null){
                      leadOverviewrejected=getDSADashboardDetailsData.response!.leadOverviewData!.rejected!.toString();
                    }
                    if(getDSADashboardDetailsData.response!.leadOverviewData!.submitted!=null){
                      leadOverviewSubmitted=getDSADashboardDetailsData.response!.leadOverviewData!.submitted!.toString();
                    }

                    if(getDSADashboardDetailsData.response!.loanOverviewData!.successRate!=null){
                      loanOverviewSuccessRate=getDSADashboardDetailsData.response!.loanOverviewData!.successRate;
                      loanOverviewProgrssSuccessRate=getDSADashboardDetailsData.response!.loanOverviewData!.successRate;
                    }
                    if(getDSADashboardDetailsData.response!.loanOverviewData!.totalLoans!=null){
                      loanOverviewTotalLoans=getDSADashboardDetailsData.response!.loanOverviewData!.totalLoans.toString();

                    }
                    if(getDSADashboardDetailsData.response!.loanOverviewData!.pending!=null){
                      loanOverviewPending=getDSADashboardDetailsData.response!.loanOverviewData!.pending.toString();
                    }
                    if(getDSADashboardDetailsData.response!.loanOverviewData!.rejected!=null){
                      loanOverviewRejected=getDSADashboardDetailsData.response!.loanOverviewData!.rejected.toString();

                    }
                    if(getDSADashboardDetailsData.response!.loanOverviewData!.approved!=null){
                      loanOverviewApproved=getDSADashboardDetailsData.response!.loanOverviewData!.approved.toString();

                    }

                    if(getDSADashboardDetailsData.response!.payoutOverviewData!.payoutAmount!=null){
                      payoutOverviewPayoutAmount=getDSADashboardDetailsData.response!.payoutOverviewData!.payoutAmount!.toString();
                    }
                    if(getDSADashboardDetailsData.response!.payoutOverviewData!.totalDisbursedAmount!=null){
                      payoutOverviewTotalDisbursedAmount=getDSADashboardDetailsData.response!.payoutOverviewData!.totalDisbursedAmount!.toString();
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
                    child: /*Column(
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
                                  Container(
                                    alignment: Alignment.centerRight,
                                    child: SvgPicture.asset(
                                      'assets/icons/ic_document_filter.svg',
                                      semanticsLabel: 'Edit Icon SVG',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          DropdownButtonFormField2<String>(
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
                                color: Colors.black,
                                fontSize: 16.0,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            items: _addDividersAfterItems(businessTypeList),
                            value: selectedFirmTypeValue,
                            onChanged: (String? value) {
                              selectedFirmTypeValue = value;
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
                                  _getCustomItemsHeights(businessTypeList),
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
                                    Container(
                                        width: 150,
                                        child:CircularPercentIndicator(
                                          radius: 70.0,
                                          lineWidth: 18.0,
                                          percent: loanOverviewProgrssSuccessRate == null ? 0.0 : loanOverviewProgrssSuccessRate.toDouble()/100,
                                          circularStrokeCap: CircularStrokeCap.round,
                                          progressColor: whiteColor,
                                          backgroundColor: dark_blue,
                                          center: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
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
                                        )
                                    ),
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
                                    Container(
                                        width: 150,
                                        child:CircularPercentIndicator(
                                          radius: 70.0,
                                          lineWidth: 18.0,
                                          percent: leadOverviewProgrssSuccessRate == null ? 0.0 : leadOverviewProgrssSuccessRate.toDouble()/100,
                                          circularStrokeCap: CircularStrokeCap.round,
                                          progressColor: kPrimaryColor,
                                          backgroundColor: dark_blue,
                                          center: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
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
                                        )
                                    ),
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
                                          Text('₹$payoutOverviewTotalDisbursedAmount',
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
                        ])*/
                    Text("Working on Dashboard"),
                  ),
                ),
              );
            }
          }),
        ));
  }

  List<DropdownMenuItem<String>> _addDividersAfterItems(List<String> items) {
    final List<DropdownMenuItem<String>> menuItems = [];
    for (final String item in items) {
      menuItems.addAll(
        [
          DropdownMenuItem<String>(
            value: item,
            child: Text(
              item,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
          ),
          //If it's last item, we will not add Divider after it.
          if (item != items.last)
            const DropdownMenuItem<String>(
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

  List<double> _getCustomItemsHeights(List<String> items) {
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

  void getDSADashboardDetails(BuildContext) async {
    final prefsUtil = await SharedPref.getInstance();
    String? userId = prefsUtil.getString(USER_ID);
    final String? productCode = prefsUtil.getString(PRODUCT_CODE);

    var model = GetDsaDashboardDetailsReqModel(
        agentUserId: "",
        startDate: "2024-06-01T11:30:11.612Z",
        endDate: "2024-06-30T11:30:11.612Z");

    await Provider.of<DataProvider>(context, listen: false)
        .getDSADashboardDetails(model);
  }
}
