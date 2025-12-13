import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'firebase_options.dart';

// Screens
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/character_creation_screen.dart';
import 'screens/guild_selection_screen.dart';

// Models
import 'models/player_profile.dart';

// Services
import 'services/profile_services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // 🔥 FORCE LOGOUT ON STARTUP (Development only)
  await FirebaseAuth.instance.signOut();

  runApp(const StepQuestApp());
}

class StepQuestApp extends StatelessWidget {
  const StepQuestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "StepQuest",
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF050814),
        useMaterial3: true,
      ),
      home: const RootRouter(),
    );
  }
}

class RootRouter extends StatefulWidget {
  const RootRouter({super.key});

  @override
  State<RootRouter> createState() => _RootRouterState();
}

class _RootRouterState extends State<RootRouter> {
  bool _loading = true;
  User? _firebaseUser;
  PlayerProfile? _profile;

  StreamSubscription<User?>? _authSub;

  @override
  void initState() {
    super.initState();
    _listenToAuth();
  }

  void _listenToAuth() {
    _authSub = FirebaseAuth.instance.authStateChanges().listen((user) async {
      if (!mounted) return;

      _firebaseUser = user;

      if (user == null) {
        setState(() {
          _profile = null;
          _loading = false;
        });
        return;
      }

      final profile = await ProfileService.instance.getProfile(user.uid);

      if (!mounted) return;

      setState(() {
        _profile = profile;
        _loading = false;
      });
    });
  }

  @override
  void dispose() {
    _authSub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator(color: Colors.white)),
      );
    }

    // --- AUTH LOGIC ---

    // 1. Not logged in → Login screen
    if (_firebaseUser == null) {
      return const LoginScreen();
    }

    // 2. Logged in but no character profile → Create character
    if (_profile == null || !_profile!.hasCharacterData()) {
      return const CharacterCreationScreen();
    }

    // 3. Character exists but no guild yet → Guild selection
    if (_profile!.guildId == null || _profile!.guildId!.isEmpty) {
      return const GuildSelectionScreen();
    }

    // 4. Everything exists → Enter the world
    return const HomeScreen();
  }
}
