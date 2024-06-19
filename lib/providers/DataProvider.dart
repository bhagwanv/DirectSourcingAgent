import 'dart:io';

import 'package:direct_sourcing_agent/inprogress/model/InProgressScreenModel.dart';
import 'package:direct_sourcing_agent/view/connector/model/CommanResponceModel.dart';
import 'package:direct_sourcing_agent/view/connector/model/ConnectorInfoReqModel.dart';
import 'package:direct_sourcing_agent/view/connector/model/ConnectorInfoResponce.dart';
import 'package:direct_sourcing_agent/utils/utils_class.dart';
import 'package:direct_sourcing_agent/view/dashboard/leadcreate/model/LeadCreatePermissionModel.dart';
import 'package:direct_sourcing_agent/view/dashboard/userprofile/model/CreateDSAUserReqModel.dart';
import 'package:direct_sourcing_agent/view/dashboard/userprofile/model/CreateUserModel.dart';
import 'package:direct_sourcing_agent/view/profile_type/model/ChooseUserTypeRequestModel.dart';
import 'package:direct_sourcing_agent/view/profile_type/model/ChooseUserTypeResponceModel.dart';
import 'package:direct_sourcing_agent/view/profile_type/model/DSAPersonalInfoModel.dart';
import 'package:flutter/cupertino.dart';

import '../ProductCompanyDetailResponseModel.dart';
import '../api/ApiService.dart';
import '../api/ExceptionHandling.dart';
import '../view/aadhaar_screen/models/AadhaaGenerateOTPRequestModel.dart';
import '../view/aadhaar_screen/models/AadhaarGenerateOTPResponseModel.dart';
import '../view/aadhaar_screen/models/LeadAadhaarResponse.dart';
import '../view/aadhaar_screen/models/ValidateAadhaarOTPRequestModel.dart';
import '../view/aadhaar_screen/models/ValidateAadhaarOTPResponseModel.dart';
import '../view/agreement_screen/model/CheckESignResponseModel.dart';
import '../view/agreement_screen/model/GetAgreementResModel.dart';
import '../view/bank_details_screen/model/BankDetailsResponceModel.dart';
import '../view/bank_details_screen/model/BankListResponceModel.dart';
import '../view/bank_details_screen/model/SaveBankDetailResponce.dart';
import '../view/bank_details_screen/model/SaveBankDetailsRequestModel.dart';
import '../view/dashboard/Lead_screen/model/DSADashboardLeadListReqModel.dart';
import '../view/dashboard/Lead_screen/model/DSADashboardLeadListResModel.dart';
import '../view/dashboard/home/DSASalesAgentListResModel.dart';
import '../view/dashboard/home/GetDSADashboardDetailsReqModel.dart';
import '../view/dashboard/home/GetDSADashboardDetailsResModel.dart';
import '../view/dashboard/payout_screen/model/GetDSADashboardPayoutListReqModel.dart';
import '../view/dashboard/payout_screen/model/GetDSADashboardPayoutListResModel.dart';
import '../view/dsa_company/model/CustomerDetailUsingGSTResponseModel.dart';
import '../view/dsa_company/model/GetDsaPersonalDetailResModel.dart';
import '../view/dsa_company/model/PostLeadDSAPersonalDetailReqModel.dart';
import '../view/dsa_company/model/PostLeadDsaPersonalDetailResModel.dart';
import '../view/login_screen/model/GenrateOptResponceModel.dart';
import '../view/otp_screens/model/GetUserProfileRequest.dart';
import '../view/otp_screens/model/GetUserProfileResponse.dart';
import '../view/otp_screens/model/LeadMobileNoResModel.dart';
import '../view/otp_screens/model/VarifayOtpRequest.dart';
import '../view/otp_screens/model/VerifyOtpResponse.dart';
import '../view/pancard_screen/model/FathersNameByValidPanCardResponseModel.dart';
import '../view/pancard_screen/model/LeadPanResponseModel.dart';
import '../view/pancard_screen/model/PostLeadPANRequestModel.dart';
import '../view/pancard_screen/model/PostLeadPANResponseModel.dart';
import '../view/pancard_screen/model/PostSingleFileResponseModel.dart';
import '../view/pancard_screen/model/ValidPanCardResponsModel.dart';
import '../view/personal_info/model/AllStateResponce.dart';
import '../view/personal_info/model/CityResponce.dart';
import '../view/personal_info/model/ElectricityAuthenticationReqModel.dart';
import '../view/personal_info/model/ElectricityAuthenticationResModel.dart';
import '../view/personal_info/model/ElectricityServiceProviderListResModel.dart';
import '../view/personal_info/model/ElectricityStateResModel.dart';
import '../view/personal_info/model/EmailExistRespoce.dart';
import '../view/personal_info/model/IvrsResModel.dart';
import '../view/personal_info/model/OTPValidateForEmailRequest.dart';
import '../view/personal_info/model/PersonalDetailsRequestModel.dart';
import '../view/personal_info/model/PersonalDetailsResponce.dart';
import '../view/personal_info/model/PostPersonalDetailsResponseModel.dart';
import '../view/personal_info/model/SendOtpOnEmailResponce.dart';
import '../view/personal_info/model/ValidEmResponce.dart';
import '../view/splash/model/GetLeadResponseModel.dart';
import '../view/splash/model/LeadCurrentRequestModel.dart';
import '../view/splash/model/LeadCurrentResponseModel.dart';
import '../view/take_selfi/model/LeadSelfieResponseModel.dart';
import '../view/take_selfi/model/PostLeadSelfieRequestModel.dart';
import '../view/take_selfi/model/PostLeadSelfieResponseModel.dart';


