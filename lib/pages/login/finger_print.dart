import 'package:local_auth/local_auth.dart';

class FingerPrint {

  static Future<bool?> canCheckBiometrics() async {
    final LocalAuthentication auth = LocalAuthentication();

    final bool canAuthenticateWithBiometrics = await auth.canCheckBiometrics;
    final List<BiometricType> availableBiometrics = await auth.getAvailableBiometrics();

    if (canAuthenticateWithBiometrics && availableBiometrics.contains(BiometricType.fingerprint)) {

      print('Pussui Biometria');
      return true;
    }

    print('Não pussui Biometria');
    return false;
  }

  static Future<bool?> verify() async {
    final LocalAuthentication auth = LocalAuthentication();

    bool ok = await auth.authenticate(localizedReason: 'Toque no sensor para autenticar com sua digital');

    return ok;
  }
}