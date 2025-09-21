import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_sdui_app/core/shared/services/network_info.dart';

class MockConnectivity extends Mock implements Connectivity {}

void main() {
  group('NetworkInfoImpl', () {
    late NetworkInfoImpl networkInfo;
    late MockConnectivity mockConnectivity;

    setUp(() {
      mockConnectivity = MockConnectivity();
      networkInfo = NetworkInfoImpl(mockConnectivity);
    });

    test('returns true when connected to wifi', () async {
      when(
        () => mockConnectivity.checkConnectivity(),
      ).thenAnswer((_) async => [ConnectivityResult.wifi]);

      final result = await networkInfo.isConnected;
      expect(result, isTrue);
    });

    test('returns false when no connection', () async {
      when(
        () => mockConnectivity.checkConnectivity(),
      ).thenAnswer((_) async => [ConnectivityResult.none]);

      final result = await networkInfo.isConnected;
      expect(result, isFalse);
    });

    test('connectivity stream emits correct values', () async {
      final controller = StreamController<List<ConnectivityResult>>.broadcast();
      when(
        () => mockConnectivity.onConnectivityChanged,
      ).thenAnswer((_) => controller.stream);

      final stream = networkInfo.connectivityStream;
      final streamTest = expectLater(stream, emitsInOrder([true, false]));

      controller.add([ConnectivityResult.wifi]);
      controller.add([ConnectivityResult.none]);

      await streamTest;
      controller.close();
    });
  });
}
