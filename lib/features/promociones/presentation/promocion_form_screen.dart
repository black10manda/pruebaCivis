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
import '../../../core/widgets/fade_in_up.dart';
import '../application/promocion_form_controller.dart';
import '../domain/promocion.dart';
import '../domain/promocion_draft.dart';
import 'widgets/form_header.dart';
import 'widgets/promocion_date_field.dart';
import 'widgets/promocion_image_picker.dart';
import 'widgets/promocion_status_card.dart';

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
    final cs = Theme.of(context).colorScheme;
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
        backgroundColor: cs.surface,
        body: SafeArea(
          child: AbsorbPointer(
            absorbing: isLoading,
            child: Column(
              children: [
                FadeInUp(
                  child: FormHeader(
                    titulo: widget.esEdicion
                        ? 'Editar promoción'
                        : 'Nueva promoción',
                    subtitulo: widget.esEdicion
                        ? 'Actualiza los datos de tu promoción'
                        : 'Completa los datos para crearla',
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 24.h),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          FadeInUp(
                            delay: const Duration(milliseconds: 80),
                            child: PromocionImagePicker(
                              imagen: _imagen,
                              imagenUrl: _imagenUrl,
                              onSeleccionar: _seleccionarImagen,
                              onQuitar: _quitarImagen,
                            ),
                          ),
                          SizedBox(height: 20.h),
                          FadeInUp(
                            delay: const Duration(milliseconds: 140),
                            child: AppTextField(
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
                          ),
                          SizedBox(height: 14.h),
                          FadeInUp(
                            delay: const Duration(milliseconds: 200),
                            child: AppTextField(
                              controller: _descripcionController,
                              label: 'Descripción',
                              textInputAction: TextInputAction.newline,
                              maxLines: 4,
                              minLines: 3,
                              maxLength: 280,
                              validator: (v) => Validators.combinar([
                                () =>
                                    Validators.requerido(v, campo: 'Descripción'),
                                () => Validators.longitudMaxima(
                                  v,
                                  max: 280,
                                  campo: 'Descripción',
                                ),
                              ]),
                            ),
                          ),
                          SizedBox(height: 14.h),
                          FadeInUp(
                            delay: const Duration(milliseconds: 260),
                            child: PromocionDateField(
                              fechaFormateada: fechaFormateada,
                              onTap: _seleccionarFecha,
                            ),
                          ),
                          SizedBox(height: 12.h),
                          FadeInUp(
                            delay: const Duration(milliseconds: 320),
                            child: PromocionStatusCard(
                              activo: _activo,
                              onChanged: (v) => setState(() => _activo = v),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                _BottomCta(
                  label: widget.esEdicion
                      ? 'Guardar cambios'
                      : 'Crear promoción',
                  isLoading: isLoading,
                  onPressed: _guardar,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _BottomCta extends StatelessWidget {
  const _BottomCta({
    required this.label,
    required this.isLoading,
    required this.onPressed,
  });

  final String label;
  final bool isLoading;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 16.h),
      decoration: BoxDecoration(
        color: cs.surface,
        border: Border(
          top: BorderSide(
            color: cs.outlineVariant.withValues(alpha: 0.6),
          ),
        ),
      ),
      child: AppButton(
        label: label,
        onPressed: onPressed,
        isLoading: isLoading,
      ),
    );
  }
}
