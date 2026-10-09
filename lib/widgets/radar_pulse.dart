import 'package:flutter/material.dart';

class RadarPulse extends StatefulWidget {
  const RadarPulse({super.key, required this.color, this.size = 220});

  final Color color;
  final double size;

  @override
  State<RadarPulse> createState() => _RadarPulseState();
}

class _RadarPulseState extends State<RadarPulse>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 3),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, _) => CustomPaint(
        size: Size.square(widget.size),
        painter: _RadarPainter(_controller.value, widget.color),
      ),
    );
  }
}

class _RadarPainter extends CustomPainter {
  _RadarPainter(this.t, this.color);

  final double t;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final maxR = size.shortestSide / 2;

    for (var i = 0; i < 3; i++) {
      final phase = (t + i / 3) % 1.0;
      canvas.drawCircle(
        center,
        maxR * (0.35 + 0.65 * phase),
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2
          ..color = color.withAlpha(((1 - phase) * 180).round()),
      );
    }
    canvas.drawCircle(
      center,
      maxR * 0.34,
      Paint()..color = color.withAlpha(35),
    );
  }

  @override
  bool shouldRepaint(_RadarPainter old) => old.t != t || old.color != color;
}