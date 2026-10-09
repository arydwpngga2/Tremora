import 'package:flutter/material.dart';

import '../models/quake.dart';
import '../utils/quake_utils.dart';
import 'quake_detail.dart';

class MagnitudeBadge extends StatelessWidget {
  const MagnitudeBadge({super.key, required this.magnitude, this.size = 52});

  final double magnitude;
  final double size;

  @override
  Widget build(BuildContext context) {
    final c = magnitudeColor(magnitude);
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: c.withAlpha(40),
        border: Border.all(color: c, width: 2),
      ),
      child: Text(
        magnitude.toStringAsFixed(1),
        style: TextStyle(
          color: c,
          fontWeight: FontWeight.w800,
          fontSize: size * 0.36,
        ),
      ),
    );
  }
}

class QuakeTile extends StatelessWidget {
  const QuakeTile({super.key, required this.quake, this.showFelt = false});

  final Quake quake;
  final bool showFelt;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: Colors.white.withAlpha(12),
        borderRadius: BorderRadius.circular(18),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () => showQuakeDetail(context, quake),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                MagnitudeBadge(magnitude: quake.magnitude),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        quake.region,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: text.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${quake.depthKm.toStringAsFixed(0)} km · ${timeAgo(quake.time)}',
                        style: text.bodySmall?.copyWith(color: Colors.white70),
                      ),
                      if (showFelt && quake.felt.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          quake.felt,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: text.bodySmall?.copyWith(
                            color: Colors.amber.shade200,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
