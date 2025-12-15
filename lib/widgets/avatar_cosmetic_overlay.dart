// lib/widgets/avatar_cosmetic_overlay.dart
import 'package:flutter/material.dart';
import '../models/player_profile.dart';

class AvatarCosmeticOverlay extends StatelessWidget {
  final PlayerProfile profile;
  final double size;

  const AvatarCosmeticOverlay({
    super.key,
    required this.profile,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        children: [
          // HAIRSTYLE
          if (profile.hairstyle != "none")
            Image.asset(
              "assets/cosmetics/hair/${profile.hairstyle}.png",
              width: size,
              height: size,
            ),

          // HAT
          if (profile.hatType != "none")
            Image.asset(
              "assets/cosmetics/hats/${profile.hatType}.png",
              width: size,
              height: size,
            ),

          // FACIAL HAIR
          if (profile.facialHair != "none")
            Image.asset(
              "assets/cosmetics/facial/${profile.facialHair}.png",
              width: size,
              height: size,
            ),
        ],
      ),
    );
  }
}
