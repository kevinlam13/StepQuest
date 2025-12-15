import 'package:flutter/material.dart';

enum CosmeticType { hairstyle, hairColor, hat, facialHair }

class CosmeticOption {
  final String id;              // Ex: "H1"
  final CosmeticType type;      // hairstyle, hairColor, hat, facialHair
  final String displayName;     // Ex: "Short Hair"
  final IconData icon;          // Visual icon shown in UI
  final Color? color;           // For hair colors

  CosmeticOption({
    required this.id,
    required this.type,
    required this.displayName,
    required this.icon,
    this.color,
  });
}
