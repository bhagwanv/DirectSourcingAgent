import 'package:direct_sourcing_agent/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class UpdateDialog extends StatefulWidget {
  final String version;
  final String description;
  final String appLink;
  final bool allowDismissal;

  const UpdateDialog({Key? key,
    this.version = " ",
    required this.description,
    required this.appLink,
    required this.allowDismissal
  }) : super(key: key);

  @override
  State<UpdateDialog> createState() => _UpdateDialogState();
}

class _UpdateDialogState extends State<UpdateDialog> {
  double screenHeight = 0;
  double screenWidth = 0;

  @override
  void dispose() {
    SystemNavigator.pop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      curve: Curves.fastLinearToSlowEaseIn,
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: content(context),
      ),
    );
  }

  Widget content(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: screenHeight / 10,
          width: screenWidth / 1,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(20),
              topLeft: Radius.circular(20),
            ),
            color: kPrimaryColor,
          ),
          child: const Center(
            child: Icon(
              Icons.error_outline_outlined,
              color: Colors.white,
              size: 40,
            ),
          ),
        ),
        Container(
          height: screenHeight / 3,
          width: screenWidth / 1,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(20),
              bottomLeft: Radius.circular(20),
            ),
            color: Colors.white,
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              bottomRight: Radius.circular(20),
              bottomLeft: Radius.circular(20),
            ),
            child: Column(
              children: [
                Expanded(
                  flex: 3,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    child: Column(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Stack(
                            children: [
                              Align(
                                alignment: Alignment.center,
                                child: Text(
                                  "ABOUT UPDATE",
                                  style: GoogleFonts.urbanist(
                                    fontSize: 22,
                                    color: blackSmall,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                              /*Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  widget.version,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),*/
                            ],
                          ),
                        ),
                        const SizedBox(height: 12,),
                        Expanded(
                          flex: 3,
                          child: SingleChildScrollView(
                            child: Text(
                              widget.description,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.urbanist(
                              fontSize: 16,
                              color: blackSmall,
                              fontWeight: FontWeight.w500,
                            ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        widget.allowDismissal ? Expanded(
                          child: GestureDetector(
                            onTap: () {
                              SystemNavigator.pop();
                            },
                            child: Container(
                              height: 48,
                              width: 120,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: kPrimaryColor,
                                ),
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: Center(
                                child: Text(
                                  "CANCEL",
                                  style: GoogleFonts.urbanist(
                                  fontSize: 16,
                                  color: kPrimaryColor,
                                  fontWeight: FontWeight.w700,
                                ),
                                ),
                              ),
                            ),
                          ),
                        ) : const SizedBox(),
                        SizedBox(width: widget.allowDismissal ? 16 : 0,),
                        Expanded(
                          child: GestureDetector(
                            onTap: () async {
                              await launchUrl(Uri.parse(widget.appLink));
                            },
                            child: Container(
                              height: 48,
                              width: 120,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: kPrimaryColor,
                                boxShadow: const [
                                  BoxShadow(
                                    color: kPrimaryColor,
                                    blurRadius: 6,
                                    offset: Offset(2, 2),
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Text(
                                  "UPDATE",
                                  style: GoogleFonts.urbanist(
                                    fontSize: 16,
                                    color: whiteColor,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}