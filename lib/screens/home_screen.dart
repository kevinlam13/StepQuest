import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/player_profile.dart';
import '../services/profile_services.dart';
import '../widgets/avatar_renderer.dart';

import 'cosmetic_reward_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  PlayerProfile? profile;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final p = await ProfileService.instance.getProfile(uid);

    setState(() {
      profile = p;
      loading = false;
    });
  }

  Future<void> _addSteps() async {
    final updated = await ProfileService.instance.addSteps(amount: 500);
    setState(() => profile = updated);
  }

  Future<void> _doEncounter() async {
    final updated = await ProfileService.instance.completeEncounter();
    setState(() => profile = updated);
  }

  Future<void> _claimDaily() async {
    final updated = await ProfileService.instance.claimDailyReward();
    setState(() => profile = updated);
  }

  /// ⭐ NEW: A reward is available if user leveled up AND has pendingReward = true
  bool get rewardAvailable {
    if (profile == null) return false;
    return profile!.pendingReward;
  }

  void _openReward() {
    if (profile == null) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CosmeticRewardScreen(profile: profile!),
      ),
    ).then((_) => _loadProfile());
  }

  Future<void> _logout() async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    if (loading || profile == null) {
      return const Scaffold(
        backgroundColor: Color(0xFF0A0C1A),
        body: Center(child: CircularProgressIndicator(color: Colors.white)),
      );
    }

    final p = profile!;

    return Scaffold(
      backgroundColor: const Color(0xFF0A0C1A),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: _logout,
            icon: const Icon(Icons.logout, color: Colors.white70),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          children: [
            // ---------------- AVATAR ----------------
            Center(
              child: AvatarRenderer(
                auraColor: Colors.blueAccent,
                hairstyle: p.hairstyle,
                hairColorValue: p.hairColorIndex != null
                    ? Colors.primaries[p.hairColorIndex % Colors.primaries.length].value
                    : Colors.brown.value,
                hatType: p.hatType,
                facialHair: p.facialHair,
              ),
            ),

            const SizedBox(height: 10),

            Text(
              p.displayName ?? "Unnamed Hero",
              style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 6),
            Text(
              "Guild: ${p.guildId ?? "None"}",
              style: const TextStyle(color: Colors.white70),
            ),

            const SizedBox(height: 20),

            Text("Level ${p.level}", style: const TextStyle(color: Colors.white, fontSize: 18)),
            const SizedBox(height: 8),
            _xpBar(current: p.xp, max: p.xpNeededForNextLevel),

            const SizedBox(height: 20),

            // ---------------- COSMETIC REWARD BUTTON ----------------
            if (rewardAvailable)
              GestureDetector(
                onTap: _openReward,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFB26BFF), Color(0xFF712BCE)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.purpleAccent.withOpacity(0.5),
                        blurRadius: 20,
                      )
                    ],
                  ),
                  child: const Center(
                    child: Text(
                      "⭐ Cosmetic Reward Available! ⭐",
                      style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),

            _bigButton(label: "+500 Steps", color: Colors.greenAccent, onTap: _addSteps),
            const SizedBox(height: 14),

            if (p.stepsUntilNextEncounter <= 0)
              _bigButton(label: "Encounter!", color: Colors.orangeAccent, onTap: _doEncounter)
            else
              Text(
                "${p.stepsUntilNextEncounter} steps until next encounter",
                style: const TextStyle(color: Colors.white70),
              ),

            const SizedBox(height: 14),

            _dailyQuestSection(p),
          ],
        ),
      ),
    );
  }

  // ---------------- XP BAR ----------------
  Widget _xpBar({required int current, required int max}) {
    final pct = current / max;
    return Container(
      height: 16,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white12,
        borderRadius: BorderRadius.circular(12),
      ),
      child: FractionallySizedBox(
        alignment: Alignment.centerLeft,
        widthFactor: pct.clamp(0, 1),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.blueAccent,
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  // ---------------- BIG BUTTON ----------------
  Widget _bigButton({required String label, required Color color, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Center(
          child: Text(label, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }

  // ---------------- DAILY QUEST ----------------
  Widget _dailyQuestSection(PlayerProfile p) {
    if (p.dailyQuestCompleted) {
      return _bigButton(
        label: "Claim Daily Reward",
        color: Colors.yellowAccent,
        onTap: _claimDaily,
      );
    }

    return Column(
      children: [
        Text(
          "Daily Quest: ${p.dailyQuestProgress}/${p.dailyQuestGoal} steps",
          style: const TextStyle(color: Colors.white70),
        ),
        const SizedBox(height: 6),
        _xpBar(current: p.dailyQuestProgress, max: p.dailyQuestGoal),
      ],
    );
  }
}