class DataProvider extends ChangeNotifier {
  final ApiService apiService = ApiService();
  bool _isLoading = false;

  GetLeadResponseModel? _getLeadData;

  GetLeadResponseModel? get getLeadData => _getLeadData;

  ProductCompanyDetailResponseModel? _ProductCompanyDetailResponseModel;

  ProductCompanyDetailResponseModel? get productCompanyDetailResponseModel => _ProductCompanyDetailResponseModel;

  Result< GenrateOptResponceModel, Exception>? _genrateOptData;
  Result< GenrateOptResponceModel, Exception>? get genrateOptData => _genrateOptData;

  //pan card module
  Result< LeadPanResponseModel, Exception>? _getLeadPANData;
  Result< LeadPanResponseModel, Exception>? get getLeadPANData => _getLeadPANData;

  Result<ValidPanCardResponsModel,Exception>? _getLeadValidPanCardData;
  Result<ValidPanCardResponsModel,Exception>? get getLeadValidPanCardData =>
      _getLeadValidPanCardData;

  Result<FathersNameByValidPanCardResponseModel,Exception>? _getFathersNameByValidPanCardData;
  Result<FathersNameByValidPanCardResponseModel,Exception>? get getFathersNameByValidPanCardData => _getFathersNameByValidPanCardData;

  PostSingleFileResponseModel? _getPostSingleFileData;
  PostSingleFileResponseModel? get getPostSingleFileData => _getPostSingleFileData;

  Result<PostLeadPanResponseModel,Exception>? _getPostLeadPanData;
  Result<PostLeadPanResponseModel,Exception>? get getPostLeadPaneData => _getPostLeadPanData;

  //Aadhaar module
  Result<LeadAadhaarResponse,Exception>? _getLeadAadhaar;
  Result<LeadAadhaarResponse,Exception>? get getLeadAadhaar =>
      _getLeadAadhaar;

  Result<AadhaarGenerateOTPResponseModel,Exception>? _getLeadAadharGenerateOTP;
  Result<AadhaarGenerateOTPResponseModel,Exception>? get getLeadAadharGenerateOTP => _getLeadAadharGenerateOTP;

  Result<ValidateAadhaarOTPResponseModel,Exception>? _getValidateAadhaarOTPData;
  Result<ValidateAadhaarOTPResponseModel,Exception>? get getValidateAadhaarOTPData => _getValidateAadhaarOTPData;

  PostSingleFileResponseModel? _getPostBackAadhaarSingleFileData;
  PostSingleFileResponseModel? get getPostBackAadhaarSingleFileData => _getPostBackAadhaarSingleFileData;

  PostSingleFileResponseModel? _getPostFrontAadhaarSingleFileData;
  PostSingleFileResponseModel? get getPostFrontAadhaarSingleFileData => _getPostFrontAadhaarSingleFileData;

  //take selfie module
  Result<LeadSelfieResponseModel,Exception>? _getLeadSelfieData;
  Result<LeadSelfieResponseModel,Exception>? get getLeadSelfieData =>
      _getLeadSelfieData;

  Result<PostLeadSelfieResponseModel,Exception>? _getPostLeadSelfieData;
  Result<PostLeadSelfieResponseModel,Exception>? get getPostLeadSelfieData => _getPostLeadSelfieData;

  PostSingleFileResponseModel? _getPostSelfieImageSingleFileData;
  PostSingleFileResponseModel? get getPostSelfieImageSingleFileData => _getPostSelfieImageSingleFileData;

  //Personal Info Module
  Result<PersonalDetailsResponce,Exception>? _getPersonalDetailsData;
  Result<PersonalDetailsResponce,Exception>? get getPersonalDetailsData =>
      _getPersonalDetailsData;

  PostSingleFileResponseModel? _getpostElectricityBillDocumentSingleFileData;
  PostSingleFileResponseModel? get getpostElectricityBillDocumentSingleFileData => _getpostElectricityBillDocumentSingleFileData;

  //Buisness details
  PostSingleFileResponseModel? _getpostBusineesDoumentSingleFileData;
  PostSingleFileResponseModel? get getpostBusineesDoumentSingleFileData => _getpostBusineesDoumentSingleFileData;

  PostSingleFileResponseModel? _getpostDSABusineesDoumentSingleFileData;
  PostSingleFileResponseModel? get getpostDSABusineesDoumentSingleFileData => _getpostDSABusineesDoumentSingleFileData;


/*  Result<DisbursementResponce,Exception>? _getDisbursementProposalData;
  Result<DisbursementResponce,Exception>? get getDisbursementProposalData => _getDisbursementProposalData;

  Result<DisbursementCompletedResponse,Exception>? _getDisbursementData;
  Result<DisbursementCompletedResponse,Exception>? get getDisbursementData => _getDisbursementData;*/


