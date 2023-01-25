import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'karkinos_mantra_fingerprint_method_channel.dart';

abstract class KarkinosMantraFingerprintPlatform extends PlatformInterface {
  /// Constructs a KarkinosMantraFingerprintPlatform.
  KarkinosMantraFingerprintPlatform() : super(token: _token);

  static final Object _token = Object();

  static KarkinosMantraFingerprintPlatform _instance = MethodChannelKarkinosMantraFingerprint();

  /// The default instance of [KarkinosMantraFingerprintPlatform] to use.
  ///
  /// Defaults to [MethodChannelKarkinosMantraFingerprint].
  static KarkinosMantraFingerprintPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [KarkinosMantraFingerprintPlatform] when
  /// they register themselves.
  static set instance(KarkinosMantraFingerprintPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
  Future<String?> getName() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
  Future<void> initDevice(){
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<String?> captureFingurePrint(){
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
  Future<String?> getDeviceInfo(){
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

}
