import 'package:flutter/material.dart';
import 'dart:io';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

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
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 10),
            Text('Faces detected: ${faces.length}'),
          ],
        ),
      ),
    );
  }
}
