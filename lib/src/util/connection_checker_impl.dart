import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:weblate_sdk/src/util/connection_checker.dart';
import 'package:weblate_sdk/src/util/connectivity_ext.dart';

class ConnectionCheckerImpl implements ConnectionChecker {
  final InternetConnection _internetConnection;
  final Connectivity _connectivity;

  const ConnectionCheckerImpl({
    required InternetConnection internetConnection,
    required Connectivity connectivity,
  })  : _internetConnection = internetConnection,
        _connectivity = connectivity;

  @override
  Future<bool> hasConnection() async {
    try {
      final isReachable = await _internetConnection.hasInternetAccess;
      final connectivityResult = await _connectivity.checkConnectivity();
      return isReachable && connectivityResult.hasConnection;
    } catch (_) {
      return false;
    }
  }
}
