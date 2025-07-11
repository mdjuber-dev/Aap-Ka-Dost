
import 'package:flutter/material.dart';

class MoodTrackerWidget extends StatelessWidget {
  const MoodTrackerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('How are you feeling today?', style: TextStyle(fontSize: 18)),
        const SizedBox(height: 10),
        Wrap(
          spacing: 10,
          children: const [
            Icon(Icons.sentiment_very_satisfied, size: 40, color: Colors.green),
            Icon(Icons.sentiment_satisfied, size: 40, color: Colors.lightGreen),
            Icon(Icons.sentiment_neutral, size: 40, color: Colors.amber),
            Icon(Icons.sentiment_dissatisfied, size: 40, color: Colors.orange),
            Icon(Icons.sentiment_very_dissatisfied, size: 40, color: Colors.red),
          ],
        ),
      ],
    );
  }
}
