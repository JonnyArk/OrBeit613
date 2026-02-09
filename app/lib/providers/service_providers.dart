/// OrBeit Providers - Service Providers
///
/// Riverpod providers for the core service layer:
/// - SecureStorageService (secrets, API keys, PINs)
/// - CacheService (Hive key-value store)
/// - VoiceService (speech-to-text + text-to-speech)
/// - DeviceCapabilityService (device detection)

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/secure_storage_service.dart';
import '../services/cache_service.dart';
import '../services/voice_service.dart';
import '../services/device_capability_service.dart';

/// Secure storage — OS keychain for secrets
final secureStorageProvider = Provider<SecureStorageService>((ref) {
  throw UnimplementedError('Must override in ProviderScope');
});

/// Hive cache — fast key-value store
final cacheServiceProvider = Provider<CacheService>((ref) {
  throw UnimplementedError('Must override in ProviderScope');
});

/// Voice interaction — speech-to-text + TTS
final voiceServiceProvider = Provider<VoiceService>((ref) {
  throw UnimplementedError('Must override in ProviderScope');
});

/// Device capabilities — what can this device do?
final deviceCapabilityProvider = Provider<DeviceCapabilityService>((ref) {
  throw UnimplementedError('Must override in ProviderScope');
});
