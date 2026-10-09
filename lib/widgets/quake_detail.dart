import 'package:flutter/material.dart';

import '../models/quake.dart';
import '../utils/quake_utils.dart';
import 'quake_tile.dart';

void showQuakeDetail(BuildContext context, Quake quake) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: const Color(0xFF111827),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
    ),
    builder: (_) => _QuakeDetail(quake: quake),
  );
}

class _QuakeDetail extends StatelessWidget {
  const _QuakeDetail({required this.quake});

  final Quake quake;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                MagnitudeBadge(magnitude: quake.magnitude, size: 64),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    quake.region,
                    style: text.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _InfoRow('Waktu', formatWib(quake.time)),
            _InfoRow(
              'Koordinat',
              '${quake.lat.toStringAsFixed(2)}, ${quake.lon.toStringAsFixed(2)}',
            ),
            _InfoRow('Kedalaman', '${quake.depthKm.toStringAsFixed(0)} km'),
            if (quake.potential.isNotEmpty)
              _InfoRow('Potensi', quake.potential),
            if (quake.felt.isNotEmpty) _InfoRow('Dirasakan', quake.felt),
            if (quake.shakemap.isNotEmpty) ...[
              const SizedBox(height: 16),
              Text(
                'Peta guncangan (shakemap)',
                style: text.labelLarge?.copyWith(color: Colors.white70),
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  'https://static.bmkg.go.id/${quake.shakemap}',
                  fit: BoxFit.cover,
                  loadingBuilder: (_, child, progress) => progress == null
                      ? child
                      : const SizedBox(
                          height: 160,
                          child: Center(child: CircularProgressIndicator()),
                        ),
                  errorBuilder: (_, _, _) => const SizedBox.shrink(),
                ),
              ),
            ],
            const SizedBox(height: 16),
            Text(
              'Sumber: BMKG. Bukan sistem peringatan dini resmi.',
              style: text.bodySmall?.copyWith(color: Colors.white54),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow(this.label, this.value);

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 92,
            child: Text(
              label,
              style: text.bodyMedium?.copyWith(color: Colors.white60),
            ),
          ),
          Expanded(child: Text(value, style: text.bodyMedium)),
        ],
      ),
    );
  }
}
