import 'package:flutter/material.dart';
import '../models/cosmetic_option.dart';

final List<CosmeticOption> cosmeticOptions = [
  // --------- HAIRSTYLES ----------
  CosmeticOption(
    id: "H1",
    type: CosmeticType.hairstyle,
    displayName: "Short Hair",
    icon: Icons.face_6,
  ),
  CosmeticOption(
    id: "H2",
    type: CosmeticType.hairstyle,
    displayName: "Spiky Hair",
    icon: Icons.face_retouching_natural,
  ),

  // --------- HAIR COLORS ----------
  CosmeticOption(
    id: "HC1",
    type: CosmeticType.hairColor,
    displayName: "Dark Brown",
    icon: Icons.circle,
    color: Color(0xFF4A2F24),
  ),
  CosmeticOption(
    id: "HC2",
    type: CosmeticType.hairColor,
    displayName: "Blonde",
    icon: Icons.circle,
    color: Color(0xFFFFE08A),
  ),

  // --------- HATS ----------
  CosmeticOption(
    id: "HT1",
    type: CosmeticType.hat,
    displayName: "Wizard Hat",
    icon: Icons.auto_fix_high,
  ),
  CosmeticOption(
    id: "HT2",
    type: CosmeticType.hat,
    displayName: "Baseball Cap",
    icon: Icons.emoji_people,
  ),

  // --------- FACIAL HAIR ----------
  CosmeticOption(
    id: "F1",
    type: CosmeticType.facialHair,
    displayName: "Goatee",
    icon: Icons.boy_outlined,
  ),
];
