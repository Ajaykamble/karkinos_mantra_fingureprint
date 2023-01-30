import 'dart:developer';
import 'package:karkinos_mantra_fingerprint/utils/app_exception.dart';

import 'karkinos_mantra_fingerprint_platform_interface.dart';
import 'package:flutter/services.dart';
export 'package:karkinos_mantra_fingerprint/utils/app_exception.dart';
class KarkinosMantraFingerprint {
  Future<String?> getPlatformVersion() {
    return KarkinosMantraFingerprintPlatform.instance.getPlatformVersion();
  }

  Future<void> getInitMantraDevice() async {
    KarkinosMantraFingerprintPlatform.instance.initDevice();
  }

  Future<String?> getName(pidOptions)async{
    try{
      return await KarkinosMantraFingerprintPlatform.instance.getName(pidOptions);
    }
    catch(e){
      rethrow;
    }
  }

  Future<String?> captureFingurePrint({required String pidOptions}) async {
    try {
      return await KarkinosMantraFingerprintPlatform.instance.captureFingurePrint(pidOptions);
    } on PlatformException catch (e) {
      String? code = e.code;
      String? message = e.message;
      String? details = e.details;

      log("${e.code}");
      log("${e.message}");
      log("${e.details}");
      switch (e.code) {
        case "ClientNotFound":
          throw ClientNotFound(code, message, details);
          break;
        default:
          rethrow;
          break;
      }
    } catch (e) {
      rethrow;
    }
  }
  Future<Map<String,dynamic>?> getDeviceInformation() async {
    try {
      return await KarkinosMantraFingerprintPlatform.instance.getDeviceInfo();
    } on PlatformException catch (e) {
      String? code = e.code;
      String? message = e.message;
      String? details = e.details;

      log("${e.code}");
      log("${e.message}");
      log("${e.details}");
      switch (e.code) {
        case "ClientNotFound":
          throw ClientNotFound(code, message, details);
          break;
        default:
          rethrow;
          break;
      }
    } catch (e) {
      rethrow;
    }
  }
}
