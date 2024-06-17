import 'dart:convert';
import 'dart:io';
import 'package:direct_sourcing_agent/inprogress/model/InProgressScreenModel.dart';
import 'package:direct_sourcing_agent/view/connector/model/CommanResponceModel.dart';
import 'package:direct_sourcing_agent/view/connector/model/ConnectorInfoReqModel.dart';
import 'package:direct_sourcing_agent/view/connector/model/ConnectorInfoResponce.dart';
import 'package:direct_sourcing_agent/view/dashboard/userprofile/model/CreateDSAUserReqModel.dart';
import 'package:direct_sourcing_agent/view/dashboard/userprofile/model/CreateUserModel.dart';
import 'package:direct_sourcing_agent/view/login_screen/login_screen.dart';
import 'package:direct_sourcing_agent/view/profile_type/model/ChooseUserTypeRequestModel.dart';
import 'package:direct_sourcing_agent/view/profile_type/model/ChooseUserTypeResponceModel.dart';
import 'package:direct_sourcing_agent/view/profile_type/model/DSAPersonalInfoModel.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../ProductCompanyDetailResponseModel.dart';
import '../shared_preferences/shared_pref.dart';
import '../utils/InternetConnectivity.dart';
import '../utils/constant.dart';
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
import '../view/splash/splash_screen.dart';
import '../view/take_selfi/model/LeadSelfieResponseModel.dart';
import '../view/take_selfi/model/PostLeadSelfieRequestModel.dart';
import '../view/take_selfi/model/PostLeadSelfieResponseModel.dart';
import 'ApiUrls.dart';
import 'ExceptionHandling.dart';
import 'FailureException.dart';
import 'Interceptor.dart';

class ApiService {
  final apiUrls = ApiUrls();
  final interceptor = Interceptor();
  final internetConnectivity = InternetConnectivity();