  Result<VerifyOtpResponse,Exception>? _getVerifyData;
  Result<VerifyOtpResponse,Exception>? get getVerifyData => _getVerifyData;

  Result<GetUserProfileResponse,Exception>? _getUserProfileResponse;
  Result<GetUserProfileResponse,Exception>? get getUserProfileResponse => _getUserProfileResponse;

  Result<LeadMobileNoResModel,Exception>? _getLeadMobileNoData;
  Result<LeadMobileNoResModel,Exception>? get getLeadMobileNoData => _getLeadMobileNoData;

  BankListResponceModel? _getBankListData;

  BankListResponceModel? get getBankListData => _getBankListData;

  Result<BankDetailsResponceModel,Exception>? _getBankDetailsData;
  Result<BankDetailsResponceModel,Exception>? get getBankDetailsData => _getBankDetailsData;

  AllStateResponce? _getAllStateData;

  AllStateResponce? get getAllStateData => _getAllStateData;

  List<CityResponce?>? _getAllCityData;
  List<CityResponce?>? get getAllCityData => _getAllCityData;

  List<CityResponce?>? _getCurrentAllCityData;
  List<CityResponce?>? get getCurrentAllCityData => _getCurrentAllCityData;

  EmailExistRespoce? _getEmailExistData;

  EmailExistRespoce? get getEmailExistData => _getEmailExistData;

  SendOtpOnEmailResponce? _getOtpOnEmailData;

  SendOtpOnEmailResponce? get getOtpOnEmailData => _getOtpOnEmailData;

  ValidEmResponce? _getValidOtpEmailData;

  ValidEmResponce? get getValidOtpEmailData => _getValidOtpEmailData;

  PostPersonalDetailsResponseModel? _getPostPersonalDetailsResponseModel;

  PostPersonalDetailsResponseModel? get getPostPersonalDetailsResponseModel =>
      _getPostPersonalDetailsResponseModel;

  Result<CustomerDetailUsingGstResponseModel,Exception>? _getCustomerDetailUsingGSTData;
  Result<CustomerDetailUsingGstResponseModel,Exception>? get getCustomerDetailUsingGSTData => _getCustomerDetailUsingGSTData;

  /*LeadBusinessDetailResponseModel? _getLeadBusinessDetailData;
  LeadBusinessDetailResponseModel? get getLeadBusinessDetailData => _getLeadBusinessDetailData;

  CustomerDetailUsingGstResponseModel? _getCustomerDetailUsingGSTData;
  CustomerDetailUsingGstResponseModel? get getCustomerDetailUsingGSTData => _getCustomerDetailUsingGSTData;

  Result<PostLeadBuisnessDetailResponsModel,Exception>? _getPostLeadBuisnessDetailData;
  Result<PostLeadBuisnessDetailResponsModel,Exception>? get getPostLeadBuisnessDetailData => _getPostLeadBuisnessDetailData;


  Result<OfferResponceModel,Exception>? _getOfferResponceata;
  Result<OfferResponceModel,Exception>? get getOfferResponceata => _getOfferResponceata;

  Result<AcceptedResponceModel,Exception>? _getAcceptOfferData;
  Result<AcceptedResponceModel,Exception>? get getAcceptOfferData => _getAcceptOfferData;

  Result<OfferPersonNameResponceModel,Exception>? _getLeadNameData;
  Result<OfferPersonNameResponceModel,Exception>? get getLeadNameData => _getLeadNameData;*/

  Result<SaveBankDetailResponce,Exception>? _getSaveLeadBankDetailData;
  Result<SaveBankDetailResponce,Exception>? get getSaveLeadBankDetailData => _getSaveLeadBankDetailData;


  Result<CreateUserModel,Exception>? _getCreatDSAUserData;
  Result<CreateUserModel,Exception>? get getCreatDSAUserData => _getCreatDSAUserData;


  /*Result< CheckOutOtpModel, Exception>? _genrateOptPaymentData;
  Result< CheckOutOtpModel, Exception>? get genrateOptPaymentData => _genrateOptPaymentData;

  Result< bool, Exception>? _reSendOptPaymentData;
  Result< bool, Exception>? get reSendOptPaymentData => _reSendOptPaymentData;

  Result< ValidOtpForCheckoutModel, Exception>? _validOptPaymentData;
  Result< ValidOtpForCheckoutModel, Exception>? get validOptPaymentData => _validOptPaymentData;

  Result< TransactionDetailModel, Exception>? _getTranscationData;
  Result< TransactionDetailModel, Exception>? get getTranscationData => _getTranscationData;

  Result< OrderPaymentModel, Exception>? _postPaymentOrderData;
  Result< OrderPaymentModel, Exception>? get postPaymentOrderData => _postPaymentOrderData;

  Result<CustomerOrderSummaryResModel,Exception>? _getCustomerOrderSummaryData;
  Result<CustomerOrderSummaryResModel,Exception>? get getCustomerOrderSummaryData => _getCustomerOrderSummaryData;

  Result<List<CustomerTransactionListRespModel>,Exception>? _getCustomerTransactionListData;
  Result<List<CustomerTransactionListRespModel>,Exception>? get getCustomerTransactionListData => _getCustomerTransactionListData;

  Result<OfferResponceModel,Exception>? _getCustomerOrderSummaryForAnchorData;
  Result<OfferResponceModel,Exception>? get getCustomerOrderSummaryForAnchorData => _getCustomerOrderSummaryForAnchorData;

  Result<List<CustomerTransactionListTwoRespModel>,Exception>? _getCustomerTransactionListTwoData;
  Result<List<CustomerTransactionListTwoRespModel>,Exception>? get getCustomerTransactionListTwoData => _getCustomerTransactionListTwoData;

  Result<TransactionBreakupResModel,Exception>? _getTransactionBreakupData;
  Result<TransactionBreakupResModel,Exception>? get getTransactionBreakupData => _getTransactionBreakupData;

  Result<CheckSignResponceModel,Exception>? _getCheckSignData;
  Result<CheckSignResponceModel,Exception>? get getCheckSignData => _getCheckSignData;

  Result<AcceptedResponceModel,Exception>? _getNextCallData;
  Result<AcceptedResponceModel,Exception>? get getNextCallData => _getNextCallData;*/

