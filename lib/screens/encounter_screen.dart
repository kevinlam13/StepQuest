import 'package:flutter/material.dart';
import 'package:stepquest/models/player_profile.dart';
import 'package:stepquest/services/profile_services.dart';

class EncounterScreen extends StatefulWidget {
  final PlayerProfile profile;

  const EncounterScreen({super.key, required this.profile});

  @override
  State<EncounterScreen> createState() => _EncounterScreenState();
}

class _EncounterScreenState extends State<EncounterScreen> {
  bool fighting = false;
  bool finished = false;
  int xpGained = 0;

  Future<void> _fight() async {
    setState(() => fighting = true);

    // Use your existing encounter system
    final updated = await ProfileService.instance.completeEncounter();

    xpGained = updated.xp - widget.profile.xp;

    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      fighting = false;
      finished = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0C1A),
      appBar: AppBar(
        title: const Text("Encounter"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Center(
        child: finished
            ? _victoryView()
            : fighting
            ? _fightingView()
            : _encounterView(),
      ),
    );
  }

  // ----------------------
  // MONSTER APPEARS
  // ----------------------
  Widget _encounterView() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "A Giant Monster Appears!",
          style: TextStyle(color: Colors.white, fontSize: 22),
        ),
        const SizedBox(height: 20),

        const Text("👹", style: TextStyle(fontSize: 120)),

        const SizedBox(height: 40),


        ElevatedButton(
          onPressed: _fight,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.pinkAccent,
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 18),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          child: const Text(
            "Fight!",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  // ----------------------
  // FIGHTING ANIMATION
  // ----------------------
  Widget _fightingView() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        Text("Fighting...", style: TextStyle(color: Colors.white, fontSize: 22)),
        SizedBox(height: 20),
        Text("⚔️", style: TextStyle(fontSize: 120)),
      ],
    );
  }

  // ----------------------
  // VICTORY SCREEN
  // ----------------------
  Widget _victoryView() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "You Defeated the Monster!",
          style: TextStyle(color: Colors.white, fontSize: 22),
        ),
        const SizedBox(height: 20),
        const Text("🏆", style: TextStyle(fontSize: 120)),
        const SizedBox(height: 20),
        Text(
          "+$xpGained XP",
          style: const TextStyle(
            color: Colors.greenAccent,
            fontSize: 26,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 40),
        ElevatedButton(
          onPressed: () => Navigator.pop(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blueAccent,
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 18),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          child: const Text(
            "Return",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        )
      ],
    );
  }
}
