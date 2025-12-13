import 'package:flutter/material.dart';

class AvatarRenderer extends StatelessWidget {
  final int bodyColor;
  final int eyeStyle;  // 0–6
  final int hairStyle; // 0–6
  final int hatStyle;  // -1 = none

  const AvatarRenderer({
    super.key,
    required this.bodyColor,
    required this.eyeStyle,
    required this.hairStyle,
    required this.hatStyle,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 120,
      height: 120,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          _buildBody(),
          _buildEyes(),
          _buildHair(),
          if (hatStyle >= 0) _buildHat(),
        ],
      ),
    );
  }

  // =====================================================
  // BODY (simple pixel circle/square hybrid)
  // =====================================================
  Widget _buildBody() {
    return Positioned(
      left: 20,
      top: 20,
      child: Container(
        width: 80,
        height: 90,
        decoration: BoxDecoration(
          color: Color(bodyColor),
          borderRadius: BorderRadius.circular(6), // pixel-ish
        ),
      ),
    );
  }

  // =====================================================
  // EYES (7 styles)
  // =====================================================
  Widget _buildEyes() {
    final eyeWidgets = [
      _eyeDot(),          // 0: cute dots
      _eyeWide(),         // 1: big wide
      _eyeAngry(),        // 2: angry
      _eyeHappy(),        // 3: happy ^ ^
      _eyeSleepy(),       // 4: sleepy - -
      _eyeSparkle(),      // 5: sparkle ✨
      _eyePixel(),        // 6: retro pixel squares
    ];

    return Positioned(
      top: 50,
      left: 32,
      child: eyeWidgets[eyeStyle.clamp(0, 6)],
    );
  }

  Widget _eyeDot() {
    return Row(
      children: [
        _pixel(10, 10),
        SizedBox(width: 18),
        _pixel(10, 10),
      ],
    );
  }

  Widget _eyeWide() {
    return Row(
      children: [
        _pixel(14, 10),
        SizedBox(width: 12),
        _pixel(14, 10),
      ],
    );
  }

  Widget _eyeAngry() {
    return Row(
      children: [
        Transform.rotate(
          angle: -0.3,
          child: _pixel(12, 8),
        ),
        SizedBox(width: 16),
        Transform.rotate(
          angle: 0.3,
          child: _pixel(12, 8),
        ),
      ],
    );
  }

  Widget _eyeHappy() {
    return Row(
      children: [
        Container(width: 14, height: 6, color: Colors.black),
        SizedBox(width: 12),
        Container(width: 14, height: 6, color: Colors.black),
      ],
    );
  }

  Widget _eyeSleepy() {
    return Row(
      children: [
        Container(width: 14, height: 4, color: Colors.black),
        SizedBox(width: 12),
        Container(width: 14, height: 4, color: Colors.black),
      ],
    );
  }

  Widget _eyeSparkle() {
    return Row(
      children: [
        _pixel(8, 8, color: Colors.white),
        SizedBox(width: 18),
        _pixel(8, 8, color: Colors.white),
      ],
    );
  }

  Widget _eyePixel() {
    return Row(
      children: [
        _pixel(12, 12),
        SizedBox(width: 12),
        _pixel(12, 12),
      ],
    );
  }

  // =====================================================
  // HAIR (7 styles)
  // =====================================================
  Widget _buildHair() {
    final hairWidgets = [
      _hairShort(),
      _hairLong(),
      _hairSpiky(),
      _hairCurly(),
      _hairSide(),
      _hairMessy(),
      _hairMohawk(),
    ];

    return Positioned(
      top: 5,
      left: 20,
      child: hairWidgets[hairStyle.clamp(0, 6)],
    );
  }

  Widget _hairShort() {
    return _pixel(80, 25, color: Colors.brown);
  }

  Widget _hairLong() {
    return Column(
      children: [
        _pixel(80, 25, color: Colors.brown),
        _pixel(60, 20, color: Colors.brown),
      ],
    );
  }

  Widget _hairSpiky() {
    return Column(
      children: [
        _pixel(80, 18, color: Colors.brown),
        Row(
          children: [
            _pixel(20, 18),
            SizedBox(width: 4),
            _pixel(20, 18),
            SizedBox(width: 4),
            _pixel(20, 18),
          ],
        ),
      ],
    );
  }

  Widget _hairCurly() {
    return Row(
      children: [
        _pixel(25, 25, color: Colors.brown),
        SizedBox(width: 4),
        _pixel(25, 25, color: Colors.brown),
      ],
    );
  }

  Widget _hairSide() {
    return Row(
      children: [
        _pixel(50, 25, color: Colors.brown),
        _pixel(20, 20, color: Colors.brown),
      ],
    );
  }

  Widget _hairMessy() {
    return Row(
      children: [
        _pixel(20, 25),
        SizedBox(width: 8),
        _pixel(30, 25),
      ],
    );
  }

  Widget _hairMohawk() {
    return Row(
      children: [
        _pixel(12, 25),
        SizedBox(width: 4),
        _pixel(12, 25),
        SizedBox(width: 4),
        _pixel(12, 25),
        SizedBox(width: 4),
        _pixel(12, 25),
      ],
    );
  }

  // =====================================================
  // HAT (cosmetic rewards)
  // =====================================================
  Widget _buildHat() {
    final hatWidgets = [
      _pixel(60, 15, color: Colors.red),        // 0: red band
      _pixel(70, 20, color: Colors.yellow),     // 1: wizard band
      _pixel(75, 25, color: Colors.purple),     // 2: top bar
    ];

    return Positioned(
      top: -5,
      left: 20,
      child: hatWidgets[hatStyle.clamp(0, 2)],
    );
  }

  // =====================================================
  // Helper pixel
  // =====================================================
  Widget _pixel(double w, double h, {Color color = Colors.black}) {
    return Container(width: w, height: h, color: color);
  }
}
