import 'package:flutter/services.dart';

class StaticMembers {
  static String userId;
  static String shopOwnerId;
  static const String logoUrl =
  "https://firebasestorage.googleapis.com/v0/b/atyab-99c92.appspot.com/o/logo_atyaab.jpg?alt=media&token=f69e2667-98db-44a8-af16-61ea74626bc4";
  static Future<List<String>> getDeviceDetails() async {
    String deviceName;
    String deviceVersion;
    String identifier;

    try {
      /*
      if (Platform.isAndroid) {
        var build = await deviceInfoPlugin.androidInfo;
        deviceName = build.model;
        deviceVersion = build.version.toString();
        identifier = build.androidId; //UUID for Android
        userId = identifier;
      }
      else if (Platform.isIOS) {
        var data = await deviceInfoPlugin.iosInfo;
        deviceName = data.name;
        deviceVersion = data.systemVersion;
        identifier = data.identifierForVendor; //UUID for iOS
        userId = identifier;
      }

       */
    } on PlatformException {
      print('Failed to get platform version');
    }

//if (!mounted) return;
    return [deviceName, deviceVersion, identifier];
  }

}
