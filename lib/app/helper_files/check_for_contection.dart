// return true when there is no connection
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';

Future<bool> checkForIntern() async {
  var connectivityResult = await (Connectivity().checkConnectivity());

  bool isOnline = await checkConnection();
  if (connectivityResult == ConnectivityResult.none || !isOnline) {
    return Future.value(false);
  } else {
    return Future.value(true);
  }
}

Future<bool> checkConnection() async {
  bool isOnline = false;
  try {
    final result = await InternetAddress.lookup('google.com');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      isOnline = true;
    } else {
      isOnline = false;
    }
  } on SocketException catch (_) {
    isOnline = false;
  }

  return Future.value(isOnline);
}
