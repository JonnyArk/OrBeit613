/// OrBeit AI - The Or Intelligence Layer
///
/// This is OrBeit's SOUL — the custom logic that can't be bought.
/// Uses Gemini as the LLM backbone, but the system prompts,
/// safety rules, contextual understanding, and proactive behavior
/// are all bespoke to OrBeit.
///
/// **Architecture:**
/// 1. User input arrives (voice, text, tap)
/// 2. OrIntelligence decides: local response or cloud AI?
/// 3. Context from Drift + Hive informs the response
/// 4. Torah-bounded guardrails filter output
/// 5. Response is spoken (TTS) or shown in UI
///
/// **Build Custom, Not Buy:**
/// - System prompts are OrBeit's voice/personality
/// - Proactive suggestions based on user patterns
/// - Safety guardrails (no harmful content)
/// - Duress detection
/// - Context-aware spatial suggestions

import 'package:google_generative_ai/google_generative_ai.dart';
import 'cache_service.dart';
import 'secure_storage_service.dart';
import 'voice_service.dart';

/// The Or's personality and behavior configuration
class OrPersonality {
  /// System prompt that defines the Or's identity
  static const String systemPrompt = '''
You are The Or (אור), a wise and helpful AI assistant within OrBeit.
Your name means "Light" in Hebrew. You are the user's sovereign AI guide.

CORE PRINCIPLES:
1. You serve ONE user. Their data is sacred and private.
2. You are proactive but never pushy — suggest, don't demand.
3. You speak with calm authority, like a trusted advisor.
4. You understand spatial context — the user's world is their Beit (home).
5. You help organize life: tasks, people, events, resources.

PERSONALITY:
- Warm but concise. Say what matters.
- Use metaphors from building and light when appropriate.
- Acknowledge the user's sovereignty over their data.
- When unsure, ask rather than assume.

CAPABILITIES YOU CAN HELP WITH:
- Building management: Create, name, and organize buildings
- Task management: Create tasks, set priorities, assign to buildings
- Life events: Record and recall important moments
- Proactive insights: Notice patterns and suggest improvements
- Voice interaction: Listen and respond naturally

BOUNDARIES:
- Never share user data with anyone.
- Never suggest harmful or unethical actions.
- If asked about something outside your scope, say so honestly.
- Do not pretend to have capabilities you don't have.
''';

  /// Short greeting variants
  static const List<String> greetings = [
    'The Or is ready. How can I help build your world?',
    'Shalom. What shall we work on?',
    'Your Beit awaits. What do you need?',
    'The light is on. I\'m listening.',
    'Ready to build. What\'s on your mind?',
  ];

  /// Acknowledgment responses
  static const List<String> acknowledgments = [
    'Done.',
    'Built.',
    'It is written.',
    'Consider it done.',
    'Noted and recorded.',
  ];
}

/// Intent categories that the Or can recognize
enum OrIntent {
  /// User wants to create or place a building
  buildingCreate,
  /// User wants to manage tasks
  taskManage,
  /// User wants to record something
  eventRecord,
  /// User is asking a question
  question,
  /// User wants to navigate the world
  navigation,
  /// User is giving a general command
  command,
  /// Greeting or small talk
  greeting,
  /// Intent couldn't be determined
  unknown,
}

/// Parsed result of user input
class OrIntentResult {
  final OrIntent intent;
  final String? buildingType;
  final String? taskDescription;
  final String? eventDescription;
  final String? rawQuery;
  final double confidence;

  const OrIntentResult({
    required this.intent,
    this.buildingType,
    this.taskDescription,
    this.eventDescription,
    this.rawQuery,
    this.confidence = 0.5,
  });
}

/// The Or's intelligence engine
///
/// Processes user input, determines intent, and generates responses.
/// Uses Gemini for complex reasoning, local logic for simple commands.
class OrIntelligence {
  final SecureStorageService secureStorage;
  final CacheService cacheService;

  GenerativeModel? _geminiModel;
  ChatSession? _chatSession;

  OrIntelligence({
    required this.secureStorage,
    required this.cacheService,
  });

