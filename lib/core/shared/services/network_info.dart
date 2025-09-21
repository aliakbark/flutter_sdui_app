import 'package:connectivity_plus/connectivity_plus.dart';

/// Abstract class for checking network connectivity
abstract class NetworkInfo {
  /// Returns true if the device is connected to the internet
  Future<bool> get isConnected;
  
  /// Stream of connectivity changes
  Stream<bool> get connectivityStream;
}

/// Implementation of [NetworkInfo] using [Connectivity]
class NetworkInfoImpl implements NetworkInfo {
  final Connectivity connectivity;

  NetworkInfoImpl(this.connectivity);

  @override
  Future<bool> get isConnected async {
    final List<ConnectivityResult> result = await connectivity
        .checkConnectivity();

    // Fix: should return true when NOT none (i.e., connected)
    return !result.contains(ConnectivityResult.none);
  }

  @override
  Stream<bool> get connectivityStream {
    return connectivity.onConnectivityChanged.map(
      (results) => !results.contains(ConnectivityResult.none),
    );
  }
}
