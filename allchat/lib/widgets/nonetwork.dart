import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:robochat/constants.dart';
import 'package:robochat/cubits/networkConnectivity/network_connectivity_cubit.dart';

class NoNetwork extends StatelessWidget {
  const NoNetwork({super.key});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: kPrimaryColor,
      onRefresh: () async {
        return context
            .read<NetworkConnectivityCubit>()
            .CheckNetworkConnectivity();
      },
      child: ListView(
        children: [
          SizedBox(
            height: (1 / 3).sh,
          ),
          Center(
            child: Text(
              "Check Your Network Connection!",
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
