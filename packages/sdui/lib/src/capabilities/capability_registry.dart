import '../exceptions/sdui_exceptions.dart';
import 'capability.dart';
import 'capability_result.dart';

/// Registry for managing capabilities
class SduiCapabilityRegistry {
  static final Map<String, SduiCapability> _capabilities = {};

  /// Register a capability
  static void register(SduiCapability capability) {
    _capabilities[capability.name] = capability;
  }

  /// Register a capability with a custom name
  static void registerWithName(String name, SduiCapability capability) {
    _capabilities[name] = capability;
  }

  /// Get a capability by name
  static SduiCapability? getCapability(String name) {
    return _capabilities[name];
  }

  /// Execute a capability
  static Future<SduiCapabilityResult> execute(
    String capabilityName,
    Map<String, dynamic> params,
  ) async {
    final SduiCapability? capability = getCapability(capabilityName);

    if (capability == null) {
      throw SduiCapabilityException('Capability not found: $capabilityName');
    }

    try {
      return await capability.execute(params);
    } catch (e) {
      throw SduiCapabilityException(
        'Failed to execute capability $capabilityName: $e',
      );
    }
  }

  /// Check if a capability is registered
  static bool hasCapability(String name) {
    return _capabilities.containsKey(name);
  }

  /// Get all registered capability names
  static List<String> getRegisteredCapabilities() {
    return _capabilities.keys.toList();
  }

  /// Clear all registered capabilities
  static void clear() {
    _capabilities.clear();
  }

  /// Remove a specific capability
  static void unregister(String name) {
    _capabilities.remove(name);
  }
}
