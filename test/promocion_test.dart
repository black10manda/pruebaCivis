import 'package:flutter_test/flutter_test.dart';

import 'package:prueba/features/promociones/domain/promocion.dart';
import 'package:prueba/features/promociones/domain/promocion_draft.dart';

void main() {
  group('Promocion.copyWith', () {
    final base = Promocion(
      id: 'abc',
      titulo: 'Original',
      descripcion: 'Desc',
      fecha: DateTime(2026, 5, 1),
      activo: true,
      creadoPor: 'user1',
      creadoEn: DateTime(2026, 1, 1),
    );

    test('cambia título sin tocar resto', () {
      final nueva = base.copyWith(titulo: 'Nuevo');
      expect(nueva.titulo, 'Nuevo');
      expect(nueva.descripcion, base.descripcion);
      expect(nueva.id, base.id);
    });

    test('marca como enviada', () {
      final enviada = DateTime(2026, 5, 18);
      final nueva = base.copyWith(enviadaEn: enviada);
      expect(nueva.yaEnviada, true);
      expect(nueva.enviadaEn, enviada);
    });

    test('yaEnviada es false si enviadaEn es null', () {
      expect(base.yaEnviada, false);
    });
  });

  group('PromocionDraft', () {
    test('esEdicion true cuando hay id', () {
      final draft = PromocionDraft(
        id: 'abc',
        titulo: 't',
        descripcion: 'd',
        fecha: DateTime.now(),
        activo: true,
      );
      expect(draft.esEdicion, true);
    });

    test('esEdicion false cuando no hay id', () {
      final draft = PromocionDraft(
        titulo: 't',
        descripcion: 'd',
        fecha: DateTime.now(),
        activo: true,
      );
      expect(draft.esEdicion, false);
    });

    test('copyWith con removerImagen limpia imagenUrl', () {
      final draft = PromocionDraft(
        titulo: 't',
        descripcion: 'd',
        fecha: DateTime.now(),
        activo: true,
        imagenUrl: 'https://...',
      );
      final actualizado = draft.copyWith(removerImagen: true);
      expect(actualizado.imagenUrl, isNull);
    });
  });
}
