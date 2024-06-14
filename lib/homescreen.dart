import 'package:flutter/material.dart';
import 'package:sight_proj/verify/login.dart';
import 'package:sight_proj/verify/register.dart';
import 'package:sight_proj/widgets/assets_images.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.only(
              top: MediaQuery.of(context).size.height / 6,
              right: 10,
            ),
            child: pngimage(
              "sightlogo",
            ),
          ),
          SizedBox(
            height: 100,
          ),
          Center(
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Login(),
                  ),
                );
              },
              child: getbutton(
                "Log in",
              ),
            ),
          ),
          SizedBox(
            height: 30,
          ),
          Center(
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Register(),
                  ),
                );
              },
              child: getbutton(
                "Sign in",
              ),
            ),
          ),
        ],
      ),
    );
  }
}