  Future<void> handle401(BuildContext context) async {
    final prefsUtil = await SharedPref.getInstance();
    prefsUtil.saveBool(IS_LOGGED_IN, false);
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => LoginScreen(),
      ),
    );
  }

  Future<ProductCompanyDetailResponseModel> productCompanyDetail(
      String product, String company) async {
    if (await internetConnectivity.networkConnectivity()) {
        final prefsUtil = await SharedPref.getInstance();
        var base_url = prefsUtil.getString(BASE_URL);

      final response = await interceptor.get(Uri.parse(
          '${base_url! + apiUrls.productCompanyDetail}?product=$product&company=$company'));
      print(response.body); // Print the response body once here
      if (response.statusCode == 200) {
        final dynamic jsonData = json.decode(response.body);
        final ProductCompanyDetailResponseModel responseModel =
            ProductCompanyDetailResponseModel.fromJson(jsonData);
        return responseModel;
      } else {
        throw Exception('Failed to load Data');
      }
    } else {
      throw Exception('No internet connection');
    }
  }

  Future<GetLeadResponseModel> getLeads(
      String mobile, int productId, int companyId, int leadId) async {
    if (await internetConnectivity.networkConnectivity()) {
      final prefsUtil = await SharedPref.getInstance();
      var base_url = prefsUtil.getString(BASE_URL);
      final response = await interceptor.get(Uri.parse(
          '${base_url! + apiUrls.getLeadCurrentActivity}?MobileNo=$mobile&ProductId=$productId&CompanyId=$companyId&LeadId=$leadId'));
      print(response.body); // Print the response body once here
      if (response.statusCode == 200) {
        // Parse the JSON response
        final dynamic jsonData = json.decode(response.body);
        final GetLeadResponseModel responseModel =
            GetLeadResponseModel.fromJson(jsonData);
        return responseModel;
      } else {
        throw Exception('Failed to load products');
      }
    } else {
      throw Exception('No internet connection');
    }
  }

  Future<LeadCurrentResponseModel> leadCurrentActivityAsync(
      LeadCurrentRequestModel leadCurrentRequestModel,
      BuildContext context) async {
    if (await internetConnectivity.networkConnectivity()) {
      final prefsUtil = await SharedPref.getInstance();
      var base_url = prefsUtil.getString(BASE_URL);
      var token = await prefsUtil.getString(TOKEN);
      final response = await interceptor.post(
          Uri.parse('${base_url! + apiUrls.leadCurrentActivityAsync}'),
          headers: {
            'Content-Type': 'application/json', // Set the content type as JSON
            'Authorization': 'Bearer $token' // Set the content type as JSON
          },
          body: json.encode(leadCurrentRequestModel));
      //print(json.encode(leadCurrentRequestModel));
      print(response.body); // Print the response body once here
      if (response.statusCode == 200) {
        // Parse the JSON response
        final dynamic jsonData = json.decode(response.body);
        final LeadCurrentResponseModel responseModel =
            LeadCurrentResponseModel.fromJson(jsonData);
        return responseModel;
      } else if (response.statusCode == 401) {
        handle401(context);
        throw Exception('Un');
      } else {
        throw Exception('Failed to load Data');
      }
    } else {
      throw Exception('No internet connection');
    }
  }

  //auth

  Future<Result<GenrateOptResponceModel, Exception>> genrateOtp(
      BuildContext context, String mobileNumber) async {
    try {
      if (await internetConnectivity.networkConnectivity()) {
        final prefsUtil = await SharedPref.getInstance();
        var base_url = prefsUtil.getString(BASE_URL);
        final response = await interceptor.get(Uri.parse(
            '${base_url! + apiUrls.generateOtp}?MobileNo=$mobileNumber'));
        print(response.body); // Print the response body once here
        switch (response.statusCode) {
          case 200:
            final dynamic jsonData = json.decode(response.body);
            final GenrateOptResponceModel responseModel =
            GenrateOptResponceModel.fromJson(jsonData);
            return Success(responseModel);

          case 401:
          // Handle 401 unauthorized error
            await handle401(context);
            return Failure(ApiException(response.statusCode, "Unauthorized"));
          default:
          // 3. return Failure with the desired exception
            return Failure(ApiException(response.statusCode, ""));
        }
      } else {
        return Failure(Exception("No Internet connection"));
      }
    } on Exception catch (e) {
      // 4. return Failure here too
      return Failure(e);
    }
  }

  Future<Result<VerifyOtpResponse, Exception>> verifyOtp(
      VarifayOtpRequest verifayOtp) async {
    try {
      if (await internetConnectivity.networkConnectivity()) {
        final prefsUtil = await SharedPref.getInstance();
        var base_url = prefsUtil.getString(BASE_URL);
        final response = await interceptor.post(
            Uri.parse(base_url! + apiUrls.leadMobileValidate),
            headers: {
              'Content-Type': 'application/json',
            },
            body: json.encode(verifayOtp));
        print(response.body); // Print the response body once here
        switch (response.statusCode) {
          case 200:
            final dynamic jsonData = json.decode(response.body);
            final VerifyOtpResponse responseModel =
                VerifyOtpResponse.fromJson(jsonData);
            return Success(responseModel);

          default:
            return Failure(ApiException(response.statusCode, ""));
        }
      } else {
        return Failure(Exception("No Internet connection"));
      }
    } on Exception catch (e) {
      return Failure(e);
    }
  }

  Future<Result<GetUserProfileResponse, Exception>> getUserData(String userId, String mobile) async {
    try {
      if (await internetConnectivity.networkConnectivity()) {
        final prefsUtil = await SharedPref.getInstance();
        var base_url = prefsUtil.getString(BASE_URL);
        var token = prefsUtil.getString(TOKEN);
        final response = await interceptor.get(
          Uri.parse('${base_url! + apiUrls.getUserData}?UserId=$userId&Mobile=$mobile'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token'
          },
        );
        print(response.body); // Print the response body once here
        switch (response.statusCode) {
          case 200:
            final dynamic jsonData = json.decode(response.body);
            final GetUserProfileResponse responseModel =
            GetUserProfileResponse.fromJson(jsonData);
            return Success(responseModel);
          default:
            return Failure(ApiException(response.statusCode, ""));
        }
      } else {
        return Failure(Exception("No Internet connection"));
      }
    } on Exception catch (e) {
      return Failure(e);
    }
  }

  Future<Result<LeadMobileNoResModel, Exception>> GetLeadByMobileNo(String userId, String mobile) async {
    try {
      if (await internetConnectivity.networkConnectivity()) {
        final prefsUtil = await SharedPref.getInstance();
        var base_url = prefsUtil.getString(BASE_URL);
        var token = prefsUtil.getString(TOKEN);
        final response = await interceptor.post(
          Uri.parse('${base_url! + apiUrls.GetLeadByMobileNo}?UserId=$userId&Mobile=$mobile'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token'
          },
        );
        print(response.body); // Print the response body once here
        switch (response.statusCode) {
          case 200:
            final dynamic jsonData = json.decode(response.body);
            final LeadMobileNoResModel responseModel =
            LeadMobileNoResModel.fromJson(jsonData);
            return Success(responseModel);
          default:
            return Failure(ApiException(response.statusCode, ""));
        }
      } else {
        return Failure(Exception("No Internet connection"));
      }
    } on Exception catch (e) {
      return Failure(e);
    }
  }

  Future<PostSingleFileResponseModel> postSingleFile(
    File file,
    bool isValidForLifeTime,
    String? validityInDays,
    String? subFolderName,
  ) async {
    if (await internetConnectivity.networkConnectivity()) {
      final prefsUtil = await SharedPref.getInstance();
      var base_url = prefsUtil.getString(BASE_URL);
      try {
        var request = http.MultipartRequest(
          'POST',
          Uri.parse('${base_url! + apiUrls.postSingleFile}'),
        );

        // Add file to the request
        var filePart = await http.MultipartFile.fromPath(
          'FileDetails', // Field name for the file
          file.path,
          filename: file.path.split('/').last,
        );
        request.files.add(filePart);

        // Add other form fields to the request
        request.fields['IsValidForLifeTime'] = isValidForLifeTime.toString();
        if (validityInDays != null) {
          request.fields['ValidityInDays'] = validityInDays;
        }
        if (subFolderName != null) {
          request.fields['SubFolderName'] = subFolderName;
        }

        // Send the request using a http.Client
        var client = http.Client();
        var streamedResponse = await client.send(request);

        // Get the response as a string
        var responseString = await streamedResponse.stream.bytesToString();

        // Check the response status code
        if (streamedResponse.statusCode == 200) {
          // Parse the JSON response
          var jsonData = jsonDecode(responseString);
          var responseModel = PostSingleFileResponseModel.fromJson(jsonData);
          return responseModel;
        } else {
          throw Exception(
              'Failed to upload file: ${streamedResponse.reasonPhrase}');
        }
      } catch (e) {
        throw Exception('Error uploading file: $e');
      }
    } else {
      throw Exception('No internet connection');
    }
  }

  //panCard Module
  Future<Result<ValidPanCardResponsModel, Exception>> getLeadValidPanCard(
      String panNumber) async {
    try {
      if (await internetConnectivity.networkConnectivity()) {
        final prefsUtil = await SharedPref.getInstance();
        var base_url = prefsUtil.getString(BASE_URL);
        var token = await prefsUtil.getString(TOKEN);
        final response = await interceptor.get(
          Uri.parse(
              '${base_url! + apiUrls.getLeadValidPanCard}?PanNumber=$panNumber'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token'
            // Set the content type as JSON
          },
        );

        print(response.body); // Print the response body once here
        switch (response.statusCode) {
        // Parse the JSON response
          case 200:
            final dynamic jsonData = json.decode(response.body);
            final ValidPanCardResponsModel responseModel =
            ValidPanCardResponsModel.fromJson(jsonData);
            return Success(responseModel);
          default:
          // 3. return Failure with the desired exception
            return Failure(ApiException(response.statusCode, ""));
        }
      } else {
        return Failure(Exception("No Internet connection"));
      }
    } on Exception catch (e) {
      return Failure(e);
    }
  }

  Future<Result<FathersNameByValidPanCardResponseModel, Exception>>
  getFathersNameByValidPanCard(String panNumber) async {
    try {
      if (await internetConnectivity.networkConnectivity()) {
        final prefsUtil = await SharedPref.getInstance();
        var base_url = prefsUtil.getString(BASE_URL);
        var token = await prefsUtil.getString(TOKEN);
        final response = await interceptor.get(
          Uri.parse(
              '${base_url! + apiUrls.getFathersNameByValidPanCard}?PanNumber=$panNumber'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token'
            // Set the content type as JSON
          },
        );
        print(response.body); // Print the response body once here
        switch (response.statusCode) {
          case 200:
          // Parse the JSON response
            final dynamic jsonData = json.decode(response.body);
            final FathersNameByValidPanCardResponseModel responseModel =
            FathersNameByValidPanCardResponseModel.fromJson(jsonData);
            return Success(responseModel);
          default:
            return Failure(ApiException(response.statusCode, ""));
        }
      } else {
        return Failure(Exception("No Internet connection"));
      }
    } on Exception catch (e) {
      return Failure(e);
    }
  }

  Future<Result<PostLeadPanResponseModel, Exception>> postLeadPAN(
      PostLeadPanRequestModel postLeadPanRequestModel) async {
    try {
      if (await internetConnectivity.networkConnectivity()) {
        final prefsUtil = await SharedPref.getInstance();
         var base_url = prefsUtil.getString(BASE_URL);
        var token = await prefsUtil.getString(TOKEN);

        final response = await interceptor.post(
            Uri.parse('${base_url! + apiUrls.postLeadPAN}'),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token'
              // Set the content type as JSON// Set the content type as JSON
            },
            body: json.encode(postLeadPanRequestModel));
        //print(json.encode(leadCurrentRequestModel));
        print(response.body); // Print the response body once here
        switch (response.statusCode) {
          case 200:
          // Parse the JSON response
            final dynamic jsonData = json.decode(response.body);
            final PostLeadPanResponseModel responseModel =
            PostLeadPanResponseModel.fromJson(jsonData);
            return Success(responseModel);

          default:
            return Failure(ApiException(response.statusCode, ""));
        }
      } else {
        return Failure(Exception("No Internet connection"));
      }
    } on Exception catch (e) {
      return Failure(e);
    }
  }

  Future<Result<LeadPanResponseModel, Exception>> getLeadPAN(
      String userId, String productCode) async {
    try {
      if (await internetConnectivity.networkConnectivity()) {
        final prefsUtil = await SharedPref.getInstance();
        var base_url = prefsUtil.getString(BASE_URL);
        final response = await interceptor.get(Uri.parse(
            '${base_url! + apiUrls.getLeadPAN}?UserId=$userId&productCode=$productCode'));
        print(response.body); // Print the response body once here
        switch (response.statusCode) {
          case 200:
          // Parse the JSON response
            final dynamic jsonData = json.decode(response.body);
            final LeadPanResponseModel responseModel =
            LeadPanResponseModel.fromJson(jsonData);
            return Success(responseModel);

          default:
            return Failure(ApiException(response.statusCode, ""));
        }
      } else {
        return Failure(Exception("No Internet connection"));
      }
    } on Exception catch (e) {
      return Failure(e);
    }
  }

  //aadhaar module
  Future<Result<LeadAadhaarResponse, Exception>> getLeadAadhar(
      String userId, String productCode) async {
    try {
      if (await internetConnectivity.networkConnectivity()) {
        final prefsUtil = await SharedPref.getInstance();
        var base_url = prefsUtil.getString(BASE_URL);
        var token = await prefsUtil.getString(TOKEN);
        final response = await interceptor.get(
          Uri.parse(
              '${base_url! + apiUrls.getLeadAadhar}?UserId=$userId&productCode=$productCode'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token'
          },
        );
        print(response.body); // Print the response body once here
        switch (response.statusCode) {
          case 200:
          // Parse the JSON response
            final dynamic jsonData = json.decode(response.body);
            final LeadAadhaarResponse responseModel =
            LeadAadhaarResponse.fromJson(jsonData);
            return Success(responseModel);

          default:
            return Failure(ApiException(response.statusCode, ""));
        }
      } else {
        return Failure(Exception("No Internet connection"));
      }
    } on Exception catch (e) {
      return Failure(e);
    }
  }

  Future<Result<AadhaarGenerateOTPResponseModel, Exception>>
  getLeadAadharGenerateOTP(
      AadhaarGenerateOTPRequestModel aadhaarGenerateOTPRequestModel) async {
    try {
      if (await internetConnectivity.networkConnectivity()) {
        final prefsUtil = await SharedPref.getInstance();
        var base_url = prefsUtil.getString(BASE_URL);
        var token = await prefsUtil.getString(TOKEN);
        final response = await interceptor.post(
            Uri.parse('${base_url! + apiUrls.getLeadAadharGenerateOTP}'),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token'
            },
            body: json.encode(aadhaarGenerateOTPRequestModel));
        print(response.body); // Print the response body once here
        switch (response.statusCode) {
          case 200:
            final dynamic jsonData = json.decode(response.body);
            final AadhaarGenerateOTPResponseModel responseModel =
            AadhaarGenerateOTPResponseModel.fromJson(jsonData);
            return Success(responseModel);
          default:
            return Failure(ApiException(response.statusCode, ""));
        }
      } else {
        return Failure(Exception("No Internet connection"));
      }
    } on Exception catch (e) {
      return Failure(e);
    }
  }

  Future<Result<ValidateAadhaarOTPResponseModel, Exception>> validateAadhaarOtp(
      ValidateAadhaarOTPRequestModel validateAadhaarOTPRequestModel) async {
    try {
      if (await internetConnectivity.networkConnectivity()) {
        final prefsUtil = await SharedPref.getInstance();
        var base_url = prefsUtil.getString(BASE_URL);
        var token = await prefsUtil.getString(TOKEN);

        final response = await interceptor.post(
            Uri.parse(base_url! + apiUrls.postLeadAadharVerifyOTP),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token'
            },
            body: json.encode(validateAadhaarOTPRequestModel));
        print(response.body); // Print the response body once here
        switch (response.statusCode) {
          case 200:
            final dynamic jsonData = json.decode(response.body);
            final ValidateAadhaarOTPResponseModel responseModel =
            ValidateAadhaarOTPResponseModel.fromJson(jsonData);
            return Success(responseModel);
          default:
            return Failure(ApiException(response.statusCode, ""));
        }
      } else {
        return Failure(Exception("No Internet connection"));
      }
    } on Exception catch (e) {
      return Failure(e);
    }
  }

  //Selfie module
  Future<Result<LeadSelfieResponseModel, Exception>> getLeadSelfie(
      String userId, productCode) async {
    try {
      if (await internetConnectivity.networkConnectivity()) {
        final prefsUtil = await SharedPref.getInstance();
        var base_url = prefsUtil.getString(BASE_URL);
        var token = await prefsUtil.getString(TOKEN);
        final response = await interceptor.get(
          Uri.parse(
              '${base_url! + apiUrls.getLeadSelfie}?UserId=$userId&productCode=$productCode'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token'
          },
        );
        print(response.body); // Print the response body once here
        switch (response.statusCode) {
          case 200:
          // Parse the JSON response
            final dynamic jsonData = json.decode(response.body);
            final LeadSelfieResponseModel responseModel =
            LeadSelfieResponseModel.fromJson(jsonData);
            return Success(responseModel);

          default:
            return Failure(ApiException(response.statusCode, ""));
        }
      } else {
        return Failure(Exception("No Internet connection"));
      }
    } on Exception catch (e) {
      return Failure(e);
    }
  }

  Future<Result<PostLeadSelfieResponseModel, Exception>> postLeadSelfie(
      PostLeadSelfieRequestModel postLeadSelfieRequestModel) async {
    try {
      if (await internetConnectivity.networkConnectivity()) {
        final prefsUtil = await SharedPref.getInstance();
        var base_url = prefsUtil.getString(BASE_URL);
        var token = await prefsUtil.getString(TOKEN);
        final response = await interceptor.post(
            Uri.parse(base_url! + apiUrls.postLeadSelfie),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token'
            },
            body: json.encode(postLeadSelfieRequestModel));
        print(response.body); // Print the response body once here
        switch (response.statusCode) {
          case 200:
            final dynamic jsonData = json.decode(response.body);
            final PostLeadSelfieResponseModel responseModel =
            PostLeadSelfieResponseModel.fromJson(jsonData);
            return Success(responseModel);
          default:
            return Failure(ApiException(response.statusCode, ""));
        }
      } else {
        return Failure(Exception("No Internet connection"));
      }
    } on Exception catch (e) {
      return Failure(e);
    }
  }

  //personal info module
  Future<Result<PersonalDetailsResponce, Exception>> getLeadPersnalDetails(
      String userId, String productCode) async {
    try {
      if (await internetConnectivity.networkConnectivity()) {
        final prefsUtil = await SharedPref.getInstance();
        var base_url = prefsUtil.getString(BASE_URL);
        var token = await prefsUtil.getString(TOKEN);
        final response = await interceptor.get(
          Uri.parse(
              '${base_url! + apiUrls.GetLeadPersonalDetail}?UserId=$userId&productCode=$productCode'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token'
          },
        );
        print(response.body); // Print the response body once here
        switch (response.statusCode) {
          case 200:
          // Parse the JSON response
            final dynamic jsonData = json.decode(response.body);
            final PersonalDetailsResponce responseModel =
            PersonalDetailsResponce.fromJson(jsonData);
            return Success(responseModel);

          default:
            return Failure(ApiException(response.statusCode, ""));
        }
      } else {
        return Failure(Exception("No Internet connection"));
      }
    } on Exception catch (e) {
      return Failure(e);
    }
  }

  Future<PostPersonalDetailsResponseModel> postLeadPersonalDetail(
      PersonalDetailsRequestModel personalDetailsRequestModel,
      BuildContext context) async {
    if (await internetConnectivity.networkConnectivity()) {
      final prefsUtil = await SharedPref.getInstance();
      var base_url = prefsUtil.getString(BASE_URL);
      var token = prefsUtil.getString(TOKEN);
      final response = await interceptor.post(
          Uri.parse(base_url! + apiUrls.PostLeadPersonalDetail),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token'
            // Set the content type as JSON// Set the content type as JSON
          },
          body: json.encode(personalDetailsRequestModel));
      print(response.body); // Print the response body once here
      if (response.statusCode == 200) {
        final dynamic jsonData = json.decode(response.body);
        final PostPersonalDetailsResponseModel responseModel =
        PostPersonalDetailsResponseModel.fromJson(jsonData);
        return responseModel;
      }
      if (response.statusCode == 401) {
        // Handle 401 unauthorized error
        await handle401(context);
        throw Exception('Failed to load products');
      } else {
        throw Exception('Failed to load products');
      }
    } else {
      throw Exception('No internet connection');
    }
  }

  Future<ValidEmResponce> otpValidateForEmail(
      OtpValidateForEmailRequest model) async {
    if (await internetConnectivity.networkConnectivity()) {
      final prefsUtil = await SharedPref.getInstance();
      var base_url = prefsUtil.getString(BASE_URL);
      final response = await interceptor.post(
          Uri.parse('${base_url! + apiUrls.OTPValidateForEmail}'),
          headers: {
            'Content-Type': 'application/json', // Set the content type as JSON
          },
          body: json.encode(model));
      //print(json.encode(leadCurrentRequestModel));
      print(response.body); // Print the response body once here
      if (response.statusCode == 200) {
        // Parse the JSON response
        final dynamic jsonData = json.decode(response.body);
        final ValidEmResponce responseModel =
        ValidEmResponce.fromJson(jsonData);
        return responseModel;
      } else {
        throw Exception('Failed to load products');
      }
    } else {
      throw Exception('No internet connection');
    }
  }

  Future<EmailExistRespoce> emailExist(String userID, String EmailId) async {
    if (await internetConnectivity.networkConnectivity()) {
      final prefsUtil = await SharedPref.getInstance();
      var base_url = prefsUtil.getString(BASE_URL);
      final response = await interceptor.get(
        Uri.parse(
            '${base_url! + apiUrls.EmailExist}?UserId=$userID&EmailId=$EmailId'),
        headers: {
          'Content-Type': 'application/json', // Set the content type as JSON
        },
      );
      //print(json.encode(leadCurrentRequestModel));
      print(response.body); // Print the response body once here
      if (response.statusCode == 200) {
        // Parse the JSON response
        final dynamic jsonData = json.decode(response.body);
        final EmailExistRespoce responseModel =
        EmailExistRespoce.fromJson(jsonData);
        return responseModel;
      } else {
        throw Exception('Failed to load products');
      }
    } else {
      throw Exception('No internet connection');
    }
  }

  Future<SendOtpOnEmailResponce> sendOtpOnEmail(String EmailId) async {
    if (await internetConnectivity.networkConnectivity()) {
      final prefsUtil = await SharedPref.getInstance();
      var base_url = prefsUtil.getString(BASE_URL);
      final response = await interceptor.get(
        Uri.parse('${base_url! + apiUrls.SendOtpOnEmail}?email=$EmailId'),
        headers: {
          'Content-Type': 'application/json', // Set the content type as JSON
        },
      );
      //print(json.encode(leadCurrentRequestModel));
      print(response.body); // Print the response body once here
      if (response.statusCode == 200) {
        // Parse the JSON response
        final dynamic jsonData = json.decode(response.body);
        final SendOtpOnEmailResponce responseModel =
        SendOtpOnEmailResponce.fromJson(jsonData);
        return responseModel;
      } else {
        throw Exception('Failed to load products');
      }
    } else {
      throw Exception('No internet connection');
    }
  }

  Future<Result<IvrsResModel, Exception>>? getIvrsNumberExist(
      String userId, String IvrsNumber) async {
    try {
      if (await internetConnectivity.networkConnectivity()) {
        final prefsUtil = await SharedPref.getInstance();
        var base_url = prefsUtil.getString(BASE_URL);
        final response = await interceptor.get(Uri.parse(
            '${base_url! + apiUrls.getIvrsNumberExist}?UserId=$userId&IVRSNumber=$IvrsNumber'));
        print(response.body); // Print the response body once here
        switch (response.statusCode) {
          case 200:
          // Parse the JSON response
            final dynamic jsonData = json.decode(response.body);
            final IvrsResModel responseModel = IvrsResModel.fromJson(jsonData);
            return Success(responseModel);

          default:
            return Failure(ApiException(response.statusCode, ""));
        }
      } else {
        return Failure(Exception("No Internet connection"));
      }
    } on Exception catch (e) {
      return Failure(e);
    }
  }

  Future<Result<List<ElectricityServiceProviderListResModel>, Exception>>
  getKarzaElectricityServiceProviderList() async {
    try {
      if (await internetConnectivity.networkConnectivity()) {
        final prefsUtil = await SharedPref.getInstance();
        var base_url = prefsUtil.getString(BASE_URL);
        final response = await interceptor.get(Uri.parse(
            '${base_url! + apiUrls.getKarzaElectricityServiceProviderList}'));
        print(response.body);
        // Print the response body once here
        switch (response.statusCode) {
          case 200:
            final dynamic jsonData = json.decode(response.body);
            final List<ElectricityServiceProviderListResModel> responseModel =
            List<ElectricityServiceProviderListResModel>.from(jsonData.map(
                    (model) => ElectricityServiceProviderListResModel.fromJson(
                    model)));
            return Success(responseModel);
          default:
            return Failure(ApiException(response.statusCode, ""));
        }
      } else {
        return Failure(Exception("No Internet connection"));
      }
    } on Exception catch (e) {
      return Failure(e);
    }
  }

  Future<Result<List<ElectricityStateResModel>, Exception>>
  getKarzaElectricityState(String state) async {
    try {
      if (await internetConnectivity.networkConnectivity()) {
        final prefsUtil = await SharedPref.getInstance();
        var base_url = prefsUtil.getString(BASE_URL);
        final response = await interceptor.get(Uri.parse(
            '${base_url! + apiUrls.getKarzaElectricityState}?state=$state'));
        print(response.body);
        // Print the response body once here
        switch (response.statusCode) {
          case 200:
            final dynamic jsonData = json.decode(response.body);
            final List<ElectricityStateResModel> responseModel =
            List<ElectricityStateResModel>.from(jsonData
                .map((model) => ElectricityStateResModel.fromJson(model)));
            return Success(responseModel);
          default:
            return Failure(ApiException(response.statusCode, ""));
        }
      } else {
        return Failure(Exception("No Internet connection"));
      }
    } on Exception catch (e) {
      return Failure(e);
    }
  }

  Future<Result<ElectricityAuthenticationResModel, Exception>>
  getKarzaElectricityAuthentication(
      ElectricityAuthenticationReqModel
      electricityAuthenticationReqModel) async {
    try {
      if (await internetConnectivity.networkConnectivity()) {
        final prefsUtil = await SharedPref.getInstance();
        var base_url = prefsUtil.getString(BASE_URL);
        var token = prefsUtil.getString(TOKEN);
        final response = await interceptor.post(
            Uri.parse(
                '${base_url! + apiUrls.getKarzaElectricityAuthentication}'),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token'
              // Set the content type as JSON// Set the content type as JSON
            },
            body: json.encode(electricityAuthenticationReqModel));
        //print(json.encode(leadCurrentRequestModel));
        print(response.body); // Print the response body once here
        switch (response.statusCode) {
          case 200:
          // Parse the JSON response
            final dynamic jsonData = json.decode(response.body);
            final ElectricityAuthenticationResModel responseModel =
            ElectricityAuthenticationResModel.fromJson(jsonData);
            return Success(responseModel);

          default:
            return Failure(ApiException(response.statusCode, ""));
        }
      } else {
        return Failure(Exception("No Internet connection"));
      }
    } on Exception catch (e) {
      return Failure(e);
    }
  }

  Future<Result<CustomerDetailUsingGstResponseModel, Exception>>
      getCustomerDetailUsingGST(String GSTNumber) async {
    try {
      if (await internetConnectivity.networkConnectivity()) {
        final prefsUtil = await SharedPref.getInstance();
        var token = prefsUtil.getString(TOKEN);
        var base_url = prefsUtil.getString(BASE_URL);
        final response = await interceptor.get(
          Uri.parse(
              '${base_url! + apiUrls.getCustomerDetailUsingGST}?GSTNO=$GSTNumber'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token'
          },
        );
        print(response.body); // Print the response body once here
        switch (response.statusCode) {
          case 200:
            // Parse the JSON response
            final dynamic jsonData = json.decode(response.body);
            final CustomerDetailUsingGstResponseModel responseModel =
                CustomerDetailUsingGstResponseModel.fromJson(jsonData);
            return Success(responseModel);

          default:
            return Failure(ApiException(response.statusCode, ""));
        }
      } else {
        return Failure(Exception("No Internet connection"));
      }
    } on Exception catch (e) {
      return Failure(e);
    }



    /*if (await internetConnectivity.networkConnectivity()) {
      final prefsUtil = await SharedPref.getInstance();
      var base_url = prefsUtil.getString(BASE_URL);
      final response = await interceptor.get(Uri.parse(
          '${base_url + apiUrls.getCustomerDetailUsingGST}?GSTNO=$GSTNumber'));
      print(response.body); // Print the response body once here
      if (response.statusCode == 200) {
        // Parse the JSON response
        final dynamic jsonData = json.decode(response.body);

        final CustomerDetailUsingGstResponseModel responseModel =
        CustomerDetailUsingGstResponseModel.fromJson(jsonData);
        return responseModel;
      } else {
        throw Exception('Failed to load products');
      }
    } else {
      throw Exception('No internet connection');
    }*/
  }


  //Business Detail Module
