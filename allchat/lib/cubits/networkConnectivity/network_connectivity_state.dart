part of 'network_connectivity_cubit.dart';

@immutable
sealed class NetworkConnectivityState {}

final class NetworkConnectivityInitial extends NetworkConnectivityState {}

final class NetworkConnectivityFail extends NetworkConnectivityState {}
