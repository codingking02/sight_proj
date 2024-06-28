import 'dart:async';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_mjpeg/flutter_mjpeg.dart';
import 'package:screenshot/screenshot.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:provider/provider.dart';
import 'package:sight_proj/provider/screenshot_provider.dart';
import 'package:sight_proj/textrecognition/resultimage.dart'; // Make sure to create and import this file

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ScreenshotProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Screenshot Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ScreenshotPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class ScreenshotPage extends StatefulWidget {
  @override
  _ScreenshotPageState createState() => _ScreenshotPageState();
}

class _ScreenshotPageState extends State<ScreenshotPage> {
  ScreenshotController screenshotController = ScreenshotController();
  bool isRunning = true;
  void _takeScreenshot() async {
    final directory = (await getApplicationDocumentsDirectory()).path;
    screenshotController.capture().then((image) async {
      if (image != null) {
        // Save image to local storage
        final file = File('$directory/screenshot.png');
        await file.writeAsBytes(image);

        // Get dimensions of the screenshot
        final Image imageInstance = Image.memory(image);
        final Completer<ui.Image> completer = Completer<ui.Image>();
        imageInstance.image
            .resolve(const ImageConfiguration())
            .addListener(ImageStreamListener((ImageInfo info, bool _) {
          completer.complete(info.image);
        }));
        final ui.Image dimensions = await completer.future;
        final int width = dimensions.width;
        final int height = dimensions.height;

        // Save image in provider
        Provider.of<ScreenshotProvider>(context, listen: false)
            .setScreenshot(image);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ResultImage(),
          ),
        );

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Screenshot saved to $directory and in provider. Dimensions: $width x $height pixels',
            ),
          ),
        );
      }
    }).catchError((onError) {
      print(onError);
    });
  }

  @override
  Widget build(BuildContext context) {
    Uint8List? screenshotImage = context.watch<ScreenshotProvider>().screenshot;

    return Scaffold(
      appBar: AppBar(
        title: Text('Screenshot Demo'),
      ),
      body: Screenshot(
        controller: screenshotController,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 400,
                height: 500,
                child: Mjpeg(
                  isLive: isRunning,
                  stream: 'http://192.168.1.8:81/stream',
                  // Alternative URL
                  // stream: 'http://91.133.85.170:8090/cgi-bin/faststream.jpg?stream=half&fps=15&rand=COUNTER',
                ),
              ),
              // Image.asset(
              //   "assets/faces.png",
              // ),

              ElevatedButton(
                onPressed: _takeScreenshot,
                child: Text(
                  'Take Screenshot',
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
            ],
          ),
        ),
      ),
    );
  }
}