/*  Future<LeadBusinessDetailResponseModel> getLeadBusinessDetail(
      String userId, String productCode) async {
    if (await internetConnectivity.networkConnectivity()) {
      final prefsUtil = await SharedPref.getInstance();
      var base_url = prefsUtil.getString(BASE_URL);
      final response = await interceptor.get(Uri.parse(
          '${base_url + apiUrls.getLeadBusinessDetail}?UserId=$userId&productCode=$productCode'));
      print(response.body); // Print the response body once here
      if (response.statusCode == 200) {
        // Parse the JSON response
        final dynamic jsonData = json.decode(response.body);

        final LeadBusinessDetailResponseModel responseModel =
            LeadBusinessDetailResponseModel.fromJson(jsonData);
        return responseModel;
      } else {
        throw Exception('Failed to load products');
      }
    } else {
      throw Exception('No internet connection');
    }
  }

  Future<CustomerDetailUsingGstResponseModel> getCustomerDetailUsingGST(
      String GSTNumber) async {
    if (await internetConnectivity.networkConnectivity()) {
      final prefsUtil = await SharedPref.getInstance();
      var base_url = prefsUtil.getString(BASE_URL);
      final response = await interceptor.get(Uri.parse(
          '${base_url + apiUrls.getCustomerDetailUsingGST}?GSTNO=$GSTNumber'));
      print(response.body); // Print the response body once here
      if (response.statusCode == 200) {
        // Parse the JSON response
        final dynamic jsonData = json.decode(response.body);

        final CustomerDetailUsingGstResponseModel responseModel =
            CustomerDetailUsingGstResponseModel.fromJson(jsonData);
        return responseModel;
      } else {
        throw Exception('Failed to load products');
      }
    } else {
      throw Exception('No internet connection');
    }
  }

  Future<Result<PostLeadBuisnessDetailResponsModel,Exception>> postLeadBuisnessDetail(
      PostLeadBuisnessDetailRequestModel
          postLeadBuisnessDetailRequestModel) async {
    if (await internetConnectivity.networkConnectivity()) {
      final prefsUtil = await SharedPref.getInstance();
      var base_url = prefsUtil.getString(BASE_URL);
      var token = await prefsUtil.getString(TOKEN);
      final response = await interceptor.post(
          Uri.parse('${base_url + apiUrls.postLeadBuisnessDetail}'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token'
            // Set the content type as JSON// Set the content type as JSON
          },
          body: json.encode(postLeadBuisnessDetailRequestModel));
      //print(json.encode(leadCurrentRequestModel));
      print(response.body); // Print the response body once here
      if (response.statusCode == 200) {
        // Parse the JSON response
        final dynamic jsonData = json.decode(response.body);
        final PostLeadBuisnessDetailResponsModel responseModel =
            PostLeadBuisnessDetailResponsModel.fromJson(jsonData);
        return Success(responseModel);
      }
      if (response.statusCode == 401) {
        return Failure(ApiException(response.statusCode, ""));
      } else {
        throw Exception('Failed to load products');
      }
    } else {
      throw Exception('No internet connection');
    }
  }*/

  //Bank DetailsModule
  Future<BankListResponceModel> getBankList() async {
    if (await internetConnectivity.networkConnectivity()) {
      final prefsUtil = await SharedPref.getInstance();
      var base_url = prefsUtil.getString(BASE_URL);
      final response = await interceptor.get(
        Uri.parse('${base_url! + apiUrls.bankListApi}'),
        headers: {
          'Content-Type': 'application/json', // Set the content type as JSON
        },
      );
      //print(json.encode(leadCurrentRequestModel));
      print(response.body); // Print the response body once here
      if (response.statusCode == 200) {
        // Parse the JSON response
        final dynamic jsonData = json.decode(response.body);
        final BankListResponceModel responseModel =
        BankListResponceModel.fromJson(jsonData);
        return responseModel;
      } else {
        throw Exception('Failed to load products');
      }
    } else {
      throw Exception('No internet connection');
    }
  }

  Future<Result<BankDetailsResponceModel, Exception>> GetLeadBankDetail(
      int leadID, String productCode) async {
    try {
      if (await internetConnectivity.networkConnectivity()) {
        final prefsUtil = await SharedPref.getInstance();
        var base_url = prefsUtil.getString(BASE_URL);
        final response = await interceptor.get(
          Uri.parse('${base_url! + apiUrls.GetLeadBankDetail}?LeadId=$leadID'),
          headers: {
            'Content-Type': 'application/json', // Set the content type as JSON
          },
        );
        //print(json.encode(leadCurrentRequestModel));
        print(response.body); // Print the response body once here
        switch (response.statusCode) {
          case 200:
          // Parse the JSON response
            final dynamic jsonData = json.decode(response.body);
            final BankDetailsResponceModel responseModel =
            BankDetailsResponceModel.fromJson(jsonData);
            return Success(responseModel);

          default:
            return Failure(ApiException(response.statusCode, ""));
        }
      } else {
        return Failure(Exception("No Internet connection"));
      }
    } on Exception catch (e) {
      return Failure(e);
    }
  }

  Future<Result<SaveBankDetailResponce, Exception>> saveLeadBankDetail(
      SaveBankDetailsRequestModel model) async {
    try {
      if (await internetConnectivity.networkConnectivity()) {
        final prefsUtil = await SharedPref.getInstance();
        var base_url = prefsUtil.getString(BASE_URL);
        var token = prefsUtil.getString(TOKEN);
        final response = await interceptor.post(
            Uri.parse(base_url! + apiUrls.saveLeadBankDetail),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token'
              // Set the content type as JSON// Set the content type as JSON
            },
            body: json.encode(model));
        print(response.body); // Print the response body once here
        switch (response.statusCode) {
          case 200:
            final dynamic jsonData = json.decode(response.body);
            final SaveBankDetailResponce responseModel =
            SaveBankDetailResponce.fromJson(jsonData);
            return Success(responseModel);
          default:
            return Failure(ApiException(response.statusCode, ""));
        }
      } else {
        return Failure(Exception("No Internet connection"));
      }
    } on Exception catch (e) {
      return Failure(e);
    }
  }

  Future<AllStateResponce> getAllState() async {
    if (await internetConnectivity.networkConnectivity()) {
      final prefsUtil = await SharedPref.getInstance();
      var base_url = prefsUtil.getString(BASE_URL);
      final response = await interceptor.get(
        Uri.parse('${base_url! + apiUrls.GetAllState}'),
        headers: {
          'Content-Type': 'application/json', // Set the content type as JSON
        },
      );
      //print(json.encode(leadCurrentRequestModel));
      print(response.body); // Print the response body once here
      if (response.statusCode == 200) {
        // Parse the JSON response
        final dynamic jsonData = json.decode(response.body);
        final AllStateResponce responseModel =
        AllStateResponce.fromJson(jsonData);
        return responseModel;
      } else {
        throw Exception('Failed to load products');
      }
    } else {
      throw Exception('No internet connection');
    }
  }

  Future<List<CityResponce>> GetCityByStateId(int stateID) async {
    if (await internetConnectivity.networkConnectivity()) {
      final prefsUtil = await SharedPref.getInstance();
      var base_url = prefsUtil.getString(BASE_URL);
      final response = await interceptor.get(
        Uri.parse('${base_url! + apiUrls.GetCityByStateId}?stateId=$stateID'),
        headers: {
          'Content-Type': 'application/json', // Set the content type as JSON
        },
      );
      //print(json.encode(leadCurrentRequestModel));
      print(response.body); // Print the response body once here
      if (response.statusCode == 200) {
        // Parse the JSON response
        final dynamic jsonData = json.decode(response.body);
        final List<CityResponce> responseModel = List<CityResponce>.from(
            jsonData.map((model) => CityResponce.fromJson(model)));
        return responseModel;
      } else {
        throw Exception('Failed to load products');
      }
    } else {
      throw Exception('No internet connection');
    }
  }

