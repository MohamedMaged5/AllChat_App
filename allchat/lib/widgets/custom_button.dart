import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:robochat/constants.dart';
import 'package:robochat/cubits/loadingCubit/loading_cubit.dart';
import 'package:robochat/global/global.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final Function()? onPressed;
  const CustomButton({super.key, required this.text, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ButtonStyle(
          elevation: MaterialStateProperty.all<double>(7),
          backgroundColor: MaterialStateProperty.all<Color>(kPrimaryColor),
        ),
        child: BlocBuilder<LoadingCubit, LoadingState>(
          builder: (context, state) {
            return isloading == false
                ? Text(
                    text,
                    style: TextStyle(color: Colors.white, fontSize: 19.sp),
                  )
                : SizedBox(
                    height: 25.h,
                    width: 25.w,
                    child: const CircularProgressIndicator(
                      color: Colors.white,
                    ),
                  );
          },
        ),
      ),
    );
  }
}
