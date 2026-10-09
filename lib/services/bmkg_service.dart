import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/quake.dart';

class FeedResult {
  final List<Quake> quakes;
  final bool fromCache;
  const FeedResult(this.quakes, this.fromCache);
}

class BmkgService {
  static const _base = 'https://data.bmkg.go.id/DataMKG/TEWS/';

  Future<FeedResult> fetch(String file) async {
    final prefs = await SharedPreferences.getInstance();
    try {
      final res = await http
          .get(Uri.parse('$_base$file'))
          .timeout(const Duration(seconds: 15));
      if (res.statusCode != 200) throw Exception('HTTP ${res.statusCode}');

      final body = utf8.decode(res.bodyBytes);
      final quakes = parse(body);
      await prefs.setString('cache_$file', body);
      return FeedResult(quakes, false);
    } catch (_) {
      final cached = prefs.getString('cache_$file');
      if (cached == null) rethrow;
      return FeedResult(parse(cached), true);
    }
  }

  static List<Quake> parse(String body) {
    final root = jsonDecode(body) as Map<String, dynamic>;
    final data = (root['Infogempa'] as Map<String, dynamic>)['gempa'];
    final items = data is List ? data : [data];

    final quakes = <Quake>[];
    for (final item in items) {
      try {
        quakes.add(Quake.fromJson(item as Map<String, dynamic>));
      } catch (_) {
        // skip data yg cacat
      }
    }
    quakes.sort((a, b) => b.time.compareTo(a.time));
    return quakes;
  }
}
