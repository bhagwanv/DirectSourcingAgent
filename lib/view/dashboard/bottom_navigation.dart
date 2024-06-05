import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../providers/DataProvider.dart';
import '../../utils/constant.dart';
import '../../utils/utils_class.dart';
import 'home/home_screen.dart';

class BottomNav extends StatefulWidget {
  final String? pageType;
  const BottomNav({super.key, this.pageType});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  final List<Widget> _pages = [
    const HomeScreen(),
    const HomeScreen(),
    const HomeScreen(),
  ];
  var selectedIndex = 2;
  late DataProvider productProvider;
  @override
  Widget build(BuildContext context) {
    productProvider = Provider.of<DataProvider>(context, listen: false);
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        debugPrint("didPop1: $didPop");
        if (didPop) {
          return;
        }
        if(widget.pageType == "pushReplacement" ) {
          final bool shouldPop = await Utils().onback(context);
          if (shouldPop) {
            SystemNavigator.pop();
          }
        } else {
          SystemNavigator.pop();
        }
      },
      child: Scaffold(
          body: _pages[selectedIndex],
          extendBody: true,
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              setState(() {
                selectedIndex = 2;
                // productProvider.disposegetCustomerOrderSummaryData();
                // productProvider.disposegetCustomerTransactionList();
              });
            },
            child: SvgPicture.asset(
              'assets/icons/ic_home.svg',
              semanticsLabel: 'home',
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            backgroundColor: kPrimaryColor,
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

          bottomNavigationBar: BottomAppBar(
            surfaceTintColor: Colors.white,
            shadowColor: textFiledBackgroundColour,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            height: 70,
            shape: const CircularNotchedRectangle(),
            notchMargin: 10,
            elevation: 30,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                // Menu item
                GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedIndex = 0;
                      // productProvider.disposegetCustomerOrderSummaryData();
                      // productProvider.disposegetCustomerTransactionList();
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Column(
                      children: [
                        SvgPicture.asset(
                          'assets/icons/ic_vendors.svg',
                          semanticsLabel: 'vendors',
                          color: selectedIndex == 0 ? kPrimaryColor : Colors.black, // Change color based on selected index
                        ),
                        const SizedBox(height: 3), // Add space between icon and text
                        Text(
                          'Vendors',
                          style: TextStyle(
                            color: selectedIndex == 0 ? kPrimaryColor : Colors.black, // Change color based on selected index
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Search item
                GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedIndex = 1;
                      //  productProvider.disposegetCustomerOrderSummaryData();
                      //  productProvider.disposegetCustomerTransactionList();
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Column(
                      children: [
                        SvgPicture.asset(
                          'assets/icons/ic_transactions.svg',
                          semanticsLabel: 'transactionsG',
                          color: selectedIndex == 1 ? kPrimaryColor : Colors.black, // Change color based on selected index
                        ),
                        const SizedBox(height: 3), // Add space between icon and text
                        Text(
                          'Transactions',
                          style: TextStyle(
                            color: selectedIndex == 1 ? kPrimaryColor : Colors.black, // Change color based on selected index
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 24.0),
                // Print item
                GestureDetector(
                  onTap: () {
                    /* setState(() {
                      selectedIndex = 3;
                    });*/
                    Utils.showBottomToast("Service Not Available");
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Column(
                      children: [
                        SvgPicture.asset(
                          'assets/icons/ic_services.svg',
                          semanticsLabel: 'ic_services',
                          color: selectedIndex == 3 ? kPrimaryColor : Colors.black, // Change color based on selected index
                        ),
                        const SizedBox(height: 3), // Add space between icon and text
                        Text(
                          'Services',
                          style: TextStyle(
                            color: selectedIndex == 3 ? kPrimaryColor : Colors.black, // Change color based on selected index
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // People item
                GestureDetector(
                  onTap: () {
                    Utils.showBottomToast("Service Not Available");
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Column(
                      children: [
                        SvgPicture.asset(
                          'assets/icons/ic_setting.svg',
                          semanticsLabel: 'Verify PAN SVG',
                          color: selectedIndex == 4 ? kPrimaryColor : Colors.black, // Change color based on selected index
                        ),
                        const SizedBox(height: 3), // Add space between icon and text
                        Text(
                          'Setting',
                          style: TextStyle(
                            color: selectedIndex == 4 ? kPrimaryColor : Colors.black, // Change color based on selected index
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )


      ),
    );
  }
}
