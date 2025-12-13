import 'package:flutter/material.dart';
import '../models/player_profile.dart';

class EncounterScreen extends StatelessWidget {
  final PlayerProfile profile;

  const EncounterScreen({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0E1A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF101426),
        title: const Text("Encounter"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "${profile.heroClass} ${profile.displayName} encounters a lurking shadow...",
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white, fontSize: 18),
              ),
              const SizedBox(height: 25),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
                child: const Text("Finish Encounter"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
