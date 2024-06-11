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

import '../../../api/ApiService.dart';
import '../../../api/FailureException.dart';
import '../../../providers/DataProvider.dart';
import '../../../shared_preferences/shared_pref.dart';
import '../../../utils/constant.dart';
import '../home/DsaSalesAgentList.dart';
import '../home/GetDSADashboardDetailsReqModel.dart';
import 'model/DSAUsersListResModel.dart';
import 'model/DsaUsersList.dart';


class LeadScreen extends StatefulWidget {
  const LeadScreen({super.key});

  @override
  State<LeadScreen> createState() => _LeadScreenState();
}

class _LeadScreenState extends State<LeadScreen> {
  var isLoading = true;
  var leadOverviewSuccessRate = 0;
  var leadOverviewProgrssSuccessRate = null;
  var agentUserId="";

  var leadOverviewSubmitted="";
  var leadOverviewrejected="";
  var leadOverviewPending="";
  var leadOverviewTotalLeads="";

  var loanOverviewTotalLoans="";
  var loanOverviewRejected="";
  var loanOverviewPending="";
  var loanOverviewApproved="";
  var skip=0;
  var take=10;

  var payoutOverviewTotalDisbursedAmount="";
  var payoutOverviewPayoutAmount="";


  var loanOverviewSuccessRate = 0;
  var loanOverviewProgrssSuccessRate = null;

  final List<DsaSalesAgentList> dsaSalesAgentList = [];
  final List<DsaUsersList> dSAUsersList = [];

  String? selecteddsaSalesAgentValue;

  @override
  void initState() {
    super.initState();
    //Api Call
    getDSAUsers(context);
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
                if (productProvider.getDSAUsersListData == null &&
                    isLoading) {
                  return Loader();
                } else {
                  if (productProvider.getDSAUsersListData != null &&
                      isLoading) {
                    Navigator.of(context, rootNavigator: true).pop();
                    isLoading = false;
                    getDSASalesAgentList(context,productProvider);
                  }


                  if (productProvider.getDSAUsersListData != null) {
                    productProvider.getDSAUsersListData!.when(
                      success: (data) {
                        // Handle successful response
                        var getDSAUsersListData = data;


                        if( getDSAUsersListData.result!=null){
                          dSAUsersList.addAll(getDSAUsersListData.result! as Iterable<DsaUsersList>);
                          print("aaa${dSAUsersList.length}");
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
                                            "Lead",
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
                                  //getDSADashboardDetails(context);
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
                                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                  customHeights: _getCustomItemsHeights3(dsaSalesAgentList),
                                ),
                                iconStyleData: const IconStyleData(
                                  openMenuIcon: Icon(Icons.arrow_drop_up),
                                ),
                              ),
                              const SizedBox(
                                height: 20.0,
                              ),
                              Expanded(
                                  child: dSAUsersList != null
                                      ? _myListView(
                                      context, dSAUsersList, productProvider)
                                      : Container())
                            ])
                    ),
                  );
                }
              }),
        ));
  }



  Future<void> getDSAUsers(BuildContext) async {
    final prefsUtil = await SharedPref.getInstance();
    String? userId = prefsUtil.getString(USER_ID);
    final String? productCode = prefsUtil.getString(PRODUCT_CODE);


    await Provider.of<DataProvider>(context, listen: false)
        .getDSAUsersList(userId!,skip,take);
  }

  Future<void> getDSASalesAgentList(BuildContext context, DataProvider productProvider,) async {
    // Loader();

    await Provider.of<DataProvider>(context, listen: false)
        .getDSASalesAgentList();
    //Navigator.of(context, rootNavigator: true).pop();

    if (productProvider.getDSASalesAgentListData != null) {
      productProvider.getDSASalesAgentListData!.when(
        success: (data) {
          // Handle successful response
          var getDSASalesAgentListData = data;
          if (getDSASalesAgentListData.result!=null) {
            dsaSalesAgentList.clear();
            dsaSalesAgentList.addAll(getDSASalesAgentListData.result as Iterable<DsaSalesAgentList>);
            print("list${dsaSalesAgentList.length}");

          }else{

          }
        },
        failure: (exception) {
          // Handle failure
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
    setState(() {

    });
  }

  List<DropdownMenuItem<DsaSalesAgentList>> _addDividersAfterItems(List<DsaSalesAgentList?> list) {
    final List<DropdownMenuItem<DsaSalesAgentList>> menuItems = [];
    for (final DsaSalesAgentList? item in list) {
      menuItems.addAll(
        [
          DropdownMenuItem<DsaSalesAgentList>(
            value: item,
            child: Text(
              item!.fullName.toString(), // Assuming 'name' is the property to display
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
      List<DsaUsersList> dsaUsersList,
      DataProvider productProvider) {
    if (dsaUsersList == null || dsaUsersList!.isEmpty) {
      // Return a widget indicating that the list is empty or null
      return Center(
        child: Text('No transactions available'),
      );
    }

    return ListView.builder(
      //controller: _scrollController,
      itemCount: dsaUsersList!.length,
      itemBuilder: (context, index) {
        if (index < dsaUsersList.length) {
          DsaUsersList dsaUsers =
          dsaUsersList ![index];

          // Null check for each property before accessing it
          String leadID = dsaUsers.userId ?? ''; // Default value if anchorName is null
          String createdDate = dsaUsers.createdDate != null
              ? Utils.convertDateTime(dsaUsers.createdDate.toString())
              : "Not generated yet.";
          String name = dsaUsers.fullName ?? '';
          String status = dsaUsers.status.toString()  ?? '';
          String? mobile =dsaUsers.mobileNo ?? '';


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
                      color: Colors.grey.withOpacity(0.5),
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
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                                Spacer(),
                                Text(
                                  "Created Date: $createdDate",
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                      fontWeight: FontWeight.normal),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SvgPicture.asset(
                                  'assets/images/dummy_image.svg',
                                  semanticsLabel: 'Edit Icon SVG',
                                  height: 80,
                                  width: 80,
                                ),
                                Column(
                                  children: [
                                    Text(
                                      " Borrower Name ",
                                      style: TextStyle(
                                          fontSize: 10,
                                          color: Colors.grey,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      "$name",
                                      style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),

                                Card(
                                  color: kPrimaryColor  ,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10), // Set the card radius
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      "Resume",
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
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
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey,
                                          fontWeight: FontWeight.normal),
                                    ),
                                    Text(
                                      "$status",
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey,
                                          fontWeight: FontWeight.normal),
                                    ),
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
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey,
                                          fontWeight: FontWeight.bold),
                                    ),
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


}
