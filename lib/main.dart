import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sight_proj/details.dart';
import 'package:sight_proj/homescreen.dart';
import 'package:sight_proj/resultscreen.dart';
import 'package:sight_proj/splashscreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Text Recognition',
      home: MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with WidgetsBindingObserver {
  bool _ispermissiongranted = false;
  late final Future<void> _future;
  CameraController? _cameraController;
  final _textrRecognizer = TextRecognizer();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _future = _requestcamerapermission();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
    _startcamera();
    _textrRecognizer.close();
  }

  Future<void> _requestcamerapermission() async {
    final status = await Permission.camera.request();
    _ispermissiongranted = status == PermissionStatus.granted;
  }

  void _startcamera() {
    if (_cameraController != null) {
      _CameraSelected(_cameraController!.description);
    }
  }

  void _stopcamera() {
    if (_cameraController != null) {
      _cameraController?.dispose();
    }
  }

  void _initCameraController(List<CameraDescription> cameras) {
    if (_cameraController != null) {
      return;
    }
    //Select first rear camera
    CameraDescription? camera;
    for (var i = 0; i < cameras.length; i++) {
      final CameraDescription current = cameras[i];
      if (current.lensDirection == CameraLensDirection.back) {
        camera = current;
        break;
      }
    }
    if (camera != null) {
      _CameraSelected(camera);
    }
  }

  Future<void> _CameraSelected(CameraDescription camera) async {
    _cameraController = CameraController(
      camera,
      ResolutionPreset.max,
      enableAudio: false,
    );
    await _cameraController?.initialize();
    if (!mounted) {
      return;
    }
    setState(() {});
  }

  Future<void> _scanimage() async {
    if (_cameraController == null) return;
    final navigator = Navigator.of(context);
    try {
      final pictureFile = await _cameraController!.takePicture();
      final file = File(pictureFile.path);
      final inputimage = InputImage.fromFile(file);
      final recognizedText = await _textrRecognizer.processImage(inputimage);
      await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ResultScreen(
              text: recognizedText.text,
            ),
          ));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'An Error Occured When Scanning Text',
          ),
        ),
      );
    }
  }

  @override
  void didChangAppLifeCycleState(AppLifecycleState state) {
    // TODO: Control Camera Flow
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return;
    }
    if (state == AppLifecycleState.inactive) {
      _stopcamera();
    } else if (state == AppLifecycleState.resumed &&
        _cameraController!.value.isInitialized &&
        _cameraController != null) {
      _startcamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _future,
      builder: (context, snapshot) {
        return Stack(
          children: [
            // show the camera feed behind everything
            if (_ispermissiongranted)
              FutureBuilder<List<CameraDescription>>(
                future: availableCameras(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    _initCameraController(snapshot.data!);
                    return Center(
                      child: CameraPreview(_cameraController!),
                    );
                  } else {
                    return LinearProgressIndicator();
                  }
                },
              ),
            Scaffold(
              appBar: AppBar(
                title: Text(
                  "Text Recognition",
                ),
              ),
              backgroundColor: _ispermissiongranted ? Colors.transparent : null,
              body: _ispermissiongranted
                  ? Column(
                      children: [
                        Expanded(
                          child: Container(),
                        ),
                        Container(
                          padding: const EdgeInsets.only(
                            bottom: 30,
                          ),
                          child: Center(
                            child: ElevatedButton(
                              onPressed: _scanimage,
                              child: Text(
                                "Scan Text",
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  : Center(
                      child: Container(
                        padding: EdgeInsets.only(
                          left: 24.0,
                          right: 24.0,
                        ),
                        child: Text(
                          "permissiondenied",
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
            ),
          ],
        );
      },
    );
  }
}
