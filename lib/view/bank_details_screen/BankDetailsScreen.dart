import 'dart:io';

import 'package:direct_sourcing_agent/utils/loader.dart';
import 'package:direct_sourcing_agent/utils/utils_class.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../api/ApiService.dart';
import '../../api/FailureException.dart';
import '../../providers/DataProvider.dart';
import '../../shared_preferences/shared_pref.dart';
import '../../utils/common_elevted_button.dart';
import '../../utils/common_text_field.dart';
import '../../utils/constant.dart';
import '../../utils/customer_sequence_logic.dart';
import '../splash/model/GetLeadResponseModel.dart';
import '../splash/model/LeadCurrentRequestModel.dart';
import '../splash/model/LeadCurrentResponseModel.dart';
import 'model/BankDetailsResponceModel.dart';
import 'model/LiveBankList.dart';
import 'model/SaveBankDetailsRequestModel.dart';

class BankDetailsScreen extends StatefulWidget {
  final int activityId;
  final int subActivityId;

  BankDetailsScreen({
    super.key,
    required this.activityId,
    required this.subActivityId,
  });

  @override
  State<BankDetailsScreen> createState() => _BankDetailsScreenState();
}

class _BankDetailsScreenState extends State<BankDetailsScreen> {
  final TextEditingController _accountHolderController =
      TextEditingController();
  final TextEditingController _bankStatmentPassworedController =
      TextEditingController();
  final TextEditingController _bankNameController = TextEditingController();
  final TextEditingController _bankAccountNumberCl = TextEditingController();
  final TextEditingController _accountTypeCl = TextEditingController();
  final TextEditingController _ifsccodeCl = TextEditingController();

  // var personalDetailsData;
  var isLoading = true;
  List<LiveBankList?>? liveBankList = [];
  late String selectedAccountTypeValue = "";
  String? selectedBankValue;
  BankDetailsResponceModel? bankDetailsResponceModel = null;
  List<String?>? documentList = [];
  var isEditableStatement = false;

  @override
  void initState() {
    super.initState();
    callAPI(context);
  }

