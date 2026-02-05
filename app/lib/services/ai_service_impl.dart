/// AI Service Implementation - Firebase Cloud Functions Bridge
///
/// Concrete implementation of [AIService] that communicates with
/// the OrBeit backend AI endpoints deployed as Firebase Cloud Functions.
///
/// **Architecture:**
/// This class is the anti-corruption layer between Flutter and backend.
/// All AI operations go through Cloud Functions, never directly to Google AI.
///
/// **Production Features:**
/// - Exponential backoff retry for transient failures
/// - Local caching for credit usage (5-minute TTL)
/// - Request timeouts to prevent hanging
/// - Offline detection with cached fallback
/// - Enhanced error mapping with user-friendly messages
///
/// **Endpoints:**
/// - `generateAsset`: POST → Whisk visual generation
/// - `distillContext`: POST → Flow context distillation
/// - `creditUsage`: GET → Usage statistics

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:path_provider/path_provider.dart';
import 'ai_interface.dart';

/// Firebase Cloud Functions implementation of [AIService]
///
/// Uses httpsCallable to invoke Cloud Functions endpoints.
/// All responses are parsed to strongly-typed DTOs.
class AIServiceImpl implements AIService {
  final FirebaseFunctions _functions;

  /// Retry configuration
  static const int _maxRetries = 3;
  static const Duration _initialRetryDelay = Duration(milliseconds: 500);

  /// Timeout configuration
  static const Duration _generateAssetTimeout = Duration(seconds: 30);
  static const Duration _distillTimeout = Duration(seconds: 15);
  static const Duration _creditUsageTimeout = Duration(seconds: 5);

  /// Cache configuration
  static const Duration _cacheTTL = Duration(minutes: 5);
  static const String _creditCacheFile = 'ai_credit_cache.json';

  /// Creates an AIServiceImpl with optional custom Functions instance
  ///
  /// Defaults to the production Firebase Functions instance.
  /// Pass a custom instance for testing or emulator use.
  AIServiceImpl({FirebaseFunctions? functions})
      : _functions = functions ??
            FirebaseFunctions.instanceFor(region: 'us-central1');

  @override
  Future<AssetGenerationResponse> generateAsset(
    AssetGenerationRequest request,
  ) async {
    await _checkConnectivity();

    return _withRetry(
      operation: 'generateAsset',
      timeout: _generateAssetTimeout,
      action: () async {
        final callable = _functions.httpsCallable('generateAsset');
        final result =
            await callable.call<Map<String, dynamic>>(request.toJson());

        final data = result.data;
        if (data['success'] != true) {
          throw AIServiceException(
            data['error'] as String? ?? 'Asset generation failed',
            code: 'GENERATION_FAILED',
            errorType: AIErrorType.clientError,
          );
        }

        return AssetGenerationResponse.fromJson(
          data['data'] as Map<String, dynamic>,
        );
      },
    );
  }

  @override
  Future<LifeEventResponse> distillContext(
    ContextDistillationRequest request,
  ) async {
    await _checkConnectivity();

    return _withRetry(
      operation: 'distillContext',
      timeout: _distillTimeout,
      action: () async {
        final callable = _functions.httpsCallable('distillContext');
        final result =
            await callable.call<Map<String, dynamic>>(request.toJson());

        final data = result.data;
        if (data['success'] != true) {
          throw AIServiceException(
            data['error'] as String? ?? 'Context distillation failed',
            code: 'DISTILLATION_FAILED',
            errorType: AIErrorType.clientError,
          );
        }

        return LifeEventResponse.fromJson(
          data['data'] as Map<String, dynamic>,
        );
      },
    );
  }

  @override
  Future<Map<String, dynamic>> getCreditUsage() async {
    // Try cache first (works offline)
    final cached = await _getCachedCreditUsage();
    if (cached != null) {
      // Background refresh if online
      _refreshCreditUsageInBackground();
      return cached;
    }

    // No cache, must be online
    await _checkConnectivity();

    final freshData = await _fetchCreditUsage();
    await _cacheCreditUsage(freshData);
    return freshData;
  }

