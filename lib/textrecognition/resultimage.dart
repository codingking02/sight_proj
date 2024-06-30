import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:sight_proj/provider/screenshot_provider.dart';
import 'package:sight_proj/textrecognition/resultface.dart';
import 'package:sight_proj/textrecognition/resulttext.dart';

class ResultImage extends StatefulWidget {
  const ResultImage({Key? key}) : super(key: key);

  @override
  State<ResultImage> createState() => _ResultImageState();
}

class _ResultImageState extends State<ResultImage> {
  String _recognizedText = '';
  final TextRecognizer _textRecognizer = TextRecognizer();

  Future<void> _recognizeTextFromImage(Uint8List imageBytes) async {
    try {
      // Convert Uint8List to File
      final directory = await getTemporaryDirectory();
      final imageFile = File('${directory.path}/screenshot.jpg');
      await imageFile.writeAsBytes(imageBytes);

      // Create InputImage from File
      final inputImage = InputImage.fromFile(imageFile);

      // Process image to recognize text
      final RecognizedText recognisedText =
          await _textRecognizer.processImage(inputImage);

      setState(() {
        _recognizedText = recognisedText.text;
      });

      // Navigate to result page with recognized text
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ResultPage(text: _recognizedText),
        ),
      );
    } catch (e) {
      print('Error recognizing text: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to recognize text from image')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 400,
              height: 400,
              child: Image.memory(
                context.watch<ScreenshotProvider>().screenshot!,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final imageBytes = Provider.of<ScreenshotProvider>(
                  context,
                  listen: false,
                ).screenshot;
                if (imageBytes != null) {
                  await _recognizeTextFromImage(imageBytes);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('No image to process')),
                  );
                }
              },
              child: Text(
                'Extract Text',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              style: ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(
                  Color(
                    0xff8EB870,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final imageBytes = Provider.of<ScreenshotProvider>(
                  context,
                  listen: false,
                ).screenshot;
                if (imageBytes != null) {
                  await _detectFaces(imageBytes);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text(
                      'No image to process',
                      style: TextStyle(color: Colors.white),
                    )),
                  );
                }
              },
              child: Text(
                'Extract Face',
                style: TextStyle(color: Colors.white),
              ),
              style: ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(
                  Color(
                    0xff8EB870,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  final FaceDetector _faceDetector = FaceDetector(
    options: FaceDetectorOptions(
      performanceMode: FaceDetectorMode.fast,
      enableLandmarks: true,
      enableContours: true,
    ),
  );
  File? _image;
  List<Face>? _faces;

  @override
  void dispose() {
    _faceDetector.close();
    super.dispose();
  }

  Future<void> _detectFaces(Uint8List imageBytes) async {
    final directory = await getTemporaryDirectory();
    final imageFile = File('${directory.path}/screenshot.jpg');
    await imageFile.writeAsBytes(imageBytes);

    // Create InputImage from File
    final inputImage = InputImage.fromFile(imageFile);
    final faces = await _faceDetector.processImage(inputImage);

    setState(() {
      _faces = faces;
    });

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            Resultface(imagePath: imageFile.path, faces: faces),
      ),
    );
  }
}
