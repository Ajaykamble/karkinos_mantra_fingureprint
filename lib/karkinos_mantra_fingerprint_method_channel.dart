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
  Future<String?> getName() async {
    return "My Name";
  }

  @override
  Future<String?> initDevice() async {
    final version = await methodChannel.invokeMethod<String>('init');
    return version;
  }

  @override
  Future<String?> captureFingurePrint() async {
    final result = await methodChannel.invokeMethod<String>('capture');
    return result;
  }
  @override
  Future<String?> getDeviceInfo() async {
    final result = await methodChannel.invokeMethod<String>('getDeviceInfo');
    return result;
  }
}
