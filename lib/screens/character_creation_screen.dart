import 'package:flutter/material.dart';
import '../services/profile_services.dart';
import 'guild_selection_screen.dart';

class CharacterCreationScreen extends StatefulWidget {
  const CharacterCreationScreen({super.key});

  @override
  State<CharacterCreationScreen> createState() =>
      _CharacterCreationScreenState();
}

class _CharacterCreationScreenState extends State<CharacterCreationScreen> {
  final _nameController = TextEditingController();
  String _selectedClass = 'Walker';
  int _selectedColorIndex = 0;
  bool _isSaving = false;
  String? _error;

  final List<String> _classes = [
    'Walker',
    'Shadow Rogue',
    'Sky Runner',
    'Guardian',
  ];

  final List<List<Color>> _colorPalettes = const [
    [Color(0xFF4ECDC4), Color(0xFF1B998B)],
    [Color(0xFFFFD166), Color(0xFFE29578)],
    [Color(0xFF8E9AFF), Color(0xFF5A5FEF)],
    [Color(0xFFEE6C4D), Color(0xFFFFB347)],
  ];

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _saveCharacter() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      setState(() => _error = 'Please enter a character name.');
      return;
    }

    setState(() {
      _isSaving = true;
      _error = null;
    });

    try {
      await ProfileService.instance.createCharacter(
        displayName: name,
        heroClass: _selectedClass,
        colorIndex: _selectedColorIndex,
      );

      // 👉 Move to guild selection screen immediately
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const GuildSelectionScreen()),
        );
      }
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = _colorPalettes[_selectedColorIndex];

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF050816),
              Color(0xFF1A1B3A),
              Color(0xFF3F1F78),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32),
            child: Column(
              children: [
                const Text(
                  'Forge Your Adventurer',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        blurRadius: 10,
                        color: Colors.black54,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                const Text(
                  'Choose a name, class, and aura color.\nYour hero awaits.',
                  style: TextStyle(fontSize: 14, color: Color(0xFFB0B3C7)),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),

                // Card Container
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.06),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: Colors.white.withOpacity(0.12)),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black54,
                        blurRadius: 20,
                        offset: Offset(0, 12),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Name Input
                      const Text(
                        'Character Name',
                        style: TextStyle(color: Color(0xFFB0B3C7), fontSize: 14),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _nameController,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: 'E.g. Luna Strider',
                          hintStyle:
                          const TextStyle(color: Color(0xFF6C718E)),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide:
                            const BorderSide(color: Color(0xFF3E3A6D)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: const BorderSide(
                              color: Color(0xFFFFD166),
                              width: 2,
                            ),
                          ),
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.04),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Class Dropdown
                      const Text(
                        'Hero Class',
                        style: TextStyle(color: Color(0xFFB0B3C7), fontSize: 14),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color(0xFF3E3A6D)),
                          color: Colors.white.withOpacity(0.04),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _selectedClass,
                            dropdownColor: const Color(0xFF211E3A),
                            items: _classes
                                .map((cls) => DropdownMenuItem<String>(
                              value: cls,
                              child: Text(cls,
                                  style:
                                  const TextStyle(color: Colors.white)),
                            ))
                                .toList(),
                            onChanged: (value) {
                              if (value != null) {
                                setState(() => _selectedClass = value);
                              }
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Color Selector
                      const Text(
                        'Aura Color',
                        style: TextStyle(color: Color(0xFFB0B3C7), fontSize: 14),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 10,
                        children: List.generate(_colorPalettes.length, (index) {
                          final palette = _colorPalettes[index];
                          final isSelected = _selectedColorIndex == index;

                          return GestureDetector(
                            onTap: () => setState(() {
                              _selectedColorIndex = index;
                            }),
                            child: Container(
                              width: 42,
                              height: 42,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: LinearGradient(
                                  colors: palette,
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                border: Border.all(
                                  color: isSelected
                                      ? Colors.white
                                      : Colors.transparent,
                                  width: 2,
                                ),
                                boxShadow: [
                                  if (isSelected)
                                    BoxShadow(
                                      color: palette.first.withOpacity(0.4),
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                    ),
                                ],
                              ),
                            ),
                          );
                        }),
                      ),

                      const SizedBox(height: 20),

                      if (_error != null)
                        Text(
                          _error!,
                          style: const TextStyle(
                              color: Colors.redAccent, fontSize: 13),
                        ),

                      const SizedBox(height: 10),

                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          onPressed: _isSaving ? null : _saveCharacter,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: colors[0],
                            foregroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16)),
                          ),
                          child: _isSaving
                              ? const CircularProgressIndicator(
                              color: Colors.black, strokeWidth: 2)
                              : const Text(
                            'Begin the Quest',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
