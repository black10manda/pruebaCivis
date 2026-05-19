import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../auth/application/login_controller.dart';

class ListaPromocionesScreen extends ConsumerWidget {
  const ListaPromocionesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Promociones'),
        actions: [
          IconButton(
            tooltip: 'Cerrar sesión',
            icon: const Icon(Icons.logout),
            onPressed: () =>
                ref.read(loginControllerProvider.notifier).signOut(),
          ),
        ],
      ),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text(
            'Lista de promociones (pendiente)',
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
