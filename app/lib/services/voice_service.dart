/// OrBeit Voice Layer - Voice Interaction Service
///
/// Unifies speech_to_text and flutter_tts into a single service
/// for the Or's voice-first interaction model.
///
/// **Capabilities:**
/// - Listen: Convert user's speech to text commands
/// - Speak: The Or responds with synthesized voice
/// - Language: Supports multiple languages (Hebrew, English, etc.)
///
/// **Usage Pattern:**
/// 1. User taps mic or says wake word
/// 2. VoiceService.startListening() captures speech
/// 3. Text is sent to Or's AI logic layer
/// 4. Or's response is spoken via VoiceService.speak()

import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'dart:async';

/// Callback for when speech is recognized
typedef OnSpeechResult = void Function(String text, bool isFinal);

/// Callback for voice service status changes
typedef OnStatusChange = void Function(VoiceStatus status);

/// Voice service status
enum VoiceStatus {
  idle,
  listening,
  processing,
  speaking,
  error,
  unavailable,
}

/// Unified voice interaction service
///
/// Handles both speech-to-text (listening) and text-to-speech (speaking)
/// for the Or's voice interface.
class VoiceService {
  final stt.SpeechToText _speechToText = stt.SpeechToText();
  final FlutterTts _tts = FlutterTts();

  VoiceStatus _status = VoiceStatus.idle;
  VoiceStatus get status => _status;

  bool _speechAvailable = false;
  bool get isSpeechAvailable => _speechAvailable;

  OnStatusChange? onStatusChange;

  final StreamController<String> _partialResultsController =
      StreamController<String>.broadcast();

  /// Stream of partial speech recognition results (real-time)
  Stream<String> get partialResults => _partialResultsController.stream;

  // ── Initialization ────────────────────────────────────────

  /// Initialize both speech-to-text and text-to-speech engines
  Future<bool> initialize() async {
    // Initialize speech recognition
    _speechAvailable = await _speechToText.initialize(
      onStatus: _handleSpeechStatus,
      onError: _handleSpeechError,
    );

    // Configure TTS
    await _tts.setLanguage('en-US');
    await _tts.setSpeechRate(0.5); // Calm, measured pace for the Or
    await _tts.setVolume(0.9);
    await _tts.setPitch(1.0);

    // Set TTS completion handler
    _tts.setCompletionHandler(() {
      _setStatus(VoiceStatus.idle);
    });

    return _speechAvailable;
  }

  // ── Speech-to-Text (Listening) ────────────────────────────

  /// Start listening for speech input
  ///
  /// [onResult] is called with the recognized text and whether it's final
  /// [localeId] language locale (default: 'en_US', also supports 'he_IL')
  /// [listenFor] maximum duration to listen
  Future<void> startListening({
    required OnSpeechResult onResult,
    String localeId = 'en_US',
    Duration listenFor = const Duration(seconds: 30),
  }) async {
    if (!_speechAvailable) {
      _setStatus(VoiceStatus.unavailable);
      return;
    }

    _setStatus(VoiceStatus.listening);

    await _speechToText.listen(
      onResult: (SpeechRecognitionResult result) {
        // Emit partial results for real-time UI feedback
        _partialResultsController.add(result.recognizedWords);

        // Call the result handler
        onResult(result.recognizedWords, result.finalResult);

        if (result.finalResult) {
          _setStatus(VoiceStatus.processing);
        }
      },
      localeId: localeId,
      listenFor: listenFor,
      listenOptions: stt.SpeechListenOptions(
        listenMode: stt.ListenMode.confirmation,
        cancelOnError: true,
        partialResults: true,
      ),
    );
  }

  /// Stop listening
  Future<void> stopListening() async {
    await _speechToText.stop();
    _setStatus(VoiceStatus.idle);
  }

  /// Cancel listening (discards any partial results)
  Future<void> cancelListening() async {
    await _speechToText.cancel();
    _setStatus(VoiceStatus.idle);
  }

  /// Get available locales for speech recognition
  Future<List<stt.LocaleName>> getAvailableLocales() async {
    return await _speechToText.locales();
  }

  // ── Text-to-Speech (The Or Speaks) ────────────────────────

  /// Have the Or speak a response
  ///
  /// [text] The text for the Or to speak
  /// [language] Language code (default: 'en-US')
  Future<void> speak(String text, {String language = 'en-US'}) async {
    _setStatus(VoiceStatus.speaking);
    await _tts.setLanguage(language);
    await _tts.speak(text);
  }

  /// Stop the Or from speaking
  Future<void> stopSpeaking() async {
    await _tts.stop();
    _setStatus(VoiceStatus.idle);
  }

  /// Pause speech (can be resumed)
  Future<void> pauseSpeaking() async {
    await _tts.pause();
  }

  /// Set the Or's voice characteristics
  Future<void> setVoiceProfile({
    double rate = 0.5,
    double pitch = 1.0,
    double volume = 0.9,
  }) async {
    await _tts.setSpeechRate(rate);
    await _tts.setPitch(pitch);
    await _tts.setVolume(volume);
  }

  /// Get available TTS voices
  Future<List<dynamic>> getAvailableVoices() async {
    return await _tts.getVoices;
  }

  // ── Convenience ───────────────────────────────────────────

  /// Listen for a single command and return it
  Future<String?> listenForCommand({
    String localeId = 'en_US',
    Duration timeout = const Duration(seconds: 10),
  }) async {
    final completer = Completer<String?>();

    await startListening(
      onResult: (text, isFinal) {
        if (isFinal && !completer.isCompleted) {
          completer.complete(text);
        }
      },
      localeId: localeId,
      listenFor: timeout,
    );

    // Timeout fallback
    Future.delayed(timeout, () {
      if (!completer.isCompleted) {
        stopListening();
        completer.complete(null);
      }
    });

    return completer.future;
  }

  // ── Internal Handlers ─────────────────────────────────────

  void _handleSpeechStatus(String status) {
    if (status == 'done' || status == 'notListening') {
      if (_status == VoiceStatus.listening) {
        _setStatus(VoiceStatus.idle);
      }
    }
  }

  void _handleSpeechError(dynamic error) {
    _setStatus(VoiceStatus.error);
  }

  void _setStatus(VoiceStatus newStatus) {
    _status = newStatus;
    onStatusChange?.call(newStatus);
  }

  /// Clean up resources
  void dispose() {
    _speechToText.cancel();
    _tts.stop();
    _partialResultsController.close();
  }
}
