import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GuildLeaderboardScreen extends StatelessWidget {
  const GuildLeaderboardScreen({super.key});

  static const int weeklyGoal = 50000;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0C1A),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text("Guild Leaderboard"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection("guilds").snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final guildDocs = snapshot.data!.docs;

          final guilds = guildDocs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return {
              "id": doc.id,
              "name": data["name"] ?? "",
              "icon": data["icon"] ?? "🏰",
              "weeklySteps": data["weeklySteps"] ?? 0,
            };
          }).toList();

          guilds.sort((a, b) => b["weeklySteps"].compareTo(a["weeklySteps"]));
          final topGuild = guilds.isNotEmpty ? guilds.first : null;

          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              if (topGuild != null)
                Column(
                  children: [
                    const Text("Weekly Goal: 50,000 Steps",
                        style: TextStyle(color: Colors.white70)),
                    const SizedBox(height: 8),
                    _guildProgress(topGuild),
                    const SizedBox(height: 20),
                  ],
                ),

              const Text("Guild Rankings",
                  style: TextStyle(color: Colors.white, fontSize: 20)),
              const SizedBox(height: 10),

              ...guilds.map((g) => _guildTile(g)),
            ],
          );
        },
      ),
    );
  }

  Widget _guildTile(Map<String, dynamic> g) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Text(g["icon"], style: const TextStyle(fontSize: 24)),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              g["name"],
              style: const TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
          Text("${g["weeklySteps"]}",
              style: const TextStyle(color: Colors.greenAccent, fontSize: 18)),
        ],
      ),
    );
  }

  Widget _guildProgress(Map<String, dynamic> guild) {
    final steps = guild["weeklySteps"];
    final pct = (steps / weeklyGoal).clamp(0, 1.0);

    return Column(
      children: [
        Text(
          "${guild["icon"]} ${guild["name"]}",
          style: const TextStyle(color: Colors.white, fontSize: 20),
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: LinearProgressIndicator(
            value: pct,
            minHeight: 12,
            backgroundColor: Colors.white12,
            valueColor: const AlwaysStoppedAnimation(Colors.greenAccent),
          ),
        ),
        const SizedBox(height: 6),
        Text("$steps / $weeklyGoal steps",
            style: const TextStyle(color: Colors.white70)),
      ],
    );
  }
}
