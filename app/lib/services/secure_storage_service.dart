/// OrBeit Security Layer - Secure Storage Service
///
/// Wraps flutter_secure_storage to provide type-safe access
/// to the OS keychain (iOS Secure Enclave, Android Keystore).
///
/// All API keys, tokens, and sensitive secrets go through here.
/// NEVER store secrets in SharedPreferences, Hive, or plain files.

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Keys for all stored secrets — single source of truth
abstract class SecureKeys {
  static const geminiApiKey = 'gemini_api_key';
  static const firebaseToken = 'firebase_custom_token';
  static const encryptionKey = 'local_encryption_key';
  static const duressPin = 'duress_pin';
  static const masterPin = 'master_pin';
  static const lastAuthTimestamp = 'last_auth_timestamp';
}

/// Service for secure storage of sensitive data
///
/// Uses the OS-level keychain:
/// - iOS: Secure Enclave / Keychain
/// - Android: EncryptedSharedPreferences / Keystore
/// - macOS: Keychain
class SecureStorageService {
  late final FlutterSecureStorage _storage;

  SecureStorageService() {
    _storage = const FlutterSecureStorage(
      iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
    );
  }

  // ── Core CRUD ─────────────────────────────────────────────

  /// Store a secret value
  Future<void> write(String key, String value) async {
    await _storage.write(key: key, value: value);
  }

  /// Read a secret value (returns null if not found)
  Future<String?> read(String key) async {
    return await _storage.read(key: key);
  }

  /// Delete a specific secret
  Future<void> delete(String key) async {
    await _storage.delete(key: key);
  }

  /// Check if a key exists
  Future<bool> containsKey(String key) async {
    return await _storage.containsKey(key: key);
  }

  /// Wipe ALL stored secrets (nuclear option — for duress or reset)
  Future<void> deleteAll() async {
    await _storage.deleteAll();
  }

  // ── Convenience Methods ───────────────────────────────────

  /// Store the Gemini API key securely
  Future<void> setGeminiApiKey(String apiKey) async {
    await write(SecureKeys.geminiApiKey, apiKey);
  }

  /// Retrieve the Gemini API key
  Future<String?> getGeminiApiKey() async {
    return await read(SecureKeys.geminiApiKey);
  }

  /// Store master PIN for app access
  Future<void> setMasterPin(String pin) async {
    await write(SecureKeys.masterPin, pin);
  }

  /// Verify a PIN against the stored master PIN
  Future<bool> verifyMasterPin(String pin) async {
    final stored = await read(SecureKeys.masterPin);
    return stored != null && stored == pin;
  }

  /// Store the duress PIN (triggers safe mode / dummy world)
  Future<void> setDuressPin(String pin) async {
    await write(SecureKeys.duressPin, pin);
  }

  /// Check if the entered PIN is the duress PIN
  Future<bool> isDuressPin(String pin) async {
    final stored = await read(SecureKeys.duressPin);
    return stored != null && stored == pin;
  }

  /// Record authentication timestamp
  Future<void> recordAuth() async {
    await write(
      SecureKeys.lastAuthTimestamp,
      DateTime.now().toIso8601String(),
    );
  }
}
