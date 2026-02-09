/// OrBeit Platform Layer - Device Capability Service
///
/// Detects what the device can do so the app can gracefully
/// adapt its features. Uses device_info_plus under the hood.
///
/// **Key Decisions This Enables:**
/// - Can this device run Gemini Nano on-device? → Use local AI
/// - Does it have Face ID / Touch ID? → Enable biometric for The Safe
/// - Screen size? → Adjust Springfield Model layout density
/// - Storage available? → Manage sprite/asset cache aggressively or relaxed

import 'package:device_info_plus/device_info_plus.dart';
import 'dart:io' show Platform;

/// Capabilities detected on the current device
class DeviceCapabilities {
  final String model;
  final String osVersion;
  final bool isPhysicalDevice;
  final String platform; // 'ios', 'android', 'macos', etc.

  // Derived capabilities
  final bool canUseBiometrics;
  final bool likelySupportsGeminiNano;
  final bool isHighEndDevice;

  const DeviceCapabilities({
    required this.model,
    required this.osVersion,
    required this.isPhysicalDevice,
    required this.platform,
    required this.canUseBiometrics,
    required this.likelySupportsGeminiNano,
    required this.isHighEndDevice,
  });

  @override
  String toString() => 'DeviceCapabilities('
      'model: $model, os: $osVersion, '
      'physical: $isPhysicalDevice, '
      'biometrics: $canUseBiometrics, '
      'geminiNano: $likelySupportsGeminiNano)';
}

/// Service for detecting device capabilities
class DeviceCapabilityService {
  final DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();
  DeviceCapabilities? _cached;

  /// Get device capabilities (cached after first call)
  Future<DeviceCapabilities> getCapabilities() async {
    if (_cached != null) return _cached!;

    if (Platform.isIOS) {
      _cached = await _detectIOS();
    } else if (Platform.isAndroid) {
      _cached = await _detectAndroid();
    } else if (Platform.isMacOS) {
      _cached = await _detectMacOS();
    } else {
      _cached = _fallback();
    }

    return _cached!;
  }

  Future<DeviceCapabilities> _detectIOS() async {
    final info = await _deviceInfo.iosInfo;
    final model = info.model;
    final osVersion = info.systemVersion;
    final isPhysical = info.isPhysicalDevice;

    // iOS 18+ on A17 Pro+ or M-series likely supports Gemini Nano
    final majorVersion = int.tryParse(osVersion.split('.').first) ?? 0;
    final isModernChip = model.contains('iPhone') ||
        model.contains('iPad');

    return DeviceCapabilities(
      model: '${info.name} ($model)',
      osVersion: 'iOS $osVersion',
      isPhysicalDevice: isPhysical,
      platform: 'ios',
      canUseBiometrics: isPhysical, // All modern iOS devices have Face/Touch ID
      likelySupportsGeminiNano: majorVersion >= 18 && isModernChip,
      isHighEndDevice: isPhysical, // Conservative — refine later
    );
  }

  Future<DeviceCapabilities> _detectAndroid() async {
    final info = await _deviceInfo.androidInfo;
    final sdkInt = info.version.sdkInt;

    // Android 14+ (SDK 34) with 6GB+ RAM likely supports Gemini Nano
    return DeviceCapabilities(
      model: '${info.manufacturer} ${info.model}',
      osVersion: 'Android ${info.version.release} (SDK $sdkInt)',
      isPhysicalDevice: info.isPhysicalDevice,
      platform: 'android',
      canUseBiometrics: info.isPhysicalDevice,
      likelySupportsGeminiNano: sdkInt >= 34,
      isHighEndDevice: sdkInt >= 33,
    );
  }

  Future<DeviceCapabilities> _detectMacOS() async {
    final info = await _deviceInfo.macOsInfo;

    return DeviceCapabilities(
      model: info.model,
      osVersion: 'macOS ${info.majorVersion}.${info.minorVersion}',
      isPhysicalDevice: true,
      platform: 'macos',
      canUseBiometrics: true, // Touch ID on Mac
      likelySupportsGeminiNano: false, // Not available on macOS yet
      isHighEndDevice: true,
    );
  }

  DeviceCapabilities _fallback() {
    return const DeviceCapabilities(
      model: 'Unknown',
      osVersion: 'Unknown',
      isPhysicalDevice: false,
      platform: 'unknown',
      canUseBiometrics: false,
      likelySupportsGeminiNano: false,
      isHighEndDevice: false,
    );
  }
}
