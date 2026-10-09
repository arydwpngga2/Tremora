import 'package:flutter/material.dart';
import '../controllers/quake_controller.dart';
import '../models/quake.dart';
import '../utils/quake_utils.dart';
import '../widgets/quake_detail.dart';
import '../widgets/quake_tile.dart';
import '../widgets/radar_pulse.dart';
import '../widgets/state_views.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, required this.controller});

  final QuakeController controller;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;

    return SafeArea(
      child: ListenableBuilder(
        listenable: controller,
        builder: (context, _) {
          final c = controller;

          if (c.latest == null && c.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (c.latest == null && c.error != null) {
            return ErrorView(message: c.error!, onRetry: c.refresh);
          }

          return RefreshIndicator(
            onRefresh: c.refresh,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
              children: [
                _Header(controller: c),
                const SizedBox(height: 16),
                if (c.latest != null) _HeroCard(quake: c.latest!),
                const SizedBox(height: 24),
                Text('Gempa M 5.0+ terkini',
                    style: text.titleMedium
                        ?.copyWith(fontWeight: FontWeight.w700)),
                const SizedBox(height: 10),
                for (final q in c.strong) QuakeTile(quake: q),
                const SizedBox(height: 8),
                Center(
                  child: Text(
                    'Sumber data: BMKG · Bukan sistem peringatan dini resmi',
                    style: text.bodySmall?.copyWith(color: Colors.white38),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.controller});

  final QuakeController controller;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final c = controller;
    final status = c.offline
        ? 'Mode offline · menampilkan data tersimpan'
        : c.updatedAt == null
            ? ''
            : 'Diperbarui ${hhmm(c.updatedAt!)}';

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Tremora',
                  style: text.headlineMedium
                      ?.copyWith(fontWeight: FontWeight.w800)),
              Text(status,
                  style: text.bodySmall?.copyWith(
                      color: c.offline ? Colors.amber : Colors.white60)),
            ],
          ),
        ),
        c.loading
            ? const Padding(
                padding: EdgeInsets.all(12),
                child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2)),
              )
            : IconButton(onPressed: c.refresh, icon: const Icon(Icons.refresh)),
      ],
    );
  }
}

class _HeroCard extends StatelessWidget {
  const _HeroCard({required this.quake});

  final Quake quake;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final color = magnitudeColor(quake.magnitude);

    return GestureDetector(
      onTap: () => showQuakeDetail(context, quake),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: color.withAlpha(90)),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [color.withAlpha(60), const Color(0xFF111827)],
          ),
        ),
        child: Column(
          children: [
            Text('GEMPA TERBARU',
                style: text.labelLarge
                    ?.copyWith(letterSpacing: 2, color: Colors.white70)),
            SizedBox(
              width: 220,
              height: 220,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  RadarPulse(color: color),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('M',
                          style: text.titleMedium?.copyWith(color: color)),
                      Text(
                        quake.magnitude.toStringAsFixed(1),
                        style: text.displayLarge?.copyWith(
                            fontWeight: FontWeight.w800, color: Colors.white),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Text(quake.region,
                textAlign: TextAlign.center,
                style: text.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
            const SizedBox(height: 4),
            Text('${formatWib(quake.time)} · ${timeAgo(quake.time)}',
                style: text.bodySmall?.copyWith(color: Colors.white70)),
            const SizedBox(height: 14),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.center,
              children: [
                _Chip(Icons.vertical_align_bottom,
                    '${quake.depthKm.toStringAsFixed(0)} km'),
                _Chip(Icons.place_outlined,
                    '${quake.lat.toStringAsFixed(2)}, ${quake.lon.toStringAsFixed(2)}'),
                if (quake.potential.isNotEmpty)
                  _Chip(Icons.warning_amber_rounded, quake.potential),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip(this.icon, this.label);

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 300),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white.withAlpha(18),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: Colors.white70),
            const SizedBox(width: 6),
            Flexible(
              child: Text(label,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall),
            ),
          ],
        ),
      ),
    );
  }
}