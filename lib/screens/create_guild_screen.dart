import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../services/guild_service.dart';
import '../services/profile_services.dart';
import 'home_screen.dart';

class CreateGuildScreen extends StatefulWidget {
  const CreateGuildScreen({super.key});

  @override
  State<CreateGuildScreen> createState() => _CreateGuildScreenState();
}

class _CreateGuildScreenState extends State<CreateGuildScreen> {
  final TextEditingController nameCtrl = TextEditingController();
  bool loading = false;
  String? error;

  Future<void> _createGuild() async {
    final name = nameCtrl.text.trim();
    if (name.isEmpty) {
      setState(() => error = "Guild name cannot be empty.");
      return;
    }

    setState(() => loading = true);

    final uid = FirebaseAuth.instance.currentUser!.uid;
    final guildId = name.toLowerCase().replaceAll(" ", "_");

    final ref = FirebaseFirestore.instance.collection("guilds").doc(guildId);

    try {
      // 1. CREATE THE GUILD DOCUMENT
      await ref.set({
        "name": name,
        "icon": "🏰",
        "members": [uid],
        "level": 1,
        "weeklySteps": 0,
      });

      // 2. ASSIGN GUILD TO PLAYER PROFILE
      await ProfileService.instance.assignGuild(guildId);

      // 3. NAVIGATE TO HOME
      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen()),
              (_) => false,
        );
      }
    } catch (e) {
      setState(() => error = e.toString());
    }

    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0C1A),
      appBar: AppBar(
        title: const Text("Create a Guild"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: nameCtrl,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: "Guild Name",
                labelStyle: TextStyle(color: Colors.white70),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white38),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
            ),

            const SizedBox(height: 20),

            if (error != null)
              Text(error!, style: const TextStyle(color: Colors.redAccent)),

            const SizedBox(height: 20),

            GestureDetector(
              onTap: loading ? null : _createGuild,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: Colors.purpleAccent,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: loading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                    "Create Guild",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