  /*Result<IvrsNumberExistResModel,Exception>? _getIvrsNumberExistData;
  Result<IvrsNumberExistResModel,Exception>? get getIvrsNumberExistData => _getIvrsNumberExistData;*/

  Result<IvrsResModel,Exception>? _getIvrsData;
  Result<IvrsResModel,Exception>? get getIvrsData => _getIvrsData;

  Result<List<ElectricityServiceProviderListResModel>,Exception>? _getElectricityServiceProviderListData;
  Result<List<ElectricityServiceProviderListResModel>,Exception>? get getElectricityServiceProviderData => _getElectricityServiceProviderListData;

  Result<List<ElectricityStateResModel>,Exception>? _getElectricityStateListData;
  Result<List<ElectricityStateResModel>,Exception>? get getElectricityStateListData => _getElectricityStateListData;

  Result<ElectricityAuthenticationResModel,Exception>? _getElectricityAuthenticationData;
  Result<ElectricityAuthenticationResModel,Exception>? get getElectricityAuthenticationData => _getElectricityAuthenticationData;

  Result<ChooseUserTypeResponceModel,Exception>? _getChooseUserTypeData;
  Result<ChooseUserTypeResponceModel,Exception>? get getChooseUserTypeData => _getChooseUserTypeData;

  Result< DSAPersonalInfoModel, Exception>? _getDSAPersonalInfoData;
  Result< DSAPersonalInfoModel, Exception>? get getDSAPersonalInfoData => _getDSAPersonalInfoData;

  Result<PostLeadDsaPersonalDetailResModel,Exception>? _getpostLeadDSAPersonalDetailData;
  Result<PostLeadDsaPersonalDetailResModel,Exception>? get getpostLeadDSAPersonalDetailData => _getpostLeadDSAPersonalDetailData;

  Result<CommanResponceModel,Exception>? _getConnectorSubmitData;
  Result<CommanResponceModel,Exception>? get getConnectorSubmitData => _getConnectorSubmitData;

  Result<ConnectorInfoResponce,Exception>? _getConnectorInfoData;
  Result<ConnectorInfoResponce,Exception>? get getConnectorInfoData => _getConnectorInfoData;
  Result< GetDsaPersonalDetailResModel, Exception>? _getDsaPersonalDetailData;
  Result< GetDsaPersonalDetailResModel, Exception>? get getDsaPersonalDetailData => _getDsaPersonalDetailData;

  Result< GetAgreementResModel, Exception>? _dSAGenerateAgreementData;
  Result< GetAgreementResModel, Exception>? get dSAGenerateAgreementData => _dSAGenerateAgreementData;


  Result<InProgressScreenModel,Exception>? _InProgressScreen;
  Result<InProgressScreenModel,Exception>? get InProgressScreenData => _InProgressScreen;

  Result<GetDsaDashboardDetailsResModel,Exception>? _getDSADashboardDetailsData;
  Result<GetDsaDashboardDetailsResModel,Exception>? get getDSADashboardDetailsData => _getDSADashboardDetailsData;

  Result<CheckESignResponseModel,Exception>? _checkESignResponseModelData;
  Result<CheckESignResponseModel,Exception>? get checkESignResponseModelData => _checkESignResponseModelData;

  Result<DsaSalesAgentListResModel,Exception>? _getDSASalesAgentListData;
  Result<DsaSalesAgentListResModel,Exception>? get getDSASalesAgentListData => _getDSASalesAgentListData;

  Result<DsaDashboardLeadListResModel,Exception>? _getDSADashboardLeadListData;
  Result<DsaDashboardLeadListResModel,Exception>? get getDSADashboardLeadListData => _getDSADashboardLeadListData;

  Result<GetDsaDashboardPayoutListResModel,Exception>? _getDSADashboardPayoutListData;
  Result<GetDsaDashboardPayoutListResModel,Exception>? get getDSADashboardPayoutListData => _getDSADashboardPayoutListData;

  Result<LeadCreatePermissionModel,Exception>? _getLeadCreatePermission;
  Result<LeadCreatePermissionModel,Exception>? get getLeadCreatePermission => _getLeadCreatePermission;


