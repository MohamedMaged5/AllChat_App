// ignore_for_file: depend_on_referenced_packages

import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:meta/meta.dart';

part 'network_connectivity_state.dart';

class NetworkConnectivityCubit extends Cubit<NetworkConnectivityState> {
  NetworkConnectivityCubit() : super(NetworkConnectivityInitial());

  void CheckNetworkConnectivity() async {
    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      emit(NetworkConnectivityInitial());
    } else if (connectivityResult == ConnectivityResult.wifi) {
      emit(NetworkConnectivityInitial());
    } else if (connectivityResult == ConnectivityResult.ethernet) {
      emit(NetworkConnectivityInitial());
    } else if (connectivityResult == ConnectivityResult.none) {
      emit(NetworkConnectivityFail());
    }
  }
}
