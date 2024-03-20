import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SendMessageStyle extends StatelessWidget {
  final Widget? child;
  const SendMessageStyle({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shadowColor: Colors.black,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30).r,
      ),
      child: Container(
        width: 370.w,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30).r,
        ),
        child: child,
      ),
    );
  }
}
