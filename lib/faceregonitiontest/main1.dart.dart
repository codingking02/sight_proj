import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:sight_proj/faceregonitiontest/databasehelper.dart';

void main() => runApp(FaceRecognitionApp());

class FaceRecognitionApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FaceRecognitionScreen(),
    );
  }
}

class FaceRecognitionScreen extends StatefulWidget {
  @override
  _FaceRecognitionScreenState createState() => _FaceRecognitionScreenState();
}

class _FaceRecognitionScreenState extends State<FaceRecognitionScreen> {
  final ImagePicker _picker = ImagePicker();
  late FaceDetector _faceDetector;
  String _faceMessage = '';
  String _name = '';

  @override
  void initState() {
    super.initState();
    _faceDetector = FaceDetector(options: FaceDetectorOptions());
  }

  @override
  void dispose() {
    _faceDetector.close();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final image = InputImage.fromFile(File(pickedFile.path));
      final faces = await _faceDetector.processImage(image);

      if (faces.isNotEmpty) {
        setState(() {
          _faceMessage = 'Face detected!';
        });
        _showNameInputDialog(pickedFile.path);
      } else {
        setState(() {
          _faceMessage = 'No face detected.';
        });
      }
    }
  }

  Future<void> _showNameInputDialog(String imagePath) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Enter Name'),
          content: TextField(
            onChanged: (value) {
              setState(() {
                _name = value;
              });
            },
          ),
          actions: <Widget>[
            ElevatedButton(
              child: Text('Submit'),
              onPressed: () {
                _registerFace(imagePath, _name);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _registerFace(String imagePath, String name) async {
    final face = {'image_path': imagePath, 'name': name};
    await DatabaseHelper.instance.insertFace(face);
  }

  Future<void> _recognizeFace() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final image = InputImage.fromFile(File(pickedFile.path));
      final faces = await _faceDetector.processImage(image);

      if (faces.isNotEmpty) {
        final faceList = await DatabaseHelper.instance.getFaceList();
        // This is a placeholder for face comparison logic
        // You need to implement the actual comparison logic
        setState(() {
          _faceMessage = 'Face recognized as: ${faceList[0]['name']}';
        });
      } else {
        setState(() {
          _faceMessage = 'No face detected.';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Face Recognition App'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _pickImage,
              child: Text('Register Image'),
            ),
            ElevatedButton(
              onPressed: _recognizeFace,
              child: Text('Recognize Image'),
            ),
            SizedBox(height: 20),
            Text(_faceMessage),
          ],
        ),
      ),
    );
  }
}
