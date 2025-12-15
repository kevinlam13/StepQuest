import 'package:flutter/material.dart';

class AvatarRenderer extends StatelessWidget {
  final Color auraColor;
  final String? hairstyle;
  final int? hairColorValue;
  final String? hatType;
  final String? facialHair;

  const AvatarRenderer({
    super.key,
    required this.auraColor,
    required this.hairstyle,
    required this.hairColorValue,
    required this.hatType,
    required this.facialHair,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(140, 140),
      painter: _AvatarPainter(
        auraColor: auraColor,
        hairstyle: hairstyle,
        hairColorValue: hairColorValue,
        hatType: hatType,
        facialHair: facialHair,
      ),
    );
  }
}

class _AvatarPainter extends CustomPainter {
  final Color auraColor;
  final String? hairstyle;
  final int? hairColorValue;
  final String? hatType;
  final String? facialHair;

  _AvatarPainter({
    required this.auraColor,
    required this.hairstyle,
    required this.hairColorValue,
    required this.hatType,
    required this.facialHair,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    const headRadius = 35.0;

    // Aura glow
    canvas.drawCircle(
        center,
        headRadius + 20,
        Paint()
          ..color = auraColor.withOpacity(0.3)
          ..style = PaintingStyle.fill);

    // Head
    canvas.drawCircle(
        center,
        headRadius,
        Paint()
          ..color = const Color(0xFFF6D7B0)
          ..style = PaintingStyle.fill);

    // Hair
    if (hairstyle != null && hairstyle != "none") {
      final hairPaint = Paint()
        ..color = Color(hairColorValue ?? Colors.brown.value)
        ..style = PaintingStyle.fill;

      switch (hairstyle) {
        case "H1":
          _drawShortHair(canvas, center, headRadius, hairPaint);
          break;
        case "H2":
          _drawSpikyHair(canvas, center, headRadius, hairPaint);
          break;
      }
    }

    // Eyes
    final eyePaint = Paint()..color = Colors.black;
    canvas.drawCircle(center + const Offset(-12, -5), 4, eyePaint);
    canvas.drawCircle(center + const Offset(12, -5), 4, eyePaint);

    // Mouth
    final mouth = Rect.fromCenter(center: center + const Offset(0, 12), width: 30, height: 20);
    canvas.drawArc(mouth, 0, 3.14, false, Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3);

    // Facial hair
    if (facialHair == "F1") {
      final beard = Rect.fromCenter(center: center + const Offset(0, 32), width: 22, height: 12);
      canvas.drawOval(beard, Paint()..color = Colors.brown.shade800);
    }

    // Hats
    if (hatType == "HT1") _drawWizardHat(canvas, center, headRadius);
    if (hatType == "HT2") _drawBaseballCap(canvas, center, headRadius);
  }

  // Drawing helpers for hair + hats...
  void _drawShortHair(Canvas canvas, Offset center, double r, Paint paint) {
    final path = Path();

    // Smooth curved hairline above the head
    path.moveTo(center.dx - r * 0.9, center.dy - r * 0.2);
    path.quadraticBezierTo(
        center.dx, center.dy - r * 0.9, center.dx + r * 0.9, center.dy - r * 0.2);

    path.lineTo(center.dx + r * 0.9, center.dy - r * 0.7);
    path.quadraticBezierTo(
        center.dx, center.dy - r * 1.2, center.dx - r * 0.9, center.dy - r * 0.7);

    path.close();
    canvas.drawPath(path, paint);
  }


  void _drawSpikyHair(Canvas canvas, Offset center, double r, Paint paint) {
    final path = Path();

    path.moveTo(center.dx - r * 1, center.dy - r * 0.2);

    // 3 main spikes
    path.lineTo(center.dx - r * 0.5, center.dy - r * 1.8);
    path.lineTo(center.dx, center.dy - r * 0.8);
    path.lineTo(center.dx + r * 0.6, center.dy - r * 1.8);

    path.lineTo(center.dx + r * 1, center.dy - r * 0.2);

    // Close lower part
    path.close();

    canvas.drawPath(path, paint);
  }

  void _drawWizardHat(Canvas canvas, Offset center, double r) {
    final paint = Paint()..color = Colors.deepPurple;

    final path = Path();
    path.moveTo(center.dx - r * 0.8, center.dy - r * 1.1);
    path.lineTo(center.dx, center.dy - r * 2.0);
    path.lineTo(center.dx + r * 0.8, center.dy - r * 1.1);
    path.close();

    canvas.drawPath(path, paint);

    // brim
    canvas.drawOval(
      Rect.fromCenter(
        center: center + Offset(0, -r * 1.05),
        width: r * 1.8,
        height: r * 0.25,
      ),
      paint,
    );
  }

  void _drawBaseballCap(Canvas canvas, Offset c, double r) {
    final paint = Paint()..color = Colors.red;
    final top = Rect.fromCenter(
        center: c + Offset(0, -r / 1.2), width: r * 1.6, height: r * 0.8);
    canvas.drawOval(top, paint);
    canvas.drawRect(Rect.fromLTWH(c.dx - r, c.dy - r / 1.2, r * 1.2, 10), paint);
  }

  @override
  bool shouldRepaint(_) => true;
}
