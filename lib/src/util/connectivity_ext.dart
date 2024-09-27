import 'package:connectivity_plus/connectivity_plus.dart';

extension ConnectivityExt on List<ConnectivityResult> {
  bool get hasConnection {
    switch (this) {
      case [ConnectivityResult.bluetooth]:
        return false;
      case [ConnectivityResult.none]:
        return false;
      default:
        return true;
    }
  }
}
