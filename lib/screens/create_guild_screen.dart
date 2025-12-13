import 'package:flutter/material.dart';

class CreateGuildScreen extends StatelessWidget {
  const CreateGuildScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF050814),
      appBar: AppBar(
        title: const Text("Create a Guild"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: const Center(
        child: Text(
          "Create Guild Screen Coming Soon",
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
