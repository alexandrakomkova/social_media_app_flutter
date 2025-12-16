import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

part 'internet_connectivity__state.dart';
part 'internet_connectivity__cubit.freezed.dart';

class InternetConnectivityCubit extends Cubit<InternetConnectivityState> {
  final Connectivity connectivity;
  StreamSubscription<List<ConnectivityResult>>? connectivityStreamSubscription;

  InternetConnectivityCubit({required this.connectivity})
      : super(const InternetConnectivityState.loading()) {
    monitorInternetConnection();
  }

  StreamSubscription<List<ConnectivityResult>> monitorInternetConnection() {
    return connectivityStreamSubscription =
        connectivity.onConnectivityChanged.listen((connectivityResult) {
          if(connectivityResult.contains(ConnectivityResult.wifi)
              || connectivityResult.contains(ConnectivityResult.mobile)) {
            _connected();
          } else if(connectivityResult.contains(ConnectivityResult.none)) {
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
