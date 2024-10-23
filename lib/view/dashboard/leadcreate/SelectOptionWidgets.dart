
import 'package:direct_sourcing_agent/api/ApiService.dart';
import 'package:direct_sourcing_agent/api/FailureException.dart';
import 'package:direct_sourcing_agent/providers/DataProvider.dart';
import 'package:direct_sourcing_agent/shared_preferences/shared_pref.dart';
import 'package:direct_sourcing_agent/utils/common_elevted_button.dart';
import 'package:direct_sourcing_agent/utils/common_text_field.dart';
import 'package:direct_sourcing_agent/utils/constant.dart';
import 'package:direct_sourcing_agent/utils/utils_class.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../../../utils/myWebBrowser.dart';
import '../bottom_navigation.dart';
import 'CreateLeadWidgets.dart';
import 'model/GetDSAProductListResModel.dart';

class SelectOptionWidgets extends StatefulWidget {
  @override
  State<SelectOptionWidgets> createState() => _SelectOptionWidgetsState();
}

class _SelectOptionWidgetsState extends State<SelectOptionWidgets> {
  final TextEditingController _MobileNumberController = TextEditingController();
  String? createLeadBaseUrl;
  String? companyID;
  String? productCode;
  String? UserToken;
  String? UserID;
  final browser = MyInAppBrowser();

  late DataProvider productProvider;
  GetDSAProductListResModel? getDSAProductListResModel;
  List<GetDSAProductList>? getDSAProductLisList = [];
  late String selectedDSAProductValue = "";
  late String selectedProductType = "";

  final settings = InAppBrowserClassSettings(
      browserSettings: InAppBrowserSettings(hideUrlBar: true),
      webViewSettings: InAppWebViewSettings(
          javaScriptEnabled: true,
          isInspectable: kDebugMode,
          clearCache: true));
  Map<int, bool> checkedItems = {};
  int? selectedItemIndex;

  @override
  void initState() {
    productProvider = Provider.of<DataProvider>(context, listen: false);
    getDSAProductList();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DataProvider>(builder: (context, productProvider, child) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical:10),
                    child: Center(
                      child: Text(
                        "Please Select financial product to \ncreate lead ",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.urbanist(
                          fontSize: 18,
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),


                ],
              ),
            ),
           /* DropdownButtonFormField2<GetDSAProductList>(
              isExpanded: true,
              decoration: InputDecoration(
                fillColor: light_gry,
                filled: true,
                contentPadding:
                const EdgeInsets.symmetric(
                    vertical: 5, horizontal: 5),
                border: OutlineInputBorder(
                    borderRadius:
                    BorderRadius.circular(8),
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
                'Select options',
                style: GoogleFonts.urbanist(
                  fontSize: 15,
                  color: light_black,
                  fontWeight: FontWeight.w400,
                ),
              ),
              items: _addDividersAfterItems(getDSAProductLisList!),
              onChanged:
                  (GetDSAProductList? value) async {


                setState(() {
                  selectedDSAProductValue = value!.productName!;
                  productType = value.productType!;
                  print("singh$productType");
                });


              },
              dropdownStyleData: DropdownStyleData(
                maxHeight: 400,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              menuItemStyleData: const MenuItemStyleData(
                padding: EdgeInsets.only(left: 16, right: 16, bottom: 16),
              ),
              iconStyleData: const IconStyleData(
                icon: Padding(
                  padding: EdgeInsets.only(right: 10),
                  child: Icon(Icons.keyboard_arrow_down),
                ), // Down arrow icon when closed
                openMenuIcon: Padding(
                  padding: EdgeInsets.only(right: 10),
                  child: Icon(Icons.keyboard_arrow_up),
                ), // Up arrow icon when open
              ),
            ),*/

            verticalListView(getDSAProductLisList),

            Padding(
              padding: const EdgeInsets.only(left: 30, right: 30, top: 30),
              child: Column(
                children: [
                  CommonElevatedButton(
                    onPressed: () async {

                      if(selectedProductType.isNotEmpty){
                        Navigator.pop(context);
                        createLeadBottom(selectedProductType);
                      } else {
                        Utils.showBottomToast("Please Select options");
                      }
                    },
                    text: "Next",
                    upperCase: true,
                  ),
                ],
              ),
            )
          ],
        )

      );
    });
  }

/*  List<DropdownMenuItem<GetDSAProductList>> _addDividersAfterItems(
      List<GetDSAProductList?> list) {
    final List<DropdownMenuItem<GetDSAProductList>> menuItems = [];
    for (final GetDSAProductList? item in list) {
      menuItems.addAll(
        [
          DropdownMenuItem<GetDSAProductList>(
            value: item,
            child: Text(
              item!.productName.toString(),
              // Assuming 'name' is the property to display
              style: GoogleFonts.urbanist(
                fontSize: 15,
                color: blackSmall,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          // If it's not the last item, add Divider after it.
          *//*if (item != list.last)
            const DropdownMenuItem<DsaSalesAgentList>(
              enabled: false,
              child: Divider(
                height: 0.1,
              ),
            ),*//*
        ],
      );
    }
    return menuItems;
  }*/


  Widget verticalListView(List<GetDSAProductList>? getDSAProductLisList) {
    return Container(
      height: 180,
      child: ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        itemCount: getDSAProductLisList!.length,
        itemBuilder: (context, index) {
          GetDSAProductList item = getDSAProductLisList![index];

          return GestureDetector(
            onTap: () {
              setState(() {
                selectedItemIndex = index; // Set the selected index
                selectedProductType = item.productType!; // Store the selected product type
              });
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
              child: Material(
                elevation: 2, // Add elevation to create a shadow effect
                borderRadius: BorderRadius.circular(5), // Ensure the border radius is applied to the material
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: selectedItemIndex == index ? Colors.blue[100] : Colors.white, // Highlight if selected
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${item.productName}",
                                style: GoogleFonts.urbanist(
                                  fontSize: 16,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w400,
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
            ),
          );
        },
      ),
    );;
  }



  void createLeadBottom(String productType) async {
    PermissionStatus cameraPermissionStatus = await Permission.camera.status;
    PermissionStatus microphonePermissionStatus = await Permission.microphone.status;
    if (cameraPermissionStatus.isGranted && microphonePermissionStatus.isGranted) {
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
                child: CreateLeadWidgets(productType: productType,),
              ),
            ),
          );
        },
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return const ForceFullyAskPermissionDialog(
            allowDismissal: true,
            description: "Please grant camera permission to continue. This is needed to capture documents and photos securely within the app.",);
        },
      );
    }
  }



  Future<void> getDSAProductList() async {

    final prefsUtil = await SharedPref.getInstance();
    String? userId = prefsUtil.getString(USER_ID);
    Utils.onLoading(context, "");
    await Provider.of<DataProvider>(context, listen: false).getDSAProductList(userId!);
    Navigator.of(context, rootNavigator: true).pop();

    if (productProvider.getDSAProductListData != null) {
      productProvider.getDSAProductListData!.when(
        success: (model) {
        if(model.isSuccess!){
          if(model.result!=null){
            getDSAProductLisList=model.result!;
          }

        }else{
          Navigator.pop(context);
          if(model.message!=null){
            Utils.showToast(model.message.toString(), context);
          }
        }

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
  }
}
