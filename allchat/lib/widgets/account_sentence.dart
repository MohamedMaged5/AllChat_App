import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:robochat/constants.dart';

class AccountSentence extends StatelessWidget {
  final String haveaccount;
  final String action;
  final Function() onTap;

  const AccountSentence(
      {super.key,
      required this.haveaccount,
      required this.action,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          haveaccount,
          style: GoogleFonts.nunito(fontSize: 15.sp, color: Colors.black),
        ),
        GestureDetector(
          onTap: onTap,
          child: Text(
            "  $action",
            style: GoogleFonts.nunito(fontSize: 15.sp, color: kPrimaryColor),
          ),
        ),
      ],
    );
  }
}
