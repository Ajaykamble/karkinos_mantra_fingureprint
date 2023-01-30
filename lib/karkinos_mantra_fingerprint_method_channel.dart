import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'karkinos_mantra_fingerprint_platform_interface.dart';

/// An implementation of [KarkinosMantraFingerprintPlatform] that uses method channels.
class MethodChannelKarkinosMantraFingerprint extends KarkinosMantraFingerprintPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('karkinos_mantra_fingerprint');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  Future<String?> getName(String pidOptions) async {
    final version = await methodChannel.invokeMethod<String>('getName',{"pidOptions":pidOptions});
    return version;
  }

  @override
  Future<String?> initDevice() async {
    final version = await methodChannel.invokeMethod<String>('init');
    return version;
  }

  @override
  Future<String?> captureFingurePrint(String pidOptions) async {
    final result = await methodChannel.invokeMethod<String>('capture',{"pidOptions":pidOptions});
    return result;
  }
  @override
  Future<Map<String,dynamic>?> getDeviceInfo() async {
    final result = await methodChannel.invokeMethod<Map<String,dynamic>>('getDeviceInfo');
    return result;
  }
}