//other module
/*Future<Result<OfferResponceModel, Exception>> GetLeadOffer(
      int leadId, int companyID) async {
    try {
      if (await internetConnectivity.networkConnectivity()) {
        final prefsUtil = await SharedPref.getInstance();
        var base_url = prefsUtil.getString(BASE_URL);
        final response = await interceptor.get(Uri.parse(
            '${base_url + apiUrls.GetLeadOffer}?LeadId=$leadId&companyId=$companyID'));
        print(response.body); // Print the response body once here
        switch (response.statusCode) {
          case 200:
            final dynamic jsonData = json.decode(response.body);
            final OfferResponceModel responseModel =
                OfferResponceModel.fromJson(jsonData);
            return Success(responseModel);

          default:
            return Failure(ApiException(response.statusCode, ""));
        }
      } else {
        return Failure(Exception("No Internet connection"));
      }
    } on Exception catch (e) {
      return Failure(e);
    }
  }

  Future<Result<OfferPersonNameResponceModel, Exception>> getLeadName(
      String UserId, String productcode) async {
    try {
      if (await internetConnectivity.networkConnectivity()) {
        final prefsUtil = await SharedPref.getInstance();
        var base_url = prefsUtil.getString(BASE_URL);
        final response = await interceptor.get(Uri.parse(
            '${base_url + apiUrls.GetLeadName}?UserId=$UserId&productCode=$productcode'));
        print(response.body); // Print the response body once here
        switch (response.statusCode) {
          case 200:
            final dynamic jsonData = json.decode(response.body);
            final OfferPersonNameResponceModel responseModel =
                OfferPersonNameResponceModel.fromJson(jsonData);
            return Success(responseModel);

          default:
            // 3. return Failure with the desired exception
            return Failure(ApiException(response.statusCode, ""));
        }
      } else {
        return Failure(Exception("No Internet connection"));
      }
    } on Exception catch (e) {
      return Failure(e);
    }
  }

  Future<Result<AcceptedResponceModel, Exception>> getAcceptOffer(
      int leadId) async {
    try {
      if (await internetConnectivity.networkConnectivity()) {
        final prefsUtil = await SharedPref.getInstance();
        var base_url = prefsUtil.getString(BASE_URL);
        var token = prefsUtil.getString(TOKEN);
        final response = await interceptor.get(
            Uri.parse('${base_url + apiUrls.AcceptOffer}?leadId=$leadId'));
        print(response.body); // Print the response body once here
        switch (response.statusCode) {
          case 200:
            final dynamic jsonData = json.decode(response.body);
            final AcceptedResponceModel responseModel =
                AcceptedResponceModel.fromJson(jsonData);
            return Success(responseModel);
          default:
            // 3. return Failure with the desired exception
            return Failure(ApiException(response.statusCode, ""));
        }
      } else {
        return Failure(Exception("No Internet connection"));
      }
    } on Exception catch (e) {
      return Failure(e);
    }
  }

  Future<Result<CheckSignResponceModel, Exception>> checkEsignStatus(
      int leadId) async {
    try {
      if (await internetConnectivity.networkConnectivity()) {
        final prefsUtil = await SharedPref.getInstance();
        var base_url = prefsUtil.getString(BASE_URL);
        var token = prefsUtil.getString(TOKEN);
        final response = await interceptor.get(Uri.parse(
            '${base_url + apiUrls.CheckEsignStatus}?leadId=$leadId'));
        print(response.body); // Print the response body once here

        switch (response.statusCode) {
          case 200:
            final data = json.decode(response.body);
            // 2. return Success with the desired value
            return Success(CheckSignResponceModel.fromJson(data));
          default:
            // 3. return Failure with the desired exception
            return Failure(ApiException(response.statusCode, ""));
        }
      } else {
        throw Exception('No internet connection');
      }
    } on Exception catch (e) {
      // 4. return Failure here too
      return Failure(e);
    }
  }

  Future<AggrementDetailsResponce> GetAgreemetDetail(
      int leadId, bool accept, int companyID) async {
    if (await internetConnectivity.networkConnectivity()) {
      final prefsUtil = await SharedPref.getInstance();
      var base_url = prefsUtil.getString(BASE_URL);
      var token = prefsUtil.getString(TOKEN);
      final response = await interceptor.get(Uri.parse(
          '${base_url + apiUrls.GetAgreemetDetail}?leadId=$leadId&IsAccept=$accept&companyId=$companyID'));
      print(response.body); // Print the response body once here
      if (response.statusCode == 200) {
        final dynamic jsonData = json.decode(response.body);
        final AggrementDetailsResponce responseModel =
            AggrementDetailsResponce.fromJson(jsonData);
        return responseModel;
      }
      if (response.statusCode == 401) {
        throw Exception('Failed to load products');
      } else {
        throw Exception('Failed to load products');
      }
    } else {
      throw Exception('No internet connection');
    }
  }

  Future<Result<DisbursementResponce, Exception>> GetDisbursementProposal(
      int leadId) async {
    try {
      if (await internetConnectivity.networkConnectivity()) {
        final prefsUtil = await SharedPref.getInstance();
        var base_url = prefsUtil.getString(BASE_URL);
        final response = await interceptor.get(Uri.parse(
            '${base_url + apiUrls.GetDisbursementProposal}?leadId=$leadId'));
        print(response.body); //
        // Print the response body once here
        switch (response.statusCode) {
          case 200:
            final data = json.decode(response.body);
            // 2. return Success with the desired value
            return Success(DisbursementResponce.fromJson(data));
          default:
            // 3. return Failure with the desired exception
            return Failure(ApiException(response.statusCode, ""));
        }
      } else {
        throw Exception('No internet connection');
      }
    } on Exception catch (e) {
      // 4. return Failure here too
      return Failure(e);
    }
  }

  Future<Result<DisbursementCompletedResponse, Exception>> GetDisbursement(
      int leadId) async {
    try {
      if (await internetConnectivity.networkConnectivity()) {
        final prefsUtil = await SharedPref.getInstance();
        var base_url = prefsUtil.getString(BASE_URL);
        final response = await interceptor.get(
            Uri.parse('${base_url + apiUrls.GetDisbursement}?leadId=$leadId'));
        print(response.body); //
        // Print the response body once here
        switch (response.statusCode) {
          case 200:
            final data = json.decode(response.body);
            // 2. return Success with the desired value
            return Success(DisbursementCompletedResponse.fromJson(data));
          default:
            // 3. return Failure with the desired exception
            return Failure(Exception(response.reasonPhrase));
        }
      } else {
        throw Exception('No internet connection');
      }
    } on Exception catch (e) {
      // 4. return Failure here too
      return Failure(e);
    }
  }

  Future<Result<CheckOutOtpModel, Exception>> genrateOtpPaymentConfromation(
      String TransactionReqNo) async {
    try {
      if (await internetConnectivity.networkConnectivity()) {
        final prefsUtil = await SharedPref.getInstance();
        var base_url = prefsUtil.getString(BASE_URL);
        final response = await interceptor.get(Uri.parse(
            '${base_url + apiUrls.GetByTransactionReqNoForOTP}?TransactionReqNo=$TransactionReqNo'));

        print(response.body); // Print the response body once here
        switch (response.statusCode) {
          case 200:
            // Parse the JSON response
            final dynamic jsonData = json.decode(response.body);
            final CheckOutOtpModel responseModel =
                CheckOutOtpModel.fromJson(jsonData);
            return Success(responseModel);

          default:
            // 3. return Failure with the desired exception
            return Failure(ApiException(response.statusCode, ""));
        }
      } else {
        return Failure(Exception("No Internet connection"));
      }
    } on Exception catch (e) {
      // 4. return Failure here too
      return Failure(e);
    }
  }

  Future<Result<bool, Exception>> reSendOtpPaymentConfromation(
      String MobileNumber, String TransactionNo) async {
    try {
      if (await internetConnectivity.networkConnectivity()) {
        final prefsUtil = await SharedPref.getInstance();
        var base_url = prefsUtil.getString(BASE_URL);
        final response = await interceptor.get(Uri.parse(
            '${base_url + apiUrls.ResentOrderOTP}?MobileNo=$MobileNumber&TransactionNo=$TransactionNo'));

        print(response.body); // Print the response body once here
        switch (response.statusCode) {
          case 200:
            // Parse the JSON response
            final dynamic jsonData = json.decode(response.body);
            final bool responseModel = jsonData;
            return Success(responseModel);

          default:
            // 3. return Failure with the desired exception
            return Failure(ApiException(response.statusCode, ""));
        }
      } else {
        return Failure(Exception("No Internet connection"));
      }
    } on Exception catch (e) {
      // 4. return Failure here too
      return Failure(e);
    }
  }

  Future<Result<ValidOtpForCheckoutModel, Exception>> ValidateOrderOTPGetToken(
      String MobileNumber, String Otp, String TransactionNo) async {
    try {
      if (await internetConnectivity.networkConnectivity()) {
        final prefsUtil = await SharedPref.getInstance();
        var base_url = prefsUtil.getString(BASE_URL);
        final response = await interceptor.get(Uri.parse(
            '${base_url + apiUrls.ValidateOrderOTPGetToken}?MobileNo=$MobileNumber&otp=$Otp&TransactionReqNo=$TransactionNo'));

        print(response.body); // Print the response body once here
        switch (response.statusCode) {
          case 200:
            // Parse the JSON response
            final dynamic jsonData = json.decode(response.body);
            final ValidOtpForCheckoutModel responseModel =
                ValidOtpForCheckoutModel.fromJson(jsonData);
            return Success(responseModel);

          default:
            // 3. return Failure with the desired exception
            return Failure(ApiException(response.statusCode, ""));
        }
      } else {
        return Failure(Exception("No Internet connection"));
      }
    } on Exception catch (e) {
      // 4. return Failure here too
      return Failure(e);
    }
  }

  Future<Result<TransactionDetailModel, Exception>> GetByTransactionReqNo(
      String TransactionReqNo) async {
    try {
      if (await internetConnectivity.networkConnectivity()) {
        final prefsUtil = await SharedPref.getInstance();
        var base_url = prefsUtil.getString(BASE_URL);
        var token = await prefsUtil.getString(TOKEN_CHECKOUT);
        final response = await interceptor.get(
          Uri.parse(
              '${base_url + apiUrls.GetByTransactionReqNo}?TransactionReqNo=$TransactionReqNo'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token'
            // Set the content type as JSON
          },
        );

        print(response.body); // Print the response body once here
        switch (response.statusCode) {
          // Parse the JSON response
          case 200:
            final dynamic jsonData = json.decode(response.body);
            final TransactionDetailModel responseModel =
                TransactionDetailModel.fromJson(jsonData);
            return Success(responseModel);
          default:
            // 3. return Failure with the desired exception
            return Failure(ApiException(response.statusCode, ""));
        }
      } else {
        return Failure(Exception("No Internet connection"));
      }
    } on Exception catch (e) {
      return Failure(e);
    }
  }

  Future<Result<OrderPaymentModel, Exception>> PostOrderPlacement(
      PayemtOrderPostRequestModel model) async {
    try {
      if (await internetConnectivity.networkConnectivity()) {
        final prefsUtil = await SharedPref.getInstance();
        var base_url = prefsUtil.getString(BASE_URL);
        var token = await prefsUtil.getString(TOKEN_CHECKOUT);
        final response = await interceptor.post(
            Uri.parse('${base_url + apiUrls.PostOrderPlacement}'),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token'
              // Set the content type as JSON
            },
            body: json.encode(model));

        print(response.body); // Print the response body once here
        switch (response.statusCode) {
          // Parse the JSON response
          case 200:
            final dynamic jsonData = json.decode(response.body);
            final OrderPaymentModel responseModel =
                OrderPaymentModel.fromJson(jsonData);
            return Success(responseModel);
          default:
            // 3. return Failure with the desired exception
            return Failure(ApiException(response.statusCode, ""));
        }
      } else {
        return Failure(Exception("No Internet connection"));
      }
    } on Exception catch (e) {
      return Failure(e);
    }
  }

  Future<Result<CustomerOrderSummaryResModel, Exception>>
      getCustomerOrderSummary(int leadId) async {
    try {
      if (await internetConnectivity.networkConnectivity()) {
        final prefsUtil = await SharedPref.getInstance();
        var base_url = prefsUtil.getString(BASE_URL);
        var token = prefsUtil.getString(TOKEN);
        final response = await interceptor.get(Uri.parse(
            '${base_url + apiUrls.getCustomerOrderSummary}?LeadId=$leadId'));
        print(response.body); // Print the response body once here
        switch (response.statusCode) {
          case 200:
            final dynamic jsonData = json.decode(response.body);
            final CustomerOrderSummaryResModel responseModel =
                CustomerOrderSummaryResModel.fromJson(jsonData);
            return Success(responseModel);

          default:
            return Failure(ApiException(response.statusCode, ""));
        }
      } else {
        return Failure(Exception("No Internet connection"));
      }
    } on Exception catch (e) {
      return Failure(e);
    }
  }

  Future<Result<List<CustomerTransactionListRespModel>, Exception>>
      getCustomerTransactionList(
          CustomerTransactionListRequestModel
              customerTransactionListRequestModel) async {
    try {
      if (await internetConnectivity.networkConnectivity()) {
        final prefsUtil = await SharedPref.getInstance();
        var base_url = prefsUtil.getString(BASE_URL);
        var token = await prefsUtil.getString(TOKEN);
        final response = await interceptor.post(
            Uri.parse(base_url + apiUrls.getCustomerTransactionList),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token'
            },
            body: json.encode(customerTransactionListRequestModel));
        print(response.body); // Print the response body once here
        switch (response.statusCode) {
          case 200:
            final dynamic jsonData = json.decode(response.body);
            final List<CustomerTransactionListRespModel> responseModel =
                List<CustomerTransactionListRespModel>.from(jsonData.map(
                    (model) =>
                        CustomerTransactionListRespModel.fromJson(model)));
            return Success(responseModel);
          default:
            return Failure(ApiException(response.statusCode, ""));
        }
      } else {
        return Failure(Exception("No Internet connection"));
      }
    } on Exception catch (e) {
      return Failure(e);
    }
  }

  Future<Result<OfferResponceModel, Exception>>
      getCustomerOrderSummaryForAnchor(int leadId) async {
    try {
      if (await internetConnectivity.networkConnectivity()) {
        final prefsUtil = await SharedPref.getInstance();
        var base_url = prefsUtil.getString(BASE_URL);
        var token = prefsUtil.getString(TOKEN);
        final response = await interceptor.get(Uri.parse(
            '${base_url + apiUrls.getCustomerOrderSummaryForAnchor}?LeadId=$leadId'));
        print(response.body); // Print the response body once here
        switch (response.statusCode) {
          case 200:
            final dynamic jsonData = json.decode(response.body);
            final OfferResponceModel responseModel =
                OfferResponceModel.fromJson(jsonData);
            return Success(responseModel);

          default:
            return Failure(ApiException(response.statusCode, ""));
        }
      } else {
        return Failure(Exception("No Internet connection"));
      }
    } on Exception catch (e) {
      return Failure(e);
    }
  }

  Future<Result<List<CustomerTransactionListTwoRespModel>, Exception>>
      getCustomerTransactionListTwo(
          CustomerTransactionListTwoReqModel
              customerTransactionListTwoReqModel) async {
    try {
      if (await internetConnectivity.networkConnectivity()) {
        final prefsUtil = await SharedPref.getInstance();
        var base_url = prefsUtil.getString(BASE_URL);
        var token = await prefsUtil.getString(TOKEN);
        final response = await interceptor.post(
            Uri.parse(base_url + apiUrls.getCustomerTransactionListTwo),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token'
            },
            body: json.encode(customerTransactionListTwoReqModel));
        print(response.body); // Print the response body once here
        switch (response.statusCode) {
          case 200:
            final dynamic jsonData = json.decode(response.body);
            final List<CustomerTransactionListTwoRespModel> responseModel =
                List<CustomerTransactionListTwoRespModel>.from(jsonData.map(
                    (model) =>
                        CustomerTransactionListTwoRespModel.fromJson(model)));
            return Success(responseModel);
          default:
            return Failure(ApiException(response.statusCode, ""));
        }
      } else {
        return Failure(Exception("No Internet connection"));
      }
    } on Exception catch (e) {
      return Failure(e);
    }
  }

  Future<Result<TransactionBreakupResModel, Exception>> getTransactionBreakup(
      int invoiceId) async {
    try {
      if (await internetConnectivity.networkConnectivity()) {
        final prefsUtil = await SharedPref.getInstance();
        var base_url = prefsUtil.getString(BASE_URL);
        var token = prefsUtil.getString(TOKEN);
        final response = await interceptor.get(Uri.parse(
            '${base_url + apiUrls.getTransactionBreakup}?InvoiceId=$invoiceId'));
        print(response.body); // Print the response body once here
        switch (response.statusCode) {
          case 200:
            final dynamic jsonData = json.decode(response.body);
            final TransactionBreakupResModel responseModel =
                TransactionBreakupResModel.fromJson(jsonData);
            return Success(responseModel);

          default:
            return Failure(ApiException(response.statusCode, ""));
        }
      } else {
        return Failure(Exception("No Internet connection"));
      }
    } on Exception catch (e) {
      return Failure(e);
    }
  }

  Future<PwaModel> pwaData(int leadId) async {
    if (await internetConnectivity.networkConnectivity()) {
      final prefsUtil = await SharedPref.getInstance();
      var base_url = prefsUtil.getString(BASE_URL);
      var token = prefsUtil.getString(TOKEN);
      final response = await interceptor.get(
          Uri.parse('${base_url + apiUrls.GetPFCollection}?leadId=$leadId'));
      print(response.body); // Print the response body once here
      if (response.statusCode == 200) {
        final dynamic jsonData = json.decode(response.body);
        final PwaModel responseModel = PwaModel.fromJson(jsonData);
        return responseModel;
      }
      if (response.statusCode == 401) {
        throw Exception('Failed to load products');
      } else {
        throw Exception('Failed to load products');
      }
    } else {
      throw Exception('No internet connection');
    }
  }

  Future<Result<AcceptedResponceModel, Exception>> getNextCall(
      int leadId) async {
    try {
      if (await internetConnectivity.networkConnectivity()) {
        final prefsUtil = await SharedPref.getInstance();
        var base_url = prefsUtil.getString(BASE_URL);
        var token = prefsUtil.getString(TOKEN);
        final response = await interceptor.get(Uri.parse(
            '${base_url + apiUrls.DisbursementNext}?leadId=$leadId'));
        print(response.body); // Print the response body once here
        switch (response.statusCode) {
          case 200:
            final dynamic jsonData = json.decode(response.body);
            final AcceptedResponceModel responseModel =
                AcceptedResponceModel.fromJson(jsonData);
            return Success(responseModel);
          default:
            // 3. return Failure with the desired exception
            return Failure(ApiException(response.statusCode, ""));
        }
      } else {
        return Failure(Exception("No Internet connection"));
      }
    } on Exception catch (e) {
      return Failure(e);
    }
  }

  Future<CheckStatusModel> checkStatus(int leadId) async {
    if (await internetConnectivity.networkConnectivity()) {
      final prefsUtil = await SharedPref.getInstance();
      var base_url = prefsUtil.getString(BASE_URL);
      var token = prefsUtil.getString(TOKEN);
      final response = await interceptor.get(
        Uri.parse(
            '${base_url + apiUrls.GetPFCollectionActivityStatus}?leadId=$leadId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
      );
      print(response.body); // Print the response body once here
      if (response.statusCode == 200) {
        final dynamic jsonData = json.decode(response.body);
        final CheckStatusModel responseModel =
            CheckStatusModel.fromJson(jsonData);
        return responseModel;
      }
      if (response.statusCode == 401) {
        throw Exception('Failed to load products');
      } else {
        throw Exception('Failed to load products');
      }
    } else {
      throw Exception('No internet connection');
    }
  }


  }*/

  Future<Result<InProgressScreenModel, Exception>> leadDataOnInProgressScreen(
      int leadId) async {
    if (await internetConnectivity.networkConnectivity()) {
      final prefsUtil = await SharedPref.getInstance();
      var base_url = prefsUtil.getString(BASE_URL);
      var token = prefsUtil.getString(TOKEN);
      final response = await interceptor.get(
        Uri.parse(
            '${base_url! + apiUrls.LeadDataOnInProgressScreen}?leadId=$leadId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
      );
      print(response.body); // Print the response body once here
      if (response.statusCode == 200) {
        final dynamic jsonData = json.decode(response.body);
        final InProgressScreenModel responseModel =
            InProgressScreenModel.fromJson(jsonData);
        return Success(responseModel);
      }
      if (response.statusCode == 401) {
        throw Exception('Failed to load products');
      } else {
        throw Exception('Failed to load products');
      }
    } else {
      throw Exception('No internet connection');
    }
  }

  Future<Result<ChooseUserTypeResponceModel, Exception>> getChooseUserType(
      ChooseUserTypeRequestModel model) async {
    try {
      if (await internetConnectivity.networkConnectivity()) {
        final prefsUtil = await SharedPref.getInstance();
        var base_url = prefsUtil.getString(BASE_URL);
        var token = prefsUtil.getString(TOKEN);
        final response = await interceptor.post(
            Uri.parse('${base_url! + apiUrls.PostLeadDSAProfileType}'),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token'
              // Set the content type as JSON// Set the content type as JSON
            },
            body: json.encode(model));
        //print(json.encode(leadCurrentRequestModel));
        print(response.body); // Print the response body once here
        switch (response.statusCode) {
          case 200:
            // Parse the JSON response
            final dynamic jsonData = json.decode(response.body);
            final ChooseUserTypeResponceModel responseModel =
                ChooseUserTypeResponceModel.fromJson(jsonData);
            return Success(responseModel);

          default:
            return Failure(ApiException(response.statusCode, ""));
        }
      } else {
        return Failure(Exception("No Internet connection"));
      }
    } on Exception catch (e) {
      return Failure(e);
    }
  }

  Future<Result<PostLeadDsaPersonalDetailResModel, Exception>>
      postLeadDSAPersonalDetail(PostLeadDsaPersonalDetailReqModel model) async {
    try {
      if (await internetConnectivity.networkConnectivity()) {
        final prefsUtil = await SharedPref.getInstance();
        var base_url = prefsUtil.getString(BASE_URL);
        var token = prefsUtil.getString(TOKEN);
        final response = await interceptor.post(
            Uri.parse('${base_url! + apiUrls.postLeadDSAPersonalDetail}'),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token'
              // Set the content type as JSON// Set the content type as JSON
            },
            body: json.encode(model));
        //print(json.encode(leadCurrentRequestModel));
        print(response.body); // Print the response body once here
        switch (response.statusCode) {
          case 200:
            // Parse the JSON response
            final dynamic jsonData = json.decode(response.body);
            final PostLeadDsaPersonalDetailResModel responseModel =
                PostLeadDsaPersonalDetailResModel.fromJson(jsonData);
            return Success(responseModel);

          default:
            return Failure(ApiException(response.statusCode, ""));
        }
      } else {
        return Failure(Exception("No Internet connection"));
      }
    } on Exception catch (e) {
      return Failure(e);
    }
  }

  Future<Result<DSAPersonalInfoModel, Exception>> getDSAPersonalInfo(
      String userId, String productCode) async {
    try {
      if (await internetConnectivity.networkConnectivity()) {
        final prefsUtil = await SharedPref.getInstance();
        var base_url = prefsUtil.getString(BASE_URL);
        var token = prefsUtil.getString(TOKEN);
        final response = await interceptor.get(
          Uri.parse(
              '${base_url! + apiUrls.GetDSAProfileType}?UserId=$userId&productCode=$productCode'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token'
          },
        );
        print(response.body); // Pr
        switch (response.statusCode) {
          case 200:
            // Parse the JSON response
            final dynamic jsonData = json.decode(response.body);
            final DSAPersonalInfoModel responseModel =
                DSAPersonalInfoModel.fromJson(jsonData);
            return Success(responseModel);

          default:
            return Failure(ApiException(response.statusCode, ""));
        }
      } else {
        return Failure(Exception("No Internet connection"));
      }
    } on Exception catch (e) {
      return Failure(e);
    }
  }

  Future<Result<CommanResponceModel, Exception>> submitConnectorData(
      ConnectorInfoReqModel model) async {
    try {
      if (await internetConnectivity.networkConnectivity()) {
        final prefsUtil = await SharedPref.getInstance();
        var base_url = prefsUtil.getString(BASE_URL);
        var token = prefsUtil.getString(TOKEN);
        final response = await interceptor.post(
            Uri.parse(
                '${base_url! + apiUrls.PostLeadConnectorPersonalDetail}'),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token'
              // Set the content type as JSON// Set the content type as JSON
            },
            body: json.encode(model));
        //print(json.encode(leadCurrentRequestModel));
        print(response.body); // Print the response body once here
        switch (response.statusCode) {
          case 200:
            // Parse the JSON response
            final dynamic jsonData = json.decode(response.body);
            final CommanResponceModel responseModel =
                CommanResponceModel.fromJson(jsonData);
            return Success(responseModel);

          default:
            return Failure(ApiException(response.statusCode, ""));
        }
      } else {
        return Failure(Exception("No Internet connection"));
      }
    } on Exception catch (e) {
      return Failure(e);
    }
  }

  Future<Result<ConnectorInfoResponce, Exception>> getConnectorInfo(
      String userId, String productCode) async {
    try {
      if (await internetConnectivity.networkConnectivity()) {
        final prefsUtil = await SharedPref.getInstance();
        var base_url = prefsUtil.getString(BASE_URL);
        var token = prefsUtil.getString(TOKEN);
        final response = await interceptor.get(
          Uri.parse(
              '${base_url! + apiUrls.GetConnectorPersonalDetail}?UserId=$userId&productCode=$productCode'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token'
          },
        );
        print(response.body); // Pr
        switch (response.statusCode) {
          case 200:
            // Parse the JSON response
            final dynamic jsonData = json.decode(response.body);
            final ConnectorInfoResponce responseModel =
                ConnectorInfoResponce.fromJson(jsonData);
            return Success(responseModel);

          default:
            return Failure(ApiException(response.statusCode, ""));
        }
      } else {
        return Failure(Exception("No Internet connection"));
      }
    } on Exception catch (e) {
      return Failure(e);
    }
  }

  Future<Result<GetDsaPersonalDetailResModel, Exception>> getDsaPersonalDetail(
      String UserId, String productCode) async {
    try {
      if (await internetConnectivity.networkConnectivity()) {
        final prefsUtil = await SharedPref.getInstance();
        var base_url = prefsUtil.getString(BASE_URL);
        var token = prefsUtil.getString(TOKEN);
        final response = await interceptor.get(
          Uri.parse(
              '${base_url! + apiUrls.getDSAPersonalDetail}?UserId=$UserId&productCode=$productCode'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token'
          },
        );
        print(response.body); // Print the response body once here
        switch (response.statusCode) {
          case 200:
            // Parse the JSON response
            final dynamic jsonData = json.decode(response.body);
            final GetDsaPersonalDetailResModel responseModel =
                GetDsaPersonalDetailResModel.fromJson(jsonData);
            return Success(responseModel);

          default:
            return Failure(ApiException(response.statusCode, ""));
        }
      } else {
        return Failure(Exception("No Internet connection"));
      }
    } on Exception catch (e) {
      return Failure(e);
    }

  }

  Future<Result<GetDsaDashboardDetailsResModel, Exception>>
      getDSADashboardDetails(GetDsaDashboardDetailsReqModel model) async {
    try {
      if (await internetConnectivity.networkConnectivity()) {
        final prefsUtil = await SharedPref.getInstance();
        var base_url = prefsUtil.getString(BASE_URL);
         var token = prefsUtil.getString(TOKEN);
         final response = await interceptor.post(
            Uri.parse('${base_url! + apiUrls.getDSADashboardDetails}'),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token'
              // Set the content type as JSON// Set the content type as JSON
            },
            body: json.encode(model));
        //print(json.encode(leadCurrentRequestModel));
        print(response.body); // Print the response body once here
        switch (response.statusCode) {
          case 200:
            // Parse the JSON response
            final dynamic jsonData = json.decode(response.body);
            final GetDsaDashboardDetailsResModel responseModel =
                GetDsaDashboardDetailsResModel.fromJson(jsonData);
            return Success(responseModel);

          default:
            return Failure(ApiException(response.statusCode, ""));
        }
      } else {
        return Failure(Exception("No Internet connection"));
      }
    } on Exception catch (e) {
      return Failure(e);
    }
  }

  Future<Result<CreateUserModel, Exception>> createDSAUser(
      CreateDSAUserReqModel model) async {
    try {
      if (await internetConnectivity.networkConnectivity()) {
        final prefsUtil = await SharedPref.getInstance();
        var base_url = prefsUtil.getString(BASE_URL);
        var token = prefsUtil.getString(TOKEN);
        final response = await interceptor.post(
            Uri.parse(base_url! + apiUrls.CreateDSAUser),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token'
              // Set the content type as JSON// Set the content type as JSON
            },
            body: json.encode(model));
        print(response.body); // Print the response body once here
        switch (response.statusCode) {
          case 200:
            final dynamic jsonData = json.decode(response.body);
            final CreateUserModel responseModel =
            CreateUserModel.fromJson(jsonData);
            return Success(responseModel);
          default:
            return Failure(ApiException(response.statusCode, ""));
        }
      } else {
        return Failure(Exception("No Internet connection"));
      }
    } on Exception catch (e) {
      return Failure(e);
    }
  }

  Future<Result<GetAgreementResModel, Exception>> dSAGenerateAgreement(
      String leadId, String ProductId, String CompanyId, bool IsSubmit) async {
    try {
      if (await internetConnectivity.networkConnectivity()) {
        final prefsUtil = await SharedPref.getInstance();
        var base_url = prefsUtil.getString(BASE_URL);
        var token = prefsUtil.getString(TOKEN);
        final response = await interceptor.get(
          Uri.parse(
              '${base_url! + apiUrls.dSAGenerateAgreement}?leadId=$leadId&ProductId=$ProductId&CompanyId=$CompanyId&IsProceedToEsign=$IsSubmit'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token'
          },
        );
        print(response.body); // Print the response body once here
        switch (response.statusCode) {
          case 200:
            // Parse the JSON response
            final dynamic jsonData = json.decode(response.body);
            final GetAgreementResModel responseModel =
                GetAgreementResModel.fromJson(jsonData);
            return Success(responseModel);

          default:
            return Failure(ApiException(response.statusCode, ""));
        }
      } else {
        return Failure(Exception("No Internet connection"));
      }
    } on Exception catch (e) {
      return Failure(e);
    }

    /*if (await internetConnectivity.networkConnectivity()) {
      final prefsUtil = await SharedPref.getInstance();
      var base_url = prefsUtil.getString(BASE_URL);
      final response = await interceptor.get(Uri.parse(
          '${base_url + apiUrls.getCustomerDetailUsingGST}?GSTNO=$GSTNumber'));
      print(response.body); // Print the response body once here
      if (response.statusCode == 200) {
        // Parse the JSON response
        final dynamic jsonData = json.decode(response.body);

        final CustomerDetailUsingGstResponseModel responseModel =
        CustomerDetailUsingGstResponseModel.fromJson(jsonData);
        return responseModel;
      } else {
        throw Exception('Failed to load products');
      }
    } else {
      throw Exception('No internet connection');
    }*/
  }

  Future<Result<CheckESignResponseModel, Exception>> checkESignDocumentStatus(
      String leadId) async {
    try {
      if (await internetConnectivity.networkConnectivity()) {
        final prefsUtil = await SharedPref.getInstance();
        var base_url = prefsUtil.getString(BASE_URL);
        var token = prefsUtil.getString(TOKEN);
        final response = await interceptor.get(
          Uri.parse(
              '${base_url! + apiUrls.checkESignDocumentStatus}?leadId=$leadId'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token'
          },
        );
        print(response.body); // Print the response body once here
        switch (response.statusCode) {
          case 200:
          // Parse the JSON response
            final dynamic jsonData = json.decode(response.body);
            final CheckESignResponseModel responseModel =
            CheckESignResponseModel.fromJson(jsonData);
            return Success(responseModel);

          default:
            return Failure(ApiException(response.statusCode, ""));
        }
      } else {
        return Failure(Exception("No Internet connection"));
      }
    } on Exception catch (e) {
      return Failure(e);
    }

    /*if (await internetConnectivity.networkConnectivity()) {
      final prefsUtil = await SharedPref.getInstance();
      var base_url = prefsUtil.getString(BASE_URL);
      final response = await interceptor.get(Uri.parse(
          '${base_url + apiUrls.getCustomerDetailUsingGST}?GSTNO=$GSTNumber'));
      print(response.body); // Print the response body once here
      if (response.statusCode == 200) {
        // Parse the JSON response
        final dynamic jsonData = json.decode(response.body);

        final CustomerDetailUsingGstResponseModel responseModel =
        CustomerDetailUsingGstResponseModel.fromJson(jsonData);
        return responseModel;
      } else {
        throw Exception('Failed to load products');
      }
    } else {
      throw Exception('No internet connection');
    }*/
  }

