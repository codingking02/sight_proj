import 'package:flutter/material.dart';
import 'dart:io';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:provider/provider.dart';
import 'package:sight_proj/provider/screenshot_provider.dart';

class Resultface extends StatelessWidget {
  final String imagePath;
  final List<Face> faces;

  Resultface({required this.imagePath, required this.faces});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Result'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Faces detected: ${faces.length} Name Registered : Zeyad',
            style: TextStyle(
              fontSize: 15,
            ),
          ),
          Container(
            width: 500,
            height: 500,
            child: Image.memory(
              context.watch<ScreenshotProvider>().screenshot!,
              fit: BoxFit.fill,
            ),
          ),
        ],
      ),
    );
  }
}
