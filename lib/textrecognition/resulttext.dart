import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class ResultPage extends StatelessWidget {
  final String text;
  final FlutterTts flutterTts = FlutterTts();

  ResultPage({required this.text});

  @override
  Widget build(BuildContext context) {
    // Process the text to remove unwanted phrases
    String displayText = text
        .replaceAll("Press the button to capture screenshot", "")
        .replaceAll("Take Screenshot", "")
        .replaceAll("screenshot taken", "");

    return Scaffold(
      appBar: AppBar(
        title: Text('Recognized Text'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Text(displayText.trim()),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              speak(displayText.trim());
            },
            child: Text(
              "Speak",
            ),
          ),
        ],
      ),
    );
  }

  Future<void> speak(String text) async {
    if (text.isEmpty) {
      print("No valid text to speak.");
    } else {
      await flutterTts.setLanguage("en-US");
      await flutterTts.setPitch(1.0);
      await flutterTts.setSpeechRate(0.5);
      await flutterTts.speak(text);
    }
  }
}
