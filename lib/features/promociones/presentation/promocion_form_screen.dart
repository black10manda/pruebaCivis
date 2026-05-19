import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../../core/utils/error_mapper.dart';
import '../../../core/utils/validators.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_text_field.dart';
import '../application/promocion_form_controller.dart';
import '../domain/promocion.dart';
import '../domain/promocion_draft.dart';

class PromocionFormScreen extends ConsumerStatefulWidget {
  const PromocionFormScreen({super.key, this.promocion});

  final Promocion? promocion;

  bool get esEdicion => promocion != null;

  @override
  ConsumerState<PromocionFormScreen> createState() =>
      _PromocionFormScreenState();
}

class _PromocionFormScreenState extends ConsumerState<PromocionFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _tituloController;
  late final TextEditingController _descripcionController;
  late DateTime _fecha;
  late bool _activo;
  File? _imagen;
  String? _imagenUrl;
  bool _removerImagen = false;

  @override
  void initState() {
    super.initState();
    final p = widget.promocion;
    _tituloController = TextEditingController(text: p?.titulo ?? '');
    _descripcionController = TextEditingController(text: p?.descripcion ?? '');
    _fecha = p?.fecha ?? DateTime.now();
    _activo = p?.activo ?? true;
    _imagenUrl = p?.imagenUrl;
  }

  @override
  void dispose() {
    _tituloController.dispose();
    _descripcionController.dispose();
    super.dispose();
  }

  Future<void> _seleccionarFecha() async {
    final hoy = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _fecha,
      firstDate: DateTime(hoy.year - 1),
      lastDate: DateTime(hoy.year + 5),
    );
    if (picked != null) {
      setState(() => _fecha = picked);
    }
  }

  Future<void> _seleccionarImagen() async {
    final picker = ImagePicker();
    final file = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
      maxWidth: 1600,
    );
    if (file != null) {
      setState(() {
        _imagen = File(file.path);
        _removerImagen = false;
      });
    }
  }

  void _quitarImagen() {
    setState(() {
      _imagen = null;
      _imagenUrl = null;
      _removerImagen = true;
    });
  }

  Future<void> _guardar() async {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();

    final draft = PromocionDraft(
      id: widget.promocion?.id,
      titulo: _tituloController.text.trim(),
      descripcion: _descripcionController.text.trim(),
      fecha: _fecha,
      activo: _activo,
      imagen: _imagen,
      imagenUrl: _removerImagen ? null : _imagenUrl,
    );

    final id = await ref
        .read(promocionFormControllerProvider.notifier)
        .guardar(draft);

    if (!mounted) return;
    if (id != null) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(
              widget.esEdicion ? 'Promoción actualizada' : 'Promoción creada',
            ),
          ),
        );
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(promocionFormControllerProvider);
    final isLoading = state.isLoading;
    final theme = Theme.of(context);
    final fechaFormateada = DateFormat('d MMM y', 'es').format(_fecha);

    ref.listen<AsyncValue<void>>(promocionFormControllerProvider, (_, next) {
      next.whenOrNull(
        error: (e, _) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(content: Text(ErrorMapper.fromException(e))),
            );
        },
      );
    });

    return PopScope(
      canPop: !isLoading,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            widget.esEdicion ? 'Editar promoción' : 'Nueva promoción',
          ),
        ),
        body: SafeArea(
          child: AbsorbPointer(
            absorbing: isLoading,
            child: Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(20.w),
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 600.w),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _ImagenPicker(
                          imagen: _imagen,
                          imagenUrl: _imagenUrl,
                          onSeleccionar: _seleccionarImagen,
                          onQuitar: _quitarImagen,
                        ),
                        SizedBox(height: 20.h),
                        AppTextField(
                          controller: _tituloController,
                          label: 'Título',
                          textInputAction: TextInputAction.next,
                          maxLength: 60,
                          validator: (v) => Validators.combinar([
                            () => Validators.requerido(v, campo: 'Título'),
                            () => Validators.longitudMaxima(
                              v,
                              max: 60,
                              campo: 'Título',
                            ),
                          ]),
                        ),
                        SizedBox(height: 16.h),
                        AppTextField(
                          controller: _descripcionController,
                          label: 'Descripción',
                          textInputAction: TextInputAction.newline,
                          maxLines: 4,
                          minLines: 3,
                          maxLength: 280,
                          validator: (v) => Validators.combinar([
                            () => Validators.requerido(v, campo: 'Descripción'),
                            () => Validators.longitudMaxima(
                              v,
                              max: 280,
                              campo: 'Descripción',
                            ),
                          ]),
                        ),
                        SizedBox(height: 16.h),
                        _FechaTile(
                          fecha: fechaFormateada,
                          onTap: _seleccionarFecha,
                        ),
                        SizedBox(height: 12.h),
                        Card(
                          child: SwitchListTile(
                            title: Text(
                              'Activa',
                              style: TextStyle(fontSize: 16.sp),
                            ),
                            subtitle: Text(
                              _activo
                                  ? 'Visible y disponible para envío'
                                  : 'Oculta de envíos',
                              style: theme.textTheme.bodySmall?.copyWith(
                                fontSize: 12.sp,
                              ),
                            ),
                            value: _activo,
                            onChanged: (v) => setState(() => _activo = v),
                          ),
                        ),
                        SizedBox(height: 28.h),
                        AppButton(
                          label: widget.esEdicion
                              ? 'Guardar cambios'
                              : 'Crear promoción',
                          onPressed: _guardar,
                          isLoading: isLoading,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _FechaTile extends StatelessWidget {
  const _FechaTile({required this.fecha, required this.onTap});

  final String fecha;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: ListTile(
        leading: Icon(
          Icons.event_outlined,
          color: theme.colorScheme.primary,
          size: 24.sp,
        ),
        title: Text('Fecha', style: TextStyle(fontSize: 16.sp)),
        subtitle: Text(fecha, style: TextStyle(fontSize: 14.sp)),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}

class _ImagenPicker extends StatelessWidget {
  const _ImagenPicker({
    required this.imagen,
    required this.imagenUrl,
    required this.onSeleccionar,
    required this.onQuitar,
  });

  final File? imagen;
  final String? imagenUrl;
  final VoidCallback onSeleccionar;
  final VoidCallback onQuitar;

  bool get _tieneImagen => imagen != null || imagenUrl != null;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onSeleccionar,
      borderRadius: BorderRadius.circular(16.r),
      child: Container(
        height: 180.h,
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest.withValues(
            alpha: 0.4,
          ),
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: theme.colorScheme.outlineVariant),
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (imagen != null)
              Image.file(imagen!, fit: BoxFit.cover)
            else if (imagenUrl != null)
              Image.network(
                imagenUrl!,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) =>
                    const Center(child: Icon(Icons.broken_image_outlined)),
              )
            else
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.add_photo_alternate_outlined,
                      size: 40.sp,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'Toca para agregar imagen (opcional)',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontSize: 14.sp,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            if (_tieneImagen)
              Positioned(
                top: 8.h,
                right: 8.w,
                child: Material(
                  color: Colors.black54,
                  shape: const CircleBorder(),
                  child: InkWell(
                    customBorder: const CircleBorder(),
                    onTap: onQuitar,
                    child: Padding(
                      padding: EdgeInsets.all(6.w),
                      child: Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 20.sp,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