  Future<void> productCompanyDetail(
      String product, String company) async {
    _ProductCompanyDetailResponseModel =
    await apiService.productCompanyDetail(product, company);
    notifyListeners();
  }

  Future<void> getLeads(
      String mobile, int productId, int companyId, int leadId) async {
    _getLeadData =
    await apiService.getLeads(mobile, productId, companyId, leadId);
    notifyListeners();
  }

  Future<void> getLeadPAN(String userId,String productCode) async {
    _getLeadPANData = await apiService.getLeadPAN(userId,productCode);
    notifyListeners();
  }

  Future<void> genrateOtp(BuildContext context, String mobileNumber) async {
    _genrateOptData = await apiService.genrateOtp(context, mobileNumber);
    notifyListeners();
  }

  Future<void> getLeadValidPanCard(String panNumber) async {
    _getLeadValidPanCardData = await apiService.getLeadValidPanCard(panNumber);
    notifyListeners();
  }

  Future<void> verifyOtp(VarifayOtpRequest verifayOtp) async {
    _getVerifyData = await apiService.verifyOtp(verifayOtp);
    notifyListeners();
  }

  Future<void> getUserData(String userId, String mobile) async {
    _getUserProfileResponse = await apiService.getUserData(userId, mobile);
    notifyListeners();
  }

  Future<void> GetLeadByMobileNo(String userId, String mobile) async {
    _getLeadMobileNoData = await apiService.GetLeadByMobileNo(userId, mobile);
    notifyListeners();
  }

  Future<void> getLeadAadhar(String userId,String productCode) async {
    _getLeadAadhaar = await apiService.getLeadAadhar(userId,productCode);
    notifyListeners();
  }

  Future<void> leadAadharGenerateOTP(
      AadhaarGenerateOTPRequestModel aadhaarGenerateOTPRequestModel) async {
    _getLeadAadharGenerateOTP =
    await apiService.getLeadAadharGenerateOTP(aadhaarGenerateOTPRequestModel);
    notifyListeners();
  }

  Future<void> getFathersNameByValidPanCard(String panNumber) async {
    _getFathersNameByValidPanCardData =
    await apiService.getFathersNameByValidPanCard(panNumber);
    notifyListeners();
  }

  Future<void> postSingleFile(File imageFile, bool isValidForLifeTime,
      String validityInDays, String subFolderName) async {
    _getPostSingleFileData = await apiService.postSingleFile(
        imageFile, isValidForLifeTime, validityInDays, subFolderName);
    notifyListeners();
  }

  Future<void> postTakeSelfieFile(File imageFile, bool isValidForLifeTime,
      String validityInDays, String subFolderName) async {
    _getPostSelfieImageSingleFileData = await apiService.postSingleFile(
        imageFile, isValidForLifeTime, validityInDays, subFolderName);
    notifyListeners();
  }

  Future<void> postElectricityBillDocumentSingleFile(File imageFile, bool isValidForLifeTime,
      String validityInDays, String subFolderName) async {
    _getpostElectricityBillDocumentSingleFileData = await apiService.postSingleFile(
        imageFile, isValidForLifeTime, validityInDays, subFolderName);
    notifyListeners();
  }

  Future<void> PostFrontAadhaarSingleFileData(File imageFile, bool isValidForLifeTime,
      String validityInDays, String subFolderName) async {
    _getPostFrontAadhaarSingleFileData = await apiService.postSingleFile(
        imageFile, isValidForLifeTime, validityInDays, subFolderName);
    notifyListeners();
  }

  Future<void> disposeFrontAadhaarSingleFileData() async {
    _getPostFrontAadhaarSingleFileData = null;
    notifyListeners();
  }

  Future<void> disposeBackAadhaarSingleFileData() async {
    _getPostBackAadhaarSingleFileData = null;
    notifyListeners();
  }

  Future<void> disposeAllSingleFileData() async {
    _getPostFrontAadhaarSingleFileData = null;
    _getPostBackAadhaarSingleFileData=null;
    _getPostSingleFileData=null;
    _getpostElectricityBillDocumentSingleFileData = null;
    _getPostSelfieImageSingleFileData = null;
    notifyListeners();
  }

  Future<void> postBusineesDoumentSingleFile(File imageFile, bool isValidForLifeTime,
      String validityInDays, String subFolderName) async {
    _getpostBusineesDoumentSingleFileData = await apiService.postSingleFile(
        imageFile, isValidForLifeTime, validityInDays, subFolderName);
    notifyListeners();
  }

  Future<void> postDSABusineesDoumentSingleFile(File imageFile, bool isValidForLifeTime,
      String validityInDays, String subFolderName) async {
    _getpostDSABusineesDoumentSingleFileData = await apiService.postSingleFile(
        imageFile, isValidForLifeTime, validityInDays, subFolderName);
    notifyListeners();
  }

  Future<void> postLeadPAN(
      PostLeadPanRequestModel postLeadPanRequestModel) async {
    _getPostLeadPanData = await apiService.postLeadPAN(postLeadPanRequestModel);
    notifyListeners();
  }


  Future<void> getBankList() async {
    _getBankListData = await apiService.getBankList();
    notifyListeners();
  }

