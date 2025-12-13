import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/profile_services.dart';
import 'home_screen.dart';
import 'create_guild_screen.dart';

class GuildSelectionScreen extends StatefulWidget {
  const GuildSelectionScreen({super.key});

  @override
  State<GuildSelectionScreen> createState() => _GuildSelectionScreenState();
}

class _GuildSelectionScreenState extends State<GuildSelectionScreen> {
  bool _loading = false;

  Future<void> _pickGuild(String guildId) async {
    if (_loading) return;
    setState(() => _loading = true);

    await ProfileService.instance.assignGuild(guildId);

    if (mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
            (_) => false,
      );
    }
  }

  Widget _guildButton({
    required String title,
    required String emoji,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 24),
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          color: const Color(0xFF6C4BFF),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Center(
          child: Text(
            "$emoji  $title",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF050814),
      appBar: AppBar(
        title: const Text("Choose Your Guild"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          const SizedBox(height: 20),
          const Text(
            "Unite with a powerful guild!\nYour steps contribute to weekly guild quests.",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),
          const SizedBox(height: 30),

          _guildButton(
            title: "Glacier Sentinels",
            emoji: "❄️",
            onTap: () => _pickGuild("glacier_sentinels"),
          ),
          _guildButton(
            title: "Thunderstorm Legion",
            emoji: "⚡",
            onTap: () => _pickGuild("thunderstorm_legion"),
          ),
          _guildButton(
            title: "Emberborne Clan",
            emoji: "🔥",
            onTap: () => _pickGuild("emberborne_clan"),
          ),

          const SizedBox(height: 40),

          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => const CreateGuildScreen()),
              );
            },
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 24),
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.white70, width: 1.4),
              ),
              child: const Center(
                child: Text(
                  "+ Create Your Own Guild",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
