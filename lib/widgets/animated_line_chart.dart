import 'dart:ui';

import 'package:aap_ka_dost/models/coin.dart';
import 'package:flutter/material.dart';

class AnimatedLineChart extends StatefulWidget {
  final List<PricePoint> points;
  final bool isRising;

  const AnimatedLineChart({super.key, required this.points, required this.isRising});

  @override
  State<AnimatedLineChart> createState() => _AnimatedLineChartState();
}

class _AnimatedLineChartState extends State<AnimatedLineChart> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200))..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return CustomPaint(
          painter: _LineChartPainter(
            points: widget.points,
            progress: Curves.easeOutCubic.transform(_controller.value),
            color: widget.isRising ? const Color(0xFF00C853) : const Color(0xFFD50000),
          ),
          child: const SizedBox.expand(),
        );
      },
    );
  }
}

class _LineChartPainter extends CustomPainter {
  final List<PricePoint> points;
  final double progress; // 0..1
  final Color color;

  _LineChartPainter({required this.points, required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    if (points.isEmpty) return;

    final double minP = points.map((e) => e.price).reduce((a, b) => a < b ? a : b);
    final double maxP = points.map((e) => e.price).reduce((a, b) => a > b ? a : b);
    final double range = (maxP - minP).abs() < 1e-6 ? 1 : (maxP - minP);

    final Path path = Path();
    final Path fillPath = Path();

    final int drawCount = (points.length * progress).clamp(1, points.length).toInt();

    Offset toPoint(int i) {
      final double x = i / (points.length - 1) * size.width;
      final double yNorm = (points[i].price - minP) / range; // 0 low .. 1 high
      final double y = size.height - yNorm * size.height; // invert
      return Offset(x, y);
    }

    final first = toPoint(0);
    path.moveTo(first.dx, first.dy);
    fillPath.moveTo(0, size.height);
    fillPath.lineTo(first.dx, first.dy);

    for (int i = 1; i < drawCount; i++) {
      final p0 = toPoint(i - 1);
      final p1 = toPoint(i);
      final control = Offset((p0.dx + p1.dx) / 2, (p0.dy + p1.dy) / 2);
      path.quadraticBezierTo(control.dx, control.dy, p1.dx, p1.dy);
      fillPath.quadraticBezierTo(control.dx, control.dy, p1.dx, p1.dy);
    }

    // Grid lines
    final gridPaint = Paint()
      ..color = const Color(0x11000000)
      ..strokeWidth = 1;
    const gridLines = 4;
    for (int i = 1; i < gridLines; i++) {
      final y = size.height * i / gridLines;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    // Glow line
    final glowPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8
      ..color = color.withOpacity(0.15)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
    canvas.drawPath(path, glowPaint);

    // Main line
    final linePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..color = color;
    canvas.drawPath(path, linePaint);

    // Gradient fill under line
    fillPath.lineTo(size.width * progress, size.height);
    fillPath.close();

    final Shader shader = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [color.withOpacity(0.25), Colors.transparent],
    ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final fillPaint = Paint()..shader = shader;
    canvas.drawPath(fillPath, fillPaint);
  }

  @override
  bool shouldRepaint(covariant _LineChartPainter oldDelegate) {
    return oldDelegate.points != points ||
        oldDelegate.progress != progress ||
        oldDelegate.color != color;
  }
}
