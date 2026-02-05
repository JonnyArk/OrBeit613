/// AI Service Interface for OrBeit
///
/// This interface defines the contract for communicating with the
/// OrBeit AI Resource Layer (Google AI Ultra: Flow, Whisk, Gemini).
///
/// **Architecture:**
/// This service acts as an anti-corruption layer between the Flutter
/// application and the Firebase Cloud Functions AI backend.
///
/// **For Future Agents:**
/// - All AI interactions MUST go through this interface
/// - Implementation handles HTTP calls to Cloud Functions
/// - Credit tracking is managed server-side (25k monthly limit)
/// - Never call AI APIs directly from Flutter
///
/// **Google AI Ultra Resources:**
/// - Whisk: Visual asset generation (badges, tiles, avatars)
/// - Flow: Context distillation (notes → Life Events)
/// - Gemini: Intent parsing and natural language understanding

/// Request object for generating visual assets via Whisk
class AssetGenerationRequest {
  /// Type of asset to generate
  /// Valid types: 'badge', 'terrain_tile', 'avatar', 'icon', 'background', 'orb'
  final String assetType;

  /// Contextual description for the asset (e.g., "first task completed")
  final String context;

  /// Asset size: 'small' (256px), 'medium' (512px), 'large' (1024px)
  final String size;

  /// Optional user ID for credit tracking
  final String? userId;

  const AssetGenerationRequest({
    required this.assetType,
    required this.context,
    this.size = 'medium',
    this.userId,
  });

  Map<String, dynamic> toJson() => {
        'assetType': assetType,
        'context': context,
        'size': size,
        if (userId != null) 'userId': userId,
      };
}

/// Response from asset generation
class AssetGenerationResponse {
  /// URL to the generated asset in Firebase Storage
  final String assetUrl;

  /// Number of AI credits consumed
  final int creditsUsed;

  /// Whether the asset was served from cache
  final bool fromCache;

  const AssetGenerationResponse({
    required this.assetUrl,
    required this.creditsUsed,
    required this.fromCache,
  });

  factory AssetGenerationResponse.fromJson(Map<String, dynamic> json) {
    return AssetGenerationResponse(
      assetUrl: json['assetUrl'] as String,
      creditsUsed: json['creditsUsed'] as int,
      fromCache: json['fromCache'] as bool,
    );
  }
}

/// Request for distilling raw context into structured Life Events
class ContextDistillationRequest {
  /// Raw text input (note, transcript, sensor data)
  final String rawData;

  /// Type of input data: 'note_text', 'voice_transcript', 'calendar_entry', etc.
  final String dataType;

  /// Optional spatial hint (e.g., "Living Room", room UUID)
  final String? spatialHint;

  /// Optional timestamp of when the event occurred
  final DateTime? occurredAt;

  const ContextDistillationRequest({
    required this.rawData,
    required this.dataType,
    this.spatialHint,
    this.occurredAt,
  });

  Map<String, dynamic> toJson() => {
        'rawData': rawData,
        'dataType': dataType,
        if (spatialHint != null) 'spatialHint': spatialHint,
        if (occurredAt != null) 'occurredAt': occurredAt!.toIso8601String(),
      };
}

/// Distilled Life Event response
class LifeEventResponse {
  /// Unique event ID
  final String id;

  /// Event category
  final String category;

  /// Generated title
  final String title;

  /// Description
  final String description;

  /// Extracted entities (people, places, things)
  final List<Map<String, dynamic>> entities;

  /// Sentiment analysis result
  final Map<String, dynamic>? sentiment;

  /// Extracted action items
  final List<Map<String, dynamic>>? actionItems;

  const LifeEventResponse({
    required this.id,
    required this.category,
    required this.title,
    required this.description,
    required this.entities,
    this.sentiment,
    this.actionItems,
  });

