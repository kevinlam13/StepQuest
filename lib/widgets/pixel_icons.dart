import 'package:flutter/material.dart';

//
// Pixel base painter helper
//
class PixelIconPainter {
  final Canvas canvas;
  final Size size;
  final Paint paint;

  PixelIconPainter(this.canvas, this.size, Color color)
      : paint = Paint()..color = color;

  double get p => size.width / 8;

  void px(double x, double y, {double w = 1, double h = 1}) {
    canvas.drawRect(
      Rect.fromLTWH(x * p, y * p, p * w, p * h),
      paint,
    );
  }
}

//
// ❄ GLACIER – SNOWFLAKE
//
class PixelSnowflake extends StatelessWidget {
  final double size;
  final Color color;
  const PixelSnowflake({this.size = 48, this.color = Colors.cyanAccent, super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: _SnowflakePainter(color),
    );
  }
}

class _SnowflakePainter extends CustomPainter {
  final Color color;
  _SnowflakePainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final px = PixelIconPainter(canvas, size, color);

    // Pixel snowflake pattern (symmetrical 8x8)
    px.px(3, 0); px.px(4, 0);
    px.px(3, 1); px.px(4, 1);

    px.px(2, 2); px.px(5, 2);
    px.px(3, 3); px.px(4, 3);

    px.px(2, 4); px.px(5, 4);
    px.px(3, 5); px.px(4, 5);

    px.px(3, 6); px.px(4, 6);
  }

  @override
  bool shouldRepaint(_) => false;
}

//
// ⚡ THUNDERSTORM – LIGHTNING BOLT
//
class PixelLightning extends StatelessWidget {
  final double size;
  final Color color;
  const PixelLightning({this.size = 48, this.color = Colors.yellowAccent, super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: _LightningPainter(color),
    );
  }
}

class _LightningPainter extends CustomPainter {
  final Color color;
  _LightningPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final px = PixelIconPainter(canvas, size, color);

    // Pixel lightning pattern
    px.px(2, 0);
    px.px(3, 0); px.px(4, 0);

    px.px(3, 1); px.px(4, 1);

    px.px(4, 2);

    px.px(5, 3);

    px.px(4, 4); px.px(5, 4);

    px.px(3, 5);

    px.px(2, 6); px.px(3, 6);
  }

  @override
  bool shouldRepaint(_) => false;
}

//
// 🔥 EMBER – FLAME
//
class PixelFlame extends StatelessWidget {
  final double size;
  final Color color;
  const PixelFlame({this.size = 48, this.color = Colors.deepOrangeAccent, super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: _FlamePainter(color),
    );
  }
}

class _FlamePainter extends CustomPainter {
  final Color color;
  _FlamePainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final px = PixelIconPainter(canvas, size, color);

    // Pixel flame (chunky retro fire)
    px.px(3, 0);

    px.px(2, 1); px.px(3, 1); px.px(4, 1);

    px.px(2, 2); px.px(4, 2);

    px.px(1, 3); px.px(2, 3); px.px(3, 3); px.px(4, 3); px.px(5, 3);

    px.px(2, 4); px.px(3, 4); px.px(4, 4);

    px.px(3, 5);

    px.px(2, 6); px.px(3, 6); px.px(4, 6);
  }

  @override
  bool shouldRepaint(_) => false;
}
