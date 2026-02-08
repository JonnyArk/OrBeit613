/// OrBeit Providers - AI Service Provider
///
/// Riverpod provider for the AI service layer.

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/ai_interface.dart';

/// AI service provider
///
/// Override in ProviderScope in main() to set the concrete implementation.
final aiServiceProvider = Provider<AIService>((ref) {
  throw UnimplementedError('Must override aiServiceProvider in main()');
});
