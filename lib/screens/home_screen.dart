import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'chatbot_screen.dart';
import 'journal_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  String? selectedMood;

  void _playSound(String mood) async {
    try {
      await _audioPlayer.stop();
      await _audioPlayer.play(AssetSource("audio/$mood.mp3"));
      setState(() => selectedMood = mood);
      // ignore: empty_catches
    } catch (e) {}
  }

  Widget _buildMoodCard(String mood, String assetPath) {
    bool isSelected = selectedMood == mood;
    return GestureDetector(
      onTap: () => _playSound(mood),
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? Colors.teal[50] : Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              // ignore: deprecated_member_use
              color: Colors.black.withOpacity(0.1),
              blurRadius: 6,
              offset: const Offset(2, 4),
            ),
          ],
          border: isSelected
              ? Border.all(color: Colors.teal, width: 2)
              : Border.all(color: Colors.transparent),
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Image.asset(assetPath, width: 60, height: 60),
            const SizedBox(height: 6),
            Text(
              mood[0].toUpperCase() + mood.substring(1),
              style: TextStyle(
                color: isSelected ? Colors.teal : Colors.black,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff6f9fc),
      appBar: AppBar(
        backgroundColor: Colors.teal,
        centerTitle: true,
        title: const Text("AAP KA DOST"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Column(
            children: [
              // Logo
              Image.asset("assets/logo.png", height: 120),
              const SizedBox(height: 10),

              Text(
                "How are you feeling today?",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal[800],
                ),
              ),

              const SizedBox(height: 25),

              // Mood Icons
              GridView.count(
                shrinkWrap: true,
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _buildMoodCard("happy", "assets/mood_happy.png"),
                  _buildMoodCard("sad", "assets/mood_sad.png"),
                  _buildMoodCard("angry", "assets/mood_angry.png"),
                  _buildMoodCard("neutral", "assets/mood_neutral.png"),
                ],
              ),

              const SizedBox(height: 30),

              // Buttons
              ElevatedButton.icon(
                icon: const Icon(Icons.chat),
                label: const Text("Chat with Dost"),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const ChatScreen()));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  padding:
                      const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              ElevatedButton.icon(
                icon: const Icon(Icons.book),
                label: const Text("Open Journal"),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const JournalScreen()));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  padding:
                      const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
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