/*if (await internetConnectivity.networkConnectivity()) {
      final prefsUtil = await SharedPref.getInstance();
      var base_url = prefsUtil.getString(BASE_URL);
      final response = await interceptor.get(Uri.parse(
          '${base_url + apiUrls.getCustomerDetailUsingGST}?GSTNO=$GSTNumber'));
      print(response.body); // Print the response body once here
      if (response.statusCode == 200) {
        // Parse the JSON response
        final dynamic jsonData = json.decode(response.body);

        final CustomerDetailUsingGstResponseModel responseModel =
        CustomerDetailUsingGstResponseModel.fromJson(jsonData);
        return responseModel;
      } else {
        throw Exception('Failed to load products');
      }
    } else {
      throw Exception('No internet connection');
    }*/

  Future<Result<DsaSalesAgentListResModel,Exception>> getDSASalesAgentList() async {

    try {
      if (await internetConnectivity.networkConnectivity()) {
        final prefsUtil = await SharedPref.getInstance();
        var base_url = prefsUtil.getString(BASE_URL);
            var token = prefsUtil.getString(TOKEN);
        final response = await interceptor.get(Uri.parse(
            '${base_url! + apiUrls.getDSASalesAgentList}'),headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },);
        print(response.body); // Print the response body once here
        switch (response.statusCode) {
          case 200:
          // Parse the JSON response
            final dynamic jsonData = json.decode(response.body);
            final DsaSalesAgentListResModel responseModel = DsaSalesAgentListResModel.fromJson(jsonData);
            return Success(responseModel);

          default:
            return Failure(ApiException(response.statusCode, ""));
        }
      } else {
        return Failure(Exception("No Internet connection"));
      }
    } on Exception catch (e) {
      return Failure(e);
    }

  }

  Future<Result<DsaDashboardLeadListResModel, Exception>>
  getDSADashboardLeadList(DsaDashboardLeadListReqModel model) async {
    try {
      if (await internetConnectivity.networkConnectivity()) {
        final prefsUtil = await SharedPref.getInstance();
        var base_url = prefsUtil.getString(BASE_URL);
        var token = prefsUtil.getString(TOKEN);
        final response = await interceptor.post(
            Uri.parse('${base_url! + apiUrls.getDSADashboardLeadList}'),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token'
              // Set the content type as JSON// Set the content type as JSON
            },
            body: json.encode(model));
        //print(json.encode(leadCurrentRequestModel));
        print(response.body); // Print the response body once here
        switch (response.statusCode) {
          case 200:
          // Parse the JSON response
            final dynamic jsonData = json.decode(response.body);
            final DsaDashboardLeadListResModel responseModel =
            DsaDashboardLeadListResModel.fromJson(jsonData);
            return Success(responseModel);

          default:
            return Failure(ApiException(response.statusCode, ""));
        }
      } else {
        return Failure(Exception("No Internet connection"));
      }
    } on Exception catch (e) {
      return Failure(e);
    }
  }

  Future<Result<GetDsaDashboardPayoutListResModel, Exception>>
  getDSADashboardPayoutList(GetDsaDashboardPayoutListReqModel model) async {
    try {
      if (await internetConnectivity.networkConnectivity()) {
        final prefsUtil = await SharedPref.getInstance();
        var base_url = prefsUtil.getString(BASE_URL);
        var token = prefsUtil.getString(TOKEN);
        final response = await interceptor.post(
            Uri.parse('${base_url! + apiUrls.getDSADashboardPayoutList}'),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token'
              // Set the content type as JSON// Set the content type as JSON
            },
            body: json.encode(model));
        //print(json.encode(leadCurrentRequestModel));
        print(response.body); // Print the response body once here
        switch (response.statusCode) {
          case 200:
          // Parse the JSON response
            final dynamic jsonData = json.decode(response.body);
            final GetDsaDashboardPayoutListResModel responseModel =
            GetDsaDashboardPayoutListResModel.fromJson(jsonData);
            return Success(responseModel);

          default:
            return Failure(ApiException(response.statusCode, ""));
        }
      } else {
        return Failure(Exception("No Internet connection"));
      }
    } on Exception catch (e) {
      return Failure(e);
    }
  }

}
