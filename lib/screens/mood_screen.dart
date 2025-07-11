import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class MoodScreen extends StatelessWidget {
  final AudioPlayer _player = AudioPlayer();

  MoodScreen({super.key});

  void playMoodSong(String mood) {
    final path = 'audio/$mood.mp3';
    _player.play(AssetSource(path));
  }

  Widget moodButton(String mood, String imagePath, BuildContext context) {
    return GestureDetector(
      onTap: () => playMoodSong(mood),
      child: Container(
        width: 130,
        height: 150,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(imagePath, width: 60, height: 60),
            const SizedBox(height: 12),
            Text(
              mood.toUpperCase(),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.1,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget extraButton(String label, IconData icon, VoidCallback onTap) {
    return ElevatedButton.icon(
      onPressed: onTap,
      icon: Icon(icon),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4FF),
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Text(
          "How are you feeling today?",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20),
        child: Column(
          children: [
            Wrap(
              spacing: 20,
              runSpacing: 20,
              alignment: WrapAlignment.center,
              children: [
                moodButton('happy', 'assets/images/mood_happy.png', context),
                moodButton('sad', 'assets/images/mood_sad.png', context),
                moodButton('angry', 'assets/images/mood_angry.png', context),
                moodButton(
                    'neutral', 'assets/images/mood_netural.png', context),
              ],
            ),
            const SizedBox(height: 40),
            Column(
              children: [
                extraButton('Chat with Dost', Icons.chat_bubble_outline, () {
                  Navigator.pushNamed(
                      context, '/chat'); // Replace with your route
                }),
                const SizedBox(height: 16),
                extraButton('Chat with Journal', Icons.book_outlined, () {
                  Navigator.pushNamed(
                      context, '/journal'); // Replace with your route
                }),
              ],
            )
          ],
        ),
      ),
    );
  }
}
