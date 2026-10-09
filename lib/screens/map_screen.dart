import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../controllers/quake_controller.dart';
import '../utils/quake_utils.dart';
import '../widgets/quake_detail.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({super.key, required this.controller});

  final QuakeController controller;

  double _size(double m) => (10 + (m - 2) * 7).clamp(14.0, 56.0).toDouble();

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        final quakes = [...controller.allQuakes]
          ..sort((a, b) => b.magnitude.compareTo(a.magnitude));

        return Stack(
          children: [
            FlutterMap(
              options: MapOptions(
                initialCenter: LatLng(-2.5, 118),
                initialZoom: 4.3,
                minZoom: 3,
                maxZoom: 12,
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}{r}.png',
                  subdomains: const ['a', 'b', 'c', 'd'],
                  userAgentPackageName: 'com.example.tremora',
                ),
                MarkerLayer(
                  markers: [
                    for (final q in quakes)
                      Marker(
                        point: LatLng(q.lat, q.lon),
                        width: _size(q.magnitude),
                        height: _size(q.magnitude),
                        child: GestureDetector(
                          onTap: () => showQuakeDetail(context, q),
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: magnitudeColor(q.magnitude).withAlpha(110),
                              border: Border.all(
                                color: magnitudeColor(q.magnitude),
                                width: 2,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                RichAttributionWidget(
                  attributions: [
                    TextSourceAttribution('OpenStreetMap contributors, CARTO'),
                    TextSourceAttribution('Data gempa: BMKG'),
                  ],
                ),
              ],
            ),
            Positioned(
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: _Legend(count: quakes.length),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _Legend extends StatelessWidget {
  const _Legend({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    const items = {'< 4': 3.5, '4-5': 4.5, '5-6': 5.5, '6+': 6.5};

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF111827).withAlpha(220),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('$count gempa', style: text.labelLarge),
          const SizedBox(height: 6),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (final e in items.entries) ...[
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: magnitudeColor(e.value),
                  ),
                ),
                const SizedBox(width: 4),
                Text(e.key, style: text.bodySmall),
                const SizedBox(width: 10),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
