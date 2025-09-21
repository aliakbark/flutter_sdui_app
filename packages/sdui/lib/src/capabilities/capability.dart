import 'capability_result.dart';

/// Abstract base class for capabilities
abstract class SduiCapability {
  String get name;

  Future<SduiCapabilityResult> execute(Map<String, dynamic> params);
}
