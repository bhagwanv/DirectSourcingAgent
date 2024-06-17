import 'package:direct_sourcing_agent/view/dashboard/Lead_screen/LeadScreen.dart';
import 'package:direct_sourcing_agent/view/dashboard/leadcreate/CreateLeadWidgets.dart';
import 'package:direct_sourcing_agent/view/dashboard/payout_screen/payout_screen.dart';
import 'package:direct_sourcing_agent/view/dashboard/userprofile/UserProfileClass.dart';
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
    const LeadScreen(),
    const PayOutScreen(),
    const UserProfileClass(),
  ];
  var selectedIndex = 0;
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
        final bool shouldPop = await Utils().onback(context);
        if (shouldPop) {
          SystemNavigator.pop();
        }
      },
      child: Scaffold(
          backgroundColor: Colors.white,
          body: _pages[selectedIndex],
          extendBody: true,
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              setState(() {
                createLeadBottom();
              });
            },
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            backgroundColor: kPrimaryColor,
            child: SvgPicture.asset(
              'assets/icons/ic_plush_button.svg',
              semanticsLabel: 'home',
            ),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          bottomNavigationBar: BottomAppBar(
            surfaceTintColor: Colors.white,
            shadowColor: Colors.black,
            padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
            height: 75,
            shape: const CircularNotchedRectangle(),
            notchMargin: 0,
            elevation: 100,
            child: Container(
              color: Colors.white,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  // Menu item
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedIndex = 0;
                        productProvider.disposehomeScreenData();
                        productProvider.disposePayOutScreenData();
                        productProvider.disposeUserProfileScreenData();
                        productProvider.disposeLeadScreenData();
                      });
                    },
                    child: Container(
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          children: [
                            SvgPicture.asset(
                              'assets/icons/ic_home_icon.svg',
                              semanticsLabel: 'ic_home_icon',
                              color: selectedIndex == 0
                                  ? kPrimaryColor
                                  : Colors
                                      .black, // Change color based on selected index
                            ),
                            const SizedBox(height: 3),
                            // Add space between icon and text
                            Text(
                              'Home',
                              style: TextStyle(
                                color: selectedIndex == 0
                                    ? kPrimaryColor
                                    : Colors.black,
                                // Change color based on selected index
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Search item
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        print("sssss");
                        selectedIndex = 1;
                        productProvider.disposehomeScreenData();
                        productProvider.disposePayOutScreenData();
                        productProvider.disposeUserProfileScreenData();
                        productProvider.disposeLeadScreenData();
                      });
                    },
                    child: Container(
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          children: [
                            SvgPicture.asset(
                              'assets/icons/ic_personal_card.svg',
                              semanticsLabel: 'ic_personal_card',
                              color: selectedIndex == 1
                                  ? kPrimaryColor
                                  : Colors
                                      .black, // Change color based on selected index
                            ),
                            const SizedBox(height: 3),
                            // Add space between icon and text
                            Text(
                              'Lead',
                              style: TextStyle(
                                color: selectedIndex == 1
                                    ? kPrimaryColor
                                    : Colors.black,
                                // Change color based on selected index
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 24.0),
                  // Print item
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedIndex = 2;
                        productProvider.disposehomeScreenData();
                        productProvider.disposePayOutScreenData();
                        productProvider.disposeUserProfileScreenData();
                        productProvider.disposeLeadScreenData();
                      });
                      //Utils.showBottomToast("Service Not Available");
                    },
                    child: Container(
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          children: [
                            SvgPicture.asset(
                              'assets/icons/ic_task_square.svg',
                              semanticsLabel: 'ic_task_square',
                              color: selectedIndex == 2
                                  ? kPrimaryColor
                                  : Colors
                                      .black, // Change color based on selected index
                            ),
                            const SizedBox(height: 3),
                            // Add space between icon and text
                            Text(
                              'Payout',
                              style: TextStyle(
                                color: selectedIndex == 2
                                    ? kPrimaryColor
                                    : Colors.black,
                                // Change color based on selected index
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedIndex = 3;
                        productProvider.disposehomeScreenData();
                        productProvider.disposePayOutScreenData();
                        productProvider.disposeUserProfileScreenData();
                        productProvider.disposeLeadScreenData();
                      });
                    },
                    child: Container(
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          children: [
                            SvgPicture.asset(
                              'assets/icons/ic_user_square.svg',
                              semanticsLabel: 'ic_user_squaree',
                              color: selectedIndex == 3
                                  ? kPrimaryColor
                                  : Colors
                                      .black, // Change color based on selected index
                            ),
                            const SizedBox(height: 3),
                            // Add space between icon and text
                            Text(
                              'Profile',
                              style: TextStyle(
                                color: selectedIndex == 3
                                    ? kPrimaryColor
                                    : Colors.black,
                                // Change color based on selected index
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // People item
                ],
              ),
            ),
          )),
    );
  }

  void createLeadBottom() async {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(16.0), // Adjust the padding as needed
              child: CreateLeadWidgets(),
            ),
          ),
        );
      },
    );
  }
}
