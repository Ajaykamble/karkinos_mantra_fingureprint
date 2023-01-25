
import 'karkinos_mantra_fingerprint_platform_interface.dart';

class KarkinosMantraFingerprint {
  Future<String?> getPlatformVersion() {
    return KarkinosMantraFingerprintPlatform.instance.getPlatformVersion();
  }
  Future<void> getInitMantraDevice() async{
    KarkinosMantraFingerprintPlatform.instance.initDevice();
  }
}
