import 'package:connectivity/connectivity.dart';

class InternetConnectivity{
  Future<bool> networkConnectivity() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      return true;

    } else {
      return false;
    }
  }
}