  Future<void> getBankDetails(int leadID,String productCode) async {
    _getBankDetailsData = await apiService.GetLeadBankDetail(leadID,productCode);
    notifyListeners();
  }


  Future<void> getLeadPersonalDetails(String userId,String productCode) async {
    _getPersonalDetailsData = await apiService.getLeadPersnalDetails(userId,productCode);
    notifyListeners();
  }

  Future<void> getAllState() async {
    _getAllStateData = await apiService.getAllState();
    notifyListeners();
  }

  Future<void> getAllCity(int stateID) async {
    _getAllCityData = await apiService.GetCityByStateId(stateID);
    notifyListeners();
  }

  Future<void> getCurrentAllCity(int stateID) async {
    _getCurrentAllCityData = await apiService.GetCityByStateId(stateID);
    notifyListeners();
  }

  Future<void> postAadhaarBackSingleFile(File imageFile, bool isValidForLifeTime,
      String validityInDays, String subFolderName) async {
    _getPostBackAadhaarSingleFileData = await apiService.postSingleFile(
        imageFile, isValidForLifeTime, validityInDays, subFolderName);
    notifyListeners();
  }

  Future<void> validateAadhaarOtp(ValidateAadhaarOTPRequestModel verifayOtp) async {
    _getValidateAadhaarOTPData = await apiService.validateAadhaarOtp(verifayOtp);
    notifyListeners();
  }

  Future<void> isEmailExist(String UserID,String Emailid) async {
    _getEmailExistData = await apiService.emailExist(UserID,Emailid);
    notifyListeners();
  }

  Future<void> getSendOtpOnEmail(String Emailid) async {
    _getOtpOnEmailData = await apiService.sendOtpOnEmail(Emailid);
    notifyListeners();
  }

  Future<void> otpValidateForEmail(OtpValidateForEmailRequest model) async {
    _getValidOtpEmailData = await apiService.otpValidateForEmail(model);
    notifyListeners();
  }

  Future<void> getLeadSelfie(String userId,String productCode) async {
    _getLeadSelfieData = await apiService.getLeadSelfie(userId,productCode);
    notifyListeners();
  }

  Future<void> postLeadSelfie(
      PostLeadSelfieRequestModel postLeadSelfieRequestModel) async {
    _getPostLeadSelfieData =
    await apiService.postLeadSelfie(postLeadSelfieRequestModel);

  }

  Future<void> postLeadPersonalDetail(
      PersonalDetailsRequestModel personalDetailsRequestModel, BuildContext context) async {
    _getPostPersonalDetailsResponseModel =
    await apiService.postLeadPersonalDetail(personalDetailsRequestModel, context);

  }

  Future<void> getCustomerDetailUsingGST(String GSTNumber) async {
    _getCustomerDetailUsingGSTData = await apiService.getCustomerDetailUsingGST(GSTNumber);
    notifyListeners();
  }

  /*Future<void> getLeadBusinessDetail(String userId,String productCode) async {
    _getLeadBusinessDetailData = await apiService.getLeadBusinessDetail(userId,productCode);
    notifyListeners();
  }

  Future<void> getCustomerDetailUsingGST(String GSTNumber) async {
    _getCustomerDetailUsingGSTData = await apiService.getCustomerDetailUsingGST(GSTNumber);
    notifyListeners();
  }

  Future<void> postLeadBuisnessDetail(PostLeadBuisnessDetailRequestModel postLeadBuisnessDetailRequestModel) async {
    _getPostLeadBuisnessDetailData = await apiService.postLeadBuisnessDetail(postLeadBuisnessDetailRequestModel);
    notifyListeners();
  }

  Future<void> GetLeadOffer(int leadId ,int companyID) async {
    _getOfferResponceata = await apiService.GetLeadOffer(leadId,companyID);
    notifyListeners();
  }
  Future<void> getAcceptOffer(int leadId) async {
    _getAcceptOfferData = await apiService.getAcceptOffer(leadId);
    notifyListeners();
  }

  Future<void> getLeadName(String UserId,String productcode) async {
    _getLeadNameData = await apiService.getLeadName(UserId,productcode);
    notifyListeners();
  }*/
  Future<void> saveLeadBankDetail(SaveBankDetailsRequestModel model) async {
    _getSaveLeadBankDetailData = await apiService.saveLeadBankDetail(model);
    notifyListeners();
  }

  Future<void> createDSAUser(CreateDSAUserReqModel model) async {
    _getCreatDSAUserData = await apiService.createDSAUser(model);
    notifyListeners();
  }

