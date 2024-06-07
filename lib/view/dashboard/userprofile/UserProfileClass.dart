import 'package:direct_sourcing_agent/providers/DataProvider.dart';
import 'package:direct_sourcing_agent/shared_preferences/shared_pref.dart';
import 'package:direct_sourcing_agent/utils/common_elevted_button.dart';
import 'package:direct_sourcing_agent/utils/common_text_field.dart';
import 'package:direct_sourcing_agent/utils/constant.dart';
import 'package:direct_sourcing_agent/view/dashboard/userprofile/CreateUserWidgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class UserProfileClass extends StatefulWidget {
  final int activityId;
  final int subActivityId;

  UserProfileClass({
    super.key,
    required this.activityId,
    required this.subActivityId,
  });

  @override
  State<UserProfileClass> createState() => _UserProfileScreenState();

}
class _UserProfileScreenState extends State<UserProfileClass> {
  final TextEditingController _MobileNoController = TextEditingController();
  final TextEditingController _PanCardNoController = TextEditingController();
  final TextEditingController _AdharcardNOController = TextEditingController();
  final TextEditingController _AddreshController = TextEditingController();
  final TextEditingController _PayOutController = TextEditingController();
  final TextEditingController _WorkingLocationController = TextEditingController();
   String? role;
   String? type;

  @override
  void initState() {
    super.initState();

    getUserData();
  }

  @override
  Widget build(BuildContext context) {

    return SafeArea(
       top: true,
       bottom: true,
       child: Scaffold(
         backgroundColor: Colors.white,
         body:SingleChildScrollView(child: Padding(
           padding:
           const EdgeInsets.symmetric(horizontal: 30.0, vertical: 0.0),
           child: SingleChildScrollView(
             child: Column(
               crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                 SizedBox(
                   height: 35,
                 ),
                 Row(
                   children: [
                     Spacer(),
                     SizedBox(
                       width: 50,
                     ),
                     Center(
                       child: Text(
                         "Profile",
                         style: GoogleFonts.urbanist(
                           fontSize: 20,
                           color: Colors.black,
                           fontWeight: FontWeight.w600,
                         ),
                       ),
                     ),
                     Spacer(),
                     role=="DSA"?type=="DSA"?
                     Container(
                       width: 100,
                       height: 40,
                       child:  CommonElevatedButton(
                         onPressed: () async {
                           showModalBottomSheet(
                               context: context,
                               builder: (builder) {
                                 return Container(child: CreateUserWidgets());
                               });
                         },
                         text: "Create",
                         upperCase: true,
                       ),
                     ):Container():Container()

                   ],
                 ),
                 SizedBox(
                   height: 25,
                 ),
                 Row(
                   children: [
                     Container(
                       width: 90,
                       height: 90,
                       decoration: BoxDecoration(
                         shape: BoxShape.rectangle,
                         borderRadius: BorderRadius.circular(10),

                         image: DecorationImage(
                             //image: NetworkImage(widget.imageUrl),
                             image: NetworkImage("https://csg10037ffe956af864.blob.core.windows.net/scaleupfiles/d1e100eb-626f-4e19-b611-e87694de6467.jpg"),
                             fit: BoxFit.fill),
                       ),
                     ),
                     Column(
                       crossAxisAlignment: CrossAxisAlignment.start,
                       children: [
                         Padding(
                           padding: const EdgeInsets.only(left: 10),
                           child: Text(
                             "Deepak Yadav",
                             style: GoogleFonts.urbanist(
                               fontSize: 20,
                               color: Colors.black,
                               fontWeight: FontWeight.w500,
                             ),
                           ),
                         )
                       ],
                     )
                   ],
                 ),

                 SizedBox(
                   height: 25,
                 ),
                 CommonTextField(
                   controller: _MobileNoController,
                   inputFormatter: [
                     FilteringTextInputFormatter.allow(
                         RegExp((r'[A-Z0-9]'))),
                     LengthLimitingTextInputFormatter(10)
                   ],
                   keyboardType: TextInputType.number,
                   hintText: "Mobile Number",
                   labelText: "Mobile Number",
                 ),

                 SizedBox(
                   height: 16.0,
                 ),
                 CommonTextField(
                   controller: _PanCardNoController,
                   hintText: "PAN number",
                   labelText: "PAN number ",
                   textCapitalization: TextCapitalization.characters,
                   inputFormatter: [FilteringTextInputFormatter.allow(RegExp((r'[A-Z0-9]'))),
                     LengthLimitingTextInputFormatter(10)],
                 ),
                 SizedBox(
                   height: 16.0,
                 ),
                 CommonTextField(
                   inputFormatter: [
                     LengthLimitingTextInputFormatter(17),
                     // Limit to 10 characters
                   ],
                   keyboardType: TextInputType.number,
                   controller: _AdharcardNOController,
                   maxLines: 1,
                   hintText: "Aadhaar ",
                   labelText: "Aadhaar",
                 ),
                 SizedBox(
                   height: 16.0,
                 ),
                 CommonTextField(
                   controller: _AddreshController,
                   hintText: "Address",
                   labelText: "Address",
                   textCapitalization: TextCapitalization.characters,
                 ),
                 SizedBox(
                   height: 16.0,
                 ),
                 CommonTextField(
                   controller: _PayOutController,
                   hintText: "Payout %",
                   labelText: "Payout %",
                 ),

                 SizedBox(
                   height: 16.0,
                 ),
                 CommonTextField(
                   controller: _WorkingLocationController,
                   hintText: "Working Location",
                   labelText: "Working Location",
                 ),

                 SizedBox(
                   height: 30.0,
                 ),

                 SizedBox(
                   height: 30.0,
                 ),

                 Container(
                   width: 300,
                   child: ElevatedButton.icon(
                     onPressed: () {

                     },
                     icon: Icon(Icons.thumb_up, size: 24),
                     label: Text('Download Agreement',style: GoogleFonts.urbanist(
                       fontSize: 14,
                       color: Colors.white,
                       fontWeight: FontWeight.w500,
                     ),),
                     style: ElevatedButton.styleFrom(
                       foregroundColor: Colors.white, backgroundColor: kPrimaryColor, // text color
                       padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                       shape: RoundedRectangleBorder(
                         borderRadius: BorderRadius.circular(10),
                       ),
                     ),
                   ),
                 ),

                 SizedBox(
                   height: 30.0,
                 ),
               ],
             ),
           ),
         ),)
       ));
  }

  Future<void>  getUserData()async {
    final prefsUtil = await SharedPref.getInstance();
    role = prefsUtil.getString(ROLE);
    type = prefsUtil.getString(TYPE);

  }


}