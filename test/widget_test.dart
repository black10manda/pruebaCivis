import 'package:flutter_test/flutter_test.dart';

import 'package:prueba/core/utils/validators.dart';
import 'package:prueba/core/utils/error_mapper.dart';

void main() {
  group('Validators.email', () {
    test('rechaza vacío', () {
      expect(Validators.email(''), isNotNull);
      expect(Validators.email(null), isNotNull);
    });

    test('rechaza formato inválido', () {
      expect(Validators.email('abc'), isNotNull);
      expect(Validators.email('abc@'), isNotNull);
      expect(Validators.email('abc@dominio'), isNotNull);
    });

    test('acepta formato válido', () {
      expect(Validators.email('user@example.com'), isNull);
      expect(Validators.email('a.b+tag@dominio.co'), isNull);
    });
  });

  group('Validators.password', () {
    test('rechaza vacío', () {
      expect(Validators.password(''), isNotNull);
      expect(Validators.password(null), isNotNull);
    });

    test('rechaza menor a 6 caracteres', () {
      expect(Validators.password('12345'), isNotNull);
    });

    test('acepta 6 o más', () {
      expect(Validators.password('123456'), isNull);
    });
  });

  group('ErrorMapper', () {
    test('mapea códigos conocidos', () {
      expect(
        ErrorMapper.authFromCode('invalid-credential'),
        contains('incorrectos'),
      );
      expect(
        ErrorMapper.authFromCode('too-many-requests'),
        contains('intentos'),
      );
    });

    test('mensaje genérico para código desconocido', () {
      expect(ErrorMapper.authFromCode('foo-bar'), isNotEmpty);
    });
  });
}