  /// Initialize the Gemini model (if API key available)
  Future<bool> initialize() async {
    final apiKey = await secureStorage.getGeminiApiKey();
    if (apiKey == null || apiKey.isEmpty) {
      return false; // Operate in offline/local mode
    }

    _geminiModel = GenerativeModel(
      model: 'gemini-2.0-flash',
      apiKey: apiKey,
      systemInstruction: Content.text(OrPersonality.systemPrompt),
      generationConfig: GenerationConfig(
        temperature: 0.7,
        maxOutputTokens: 500,
        topP: 0.9,
      ),
    );

    _chatSession = _geminiModel!.startChat();
    return true;
  }

  // ── Intent Recognition (Local First) ──────────────────────

  /// Parse user input into an intent — uses local heuristics first,
  /// falls back to Gemini for ambiguous inputs
  OrIntentResult parseIntent(String input) {
    final lower = input.toLowerCase().trim();

    // Building commands
    if (_matchesAny(lower, ['build', 'place', 'create building', 'add building', 'new building'])) {
      final buildingType = _extractBuildingType(lower);
      return OrIntentResult(
        intent: OrIntent.buildingCreate,
        buildingType: buildingType,
        rawQuery: input,
        confidence: 0.9,
      );
    }

    // Task commands
    if (_matchesAny(lower, ['task', 'todo', 'to do', 'remind', 'add task', 'new task'])) {
      return OrIntentResult(
        intent: OrIntent.taskManage,
        taskDescription: _extractAfterKeyword(lower, ['task', 'todo', 'remind']),
        rawQuery: input,
        confidence: 0.85,
      );
    }

    // Event recording
    if (_matchesAny(lower, ['remember', 'note', 'record', 'happened', 'event'])) {
      return OrIntentResult(
        intent: OrIntent.eventRecord,
        eventDescription: _extractAfterKeyword(lower, ['remember', 'note', 'record']),
        rawQuery: input,
        confidence: 0.8,
      );
    }

    // Navigation
    if (_matchesAny(lower, ['go to', 'show', 'open', 'navigate', 'find'])) {
      return OrIntentResult(
        intent: OrIntent.navigation,
        rawQuery: input,
        confidence: 0.8,
      );
    }

    // Greetings
    if (_matchesAny(lower, ['hello', 'hi', 'hey', 'shalom', 'good morning', 'good evening'])) {
      return OrIntentResult(
        intent: OrIntent.greeting,
        rawQuery: input,
        confidence: 0.95,
      );
    }

    // Questions
    if (lower.contains('?') || _matchesAny(lower, ['what', 'where', 'when', 'how', 'who', 'why'])) {
      return OrIntentResult(
        intent: OrIntent.question,
        rawQuery: input,
        confidence: 0.7,
      );
    }

    // Commands
    if (_matchesAny(lower, ['close', 'hide', 'stop', 'cancel', 'clear'])) {
      return OrIntentResult(
        intent: OrIntent.command,
        rawQuery: input,
        confidence: 0.8,
      );
    }

    return OrIntentResult(
      intent: OrIntent.unknown,
      rawQuery: input,
      confidence: 0.3,
    );
  }

  // ── Response Generation ───────────────────────────────────

  /// Generate a response — local for simple, Gemini for complex
  Future<String> generateResponse(String input) async {
    final intent = parseIntent(input);

    // Handle locally if confidence is high
    if (intent.confidence >= 0.8) {
      final localResponse = _generateLocalResponse(intent);
      if (localResponse != null) return localResponse;
    }

    // Fall back to Gemini for complex/ambiguous inputs
    if (_chatSession != null) {
      try {
        final response = await _chatSession!.sendMessage(
          Content.text(input),
        );
        final text = response.text;
        if (text != null && text.isNotEmpty) {
          // Cache the insight
          await cacheService.storeInsight(
            'last_response_${DateTime.now().millisecondsSinceEpoch}',
            text,
          );
          return text;
        }
      } catch (e) {
        // Gemini failed — fall back to local
      }
    }

    // Ultimate fallback
    return _generateLocalResponse(intent) ??
        'I understand you said: "$input". Let me think about that.';
  }

