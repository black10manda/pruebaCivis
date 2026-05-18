class ErrorMapper {
  const ErrorMapper._();

  static const String _genericoAuth = 'No se pudo iniciar sesión. Intenta de nuevo.';
  static const String _genericoData = 'Ocurrió un error. Intenta de nuevo.';

  static String authFromCode(String? code) {
    switch (code) {
      case 'invalid-email':
        return 'El correo no es válido.';
      case 'user-disabled':
        return 'Esta cuenta está deshabilitada.';
      case 'user-not-found':
      case 'wrong-password':
      case 'invalid-credential':
        return 'Correo o contraseña incorrectos.';
      case 'too-many-requests':
        return 'Demasiados intentos. Espera un momento e intenta de nuevo.';
      case 'network-request-failed':
        return 'Sin conexión. Verifica tu red.';
      case 'operation-not-allowed':
        return 'Operación no permitida.';
      default:
        return _genericoAuth;
    }
  }

  static String fromException(Object error) {
    final code = _extractCode(error);
    if (code != null) return authFromCode(code);
    return _genericoData;
  }

  static String? _extractCode(Object error) {
    try {
      final dyn = error as dynamic;
      final code = dyn.code;
      if (code is String) return code;
    } catch (_) {}
    return null;
  }
}
