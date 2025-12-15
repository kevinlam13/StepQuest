import 'package:flutter/material.dart';
import '../models/player_profile.dart';
import '../services/profile_services.dart';
import '../widgets/avatar_renderer.dart';

class CosmeticRewardScreen extends StatefulWidget {
  final PlayerProfile profile;

  const CosmeticRewardScreen({super.key, required this.profile});

  @override
  State<CosmeticRewardScreen> createState() => _CosmeticRewardScreenState();
}

class _CosmeticRewardScreenState extends State<CosmeticRewardScreen> {
  String? selectedHair;
  int? selectedHairColor;
  String? selectedHat;
  String? selectedFacialHair;

  static const hairColors = [
    Colors.brown,
    Colors.black,
    Colors.red,
    Colors.yellow,
    Colors.white,
  ];

  @override
  Widget build(BuildContext context) {
    final p = widget.profile;

    return Scaffold(
      backgroundColor: const Color(0xFF0A0C1A),
      appBar: AppBar(
        title: const Text("Choose Your Reward"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),

          // -----------------------
          // PREVIEW AVATAR
          // -----------------------
          Center(
            child: AvatarRenderer(
              auraColor: Colors.blueAccent,
              hairstyle: selectedHair ?? p.hairstyle,
              hairColorValue: selectedHairColor ?? p.hairColorValue,
              hatType: selectedHat ?? p.hatType,
              facialHair: selectedFacialHair ?? p.facialHair,
            ),
          ),

          const SizedBox(height: 20),

          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _sectionTitle("Hairstyles"),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _hairOption("H1"),
                    _hairOption("H2"),
                  ],
                ),

                const SizedBox(height: 20),

                _sectionTitle("Hair Colors"),
                Wrap(
                  spacing: 10,
                  children: hairColors
                      .map((c) => _colorCircle(c))
                      .toList(),
                ),

                const SizedBox(height: 20),

                _sectionTitle("Hats"),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _hatOption("HT1"),
                    _hatOption("HT2"),
                  ],
                ),

                const SizedBox(height: 20),

                _sectionTitle("Facial Hair"),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _facialOption("F1"),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          GestureDetector(
            onTap: _confirmReward,
            child: Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFB26BFF), Color(0xFF712BCE)],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Center(
                child: Text(
                  "Confirm Reward",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ),

          const SizedBox(height: 30),
        ],
      ),
    );
  }

  // ============================================
  // UI HELPERS
  // ============================================

  Widget _sectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(text,
          style: const TextStyle(fontSize: 18, color: Colors.white)),
    );
  }

  Widget _hairOption(String id) {
    return GestureDetector(
      onTap: () => setState(() => selectedHair = id),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: selectedHair == id ? Colors.purple : Colors.white12,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          Icons.face_6,
          size: 40,
          color: selectedHair == id ? Colors.white : Colors.white70,
        ),
      ),
    );
  }

  Widget _hatOption(String id) {
    return GestureDetector(
      onTap: () => setState(() => selectedHat = id),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: selectedHat == id ? Colors.purple : Colors.white12,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          Icons.emoji_emotions,
          size: 40,
          color: selectedHat == id ? Colors.white : Colors.white70,
        ),
      ),
    );
  }

  Widget _facialOption(String id) {
    return GestureDetector(
      onTap: () => setState(() => selectedFacialHair = id),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: selectedFacialHair == id ? Colors.purple : Colors.white12,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          Icons.account_circle,
          size: 40,
          color: selectedFacialHair == id ? Colors.white : Colors.white70,
        ),
      ),
    );
  }

  Widget _colorCircle(Color c) {
    return GestureDetector(
      onTap: () => setState(() => selectedHairColor = c.value),
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: c,
          shape: BoxShape.circle,
          border: Border.all(
            color: selectedHairColor == c.value ? Colors.white : Colors.transparent,
            width: 2,
          ),
        ),
      ),
    );
  }

  // ============================================
  // CONFIRM
  // ============================================
  Future<void> _confirmReward() async {
    await ProfileService.instance.saveCosmetics(
      hairstyle: selectedHair,
      hairColorValue: selectedHairColor,
      hatType: selectedHat,
      facialHair: selectedFacialHair,
    );

    if (mounted) Navigator.pop(context);
  }
}
