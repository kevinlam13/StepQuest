import 'package:flutter/material.dart';
import '../services/profile_services.dart';
import '../widgets/avatar_renderer.dart';
import 'guild_selection_screen.dart';

class CharacterCreationScreen extends StatefulWidget {
  const CharacterCreationScreen({super.key});

  @override
  State<CharacterCreationScreen> createState() =>
      _CharacterCreationScreenState();
}

class _CharacterCreationScreenState extends State<CharacterCreationScreen> {
  final TextEditingController _nameController = TextEditingController();

  String _selectedClass = "Walker";
  int _selectedColorIndex = 0;

  bool _saving = false;
  String? _error;

  // Aura palettes (MUST match ProfileService)
  final List<Color> auraColors = const [
    Color(0xFF4ECDC4),
    Color(0xFFFFD166),
    Color(0xFF8E9AFF),
    Color(0xFFEE6C4D),
  ];

  final List<String> classes = [
    "Walker",
    "Shadow Rogue",
    "Sky Runner",
    "Guardian",
  ];

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _saveCharacter() async {
    final name = _nameController.text.trim();

    if (name.isEmpty) {
      setState(() => _error = "Please enter a character name.");
      return;
    }

    setState(() {
      _saving = true;
      _error = null;
    });

    try {
      await ProfileService.instance.createCharacter(
        displayName: name,
        heroClass: _selectedClass,
        colorIndex: _selectedColorIndex,
      );

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const GuildSelectionScreen()),
      );
    } catch (e) {
      setState(() => _error = e.toString());
    }

    if (mounted) {
      setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final auraColor = auraColors[_selectedColorIndex];

    return Scaffold(
      backgroundColor: const Color(0xFF090B18),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            children: [
              const Text(
                "Forge Your Adventurer",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 20),

              // --------------------------
              // AVATAR PREVIEW (NO COSMETICS)
              // --------------------------
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white12),
                ),
                child: Column(
                  children: [
                    const Text(
                      "Your Essence",
                      style: TextStyle(color: Colors.white70),
                    ),
                    const SizedBox(height: 10),

                    AvatarRenderer(
                      auraColor: auraColor,
                      hairstyle: "none",
                      hairColorValue: null,
                      hatType: "none",
                      facialHair: "none",
                    ),

                    const SizedBox(height: 20),

                    // Aura Color Selection
                    const Text(
                      "Aura Color",
                      style: TextStyle(color: Colors.white70),
                    ),
                    const SizedBox(height: 10),

                    Wrap(
                      spacing: 12,
                      children: List.generate(auraColors.length, (i) {
                        final isSelected = _selectedColorIndex == i;

                        return GestureDetector(
                          onTap: () => setState(() => _selectedColorIndex = i),
                          child: Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: auraColors[i],
                              border: Border.all(
                                color: isSelected
                                    ? Colors.white
                                    : Colors.transparent,
                                width: 2,
                              ),
                              boxShadow: [
                                if (isSelected)
                                  BoxShadow(
                                    color: auraColors[i].withOpacity(.5),
                                    blurRadius: 10,
                                  )
                              ],
                            ),
                          ),
                        );
                      }),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // --------------------------
              // NAME + CLASS SELECTION
              // --------------------------
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name
                    const Text(
                      "Character Name",
                      style: TextStyle(color: Colors.white70),
                    ),
                    const SizedBox(height: 8),

                    TextField(
                      controller: _nameController,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: "E.g. Luna Strider",
                        hintStyle: const TextStyle(color: Colors.white30),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.05),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Class Dropdown
                    const Text(
                      "Hero Class",
                      style: TextStyle(color: Colors.white70),
                    ),
                    const SizedBox(height: 8),

                    DropdownButtonHideUnderline(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: Colors.white24),
                          color: Colors.white.withOpacity(0.05),
                        ),
                        child: DropdownButton<String>(
                          value: _selectedClass,
                          dropdownColor: const Color(0xFF1A1D2E),
                          style: const TextStyle(color: Colors.white),
                          items: classes
                              .map((cls) =>
                              DropdownMenuItem(value: cls, child: Text(cls)))
                              .toList(),
                          onChanged: (v) =>
                              setState(() => _selectedClass = v ?? "Walker"),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              if (_error != null)
                Text(
                  _error!,
                  style: const TextStyle(color: Colors.redAccent),
                ),

              const SizedBox(height: 20),

              // --------------------------
              // CONFIRM BUTTON
              // --------------------------
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _saving ? null : _saveCharacter,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: auraColor,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: _saving
                      ? const CircularProgressIndicator(
                    color: Colors.black,
                  )
                      : const Text(
                    "Begin Your Journey",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
