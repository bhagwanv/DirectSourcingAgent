import 'package:direct_sourcing_agent/utils/utils_class.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../providers/DataProvider.dart';
import '../../../utils/constant.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var isLoading = false;

  @override
  void initState() {
    super.initState();
    //Api Call
    //getCustomerOrderSummary(context);
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
            if (productProvider.getLeadPANData == null && isLoading) {
              Future.delayed(Duration(seconds: 1), () {
                setState(() {});
              });
              return Utils.onLoading(context, "");
            } else {
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
                            height: 20.0,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Text(
                                'Lead Overview',
                                textAlign: TextAlign.left,
                                style: GoogleFonts.urbanist(
                                  fontSize: 15,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w400,
                                )),
                          ),

                          Padding(
                            padding: const EdgeInsets.all(10.0),
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
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          child: SvgPicture.asset(
                                            'assets/images/dummy_image.svg',
                                            semanticsLabel: 'dummy_image SVG',
                                          ),
                                        ),
                                        Container(
                                          color: Colors.red,
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              Row(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                      'Total Leads ',
                                                      textAlign: TextAlign.left,
                                                      style: GoogleFonts.urbanist(
                                                        fontSize: 14,
                                                        color: whiteColor,
                                                        fontWeight: FontWeight.w400,
                                                      )),
                                                  Text(
                                                      '4205',
                                                      textAlign: TextAlign.right,
                                                      style: GoogleFonts.urbanist(
                                                        fontSize: 14,
                                                        color: whiteColor,
                                                        fontWeight: FontWeight.w400,
                                                      )),
                                                ],
                                              ),
                                              Row(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                      'Pending',
                                                      textAlign: TextAlign.start,
                                                      style: GoogleFonts.urbanist(
                                                        fontSize: 14,
                                                        color: whiteColor,
                                                        fontWeight: FontWeight.w400,
                                                      )),
                                                  const SizedBox(
                                                    width: 20.0,
                                                  ),

                                                  Text(
                                                      '400 ',
                                                      textAlign: TextAlign.start,
                                                      style: GoogleFonts.urbanist(
                                                        fontSize: 14,
                                                        color: whiteColor,
                                                        fontWeight: FontWeight.w400,
                                                      )),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Text(
                                                      'Rejected',
                                                      textAlign: TextAlign.left,
                                                      style: GoogleFonts.urbanist(
                                                        fontSize: 14,
                                                        color: whiteColor,
                                                        fontWeight: FontWeight.w400,
                                                      )),
                                                  const SizedBox(
                                                    width: 20.0,
                                                  ),

                                                  Text(
                                                      '10',
                                                      textAlign: TextAlign.left,
                                                      style: GoogleFonts.urbanist(
                                                        fontSize: 14,
                                                        color:whiteColor,
                                                        fontWeight: FontWeight.w400,
                                                      )),

                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Text(
                                                      'Submitted',
                                                      textAlign: TextAlign.left,
                                                      style: GoogleFonts.urbanist(
                                                        fontSize: 14,
                                                        color: whiteColor,
                                                        fontWeight: FontWeight.w400,
                                                      )),

                                                  const SizedBox(
                                                    width: 20.0,
                                                  ),
                                                  Text(
                                                      '10',
                                                      textAlign: TextAlign.left,
                                                      style: GoogleFonts.urbanist(
                                                        fontSize: 14,
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
                                    // Add more widgets as needed
                                  ],
                                ),
                              ),
                            ),
                          ),

                        ]),
                  ),
                ),
              );
            }
          }),
        ));
  }
}
