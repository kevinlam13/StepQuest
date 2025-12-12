import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/player_profile.dart';
import '../services/profile_services.dart';
import 'character_creation_screen.dart';
import 'encounter_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  // Color palettes we reuse for cards
  List<List<Color>> get _palettes => const [
    [Color(0xFF4ECDC4), Color(0xFF1B998B)],
    [Color(0xFFFFD166), Color(0xFFE29578)],
    [Color(0xFF8E9AFF), Color(0xFF5A5FEF)],
    [Color(0xFFEE6C4D), Color(0xFFFFB347)],
  ];

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1B2540),
        title: const Text(
          'StepQuest Dashboard',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            tooltip: 'Sign out',
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
            },
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF050816),
              Color(0xFF12142A),
              Color(0xFF2B2148),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: StreamBuilder<PlayerProfile?>(
          stream: ProfileService.instance.watchCurrentUserProfile(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            final profile = snapshot.data;

            // 👉 No character yet → show “Create Adventurer” view
            if (profile == null) {
              final email = user?.email ?? 'Adventurer';
              return _buildNoCharacterView(context, email);
            }

            final palette =
            _palettes[profile.colorIndex % _palettes.length];
            final stepsToNext =
            ProfileService.instance.stepsToNextEncounter(profile);

            return ListView(
              padding: const EdgeInsets.all(20),
              children: [
                Text(
                  'Welcome back, ${profile.displayName}',
                  style: const TextStyle(
                    fontSize: 20,
                    color: Color(0xFFB0B3C7),
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Your Journey Overview',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 24),

                // Level / XP card
                _StatCard(
                  title: 'Level',
                  value: profile.level.toString(),
                  subtitle: '${profile.heroClass} • XP: ${profile.xp}',
                  icon: Icons.shield_moon,
                  colors: palette,
                ),
                const SizedBox(height: 16),

                // Steps card
                _StatCard(
                  title: 'Steps Today',
                  value: profile.stepsToday.toString(),
                  subtitle:
                  'Lifetime steps: ${profile.stepsLifetime} • 1 XP per 20 steps',
                  icon: Icons.directions_walk,
                  colors: const [Color(0xFFFFD166), Color(0xFFE29578)],
                ),
                const SizedBox(height: 12),

                // Demo controls row
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white70,
                          side: const BorderSide(color: Color(0xFF4ECDC4)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        onPressed: () async {
                          await ProfileService.instance.addSteps(500);
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Added 500 demo steps'),
                              ),
                            );
                          }
                        },
                        icon: const Icon(Icons.add),
                        label: const Text('+500 demo steps'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Encounter status
                _StatCard(
                  title: 'Next Encounter',
                  value: stepsToNext == 0
                      ? 'Ready!'
                      : '$stepsToNext steps left',
                  subtitle:
                  'Encounters completed: ${profile.encountersCompleted}',
                  icon: Icons.cruelty_free_outlined,
                  colors: const [Color(0xFF8E9AFF), Color(0xFF5A5FEF)],
                ),
                const SizedBox(height: 12),

                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton.icon(
                    onPressed: stepsToNext == 0
                        ? () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) =>
                              EncounterScreen(profile: profile),
                        ),
                      );
                    }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4ECDC4),
                      foregroundColor: Colors.black,
                      disabledBackgroundColor:
                      Colors.white.withOpacity(0.1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    icon: const Icon(Icons.sports_martial_arts),
                    label: Text(
                      stepsToNext == 0
                          ? 'Start Encounter'
                          : 'Walk more to unlock',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 32),
                const Text(
                  'Next Steps (no pun intended)',
                  style: TextStyle(
                    fontSize: 18,
                    color: Color(0xFFB0B3C7),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  '• Integrate Google Fit / Apple Health instead of demo steps.\n'
                      '• Log encounters in a Firestore subcollection.\n'
                      '• Add loot rewards, items, and quest hooks.',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF9093A6),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  // ----------------- UI when there is NO character yet -----------------

  Widget _buildNoCharacterView(BuildContext context, String email) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.bolt_outlined,
              size: 80,
              color: Color(0xFFFFD166),
            ),
            const SizedBox(height: 16),
            Text(
              'Welcome, $email',
              style: const TextStyle(
                fontSize: 20,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              'You haven’t forged your StepQuest hero yet.\nCreate a character to begin your adventure!',
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFFB0B3C7),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: 230,
              height: 48,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.auto_awesome),
                label: const Text(
                  'Create Adventurer',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4ECDC4),
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const CharacterCreationScreen(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ----------------- Reusable stat card widget -----------------

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final IconData icon;
  final List<Color> colors;

  const _StatCard({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          colors: colors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: const [
          BoxShadow(
            color: Colors.black54,
            blurRadius: 16,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.15),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: Colors.white, size: 30),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
