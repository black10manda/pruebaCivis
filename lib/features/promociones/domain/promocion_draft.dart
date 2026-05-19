import 'dart:io';

class PromocionDraft {
  const PromocionDraft({
    this.id,
    required this.titulo,
    required this.descripcion,
    required this.fecha,
    required this.activo,
    this.imagen,
    this.imagenUrl,
  });

  final String? id;
  final String titulo;
  final String descripcion;
  final DateTime fecha;
  final bool activo;
  final File? imagen;
  final String? imagenUrl;

  bool get esEdicion => id != null;

  PromocionDraft copyWith({
    String? titulo,
    String? descripcion,
    DateTime? fecha,
    bool? activo,
    File? imagen,
    String? imagenUrl,
    bool removerImagen = false,
  }) {
    return PromocionDraft(
      id: id,
      titulo: titulo ?? this.titulo,
      descripcion: descripcion ?? this.descripcion,
      fecha: fecha ?? this.fecha,
      activo: activo ?? this.activo,
      imagen: imagen ?? this.imagen,
      imagenUrl: removerImagen ? null : (imagenUrl ?? this.imagenUrl),
    );
  }
}
