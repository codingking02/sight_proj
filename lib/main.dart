import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sight_proj/homescreen.dart';
import 'package:sight_proj/provider/screenshot_provider.dart';
import 'package:sight_proj/splashscreen.dart';
import 'package:sight_proj/textrecognition/screenshot_image.dart';

void main() async {
  runApp(
    MultiProvider(providers: [
      ChangeNotifierProvider(
        create: (context) => ScreenshotProvider(),
        child: ScreenshotPage(),
      ),
    ], child: MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Text Recognition',
      home: ScreenshotPage(),
    );
  }
}
