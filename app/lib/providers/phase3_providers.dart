/// OrBeit Phase 3 — Provider Definitions
///
/// Riverpod providers for Phase 3 services:
///  - ReminderService (contextual reminders)
///  - VoiceCommandProcessor (intent classification)

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/reminder_service.dart';
import '../services/voice_command_processor.dart';

/// Contextual reminder service — periodic local checks
final reminderServiceProvider = Provider<ReminderService>((ref) {
  final service = ReminderService();
  ref.onDispose(() => service.dispose());
  return service;
});

/// Voice command processor — parse speech → intent → action
final voiceCommandProcessorProvider = Provider<VoiceCommandProcessor>((ref) {
  return VoiceCommandProcessor();
});
