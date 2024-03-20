import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:robochat/constants.dart';

class AlertDialogBox extends StatelessWidget {
  final Function()? onPressed;
  final String? title;
  final String? actionText;

  const AlertDialogBox(
      {super.key, this.onPressed, this.title, this.actionText});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        title!,
        style: GoogleFonts.nunito(fontSize: 21.sp, color: Colors.black),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text(
            "Cancel",
            style: TextStyle(color: kPrimaryColor),
          ),
        ),
        TextButton(
          onPressed: onPressed,
          child: Text(
            actionText!,
            style: const TextStyle(color: Colors.red),
          ),
        ),
      ],
    );
  }
}
