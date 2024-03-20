import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class Logo extends StatelessWidget {
  const Logo({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          "assets/images/app-logo.png",
          scale: 1.1,
          color: Colors.white,
        ),
        SizedBox(
          width: 8.w,
        ),
        Row(
          children: [
            Text(
              "All",
              style: GoogleFonts.rowdies(fontSize: 40.sp, color: Colors.black),
            ),
            Text(
              "Chat",
              style: GoogleFonts.rowdies(
                fontSize: 40.sp,
                color: Colors.white,
              ),
            )
          ],
        )
      ],
    );
  }
}
