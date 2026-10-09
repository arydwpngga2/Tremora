import 'package:flutter/material.dart';

import '../controllers/quake_controller.dart';
import '../widgets/quake_tile.dart';
import '../widgets/state_views.dart';

class FeltScreen extends StatelessWidget {
  const FeltScreen({super.key, required this.controller});

  final QuakeController controller;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;

    return SafeArea(
      child: ListenableBuilder(
        listenable: controller,
        builder: (context, _) {
          final c = controller;

          if (c.felt.isEmpty && c.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (c.felt.isEmpty && c.error != null) {
            return ErrorView(message: c.error!, onRetry: c.refresh);
          }

          return RefreshIndicator(
            onRefresh: c.refresh,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
              children: [
                Text(
                  'Dirasakan',
                  style: text.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  '15 gempa terakhir yang dirasakan masyarakat',
                  style: text.bodySmall?.copyWith(color: Colors.white60),
                ),
                const SizedBox(height: 16),
                for (final q in c.felt) QuakeTile(quake: q, showFelt: true),
              ],
            ),
          );
        },
      ),
    );
  }
}
