import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:robochat/constants.dart';
import 'package:robochat/widgets/logo.dart';

class TopContainer extends StatelessWidget {
  const TopContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1.sw,
      height: 1.sh,
      color: kPrimaryColor,
      child: const Align(
        alignment: Alignment(0, -0.725),
        child: Logo(),
      ),
    );
  }
}
