class Validators {
  const Validators._();

  static final RegExp _emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  static String? requerido(String? value, {String campo = 'Campo'}) {
    if (value == null || value.trim().isEmpty) {
      return '$campo es requerido';
    }
    return null;
  }

  static String? email(String? value) {
    final v = value?.trim() ?? '';
    if (v.isEmpty) return 'El correo es requerido';
    if (!_emailRegex.hasMatch(v)) return 'Correo no válido';
    return null;
  }

  static String? password(String? value, {int minLength = 6}) {
    final v = value ?? '';
    if (v.isEmpty) return 'La contraseña es requerida';
    if (v.length < minLength) {
      return 'Debe tener al menos $minLength caracteres';
    }
    return null;
  }

  static String? longitudMaxima(
    String? value, {
    required int max,
    String campo = 'Campo',
  }) {
    if (value == null) return null;
    if (value.length > max) {
      return '$campo debe tener máximo $max caracteres';
    }
    return null;
  }

  static String? coincide(
    String? value,
    String original, {
    String mensaje = 'Las contraseñas no coinciden',
  }) {
    if (value != original) return mensaje;
    return null;
  }

  static String? combinar(List<String? Function()> validadores) {
    for (final v in validadores) {
      final result = v();
      if (result != null) return result;
    }
    return null;
  }
}