  List<String> accountTypeList = ['saving', 'current', 'other'];

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
                fontSize: 14,
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
      if (i.isOdd) {
        itemsHeights.add(4);
      }
    }
    return itemsHeights;
  }

  List<double> _getCustomItemsHeights1(List<LiveBankList?> items) {
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

  List<DropdownMenuItem<LiveBankList>> _addDividersAfterItems1(
      List<LiveBankList?> items) {
    final List<DropdownMenuItem<LiveBankList>> menuItems = [];
    for (final LiveBankList? item in items) {
      menuItems.addAll(
        [
          DropdownMenuItem<LiveBankList>(
            value: item,
            child: Text(
              item!.bankName!, // Assuming 'name' is the property to display
              style: const TextStyle(
                fontSize: 14,
              ),
            ),
          ),
          // If it's not the last item, add Divider after it.
          if (item != items.last)
            const DropdownMenuItem<LiveBankList>(
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        top: true,
        bottom: true,
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Consumer<DataProvider>(builder: (context, productProvider, child) {
            if (productProvider.getBankDetailsData == null && isLoading) {
              return const Loader();
            } else {
              if (productProvider.getBankDetailsData != null && isLoading) {
                Navigator.of(context, rootNavigator: true).pop();
                isLoading = false;
              }

              if (productProvider.getBankDetailsData != null) {
                productProvider.getBankDetailsData!.when(
                  success: (BankDetailsResponceModel) async {
                    bankDetailsResponceModel = BankDetailsResponceModel;

                    if (bankDetailsResponceModel != null) {
                      if (bankDetailsResponceModel!.result != null) {

                        if(bankDetailsResponceModel!.result!.leadBankDetailDTOs!=null) {
                          if (bankDetailsResponceModel!.isSuccess!) {
                            _accountHolderController.text =
                            bankDetailsResponceModel!.result!
                                .leadBankDetailDTOs!.first.accountHolderName!;
                            if (bankDetailsResponceModel!.result!
                                .leadBankDetailDTOs!.first.accountNumber !=
                                null) {
                              _bankAccountNumberCl.text =
                              bankDetailsResponceModel!.result!
                                  .leadBankDetailDTOs!.first.accountNumber!;
                            }
                            _ifsccodeCl.text = bankDetailsResponceModel!
                                .result!.leadBankDetailDTOs!.first.ifscCode!;
                            _bankNameController.text = bankDetailsResponceModel!
                                .result!.leadBankDetailDTOs!.first.bankName!;
                            _accountTypeCl.text = bankDetailsResponceModel!
                                .result!.leadBankDetailDTOs!.first.accountType!;
                            _bankStatmentPassworedController.text =
                            bankDetailsResponceModel!.result!.leadBankDetailDTOs!.first.pdfPassword!;
                            if (!isEditableStatement) {
                              for (int i = 0;
                              i <
                                  bankDetailsResponceModel!
                                      .result!.bankDocs!.length;
                              i++) {
                                print("bankDocsDAta " + i.toString());
                                documentList!.add(bankDetailsResponceModel!
                                    .result!.bankDocs![i].fileURL);
                              }
                              isEditableStatement = true;
                            }
                          } else {
                            Utils.showToast(
                                bankDetailsResponceModel!.message!, context);
                          }
                        }
                      }
                    }
                  },
                  failure: (exception) {
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

              if (productProvider.getBankListData != null) {
                if (productProvider.getBankListData!.liveBankList != null) {
                  liveBankList = productProvider.getBankListData!.liveBankList!;
                }
              }
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30.0, vertical: 0.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 25,
                      ),
                      Center(
                        child: Text(
                          "Bank Details",
                          style: GoogleFonts.urbanist(
                            fontSize: 14,
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 30.0,
                      ),
                      bankListWidget(productProvider),
                      const SizedBox(
                        height: 16.0,
                      ),
                      CommonTextField(
                        controller: _accountHolderController,
                        hintText: "Account Holder Name ",
                        labelText: "Account Holder Name ",
                      ),
                      const SizedBox(
                        height: 16.0,
                      ),
                      CommonTextField(
                        inputFormatter: [
                          FilteringTextInputFormatter.allow(
                              RegExp((r'[0-9]'))),
                          LengthLimitingTextInputFormatter(17)
                        ],
                        enableinteractiveSelection:false,
                        keyboardType: TextInputType.number,
                        controller: _bankAccountNumberCl,
                        maxLines: 1,
                        hintText: "Bank Acc Number ",
                        labelText: "Bank Acc Number ",
                      ),
                      const SizedBox(
                        height: 16.0,
                      ),
                      accountTypeWidget(productProvider),
                      const SizedBox(
                        height: 16.0,
                      ),
                      CommonTextField(
                        inputFormatter: [
                          FilteringTextInputFormatter.allow(
                              RegExp((r'[A-Z0-9]'))),
                          LengthLimitingTextInputFormatter(11)
                        ],
                        controller: _ifsccodeCl,
                        hintText: "IFSC Code",
                        labelText: "IFSC Code",
                        textCapitalization: TextCapitalization.characters,
                          onChanged: (value) {

                          }),
                      const SizedBox(
                        height: 16.0,
                      ),
                      CommonTextField(
                        controller: _bankStatmentPassworedController,
                        hintText: "Bank Statement password(optional)",
                        labelText: "Bank Statement password(optional)",
                      ),
                      const SizedBox(
                        height: 16.0,
                      ),
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: const Color(0xff0196CE))),
                        width: double.infinity,
                        child: GestureDetector(
                          onTap: () async {
                            isEditableStatement = true;
                            FilePickerResult? result = await FilePicker.platform
                                .pickFiles(
                                    type: FileType.custom,
                                    allowedExtensions: ['pdf']);
                            if (result != null) {
                              File file = File(result.files.single.path!);
                              print(file.path);
                              //widget.onImageSelected(file);
                              Utils.onLoading(context, "");
                              await Provider.of<DataProvider>(context,
                                      listen: false)
                                  .postBusineesDoumentSingleFile(
                                      file, true, "", "");
                              if (productProvider.getpostBusineesDoumentSingleFileData != null) {
                                documentList!.add(productProvider.getpostBusineesDoumentSingleFileData!.filePath);
                              }
                              setState(() {
                                Navigator.pop(context);
                              });
                            } else {
                              // User canceled the picker
                            }
                          },
                          child: Container(
                            height: 148,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: const Color(0xffEFFAFF),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset('assets/images/gallery.svg'),
                                 Text(
                                  'Upload Bank Proof',
                                  style: GoogleFonts.urbanist(
                                    fontSize: 12,
                                    color: kPrimaryColor,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                Text('Supports : PDF',
                                  style: GoogleFonts.urbanist(
                                    fontSize: 12,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w400,
                                  ),),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 16.0,
                      ),
                      documentList!.isNotEmpty
                          ? Column(
                              children:
                                  documentList!.asMap().entries.map((entry) {
                                final index = entry.key;
                                final document = entry.value;
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8.0),
                                      color: Colors.grey[200],
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text("${index + 1}"),
                                          Spacer(),
                                          Icon(Icons.picture_as_pdf),
                                          Spacer(),
                                          InkWell(
                                            onTap: () {
                                              setState(() {
                                                isEditableStatement = true;
                                                documentList!.removeAt(index);
                                              });
                                            },
                                            child: SvgPicture.asset(
                                                'assets/icons/delete_icon.svg'),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            )
                          : Container(),
                      const SizedBox(
                        height: 30.0,
                      ),
                      CommonElevatedButton(
                        onPressed: () async {
                          await submitBankDetailsApi(
                              context, productProvider, documentList!);

                          /* Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return const AgreementScreen();
                              },
                            ),
                          );*/
                        },
                        text: 'Next',
                        upperCase: true,
                      ),
                      const SizedBox(
                        height: 30.0,
                      ),
                    ],
                  ),
                ),
              );
            }
          }),
        ));
  }

  Future<void> callAPI(BuildContext context) async {
    final prefsUtil = await SharedPref.getInstance();
    final int? leadId = prefsUtil.getInt(LEADE_ID);
    final String? productCode = prefsUtil.getString(PRODUCT_CODE);
    Provider.of<DataProvider>(context, listen: false)
        .getBankDetails(leadId!, productCode!);
    //Utils.onLoading(context, "");
    await Provider.of<DataProvider>(context, listen: false).getBankList();
    //Navigator.of(context, rootNavigator: true).pop();
  }

  Widget bankListWidget(DataProvider productProvider) {
    var initialData = null;
    if (bankDetailsResponceModel != null) {
      if (bankDetailsResponceModel!.result != null) {
        if (bankDetailsResponceModel!.result!.leadBankDetailDTOs != null) {
          if (bankDetailsResponceModel!.result!.leadBankDetailDTOs!.first.bankName != null) {

            var data = liveBankList!.where((element) => element?.bankName == bankDetailsResponceModel!.result!.leadBankDetailDTOs!.first.bankName!).toList();
            if (data.isNotEmpty) {
              selectedBankValue = data.first!.bankName!.toString();
              initialData = data.first;
            }
          } else {
            initialData = null;
          }
        } else {
          initialData = null;
        }
      }

      return DropdownButtonFormField2<LiveBankList>(
        value: initialData,
        isExpanded: true,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(vertical: 16),
          fillColor: textFiledBackgroundColour,
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: kPrimaryColor, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: kPrimaryColor, width: 1),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: kPrimaryColor, width: 1),
          ),
        ),
        hint: Text(
          'Bank Name',
          style: GoogleFonts.urbanist(
            fontSize: 14,
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
        items: _addDividersAfterItems1(liveBankList!),
        onChanged: (LiveBankList? value) {
          selectedBankValue = value!.bankName!;
        },
        buttonStyleData: const ButtonStyleData(
          padding: EdgeInsets.only(right: 8),
        ),
        dropdownStyleData: const DropdownStyleData(
          maxHeight: 200,
        ),
        menuItemStyleData: MenuItemStyleData(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          customHeights: _getCustomItemsHeights1(liveBankList!),
        ),
        iconStyleData: const IconStyleData(
          openMenuIcon: Icon(Icons.arrow_drop_up),
        ),
      );
    } else {
      return DropdownButtonFormField2<LiveBankList>(
        isExpanded: true,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(vertical: 16),
          fillColor: textFiledBackgroundColour,
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: kPrimaryColor, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: kPrimaryColor, width: 1),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: kPrimaryColor, width: 1),
          ),
        ),
        hint: Text(
          'Bank Name',
          style: GoogleFonts.urbanist(
            fontSize: 14,
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
        items: _addDividersAfterItems1(liveBankList!),
        onChanged: (LiveBankList? value) {
          selectedBankValue = value!.bankName!;
        },
        buttonStyleData: const ButtonStyleData(
          padding: EdgeInsets.only(right: 8),
        ),
        dropdownStyleData: const DropdownStyleData(
          maxHeight: 200,
        ),
        menuItemStyleData: MenuItemStyleData(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          customHeights: _getCustomItemsHeights1(liveBankList!),
        ),
        iconStyleData: const IconStyleData(
          openMenuIcon: Icon(Icons.arrow_drop_up),
        ),
      );
    }
  }

  Widget accountTypeWidget(DataProvider productProvider) {
    if (bankDetailsResponceModel != null) {
      if (bankDetailsResponceModel!.result != null) {
        if (bankDetailsResponceModel!.result!.leadBankDetailDTOs != null) {
          if (bankDetailsResponceModel!
                  .result!.leadBankDetailDTOs!.first.accountType !=
              null) {
            List<String> initialData = accountTypeList
                .where((element) => element.contains(bankDetailsResponceModel!
                        .result?.leadBankDetailDTOs!.first.accountType ??
                    ''))
                .toList();
            if (initialData.isNotEmpty) {
              selectedAccountTypeValue = initialData.first;
            }

            return DropdownButtonFormField2<String>(
              value: initialData.isNotEmpty ? initialData.first : null,
              isExpanded: true,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(vertical: 16),
                fillColor: textFiledBackgroundColour,
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: kPrimaryColor, width: 1),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: kPrimaryColor, width: 1),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: kPrimaryColor, width: 1),
                ),
              ),
              hint: const Text(
                'Account Type',
                style: TextStyle(
                  color: blueColor,
                  fontSize: 14.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
              items: _addDividersAfterItems(accountTypeList),
              onChanged: (String? value) {
                selectedAccountTypeValue = value!;
              },
              buttonStyleData: const ButtonStyleData(
                padding: EdgeInsets.only(right: 8),
              ),
              dropdownStyleData: const DropdownStyleData(
                maxHeight: 200,
              ),
              menuItemStyleData: MenuItemStyleData(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                customHeights: _getCustomItemsHeights(accountTypeList),
              ),
              iconStyleData: const IconStyleData(
                openMenuIcon: Icon(Icons.arrow_drop_up),
              ),
            );
          } else {
            return DropdownButtonFormField2<String>(
              isExpanded: true,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(vertical: 16),
                fillColor: textFiledBackgroundColour,
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: kPrimaryColor, width: 1),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: kPrimaryColor, width: 1),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: kPrimaryColor, width: 1),
                ),
              ),
              hint: Text(
                'Account Type',
                style: GoogleFonts.urbanist(
                  fontSize: 14,
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
              items: _addDividersAfterItems(accountTypeList),
              onChanged: (String? value) {
                selectedAccountTypeValue = value!;
              },
              buttonStyleData: const ButtonStyleData(
                padding: EdgeInsets.only(right: 8),
              ),
              dropdownStyleData: const DropdownStyleData(
                maxHeight: 200,
              ),
              menuItemStyleData: MenuItemStyleData(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                customHeights: _getCustomItemsHeights(accountTypeList),
              ),
              iconStyleData: const IconStyleData(
                openMenuIcon: Icon(Icons.arrow_drop_up),
              ),
            );
          }
        } else {
          return DropdownButtonFormField2<String>(
            isExpanded: true,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(vertical: 16),
              fillColor: textFiledBackgroundColour,
              filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: kPrimaryColor, width: 1),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: kPrimaryColor, width: 1),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: kPrimaryColor, width: 1),
              ),
            ),
            hint: Text(
              'Account Type',
              style: GoogleFonts.urbanist(
                fontSize: 14,
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
            items: _addDividersAfterItems(accountTypeList),
            onChanged: (String? value) {
              selectedAccountTypeValue = value!;
            },
            buttonStyleData: const ButtonStyleData(
              padding: EdgeInsets.only(right: 8),
            ),
            dropdownStyleData: const DropdownStyleData(
              maxHeight: 200,
            ),
            menuItemStyleData: MenuItemStyleData(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              customHeights: _getCustomItemsHeights(accountTypeList),
            ),
            iconStyleData: const IconStyleData(
              openMenuIcon: Icon(Icons.arrow_drop_up),
            ),
          );
        }
      } else {
        return DropdownButtonFormField2<String>(
          isExpanded: true,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(vertical: 16),
            fillColor: textFiledBackgroundColour,
            filled: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: kPrimaryColor, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: kPrimaryColor, width: 1),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: kPrimaryColor, width: 1),
            ),
          ),
          hint: const Text(
            'Account Type',
            style: TextStyle(
              color: blueColor,
              fontSize: 14.0,
              fontWeight: FontWeight.w500,
            ),
          ),
          items: _addDividersAfterItems(accountTypeList),
          onChanged: (String? value) {
            selectedAccountTypeValue = value!;
          },
          buttonStyleData: const ButtonStyleData(
            padding: EdgeInsets.only(right: 8),
          ),
          dropdownStyleData: const DropdownStyleData(
            maxHeight: 200,
          ),
          menuItemStyleData: MenuItemStyleData(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            customHeights: _getCustomItemsHeights(accountTypeList),
          ),
          iconStyleData: const IconStyleData(
            openMenuIcon: Icon(Icons.arrow_drop_up),
          ),
        );
      }
    } else {
      return DropdownButtonFormField2<String>(
        isExpanded: true,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(vertical: 16),
          fillColor: textFiledBackgroundColour,
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: kPrimaryColor, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: kPrimaryColor, width: 1),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: kPrimaryColor, width: 1),
          ),
        ),
        hint: const Text(
          'Account Type',
          style: TextStyle(
            color: blueColor,
            fontSize: 14.0,
            fontWeight: FontWeight.w500,
          ),
        ),
        items: _addDividersAfterItems(accountTypeList),
        onChanged: (String? value) {
          selectedAccountTypeValue = value!;
        },
        buttonStyleData: const ButtonStyleData(
          padding: EdgeInsets.only(right: 8),
        ),
        dropdownStyleData: const DropdownStyleData(
          maxHeight: 200,
        ),
        menuItemStyleData: MenuItemStyleData(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          customHeights: _getCustomItemsHeights(accountTypeList),
        ),
        iconStyleData: const IconStyleData(
          openMenuIcon: Icon(Icons.arrow_drop_up),
        ),
      );
    }
  }

  Future<void> submitBankDetailsApi(BuildContext contextz,
      DataProvider productProvider, List<String?> docList) async {
    if (selectedBankValue == null) {
      Utils.showToast("Please Select Bank", context);
    } else if (selectedBankValue!.isEmpty) {
      Utils.showToast("Please Select Bank", context);
    } else if (_accountHolderController.text.trim().isEmpty) {
      Utils.showToast("Please Enter Account Holder Name", context);
    } else if (_bankAccountNumberCl.text.trim().isEmpty) {
      Utils.showToast("Please Enter Account Number", context);
    } else if (selectedAccountTypeValue.isEmpty) {
      Utils.showToast("Please Select account Type", context);
    } else if (_ifsccodeCl.text.trim().isEmpty) {
      Utils.showToast("Please Enter IFSC code", context);
    } else if (!Utils.isValidIFSCode(_ifsccodeCl.text)) {
      Utils.showToast("IFSC code should be Proper format", context);
    } else if(documentList!.isEmpty){
      Utils.showToast("Please upload Bank Statement", context);
    }else {
      final prefsUtil = await SharedPref.getInstance();
      final int? leadID = prefsUtil.getInt(LEADE_ID);

      List<LeadBankDetailDTOs> leadBankDetailsList = [];
      List<BankDocs> bankDocList = [];

      leadBankDetailsList.add(
        LeadBankDetailDTOs(
          leadId: leadID!,
          Type: "borrower",
          bankName: selectedBankValue,
          ifscCode: _ifsccodeCl.text,
          accountType: selectedAccountTypeValue,
          activityId: widget.activityId,
          subActivityId: widget.subActivityId,
          accountNumber: _bankAccountNumberCl.text,
          accountHolderName: _accountHolderController.text,
          pdfPassword: _bankStatmentPassworedController.text.trim(),
          surrogateType: "Banking",
        ),
      );

      for (int i = 0; i < docList.length; i++) {
        bankDocList.add(BankDocs(
            documentType: "id_proof",
            documentName: "bank_statement",
            fileURL: docList[i],
            sequence: i,
            pdfPassword: _bankStatmentPassworedController.text,
            documentNumber: _bankAccountNumberCl.text));
      }

      var postData = SaveBankDetailsRequestModel(
          leadBankDetailDTOs: leadBankDetailsList,
          isScaleUp: true,
          bankDocs: bankDocList);

      print("Save Data" + postData.toJson().toString());
      Utils.onLoading(context, "");
      await Provider.of<DataProvider>(context, listen: false)
          .saveLeadBankDetail(postData);
      Navigator.of(context, rootNavigator: true).pop();

      if (productProvider.getSaveLeadBankDetailData != null) {
        productProvider.getSaveLeadBankDetailData!.when(
          success: (SaveBankDetailResponce) async {
            // Handle successful response
            var saveBankDetailResponce = SaveBankDetailResponce;
            if (saveBankDetailResponce.isSuccess!) {
              fetchData(context);
            } else {
              Utils.showToast(saveBankDetailResponce.message!, context);
            }
          },
          failure: (exception) {
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

  Future<void> fetchData(BuildContext context) async {
    final prefsUtil = await SharedPref.getInstance();
    try {
      LeadCurrentResponseModel? leadCurrentActivityAsyncData;
      var leadCurrentRequestModel = LeadCurrentRequestModel(
        companyId: prefsUtil.getInt(COMPANY_ID),
        productId: prefsUtil.getInt(PRODUCT_ID),
        leadId: prefsUtil.getInt(LEADE_ID),
        userId: prefsUtil.getString(USER_ID),
        mobileNo: prefsUtil.getString(LOGIN_MOBILE_NUMBER),
        activityId: widget.activityId,
        subActivityId: widget.subActivityId,
        monthlyAvgBuying: 0,
        vintageDays: 0,
        isEditable: true,
      );
      leadCurrentActivityAsyncData = await ApiService()
              .leadCurrentActivityAsync(leadCurrentRequestModel, context)
          as LeadCurrentResponseModel?;

      GetLeadResponseModel? getLeadData;
      getLeadData = await ApiService().getLeads(
          prefsUtil.getString(LOGIN_MOBILE_NUMBER)!,
          prefsUtil.getInt(COMPANY_ID)!,
          prefsUtil.getInt(PRODUCT_ID)!,
          prefsUtil.getInt(LEADE_ID)!) as GetLeadResponseModel?;

      customerSequence(
          context, getLeadData, leadCurrentActivityAsyncData, "push");
    } catch (error) {
      if (kDebugMode) {
        print('Error occurred during API call: $error');
      }
    }
  }
}
