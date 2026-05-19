class ErrorMapper {
  const ErrorMapper._();

  static const String _genericoAuth =
      'No se pudo iniciar sesión. Intenta de nuevo.';
  static const String _genericoData = 'Ocurrió un error. Intenta de nuevo.';

  /// Mensaje para errores de Firebase Auth (login, registro, sign out).
  static String fromAuth(Object error) {
    final code = _extractCode(error);
    return _authFromCode(code);
  }

  /// Mensaje para errores de Firestore / Storage (crear/editar/enviar promos).
  static String fromData(Object error) {
    final code = _extractCode(error);
    return _dataFromCode(code);
  }

  static String _authFromCode(String? code) {
    switch (code) {
      case 'invalid-email':
        return 'El correo no es válido.';
      case 'user-disabled':
        return 'Esta cuenta está deshabilitada.';
      case 'user-not-found':
      case 'wrong-password':
      case 'invalid-credential':
        return 'Correo o contraseña incorrectos.';
      case 'email-already-in-use':
        return 'Ese correo ya está registrado.';
      case 'weak-password':
        return 'La contraseña es demasiado débil.';
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

  static String _dataFromCode(String? code) {
    switch (code) {
      case 'permission-denied':
      case 'unauthorized':
        return 'No tienes permiso para realizar esta acción.';
      case 'unavailable':
        return 'Servicio no disponible. Intenta de nuevo en un momento.';
      case 'deadline-exceeded':
        return 'La operación tardó demasiado. Verifica tu conexión.';
      case 'not-found':
      case 'object-not-found':
        return 'El recurso ya no existe.';
      case 'cancelled':
        return 'La operación fue cancelada.';
      case 'resource-exhausted':
        return 'Has alcanzado el límite. Intenta más tarde.';
      case 'failed-precondition':
        return 'No se pudo completar la operación. Revisa los datos.';
      case 'network-request-failed':
      case 'retry-limit-exceeded':
        return 'Sin conexión. Verifica tu red.';
      default:
        return _genericoData;
    }
  }

  /// Conservado por compatibilidad con tests existentes.
  static String authFromCode(String? code) => _authFromCode(code);

  static String? _extractCode(Object error) {
    try {
      final dyn = error as dynamic;
      final code = dyn.code;
      if (code is String) return code;
    } catch (_) {}
    return null;
  }
}
