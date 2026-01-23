part of 'internet_connectivity_cubit.dart';

enum InternetStatus {
  loading,
  connected,
  disconnected;

  bool get isLoading => this == InternetStatus.loading;

  bool get isConnected => this == InternetStatus.connected;

  bool get isDisconnected => this == InternetStatus.disconnected;
}

@freezed
sealed class InternetConnectivityState with _$InternetConnectivityState {
  const InternetConnectivityState._();

  const factory InternetConnectivityState.loading({
    @Default(InternetStatus.loading) InternetStatus status,
  }) = InternetConnectivityState$Loading;

  const factory InternetConnectivityState.connected({
    @Default(InternetStatus.connected) InternetStatus status,
  }) = InternetConnectivityState$Connected;

  const factory InternetConnectivityState.disconnected({
    @Default(InternetStatus.disconnected) InternetStatus status,
  }) = InternetConnectivityState$Disconnected;
}
