import 'package:connectivity_plus/connectivity_plus.dart';
extension ConnectivityExtension on Connectivity {
  Future<bool> isConnected() async {
    final result = await Connectivity().checkConnectivity();
    print("Connectivity result: $result");
    return result == ConnectivityResult.mobile || result == ConnectivityResult.wifi;
  }
}
