import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../view/otp_screens/model/GetUserProfileResponse.dart';

class SharedPref {

  static SharedPref? _instance;
  late SharedPreferences _prefs;

  SharedPref._internal();

  static Future<SharedPref> getInstance() async {
    if (_instance == null) {
      _instance = SharedPref._internal();
      await _instance!._init();
    }
    return _instance!;
  }

  Future<void> _init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<void> saveInt(String key, int value) async {
    await _prefs.setInt(key, value);
  }

  Future<void> saveBool(String key, bool value) async {
    await _prefs.setBool(key, value);
  }

  Future<void> saveDouble(String key, double value) async {
    await _prefs.setDouble(key, value);
  }

  Future<void> saveString(String key, String value) async {
    await _prefs.setString(key, value);
  }

  Future<void> saveStringList(String key, List<String> value) async {
    await _prefs.setStringList(key, value);
  }

  int? getInt(String key) {
    return _prefs.getInt(key);
  }

  bool? getBool(String key) {
    return _prefs.getBool(key);
  }

  double? getDouble(String key) {
    return _prefs.getDouble(key);
  }

  String? getString(String key) {
    return _prefs.getString(key);
  }

  List<String>? getStringList(String key) {
    return _prefs.getStringList(key);
  }

  // Save SalesAgentCommissions to SharedPreferences
  Future<void> saveCommissions(List<SalesAgentCommissions> commissions) async {
    List<String> commissionsJsonList = commissions.map((commission) => jsonEncode(commission.toJson())).toList();
    await _prefs.setStringList('salesAgentCommissions', commissionsJsonList);
  }

// Load SalesAgentCommissions from SharedPreferences
  Future<List<SalesAgentCommissions>> loadCommissions() async {
    List<String>? commissionsJsonList = _prefs.getStringList('salesAgentCommissions');
    if (commissionsJsonList == null) {
      return [];
    }
    List<SalesAgentCommissions> commissions = commissionsJsonList.map((commissionJson) => SalesAgentCommissions.fromJson(jsonDecode(commissionJson))).toList();
    return commissions;
  }

  Future<void> clear() async {
    try {
      await _prefs.clear();
    } catch (e) {
      print("Error clearing shared preferences: $e");
      // Handle clearing error
    }
  }
}