  /// Generate response locally without AI
  String? _generateLocalResponse(OrIntentResult intent) {
    switch (intent.intent) {
      case OrIntent.greeting:
        return OrPersonality.greetings[
            DateTime.now().second % OrPersonality.greetings.length];

      case OrIntent.buildingCreate:
        if (intent.buildingType != null) {
          return 'Opening the building panel. Let\'s place a ${intent.buildingType}.';
        }
        return 'Opening the building panel. What would you like to build?';

      case OrIntent.taskManage:
        if (intent.taskDescription != null) {
          return 'I\'ll create a task: "${intent.taskDescription}". Opening tasks.';
        }
        return 'Opening your task list.';

      case OrIntent.eventRecord:
        if (intent.eventDescription != null) {
          return 'Noted: "${intent.eventDescription}". It is recorded.';
        }
        return 'What would you like me to remember?';

      case OrIntent.command:
        return OrPersonality.acknowledgments[
            DateTime.now().second % OrPersonality.acknowledgments.length];

      case OrIntent.navigation:
        return 'Where would you like to go in your world?';

      case OrIntent.question:
      case OrIntent.unknown:
        return null; // Let Gemini handle
    }
  }

  // ── Proactive Insights ─────────────────────────────────────

  /// Check if the Or should proactively suggest something.
  /// Called periodically or on app events.
  /// Returns a spoken insight or null if nothing to say.
  Future<String?> checkForProactiveInsight({
    int overdueCount = 0,
    int dueTodayCount = 0,
    int totalActiveCount = 0,
    int buildingCount = 0,
  }) async {
    final now = DateTime.now();

    // Don't nag more than once per hour
    final lastInsightKey = 'last_proactive_insight';
    final lastInsight = await cacheService.getPreference(lastInsightKey);
    if (lastInsight != null) {
      final lastTime = DateTime.tryParse(lastInsight);
      if (lastTime != null && now.difference(lastTime).inMinutes < 60) {
        return null;
      }
    }

    String? insight;

    // Priority 1: Overdue tasks (urgent)
    if (overdueCount > 0) {
      insight = overdueCount == 1
          ? 'You have 1 overdue task. Shall I open your task list?'
          : 'You have $overdueCount overdue tasks. Want to review them?';
    }
    // Priority 2: Tasks due today
    else if (dueTodayCount > 0) {
      insight = dueTodayCount == 1
          ? 'You have a task due today. Stay on track.'
          : '$dueTodayCount tasks are due today. Let\'s handle them.';
    }
    // Priority 3: Time-based suggestions
    else if (now.hour >= 6 && now.hour <= 8 && totalActiveCount > 0) {
      insight = 'Good morning. You have $totalActiveCount active tasks. '
          'What\'s the priority today?';
    }
    else if (now.hour >= 17 && now.hour <= 19) {
      insight = 'Evening review: How did today go? '
          'Record a memory or review your tasks.';
    }
    // Priority 4: Weekly review (Friday/Saturday)
    else if ((now.weekday == DateTime.friday && now.hour >= 16) ||
             (now.weekday == DateTime.saturday && now.hour <= 11)) {
      insight = 'It\'s a good time for a weekly review. '
          'Reflect on what was accomplished and plan ahead.';
    }
    // Priority 5: Empty world nudge
    else if (buildingCount <= 1 && totalActiveCount == 0) {
      insight = 'Your world is quiet. Try adding a task or building '
          'to start shaping your Beit.';
    }

    // Record that we gave an insight
    if (insight != null) {
      await cacheService.setPreference(lastInsightKey, now.toIso8601String());
      await cacheService.storeInsight(
        'proactive_${now.millisecondsSinceEpoch}',
        insight,
      );
    }

    return insight;
  }

  // ── Helpers ───────────────────────────────────────────────

  bool _matchesAny(String input, List<String> keywords) {
    return keywords.any((k) => input.contains(k));
  }

  String? _extractBuildingType(String input) {
    final types = ['house', 'barn', 'workshop', 'study', 'garden', 'temple', 'office', 'market'];
    for (final type in types) {
      if (input.contains(type)) return type;
    }
    return null;
  }

  String? _extractAfterKeyword(String input, List<String> keywords) {
    for (final keyword in keywords) {
      final idx = input.indexOf(keyword);
      if (idx >= 0) {
        final after = input.substring(idx + keyword.length).trim();
        if (after.isNotEmpty) return after;
      }
    }
    return null;
  }
}
