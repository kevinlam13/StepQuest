import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/player_profile.dart';
import '../services/profile_services.dart';
import 'encounter_screen.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  PlayerProfile? profile;
  bool loading = true;

  late AnimationController _shakeController;
  String? levelUpMessage;

  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 120));
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final data = await ProfileService.instance.getProfile(uid);

    setState(() {
      profile = data;
      loading = false;
    });
  }

  void _showLevelUpPopup(int gained, int newLevel) {
    if (gained <= 0) return;

    setState(() {
      levelUpMessage = "✨ LEVEL UP! You reached Level $newLevel!";
    });

    _shakeController.forward(from: 0);

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => levelUpMessage = null);
    });
  }

  Future<void> _addFakeSteps() async {
    if (profile == null) return;

    setState(() => loading = true);
    final beforeLevel = profile!.level;

    final updated = await ProfileService.instance.addFakeSteps(amount: 500);

    final gained = updated.level - beforeLevel;

    setState(() {
      profile = updated;
      loading = false;
    });

    _showLevelUpPopup(gained, updated.level);
  }

  double _xpPercent() {
    if (profile == null) return 0;
    return (profile!.xp / profile!.xpNeededForNextLevel).clamp(0, 1);
  }

  @override
  Widget build(BuildContext context) {
    if (loading || profile == null) {
      return const Scaffold(
        backgroundColor: Color(0xFF050814),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final p = profile!;

    // Encounter unlock logic
    bool encounterAvailable = p.stepsUntilNextEncounter <= 0;

    return Scaffold(
      backgroundColor: const Color(0xFF050814),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D0F1F),
        title: const Text("StepQuest"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: "Logout",
            onPressed: () async {
              await FirebaseAuth.instance.signOut();

              if (context.mounted) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                      (_) => false,
                );
              }
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.all(20),
            children: [
              /// XP + Level
              Text("Level ${p.level}",
                  style: const TextStyle(fontSize: 20, color: Colors.white)),
              const SizedBox(height: 8),
              LinearProgressIndicator(
                value: _xpPercent(),
                color: Colors.blueAccent,
                backgroundColor: Colors.white12,
                minHeight: 12,
              ),
              Text("${p.xp} / ${p.xpNeededForNextLevel} XP",
                  style: const TextStyle(color: Colors.white70)),
              const SizedBox(height: 25),

              /// STEPS
              Text("Today's Steps: ${p.todaySteps}",
                  style: const TextStyle(color: Colors.white)),
              Text("Total Steps: ${p.totalSteps}",
                  style: const TextStyle(color: Colors.white54)),
              const SizedBox(height: 12),

              ElevatedButton(
                onPressed: _addFakeSteps,
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black45,
                    minimumSize: const Size(double.infinity, 48)),
                child: const Text("Add 500 Demo Steps"),
              ),

              const SizedBox(height: 25),

              /// DAILY QUEST
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1D38),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Daily Quest",
                        style: TextStyle(color: Colors.white, fontSize: 18)),
                    const SizedBox(height: 6),

                    Text(
                      p.dailyQuestCompleted
                          ? "✔ Quest Complete! +100 XP"
                          : "Walk ${p.dailyQuestGoal} steps",
                      style: const TextStyle(color: Colors.white70),
                    ),

                    const SizedBox(height: 10),

                    LinearProgressIndicator(
                      value:
                      (p.dailyQuestProgress / p.dailyQuestGoal).clamp(0, 1),
                      color: Colors.greenAccent,
                      backgroundColor: Colors.white12,
                      minHeight: 10,
                    ),
                    const SizedBox(height: 6),

                    Text(
                      "${p.dailyQuestProgress} / ${p.dailyQuestGoal}",
                      style: const TextStyle(color: Colors.white54),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              /// ENCOUNTERS
              ElevatedButton(
                onPressed: encounterAvailable
                    ? () async {
                  final before = p.level;
                  final updated = await ProfileService.instance
                      .completeEncounter();

                  final gained = updated.level - before;

                  setState(() => profile = updated);
                  _showLevelUpPopup(gained, updated.level);

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) =>
                            EncounterScreen(profile: updated)),
                  ).then((_) => _loadProfile());
                }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                  encounterAvailable ? Colors.redAccent : Colors.grey,
                  minimumSize: const Size(double.infinity, 48),
                ),
                child: Text(
                  encounterAvailable
                      ? "⚔ Start Encounter"
                      : "Walk ${p.stepsUntilNextEncounter} more steps",
                ),
              ),

              const SizedBox(height: 25),

              /// Guild button placeholder
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purpleAccent,
                    minimumSize: const Size(double.infinity, 48)),
                child: const Text("Guild"),
              ),
            ],
          ),

          /// LEVEL UP POPUP
          if (levelUpMessage != null)
            Center(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E223A),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.yellowAccent, width: 2),
                ),
                child: Text(
                  levelUpMessage!,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontFamily: "monospace"),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
