part of 'my_app_cubit.dart';

class MyAppState {
  bool isLoading = false;
  ConnectivityResult? connectionStatus;
  String? test;

  MyAppState.initial() : this._();

  MyAppState._(
      {this.isLoading = false,
      this.connectionStatus = ConnectivityResult.none,
      this.test});

  MyAppState copyWith({isLoading = false, connectionStatus, test}) {
    return MyAppState._(
        isLoading: isLoading,
        connectionStatus: connectionStatus ?? this.connectionStatus,
        test: test ?? this.test);
  }
}
