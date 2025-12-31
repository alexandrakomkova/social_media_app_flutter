import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'internet_connectivity_cubit.freezed.dart';
part 'internet_connectivity_state.dart';

class InternetConnectivityCubit extends Cubit<InternetConnectivityState> {
  final Connectivity connectivity;
  StreamSubscription<List<ConnectivityResult>>? connectivityStreamSubscription;

  InternetConnectivityCubit({required this.connectivity})
    : super(const InternetConnectivityState.loading()) {
    monitorInternetConnection();
  }

  StreamSubscription<List<ConnectivityResult>> monitorInternetConnection() {
    return connectivityStreamSubscription = connectivity.onConnectivityChanged
        .listen((connectivityResult) {
          if (connectivityResult.contains(ConnectivityResult.wifi) ||
              connectivityResult.contains(ConnectivityResult.mobile)) {
            _connected();
          } else if (connectivityResult.contains(ConnectivityResult.none)) {
            _disconnected();
          }
        });
  }

  void _connected() {
    emit(state.copyWith(status: InternetStatus.connected));
  }

  void _disconnected() {
    emit(state.copyWith(status: InternetStatus.disconnected));
  }

  @override
  Future<void> close() {
    connectivityStreamSubscription?.cancel();
    return super.close();
  }
}
