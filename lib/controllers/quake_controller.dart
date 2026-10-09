import 'package:flutter/foundation.dart';

import '../models/quake.dart';
import '../services/bmkg_service.dart';

class QuakeController extends ChangeNotifier {
  QuakeController(this._service);

  final BmkgService _service;

  Quake? latest;
  List<Quake> strong = [];
  List<Quake> felt = [];
  bool loading = false;
  bool offline = false;
  String? error;
  DateTime? updatedAt;

  List<Quake> get allQuakes {
    final map = <String, Quake>{};
    for (final q in [?latest, ...strong, ...felt]) {
      map[q.id] = q;
    }
    return map.values.toList();
  }

  Future<void> refresh() async {
    if (loading) return;
    loading = true;
    error = null;
    notifyListeners();

    try {
      final results = await Future.wait([
        _service.fetch('autogempa.json'),
        _service.fetch('gempaterkini.json'),
        _service.fetch('gempadirasakan.json'),
      ]);
      latest = results[0].quakes.isEmpty ? null : results[0].quakes.first;
      strong = results[1].quakes;
      felt = results[2].quakes;
      offline = results.any((r) => r.fromCache);
      updatedAt = DateTime.now();
    } catch (_) {
      error = 'Gagal memuat data. Periksa koneksi internet';
    }

    loading = false;
    notifyListeners();
  }
}
