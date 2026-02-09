/// OrBeit UI - The Or Beacon
///
/// The Or's visual presence in the interface — a pulsing,
/// glowing beacon that represents the AI assistant.
///
/// **Visual Design:**
/// - Golden pulsing orb with lighthouse-style beam sweep
/// - Breathes slowly when idle (inhale/exhale rhythm)
/// - Brightens when listening for voice input
/// - Ripples outward when speaking
/// - Tappable to activate voice interaction
///
/// **States:**
/// - Idle: Soft slow pulse
/// - Listening: Bright steady glow, mic indicator
/// - Processing: Spinning inner ring
/// - Speaking: Expanding ripple waves
/// - Error: Red flash, then return to idle

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/service_providers.dart';
import '../services/voice_service.dart';

/// The Or's visual beacon — always present on screen
class OrBeacon extends ConsumerStatefulWidget {
  /// Size of the beacon
  final double size;

  /// Called when the Or has processed a voice command
  final void Function(String command)? onVoiceCommand;

  const OrBeacon({
    super.key,
    this.size = 64,
    this.onVoiceCommand,
  });

  @override
  ConsumerState<OrBeacon> createState() => _OrBeaconState();
}

class _OrBeaconState extends ConsumerState<OrBeacon>
    with SingleTickerProviderStateMixin {
  VoiceStatus _voiceStatus = VoiceStatus.idle;
  String _partialText = '';

  @override
  void initState() {
    super.initState();
    // Listen for voice status changes
    final voiceService = ref.read(voiceServiceProvider);
    voiceService.onStatusChange = (status) {
      if (mounted) {
        setState(() => _voiceStatus = status);
      }
    };
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      onLongPress: _handleLongPress,
      child: SizedBox(
        width: widget.size + 24, // Extra space for glow
        height: widget.size + 24,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Outer glow ring
            _buildGlowRing(),
            // Ripple effect (when speaking)
            if (_voiceStatus == VoiceStatus.speaking) _buildRipples(),
            // Main orb
            _buildOrb(),
            // Status indicator
            _buildStatusIndicator(),
            // Partial text (when listening)
            if (_voiceStatus == VoiceStatus.listening && _partialText.isNotEmpty)
              _buildPartialText(),
          ],
        ),
      ),
    );
  }

  /// The outer glow ring — soft pulsing halo
  Widget _buildGlowRing() {
    return Container(
      width: widget.size + 20,
      height: widget.size + 20,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: _glowColor.withAlpha(60),
            blurRadius: 20,
            spreadRadius: 5,
          ),
        ],
      ),
    )
        .animate(onPlay: (controller) => controller.repeat(reverse: true))
        .scaleXY(begin: 0.9, end: 1.1, duration: 2000.ms)
        .fadeIn(duration: 1000.ms);
  }

  /// The main orb — the Or's visual core
  Widget _buildOrb() {
    return Container(
      width: widget.size,
      height: widget.size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            _coreColor,
            _coreColor.withAlpha(180),
            _glowColor.withAlpha(100),
          ],
          stops: const [0.0, 0.6, 1.0],
        ),
        boxShadow: [
          BoxShadow(
            color: _glowColor.withAlpha(120),
            blurRadius: 15,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Center(
        child: Icon(
          _statusIcon,
          color: Colors.white.withAlpha(220),
          size: widget.size * 0.4,
        ),
      ),
    )
        .animate(onPlay: (controller) => controller.repeat(reverse: true))
        .scaleXY(
          begin: 0.95,
          end: 1.05,
          duration: _voiceStatus == VoiceStatus.listening ? 800.ms : 3000.ms,
        );
  }

  /// Ripple effect when the Or is speaking
  Widget _buildRipples() {
    return Stack(
      alignment: Alignment.center,
      children: List.generate(3, (i) {
        return Container(
          width: widget.size,
          height: widget.size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: const Color(0xFFD4AF37).withAlpha(80),
              width: 2,
            ),
          ),
        )
            .animate(
              onPlay: (controller) => controller.repeat(),
              delay: Duration(milliseconds: i * 400),
            )
            .scaleXY(begin: 1.0, end: 2.0, duration: 1200.ms)
            .fadeOut(duration: 1200.ms);
      }),
    );
  }

  /// Small status indicator dot
  Widget _buildStatusIndicator() {
    if (_voiceStatus == VoiceStatus.idle) return const SizedBox.shrink();

    return Positioned(
      bottom: 0,
      right: 0,
      child: Container(
        width: 16,
        height: 16,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: _statusDotColor,
          border: Border.all(color: Colors.white, width: 2),
        ),
      ).animate().fadeIn(duration: 200.ms).scaleXY(begin: 0.5, end: 1.0),
    );
  }

  /// Shows partial recognized text while listening
  Widget _buildPartialText() {
    return Positioned(
      bottom: -30,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.black.withAlpha(180),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          _partialText,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 11,
            fontStyle: FontStyle.italic,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ).animate().fadeIn(duration: 150.ms),
    );
  }

  // ── Interaction Handlers ──────────────────────────────────

  void _handleTap() async {
    final voiceService = ref.read(voiceServiceProvider);

    if (_voiceStatus == VoiceStatus.listening) {
      // Already listening — stop
      await voiceService.stopListening();
      return;
    }

    if (_voiceStatus == VoiceStatus.speaking) {
      // Already speaking — stop
      await voiceService.stopSpeaking();
      return;
    }

    // Start listening
    await voiceService.startListening(
      onResult: (text, isFinal) {
        setState(() => _partialText = text);
        if (isFinal && text.isNotEmpty) {
          widget.onVoiceCommand?.call(text);
          setState(() => _partialText = '');
        }
      },
    );
  }

  void _handleLongPress() {
    // Could show Or's recent insights or settings
    // For now, provide haptic feedback
  }

  // ── Visual State Mappings ─────────────────────────────────

  Color get _coreColor {
    switch (_voiceStatus) {
      case VoiceStatus.idle:
        return const Color(0xFFD4AF37); // Gold
      case VoiceStatus.listening:
        return const Color(0xFF4FC3F7); // Light blue
      case VoiceStatus.processing:
        return const Color(0xFFFFB74D); // Amber
      case VoiceStatus.speaking:
        return const Color(0xFF81C784); // Green
      case VoiceStatus.error:
        return const Color(0xFFE57373); // Red
      case VoiceStatus.unavailable:
        return const Color(0xFF9E9E9E); // Grey
    }
  }

  Color get _glowColor {
    switch (_voiceStatus) {
      case VoiceStatus.idle:
        return const Color(0xFFFFD700); // Bright gold
      case VoiceStatus.listening:
        return const Color(0xFF29B6F6); // Blue
      case VoiceStatus.processing:
        return const Color(0xFFFF9800); // Orange
      case VoiceStatus.speaking:
        return const Color(0xFF66BB6A); // Green
      case VoiceStatus.error:
        return const Color(0xFFF44336); // Red
      case VoiceStatus.unavailable:
        return const Color(0xFF757575); // Dark grey
    }
  }

  IconData get _statusIcon {
    switch (_voiceStatus) {
      case VoiceStatus.idle:
        return Icons.auto_awesome; // Sparkle — the Or awaits
      case VoiceStatus.listening:
        return Icons.mic; // Listening
      case VoiceStatus.processing:
        return Icons.psychology; // Thinking
      case VoiceStatus.speaking:
        return Icons.record_voice_over; // Speaking
      case VoiceStatus.error:
        return Icons.warning_rounded; // Error
      case VoiceStatus.unavailable:
        return Icons.mic_off; // No mic
    }
  }

  Color get _statusDotColor {
    switch (_voiceStatus) {
      case VoiceStatus.listening:
        return Colors.red; // Recording indicator
      case VoiceStatus.processing:
        return Colors.amber;
      case VoiceStatus.speaking:
        return Colors.green;
      case VoiceStatus.error:
        return Colors.red;
      default:
        return Colors.transparent;
    }
  }
}
