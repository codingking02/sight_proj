import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class ResultScreen extends StatelessWidget {
  final String text;

  ResultScreen({super.key, required this.text});
  final FlutterTts flutterTts = FlutterTts();
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Result'),
        ),
        body: ListView(
          children: [
            Container(
              child: AutoSizeText(text),
            ),
            ElevatedButton(
              onPressed: () {
                speak(text);
              },
              child: Text(
                "Speak",
              ),
            ),
          ],
        ),
      );
  Future<void> speak(String text) async {
    await flutterTts.setLanguage("en-US");
    await flutterTts.setPitch(1.0);
    await flutterTts.setSpeechRate(0.5);
    await flutterTts.speak(text);
  }
}