  // ============================================================
  // RETRY LOGIC
  // ============================================================

  /// Executes an operation with exponential backoff retry
  Future<T> _withRetry<T>({
    required String operation,
    required Duration timeout,
    required Future<T> Function() action,
  }) async {
    int attempt = 0;
    Duration delay = _initialRetryDelay;

    while (true) {
      try {
        return await action().timeout(timeout);
      } on TimeoutException {
        throw AIServiceException(
          '$operation timed out after ${timeout.inSeconds}s',
          code: 'TIMEOUT',
          errorType: AIErrorType.timeout,
        );
      } on FirebaseFunctionsException catch (e) {
        final exception = AIServiceException.fromFirebaseCode(
          e.code,
          e.message ?? 'Firebase Functions error',
        );

        // Only retry transient errors
        if (!exception.isRetryable || attempt >= _maxRetries - 1) {
          throw exception;
        }

        attempt++;
        await Future.delayed(delay);
        delay *= 2; // Exponential backoff
      } on SocketException {
        throw const AIServiceException(
          'Network error',
          code: 'NETWORK_ERROR',
          errorType: AIErrorType.network,
        );
      } on AIServiceException {
        rethrow;
      } catch (e) {
        throw AIServiceException('Unexpected error: $e');
      }
    }
  }

  // ============================================================
  // CONNECTIVITY
  // ============================================================

  /// Checks if device is online, throws OfflineException if not
  Future<void> _checkConnectivity() async {
    try {
      final result = await InternetAddress.lookup('google.com')
          .timeout(const Duration(seconds: 3));
      if (result.isEmpty || result[0].rawAddress.isEmpty) {
        throw const OfflineException();
      }
    } on SocketException {
      throw const OfflineException();
    } on TimeoutException {
      throw const OfflineException();
    }
  }

  // ============================================================
  // CREDIT USAGE CACHING
  // ============================================================

  Future<File> get _cacheFile async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/$_creditCacheFile');
  }

  Future<Map<String, dynamic>?> _getCachedCreditUsage() async {
    try {
      final file = await _cacheFile;
      if (!await file.exists()) return null;

      final content = await file.readAsString();
      final cached = jsonDecode(content) as Map<String, dynamic>;

      final cachedAt = DateTime.parse(cached['_cachedAt'] as String);
      if (DateTime.now().difference(cachedAt) > _cacheTTL) {
        return null; // Cache expired
      }

      final data = Map<String, dynamic>.from(cached);
      data.remove('_cachedAt');
      return data;
    } catch (e) {
      return null;
    }
  }

  Future<void> _cacheCreditUsage(Map<String, dynamic> data) async {
    try {
      final file = await _cacheFile;
      final cached = Map<String, dynamic>.from(data);
      cached['_cachedAt'] = DateTime.now().toIso8601String();
      await file.writeAsString(jsonEncode(cached));
    } catch (e) {
      // Cache write failure is non-fatal
    }
  }

  Future<Map<String, dynamic>> _fetchCreditUsage() async {
    return _withRetry(
      operation: 'getCreditUsage',
      timeout: _creditUsageTimeout,
      action: () async {
        final callable = _functions.httpsCallable('creditUsage');
        final result = await callable.call<Map<String, dynamic>>();

        final data = result.data;
        if (data['success'] != true) {
          throw AIServiceException(
            data['error'] as String? ?? 'Failed to fetch credit usage',
            code: 'CREDIT_FETCH_FAILED',
            errorType: AIErrorType.clientError,
          );
        }

        return data['data'] as Map<String, dynamic>;
      },
    );
  }

  void _refreshCreditUsageInBackground() {
    // Fire-and-forget background refresh
    Future(() async {
      try {
        final isOnline = await _isOnline();
        if (isOnline) {
          final freshData = await _fetchCreditUsage();
          await _cacheCreditUsage(freshData);
        }
      } catch (_) {
        // Background refresh failure is silent
      }
    });
  }

  Future<bool> _isOnline() async {
    try {
      final result = await InternetAddress.lookup('google.com')
          .timeout(const Duration(seconds: 2));
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } catch (_) {
      return false;
    }
  }
}
