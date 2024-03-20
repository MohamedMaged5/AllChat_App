import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:robochat/constants.dart';

class CustomTextFormField extends StatelessWidget {
  final String? hintText;
  final Widget? prefixIcon;
  final bool obscureText;
  final IconButton? suffixIcon;
  final Function(String)? onsubmited;
  final bool filled;
  final Color bordercolor;
  final Color? fillColor;
  final Function(String)? onChanged;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  const CustomTextFormField({
    super.key,
    this.hintText,
    this.prefixIcon,
    this.obscureText = false,
    this.suffixIcon,
    this.onChanged,
    this.controller,
    this.validator,
    this.onsubmited,
    this.filled = true,
    required this.fillColor,
    this.bordercolor = kPrimaryColor,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: validator,
      controller: controller,
      onFieldSubmitted: onsubmited,
      onChanged: onChanged,
      obscureText: obscureText,
      cursorColor: Colors.black,
      style: const TextStyle(color: Colors.black),
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(
          vertical: 5.h,
          horizontal: 20.w,
        ),
        hintText: hintText,
        filled: filled,
        fillColor: fillColor,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: bordercolor,
          ),
          borderRadius: BorderRadius.circular(30).r,
        ),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30).r,
            borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: bordercolor,
          ),
          borderRadius: BorderRadius.circular(30).r,
        ),
      ),
    );
  }
}
