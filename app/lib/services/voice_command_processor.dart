/// OrBeit Phase 3 — Voice Command Processor
///
/// Parses raw transcribed text into structured intents,
/// executes the appropriate action, and returns a response
/// for the Or to speak.
///
/// Intent Classification (local, rule-based for MVP):
///   "build a house"     → OrIntent.buildingCreate
///   "add task"          → OrIntent.taskManage
///   "log event"         → OrIntent.eventRecord
///   "show buildings"    → OrIntent.command
///
/// Privacy: All processing is on-device. No text leaves.

import 'package:flutter/foundation.dart';
import 'or_intelligence.dart'; // Canonical OrIntent enum

/// Result of processing a voice command
class VoiceCommandResult {
  final String rawText;
  final OrIntent? executedIntent;
  final String spokenResponse;
  final bool success;

  const VoiceCommandResult({
    required this.rawText,
    this.executedIntent,
    required this.spokenResponse,
    required this.success,
  });
}

/// Processes raw voice input into structured intents and actions
class VoiceCommandProcessor {
  /// Process raw voice text → classify intent → execute → respond
  Future<VoiceCommandResult> processVoiceInput(String rawText) async {
    final text = rawText.toLowerCase().trim();
    debugPrint('[VoiceProcessor] Input: "$text"');

    final intent = _classifyIntent(text);
    debugPrint('[VoiceProcessor] Intent: $intent');

    switch (intent) {
      case OrIntent.buildingCreate:
        return VoiceCommandResult(
          rawText: rawText,
          executedIntent: OrIntent.buildingCreate,
          spokenResponse: 'Opening the building menu for you.',
          success: true,
        );

      case OrIntent.taskManage:
        return VoiceCommandResult(
          rawText: rawText,
          executedIntent: OrIntent.taskManage,
          spokenResponse: 'Here are your tasks.',
          success: true,
        );

      case OrIntent.eventRecord:
        return VoiceCommandResult(
          rawText: rawText,
          executedIntent: OrIntent.eventRecord,
          spokenResponse: 'Opening your timeline.',
          success: true,
        );

      case OrIntent.command:
      case OrIntent.navigation:
        return VoiceCommandResult(
          rawText: rawText,
          executedIntent: OrIntent.command,
          spokenResponse: 'Done.',
          success: true,
        );

      case OrIntent.greeting:
        return VoiceCommandResult(
          rawText: rawText,
          executedIntent: null,
          spokenResponse: 'Shalom. How can I help?',
          success: true,
        );

      case OrIntent.question:
      case OrIntent.unknown:
        return VoiceCommandResult(
          rawText: rawText,
          executedIntent: null,
          spokenResponse: "I didn't understand that. Try 'build', 'tasks', or 'timeline'.",
          success: false,
        );
    }
  }

  /// Simple rule-based intent classification (MVP)
  /// Will be replaced with Gemini Nano on-device classification
  OrIntent _classifyIntent(String text) {
    // Building creation
    if (_matches(text, ['build', 'create', 'add building', 'new building', 'construct'])) {
      return OrIntent.buildingCreate;
    }

    // Task management
    if (_matches(text, ['task', 'todo', 'to do', 'add task', 'my tasks', 'show tasks'])) {
      return OrIntent.taskManage;
    }

    // Life events
    if (_matches(text, ['event', 'log', 'record', 'timeline', 'history', 'life event'])) {
      return OrIntent.eventRecord;
    }

    // General commands
    if (_matches(text, ['show', 'open', 'close', 'hide', 'navigate'])) {
      return OrIntent.command;
    }

    return OrIntent.unknown;
  }

  /// Check if text contains any of the keywords
  bool _matches(String text, List<String> keywords) {
    return keywords.any((kw) => text.contains(kw));
  }
}