  /* Future<void> getDisbursementProposal(int leadId) async {
    _getDisbursementProposalData = await apiService.GetDisbursementProposal(leadId);
    notifyListeners();
  }

  Future<void> GetDisbursement(int leadId) async {
    _getDisbursementData = await apiService.GetDisbursement(leadId);
    notifyListeners();
  }
  Future<void> GetByTransactionReqNoForOTP(String transactionReqNo) async {
    _genrateOptPaymentData = await apiService.genrateOtpPaymentConfromation(transactionReqNo);
    notifyListeners();
  }

  Future<void> reSendOtpPaymentConfromation(String MobileNo,String transactionReqNo) async {
    _reSendOptPaymentData = await apiService.reSendOtpPaymentConfromation(MobileNo,transactionReqNo);
    notifyListeners();
  }

  Future<void> ValidateOrderOTPGetToken(String MobileNo,String otp,String transactionReqNo) async {
    _validOptPaymentData = await apiService.ValidateOrderOTPGetToken(MobileNo,otp,transactionReqNo);
    notifyListeners();
  }

  Future<void> GetByTransactionReqNo(String transactionReqNo) async {
    _getTranscationData = await apiService.GetByTransactionReqNo(transactionReqNo);
    notifyListeners();
  }
  Future<void> PostOrderPlacement(PayemtOrderPostRequestModel model) async {
    _postPaymentOrderData = await apiService.PostOrderPlacement(model);
    notifyListeners();
  }

  Future<void> getCustomerOrderSummary( leadId) async {
    _getCustomerOrderSummaryData = await apiService.getCustomerOrderSummary(leadId);
    notifyListeners();
  }

  Future<void> getCustomerTransactionList(
      CustomerTransactionListRequestModel customerTransactionListRequestModel) async {
    _getCustomerTransactionListData =
    await apiService.getCustomerTransactionList(customerTransactionListRequestModel);
    notifyListeners();
  }

  Future<void> getCustomerOrderSummaryForAnchor(int leadId) async {
    _getCustomerOrderSummaryForAnchorData = await apiService.getCustomerOrderSummaryForAnchor(leadId);
    notifyListeners();
  }

  Future<void> getCustomerTransactionListTwo(
      CustomerTransactionListTwoReqModel customerTransactionListTwoReqModel) async {
    _getCustomerTransactionListTwoData =
    await apiService.getCustomerTransactionListTwo(customerTransactionListTwoReqModel);
    notifyListeners();
  }

  Future<void> disposegetCustomerOrderSummaryData() async {
    _getCustomerOrderSummaryData = null;
    _getCustomerTransactionListTwoData = null;
    notifyListeners();
  }

  Future<void> disposegetCustomerTransactionList() async {
    _getCustomerTransactionListData = null;
    notifyListeners();
  }

  Future<void> getTransactionBreakup(int invoiceId) async {
    _getTransactionBreakupData = await apiService.getTransactionBreakup(invoiceId);
    notifyListeners();
  }

  Future<void> checkEsignStatus(int leadID) async {
    _getCheckSignData = await apiService.checkEsignStatus(leadID);
    notifyListeners();
  }

  Future<void> getCallNext(int leadId) async {
    _getNextCallData = await apiService.getNextCall(leadId);
    notifyListeners();
  }


  */

  Future<void> leadDataOnInProgressScreen(BuildContext context, int leadId) async {
    _isLoading = true;
    notifyListeners();
    Utils.onLoading(context, "");
    _InProgressScreen = await apiService.leadDataOnInProgressScreen(leadId);
    _isLoading = false;
    notifyListeners();
    Navigator.of(context).pop();
  }

  Future<void> getIvrsNumberExist(String UserId,String IvrsNumber) async {
    _getIvrsData = await apiService.getIvrsNumberExist(UserId,IvrsNumber);
    notifyListeners();
  }

  Future<void> getKarzaElectricityServiceProviderList() async {
    _getElectricityServiceProviderListData =
    await apiService.getKarzaElectricityServiceProviderList();
    notifyListeners();
  }

  Future<void> getKarzaElectricityState(String state) async {
    _getElectricityStateListData =
    (await apiService.getKarzaElectricityState(state)) ;
    notifyListeners();
  }

  Future<void> getKarzaElectricityAuthentication(ElectricityAuthenticationReqModel electricityAuthenticationReqModel) async {
    _getElectricityAuthenticationData = await apiService.getKarzaElectricityAuthentication(electricityAuthenticationReqModel) ;
    notifyListeners();
  }

  Future<void> getChooseUserType(ChooseUserTypeRequestModel model) async {
    _getChooseUserTypeData = await apiService.getChooseUserType(model) ;
    notifyListeners();
  }

  Future<void> postLeadDSAPersonalDetail(PostLeadDsaPersonalDetailReqModel model) async {
    _getpostLeadDSAPersonalDetailData = await apiService.postLeadDSAPersonalDetail(model) ;
    notifyListeners();
  }

  Future<void> getDSAPersonalInfo(BuildContext context, String userId,String productCode) async {
    _isLoading = true;
    notifyListeners();
    Utils.onLoading(context, "");
    _getDSAPersonalInfoData = await apiService.getDSAPersonalInfo(userId,productCode);
    _isLoading = false;
    notifyListeners();
    Navigator.of(context).pop();
  }

  Future<void> submitConnectorData(ConnectorInfoReqModel model) async {
    _getConnectorSubmitData = await apiService.submitConnectorData(model);
    notifyListeners();
  }

  Future<void> getConnectorInfo(String userId,String productCode) async {
    _getConnectorInfoData = await apiService.getConnectorInfo(userId,productCode);
    notifyListeners();
  }

  Future<void> getDsaPersonalDetail(String userId,String productCode) async {
    _getDsaPersonalDetailData = await apiService.getDsaPersonalDetail(userId,productCode);
    notifyListeners();
  }

