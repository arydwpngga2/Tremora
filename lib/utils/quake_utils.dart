import 'package:flutter/material.dart';

Color magnitudeColor(double m) {
  if (m < 3) return const Color(0xFF69F0AE);
  if (m < 4) return const Color(0xFFC6FF00);
  if (m < 5) return const Color(0xFFFFD54F);
  if (m < 6) return const Color(0xFFFF9800);
  if (m < 7) return const Color(0xFFFF5252);
  return const Color(0xFFD50000);
}

String _two(int n) => n.toString().padLeft(2, '0');

const _bulan = [
  'Jan',
  'Feb',
  'Mar',
  'Apr',
  'Mei',
  'Jun',
  'Jul',
  'Agu',
  'Sep',
  'Okt',
  'Nov',
  'Des',
];

// UTC -> WIB (UTC+7)
String formatWib(DateTime utc) {
  final t = utc.toUtc().add(const Duration(hours: 7));
  return '${_two(t.day)} ${_bulan[t.month - 1]} ${t.year},'
      '${_two(t.hour)}:${_two(t.minute)} WIB';
}

String timeAgo(DateTime utc) {
  final d = DateTime.now().toUtc().difference(utc);
  if (d.inMinutes < 1) return 'baru saja';
  if (d.inMinutes < 60) return '${d.inMinutes} mnt lalu';
  if (d.inHours < 24) return '${d.inHours} jam lalu';
  return '${d.inDays} hari lalu';
}

String hhmm(DateTime t) => '${_two(t.hour)}:${_two(t.minute)}';