  factory LifeEventResponse.fromJson(Map<String, dynamic> json) {
    return LifeEventResponse(
      id: json['id'] as String,
      category: json['category'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      entities: (json['entities'] as List).cast<Map<String, dynamic>>(),
      sentiment: json['sentiment'] as Map<String, dynamic>?,
      actionItems: json['actionItems'] != null
          ? (json['actionItems'] as List).cast<Map<String, dynamic>>()
          : null,
    );
  }
}

/// Abstract interface for AI service operations
///
/// **Implementation Notes:**
/// - The concrete implementation will use Cloud Functions HTTP endpoints
/// - All methods are async and may throw [AIServiceException]
/// - Credit limits are enforced server-side (25,000/month)
abstract class AIService {
  /// Generates a visual asset using the Whisk service
  ///
  /// **Sovereign Sanctum Aesthetic:**
  /// All generated assets follow the geometric gold/teal design system.
  ///
  /// **Credit Cost:**
  /// - Small: 5 credits
  /// - Medium: 10 credits
  /// - Large: 25 credits
  ///
  /// Throws [AIServiceException] if generation fails or credits exhausted.
  Future<AssetGenerationResponse> generateAsset(AssetGenerationRequest request);

  /// Distills raw context into a structured Life Event
  ///
  /// **Sovereign Pipeline:**
  /// Transforms unstructured input into categorized, searchable events
  /// with entity extraction and sentiment analysis.
  ///
  /// **Credit Cost:**
  /// - Simple: 2 credits
  /// - Complex: 8 credits
  ///
  /// Throws [AIServiceException] if distillation fails or credits exhausted.
  Future<LifeEventResponse> distillContext(ContextDistillationRequest request);

  /// Retrieves current AI credit usage statistics
  ///
  /// Returns remaining credits, percentage used, and estimated days remaining.
  Future<Map<String, dynamic>> getCreditUsage();
}

/// Error types for AI service operations
enum AIErrorType {
  /// Network connectivity issue
  network,

  /// Request timed out
  timeout,

  /// Rate limited by API
  rateLimited,

  /// Insufficient credits remaining
  insufficientCredits,

  /// Server-side error (5xx)
  serverError,

  /// Client error (4xx)
  clientError,

  /// Device is offline
  offline,

  /// Unknown error
  unknown,
}

/// Exception thrown by AI service operations
class AIServiceException implements Exception {
  final String message;
  final String? code;
  final AIErrorType errorType;

  /// Whether this error is transient and should be retried
  bool get isRetryable => [
        AIErrorType.network,
        AIErrorType.timeout,
        AIErrorType.serverError,
      ].contains(errorType);

  const AIServiceException(
    this.message, {
    this.code,
    this.errorType = AIErrorType.unknown,
  });

  /// Creates exception from Firebase error code
  factory AIServiceException.fromFirebaseCode(String code, String message) {
    AIErrorType type;
    switch (code) {
      case 'unavailable':
      case 'internal':
        type = AIErrorType.serverError;
        break;
      case 'deadline-exceeded':
        type = AIErrorType.timeout;
        break;
      case 'resource-exhausted':
        type = AIErrorType.rateLimited;
        break;
      case 'permission-denied':
      case 'unauthenticated':
        type = AIErrorType.insufficientCredits;
        break;
      default:
        type = AIErrorType.unknown;
    }
    return AIServiceException(message, code: code, errorType: type);
  }

  /// User-friendly error message
  String get userMessage {
    switch (errorType) {
      case AIErrorType.network:
        return 'Network error. Please check your connection.';
      case AIErrorType.timeout:
        return 'Request timed out. Please try again.';
      case AIErrorType.rateLimited:
        return 'Too many requests. Please wait a moment.';
      case AIErrorType.insufficientCredits:
        return 'AI credits exhausted. Limit resets monthly.';
      case AIErrorType.serverError:
        return 'Server error. Please try again later.';
      case AIErrorType.clientError:
        return 'Invalid request. Please check your input.';
      case AIErrorType.offline:
        return 'You are offline. Some features unavailable.';
      case AIErrorType.unknown:
        return message;
    }
  }

  @override
  String toString() =>
      'AIServiceException: $message${code != null ? ' ($code)' : ''} [${errorType.name}]';
}

/// Exception for offline-specific scenarios
class OfflineException extends AIServiceException {
  const OfflineException([String message = 'Device is offline'])
      : super(message, errorType: AIErrorType.offline);
}

