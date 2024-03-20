import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:robochat/constants.dart';
import 'package:robochat/cubits/networkConnectivity/network_connectivity_cubit.dart';

class AppNameAndConnectivityInAppBar extends StatelessWidget {
  const AppNameAndConnectivityInAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              "All",
              style: GoogleFonts.nunito(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: kPrimaryColor,
              ),
            ),
            Text(
              "Chat",
              style: GoogleFonts.nunito(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ],
        ),
        BlocBuilder<NetworkConnectivityCubit, NetworkConnectivityState>(
          builder: (context, state) {
            if (state is NetworkConnectivityInitial) {
              return Row(
                children: [
                  Icon(
                    Icons.circle,
                    color: Colors.green,
                    size: 10.sp,
                  ),
                  SizedBox(
                    width: 5.w,
                  ),
                  Text(
                    "Connected",
                    style: GoogleFonts.nunito(
                      fontSize: 16.sp,
                      color: Colors.green,
                    ),
                  )
                ],
              );
            } else if (state is NetworkConnectivityFail) {
              return Row(
                children: [
                  Icon(
                    Icons.circle,
                    color: Colors.red,
                    size: 10.sp,
                  ),
                  SizedBox(
                    width: 5.w,
                  ),
                  Text(
                    "Disconnected",
                    style: GoogleFonts.nunito(
                      fontSize: 16.sp,
                      color: Colors.red,
                    ),
                  )
                ],
              );
            } else {
              return const SizedBox();
            }
          },
        )
      ],
    );
  }
}
