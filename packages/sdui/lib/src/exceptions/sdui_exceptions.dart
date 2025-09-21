/// Base exception class for SDUI-related errors
abstract class SduiException implements Exception {
  final String message;
  final dynamic cause;

  const SduiException(this.message, [this.cause]);

  @override
  String toString() => 'SduiException: $message${cause != null ? ' (Cause: $cause)' : ''}';
}

/// Exception thrown when parsing SDUI configuration fails
class SduiParsingException extends SduiException {
  const SduiParsingException(String message, [dynamic cause]) : super(message, cause);

  @override
  String toString() => 'SduiParsingException: $message${cause != null ? ' (Cause: $cause)' : ''}';
}

/// Exception thrown when rendering SDUI widgets fails
class SduiRenderingException extends SduiException {
  const SduiRenderingException(String message, [dynamic cause]) : super(message, cause);

  @override
  String toString() => 'SduiRenderingException: $message${cause != null ? ' (Cause: $cause)' : ''}';
}

/// Exception thrown when executing capabilities fails
class SduiCapabilityException extends SduiException {
  const SduiCapabilityException(String message, [dynamic cause]) : super(message, cause);

  @override
  String toString() => 'SduiCapabilityException: $message${cause != null ? ' (Cause: $cause)' : ''}';
}

/// Exception thrown when validation fails
class SduiValidationException extends SduiException {
  const SduiValidationException(String message, [dynamic cause]) : super(message, cause);

  @override
  String toString() => 'SduiValidationException: $message${cause != null ? ' (Cause: $cause)' : ''}';
}
