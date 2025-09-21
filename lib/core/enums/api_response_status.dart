/// This file defines an enumeration for API response statuses
enum APIResponseStatus { ok, error }

/// Extension methods for APIResponseStatus.
extension APIResponseStatusExtension on APIResponseStatus {
  static APIResponseStatus fromString(String value) {
    switch (value.toLowerCase()) {
      case 'ok':
        return APIResponseStatus.ok;
      case 'error':
        return APIResponseStatus.error;
      default:
        throw ArgumentError('Unknown API status: $value');
    }
  }

  String get value {
    switch (this) {
      case APIResponseStatus.ok:
        return 'ok';
      case APIResponseStatus.error:
        return 'error';
    }
  }
}
