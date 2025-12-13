import 'package:flutter/material.dart';

class XPBar extends StatelessWidget {
  final int currentXP;
  final int maxXP;
  final double height;

  const XPBar({
    super.key,
    required this.currentXP,
    required this.maxXP,
    this.height = 22,
  });

  @override
  Widget build(BuildContext context) {
    final progress = (currentXP / maxXP).clamp(0.0, 1.0);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: const Color(0xFF3A3A57),
          width: 3,
        ),
        color: const Color(0xFF0D0D1A),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(3),
        child: Stack(
          children: [
            // 🔵 Pixel outline → dark
            Container(color: const Color(0xFF141427)),

            // 🌈 Smooth glowing gradient → hybrid style
            FractionallySizedBox(
              widthFactor: progress,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFF5A5FEF).withOpacity(.95),
                      const Color(0xFF8E9AFF),
                      const Color(0xFFB8C0FF),
                    ],
                  ),
                ),
              ),
            ),

            // ✨ XP text centered
            Center(
              child: Text(
                "$currentXP / $maxXP XP",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  shadows: [
                    Shadow(
                      color: Colors.black87,
                      blurRadius: 4,
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
