import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:robochat/constants.dart';
import 'package:robochat/screens/chat_screen.dart';
import 'package:robochat/screens/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Timer(const Duration(seconds: 2), () {
      checkLoginStatus();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => LoginScreen(),
        ),
      );
    });

    super.initState();
  }

  Future<void> checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getBool("isLoggedIn") == true) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
        return ChatScreen(
          email: prefs.getString("email")!,
        );
      }));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: kPrimaryColor,
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/images/app-logo.png",
              scale: 0.7,
              color: Colors.white,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("All",
                    style: GoogleFonts.rowdies(
                        color: Colors.black,
                        fontSize: 34,
                        fontWeight: FontWeight.bold)),
                Text("Chat",
                    style: GoogleFonts.rowdies(
                        color: Colors.white,
                        fontSize: 34,
                        fontWeight: FontWeight.bold)),
              ],
            ),
          ],
        )),
      ),
    );
  }
}
