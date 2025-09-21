/// Result of a capability execution
class SduiCapabilityResult {
  final bool isSuccess;
  final String? message;
  final Map<String, dynamic>? data;

  const SduiCapabilityResult._({
    required this.isSuccess,
    this.message,
    this.data,
  });

  factory SduiCapabilityResult.success({
    String? message,
    Map<String, dynamic>? data,
  }) {
    return SduiCapabilityResult._(
      isSuccess: true,
      message: message,
      data: data,
    );
  }

  factory SduiCapabilityResult.error(
    String message, {
    Map<String, dynamic>? data,
  }) {
    return SduiCapabilityResult._(
      isSuccess: false,
      message: message,
      data: data,
    );
  }
}
