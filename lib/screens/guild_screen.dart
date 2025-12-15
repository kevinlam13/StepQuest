import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class GuildScreen extends StatefulWidget {
  const GuildScreen({super.key});

  @override
  State<GuildScreen> createState() => _GuildScreenState();
}

class _GuildScreenState extends State<GuildScreen> {
  bool _loading = true;
  Map<String, dynamic>? _guildData;

  @override
  void initState() {
    super.initState();
    _loadGuild();
  }

  Future<void> _loadGuild() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    // Load user
    final userDoc = await FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .get();

    final guildId = userDoc.data()?["guildId"];
    if (guildId == null) {
      setState(() => _loading = false);
      return;
    }

    // Fetch guild document
    final guildDoc = await FirebaseFirestore.instance
        .collection("guilds")
        .doc(guildId)
        .get();

    setState(() {
      _guildData = guildDoc.data();
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF050814),
      appBar: AppBar(
        title: const Text("Your Guild"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _guildData == null
          ? const Center(
        child: Text(
          "You are not in a guild.",
          style: TextStyle(color: Colors.white),
        ),
      )
          : _buildGuildUI(),
    );
  }

  Widget _buildGuildUI() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // Guild Title
          Text(
            _guildData!["name"] ?? "Unknown Guild",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),

          // Guild Emblem
          Text(
            _guildData!["emblem"] ?? "🛡️",
            style: const TextStyle(fontSize: 36),
          ),

          const SizedBox(height: 20),

          // Weekly steps
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Weekly Steps", style: TextStyle(color: Colors.white70)),
              Text("${_guildData!["weeklySteps"] ?? 0}",
                  style: const TextStyle(color: Colors.white, fontSize: 16)),
            ],
          ),

          const SizedBox(height: 16),

          // Member Count
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Members", style: TextStyle(color: Colors.white70)),
              Text("${_guildData!["members"].length}",
                  style: const TextStyle(color: Colors.white, fontSize: 16)),
            ],
          ),

          const SizedBox(height: 40),

          // Leaderboard button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                // TODO: Build leaderboard screen later
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurpleAccent,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
              ),
              child: const Text(
                "View Guild Leaderboard",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Optional: Leave Guild button
          TextButton(
            onPressed: () {},
            child: const Text(
              "Leave Guild",
              style: TextStyle(color: Colors.redAccent),
            ),
          ),
        ],
      ),
    );
  }
}
