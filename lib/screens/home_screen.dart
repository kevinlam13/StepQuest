import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final email = user?.email ?? 'Adventurer';

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
              await AuthService.instance.signOut();
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
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Text(
              'Welcome back, $email',
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

            // XP / Level card (placeholder for now)
            _StatCard(
              title: 'Level',
              value: '1',
              subtitle: 'Novice Wanderer',
              icon: Icons.shield_moon,
              colors: const [Color(0xFF4ECDC4), Color(0xFF1B998B)],
            ),
            const SizedBox(height: 16),

            _StatCard(
              title: 'Steps Today',
              value: '0',
              subtitle: 'Sync from device or enter manually later',
              icon: Icons.directions_walk,
              colors: const [Color(0xFFFFD166), Color(0xFFE29578)],
            ),
            const SizedBox(height: 16),

            _StatCard(
              title: 'Active Quest',
              value: 'None',
              subtitle: 'You have no active quests. New quests coming soon!',
              icon: Icons.map_outlined,
              colors: const [Color(0xFF8E9AFF), Color(0xFF5A5FEF)],
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
              '• Track your daily steps and convert them into XP.\n'
                  '• Unlock quests and regions as your step count increases.\n'
                  '• Compete with friends in future guild updates.',
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF9093A6),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

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