  /*Future<void> getDsaPersonalDetail(BuildContext context, String userId,String productCode) async {
    _isLoading = true;
    notifyListeners();
    Utils.onLoading(context, "");
    _getDsaPersonalDetailData = await apiService.getDsaPersonalDetail(userId,productCode);
    _isLoading = false;
    notifyListeners();
  }*/
  Future<void> getDSADashboardDetails(GetDsaDashboardDetailsReqModel model) async {
    _getDSADashboardDetailsData = await apiService.getDSADashboardDetails(model);
    notifyListeners();
  }

  Future<void> dSAGenerateAgreement(BuildContext context, String leadId,String ProductId, String ComapnyId, bool IsSubmit) async {
    _isLoading = true;
    notifyListeners();
    Utils.onLoading(context, "");
    _dSAGenerateAgreementData = await apiService.dSAGenerateAgreement(leadId,ProductId, ComapnyId, IsSubmit);
    _isLoading = false;
    notifyListeners();
    Navigator.of(context).pop();
  }

  Future<void> disposeDSAGenerateAgreementData() async {
    _dSAGenerateAgreementData = null;
  }

  Future<void> checkESignDocumentStatus(String leadId) async {
    _checkESignResponseModelData = await apiService.checkESignDocumentStatus(leadId) ;
    notifyListeners();
  }

  Future<void> getDSASalesAgentList() async {
    _getDSASalesAgentListData = await apiService.getDSASalesAgentList();
    notifyListeners();
  }

  Future<void> getDSADashboardLeadList(DsaDashboardLeadListReqModel model) async {
    _getDSADashboardLeadListData = await apiService.getDSADashboardLeadList(model);
    notifyListeners();
  }
  Future<void> getDSADashboardPayoutList(GetDsaDashboardPayoutListReqModel model) async {
    _getDSADashboardPayoutListData = await apiService.getDSADashboardPayoutList(model);
    notifyListeners();
  }

  Future<void> getCheckLeadCreatePermission(String mobileNo) async {
    _getLeadCreatePermission = await apiService.getCheckLeadCreatePermission(mobileNo);
    notifyListeners();
  }

  Future<void> disposeAllProviderData() async {
    /*_getCustomerOrderSummaryData = null;
    _getCustomerTransactionListTwoData = null;
    _ProductCompanyDetailResponseModel = null;*/
    _genrateOptData = null;
    _getLeadPANData = null;
    _getLeadValidPanCardData = null;
    _getFathersNameByValidPanCardData = null;
    _getPostLeadPanData = null;
    _getLeadAadhaar = null;
    _getValidateAadhaarOTPData = null;
    _getLeadAadharGenerateOTP = null;
    _getLeadSelfieData = null;
    _getPostLeadSelfieData = null;
    _getPersonalDetailsData = null;
    /* _getDisbursementProposalData = null;
    _getDisbursementData = null;*/
    _getVerifyData = null;
    _getBankListData = null;
    _getBankDetailsData = null;
    _getAllStateData = null;
    _getAllCityData = null;
    _getCurrentAllCityData = null;
    _getEmailExistData = null;
    _getOtpOnEmailData = null;
    _getValidOtpEmailData = null;
    _getPostPersonalDetailsResponseModel = null;
    /* _getLeadBusinessDetailData = null;
    _getCustomerDetailUsingGSTData = null;
    _getPostLeadBuisnessDetailData = null;
    _getOfferResponceata = null;
    _getAcceptOfferData = null;
    _getLeadNameData = null;*/
    _getSaveLeadBankDetailData = null;
    /*_genrateOptPaymentData = null;
    _reSendOptPaymentData = null;
    _getTranscationData = null;
    _validOptPaymentData = null;
    _postPaymentOrderData = null;
    _getCustomerOrderSummaryData = null;
    _getCustomerTransactionListData = null;
    _getCustomerOrderSummaryForAnchorData = null;
    _getCustomerTransactionListTwoData = null;
    _getTransactionBreakupData = null;
    _getCheckSignData = null;
    _getNextCallData = null;*/
    _getIvrsData = null;
    _getElectricityServiceProviderListData = null;
    _getElectricityStateListData = null;
    _getElectricityAuthenticationData = null;
    _getUserProfileResponse = null;
    _getConnectorSubmitData = null;
    _getConnectorInfoData = null;
    _getCreatDSAUserData = null;
    _getLeadCreatePermission=null;
    /*_InProgressScreen = null;*/
    notifyListeners();
  }


  Future<void> disposehomeScreenData() async {
    _getDSASalesAgentListData=null;
    _getDSADashboardDetailsData=null;
    notifyListeners();
  }
  Future<void> disposeLeadScreenData() async {
    _getDSASalesAgentListData=null;
    _getDSADashboardLeadListData=null;
    notifyListeners();
  }
  Future<void> disposePayOutScreenData() async {
    _getDSASalesAgentListData=null;
    _getDSADashboardPayoutListData=null;
    notifyListeners();
  }

  Future<void> disposeUserProfileScreenData() async {
    _getCreatDSAUserData=null;
    notifyListeners();
  }

  Future<void> disposegetDSAPersonalInfoData() async {
    _getDSAPersonalInfoData=null;
    notifyListeners();
  }
}