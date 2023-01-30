// In order to *not* need this ignore, consider extracting the "web" version
// of your plugin as a separate package, instead of inlining it in the same
// package as the core of your plugin.
// ignore: avoid_web_libraries_in_flutter
//import 'dart:html' as html show window, document, ScriptElement;

import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:js/js_util.dart';
import 'package:karkinos_mantra_fingerprint/web/web_plugin.dart';

import 'karkinos_mantra_fingerprint_platform_interface.dart';

/// A web implementation of the KarkinosMantraFingerprintPlatform of the KarkinosMantraFingerprint plugin.
class KarkinosMantraFingerprintWeb extends KarkinosMantraFingerprintPlatform {
  /// Constructs a KarkinosMantraFingerprintWeb
  //KarkinosMantraFingerprintWeb();

  static void registerWith(Registrar registrar) {
    KarkinosMantraFingerprintPlatform.instance = KarkinosMantraFingerprintWeb();
  }

  /*Future<String> add1And2() async{
    final JsFunction _addNumbers = context['getAadhaar'];
    
    return _addNumbers.apply([]);
  }*/

  @override
  Future<String?> getPlatformVersion() async {
    var myVar = await promiseToFuture(checkDeviceStatus());
    print(myVar);
    return myVar;
  }
}
