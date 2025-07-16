import 'package:local_auth/local_auth.dart';

class AuthLocalService {
  final LocalAuthentication _auth = LocalAuthentication();

  Future<bool> autenticarBiometricamente() async {
    try {
      final bool puedeAutenticar = await _auth.canCheckBiometrics;
      final bool tieneBiometricoDisponible = await _auth.isDeviceSupported();

      if (!puedeAutenticar || !tieneBiometricoDisponible) return false;

      return await _auth.authenticate(
        localizedReason: 'Autenticarse con huella o FaceID',
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
        ),
      );
    } catch (e) {
      print('Error autenticando: $e');
      return false;
    }
  }
}
