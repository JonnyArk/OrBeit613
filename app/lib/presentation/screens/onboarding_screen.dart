/// OrBeit Presentation - Onboarding Screen
///
/// The cinematic "Darkness to Light" onboarding experience.
///
/// **Three Stages:**
/// 1. The Void — Pure black with floating golden motes; a pulse appears
/// 2. The Foundation — User names their house; world darkens to deep blue
/// 3. The Light — Building materializes with golden burst; "Let there be light."
///
/// After completion, navigates to the main GameScreen.

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../providers/building_provider.dart';
import '../../providers/genesis_provider.dart';
import '../../providers/service_providers.dart';
import '../../domain/entities/genesis_kit.dart';
import '../../domain/entities/calendar_mode.dart';
import '../../main.dart';
import 'calendar_choice_screen.dart';

/// Stage of the onboarding
enum _OnboardingStage { theVoid, theFoundation, theCalendar, theLight }

/// The cinematic onboarding screen
class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen>
    with TickerProviderStateMixin {
  _OnboardingStage _stage = _OnboardingStage.theVoid;
  final _nameController = TextEditingController();
  CalendarMode _selectedCalendarMode = CalendarMode.western;
  bool _showWelcomeText = false;
  bool _showPulse = false;
  bool _isCreating = false;
  bool _showLetThereBeLight = false;
  bool _showBuildingBurst = false;

  // Animation controllers
  late AnimationController _pulseController;
  late AnimationController _particleController;
  late AnimationController _lightBurstController;

  @override
  void initState() {
    super.initState();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);

    _particleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 8000),
    )..repeat();

    _lightBurstController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    );

    // Stage 1: Animate in
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) setState(() => _showWelcomeText = true);
    });

    Future.delayed(const Duration(milliseconds: 3000), () {
      if (mounted) setState(() => _showPulse = true);
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _pulseController.dispose();
    _particleController.dispose();
    _lightBurstController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 1500),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: _backgroundColors,
          ),
        ),
        child: Stack(
          children: [
            // Floating particles (all stages)
            _FloatingParticles(
              controller: _particleController,
              brightness: _particleBrightness,
            ),

            // Stage content
            _buildStageContent(),

            // Light burst effect (Stage 3)
            if (_showBuildingBurst) _buildLightBurst(),
          ],
        ),
      ),
    );
  }

  // ── Background Colors ─────────────────────────────────────

  List<Color> get _backgroundColors {
    switch (_stage) {
      case _OnboardingStage.theVoid:
        return [Colors.black, Colors.black];
      case _OnboardingStage.theFoundation:
        return [
          const Color(0xFF050510),
          const Color(0xFF0A0A1A),
        ];
      case _OnboardingStage.theCalendar:
        return [
          const Color(0xFF080818),
          const Color(0xFF0E0E1E),
        ];
      case _OnboardingStage.theLight:
        return [
          const Color(0xFF0A0A12),
          const Color(0xFF1A1A2E),
        ];
    }
  }

  double get _particleBrightness {
    switch (_stage) {
      case _OnboardingStage.theVoid:
        return 0.15;
      case _OnboardingStage.theFoundation:
        return 0.3;
      case _OnboardingStage.theCalendar:
        return 0.4;
      case _OnboardingStage.theLight:
        return 0.6;
    }
  }

  // ── Stage Content ─────────────────────────────────────────

  Widget _buildStageContent() {
    switch (_stage) {
      case _OnboardingStage.theVoid:
        return _buildVoidStage();
      case _OnboardingStage.theFoundation:
        return _buildFoundationStage();
      case _OnboardingStage.theCalendar:
        return _buildCalendarStage();
      case _OnboardingStage.theLight:
        return _buildLightStage();
    }
  }

  // ── STAGE 1: The Void ─────────────────────────────────────

  Widget _buildVoidStage() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Welcome text
          AnimatedOpacity(
            opacity: _showWelcomeText ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 1500),
            curve: Curves.easeIn,
            child: const Text(
              'Welcome to your world.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFFF5F0E8),
                fontSize: 28,
                fontWeight: FontWeight.w300,
                letterSpacing: 1.5,
                height: 1.4,
              ),
            ),
          ),

          const SizedBox(height: 60),

          // Golden pulse
          AnimatedOpacity(
            opacity: _showPulse ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 800),
            child: GestureDetector(
              onTap: _advanceToFoundation,
              child: AnimatedBuilder(
                animation: _pulseController,
                builder: (context, child) {
                  final scale = 1.0 + _pulseController.value * 0.15;
                  final glowAlpha = (80 + _pulseController.value * 60).toInt();
                  return Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          const Color(0xFFD4AF37),
                          const Color(0xFFD4AF37).withAlpha(120),
                          Colors.transparent,
                        ],
                        stops: const [0.0, 0.5, 1.0],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFD4AF37).withAlpha(glowAlpha),
                          blurRadius: 30 * scale,
                          spreadRadius: 5 * scale,
                        ),
                      ],
                    ),
                    transform: Matrix4.identity()..scale(scale),
                    transformAlignment: Alignment.center,
                    child: const Icon(
                      Icons.touch_app,
                      color: Color(0xFF1A1A2E),
                      size: 28,
                    ),
                  );
                },
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Hint text
          AnimatedOpacity(
            opacity: _showPulse ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 600),
            child: Text(
              'Tap to begin',
              style: TextStyle(
                color: const Color(0xFFD4AF37).withAlpha(100),
                fontSize: 13,
                letterSpacing: 2.0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── STAGE 2: The Foundation ───────────────────────────────

  Widget _buildFoundationStage() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 48),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Shield icon
            const Icon(
              Icons.shield_outlined,
              size: 56,
              color: Color(0xFFD4AF37),
            )
                .animate()
                .fadeIn(duration: 600.ms)
                .scaleXY(begin: 0.5, end: 1.0, duration: 600.ms),

            const SizedBox(height: 40),

            // Prompt
            const Text(
              'What shall we call\nthis place?',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFFF5F0E8),
                fontSize: 24,
                fontWeight: FontWeight.w300,
                letterSpacing: 1.0,
                height: 1.5,
              ),
            ).animate().fadeIn(duration: 800.ms, delay: 200.ms),

            const SizedBox(height: 48),

            // Name input
            SizedBox(
              width: 280,
              child: TextField(
                controller: _nameController,
                textAlign: TextAlign.center,
                autofocus: true,
                style: const TextStyle(
                  color: Color(0xFFD4AF37),
                  fontSize: 20,
                  letterSpacing: 1.5,
                  fontWeight: FontWeight.w500,
                ),
                decoration: InputDecoration(
                  hintText: 'My Sanctum',
                  hintStyle: TextStyle(
                    color: const Color(0xFFD4AF37).withAlpha(40),
                    fontSize: 20,
                    letterSpacing: 1.5,
                  ),
                  enabledBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0xFFD4AF37),
                      width: 1,
                    ),
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0xFFD4AF37),
                      width: 2,
                    ),
                  ),
                ),
              ),
            ).animate().fadeIn(duration: 800.ms, delay: 400.ms),

            const SizedBox(height: 56),

            // Submit button
            AnimatedBuilder(
              animation: _pulseController,
              builder: (context, child) {
                final scale = 1.0 + _pulseController.value * 0.04;
                return Transform.scale(
                  scale: scale,
                  child: OutlinedButton(
                    onPressed: _isCreating ? null : _advanceToCalendar,
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(
                        color: Color(0xFFD4AF37),
                        width: 1.5,
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 48,
                        vertical: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0),
                      ),
                    ),
                    child: _isCreating
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Color(0xFFD4AF37),
                            ),
                          )
                        : const Text(
                            'ESTABLISH',
                            style: TextStyle(
                              color: Color(0xFFD4AF37),
                              letterSpacing: 3.0,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                  ),
                );
              },
            ).animate().fadeIn(duration: 800.ms, delay: 600.ms),
          ],
        ),
      ),
    );
  }

  // ── STAGE 2.5: The Calendar Choice ────────────────────────

  Widget _buildCalendarStage() {
    return CalendarChoiceScreen(
      onModeSelected: (mode) async {
        _selectedCalendarMode = mode;

        // Persist the choice
        final calendarService = ref.read(calendarModeServiceProvider);
        await calendarService.setMode(mode);

        // Advance to the light stage
        _advanceToLight();
      },
    );
  }

  // ── STAGE 3: The Light ────────────────────────────────────

  Widget _buildLightStage() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Building icon (materializing)
          if (_showBuildingBurst)
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFFD4AF37),
                    const Color(0xFFD4AF37).withAlpha(60),
                    Colors.transparent,
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFD4AF37).withAlpha(80),
                    blurRadius: 40,
                    spreadRadius: 15,
                  ),
                ],
              ),
              child: const Icon(
                Icons.home_work_rounded,
                size: 48,
                color: Color(0xFF1A1A2E),
              ),
            )
                .animate()
                .scaleXY(begin: 0.0, end: 1.0, duration: 800.ms, curve: Curves.elasticOut)
                .fadeIn(duration: 400.ms),

          const SizedBox(height: 48),

          // "Let there be light."
          if (_showLetThereBeLight)
            const Text(
              'Let there be light.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFFF5F0E8),
                fontSize: 26,
                fontWeight: FontWeight.w300,
                letterSpacing: 1.5,
                fontStyle: FontStyle.italic,
              ),
            )
                .animate()
                .fadeIn(duration: 1200.ms)
                .then(delay: 2000.ms)
                .fadeOut(duration: 800.ms),

          const SizedBox(height: 16),

          if (_showLetThereBeLight)
            Text(
              _nameController.text.isEmpty ? 'Your Sanctum' : _nameController.text,
              style: TextStyle(
                color: const Color(0xFFD4AF37).withAlpha(180),
                fontSize: 14,
                letterSpacing: 2.0,
                fontWeight: FontWeight.w600,
              ),
            ).animate().fadeIn(duration: 800.ms, delay: 500.ms),
        ],
      ),
    );
  }

  // ── Light Burst Effect ────────────────────────────────────

  Widget _buildLightBurst() {
    return Center(
      child: AnimatedBuilder(
        animation: _lightBurstController,
        builder: (context, child) {
          return CustomPaint(
            size: const Size(400, 400),
            painter: _LightBurstPainter(
              progress: _lightBurstController.value,
              color: const Color(0xFFD4AF37),
            ),
          );
        },
      ),
    );
  }

  // ── Navigation Logic ──────────────────────────────────────

  void _advanceToFoundation() {
    setState(() => _stage = _OnboardingStage.theFoundation);
  }

  void _advanceToCalendar() {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Give your world a name'),
          backgroundColor: const Color(0xFFD4AF37).withAlpha(200),
        ),
      );
      return;
    }
    setState(() {
      _isCreating = false;
      _stage = _OnboardingStage.theCalendar;
    });
  }

  Future<void> _advanceToLight() async {
    // Name was validated in _advanceToCalendar

    setState(() => _isCreating = true);

    try {
      // Create the first building
      final buildingRepo = ref.read(buildingRepositoryProvider);
      await buildingRepo.createBuilding(
        type: 'farmhouse_base',
        x: 10,
        y: 10,
      );

      // If Hebrew mode: spawn the Tabernacle at the world's heart
      if (_selectedCalendarMode == CalendarMode.hebrew) {
        await buildingRepo.createBuilding(
          type: 'mishkan_tabernacle',
          x: 15,
          y: 8,
        );
      }

      // Spawn the Genesis kits
      final genesisRepo = ref.read(genesisRepositoryProvider);
      await genesisRepo.spawnKit(GenesisKit.steward, 10, 10);
      await genesisRepo.spawnKit(GenesisKit.town, 20, 15);

      // Advance to light stage
      setState(() {
        _stage = _OnboardingStage.theLight;
        _isCreating = false;
      });

      // Sequence the light stage animations
      await Future.delayed(const Duration(milliseconds: 400));
      if (mounted) {
        setState(() => _showBuildingBurst = true);
        _lightBurstController.forward();
      }

      await Future.delayed(const Duration(milliseconds: 1000));
      if (mounted) setState(() => _showLetThereBeLight = true);

      // Transition to game after the full sequence
      await Future.delayed(const Duration(milliseconds: 4500));
      if (mounted) {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                const GameScreen(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
            transitionDuration: const Duration(milliseconds: 1200),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isCreating = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Something went wrong: $e'),
            backgroundColor: const Color(0xFF9B1B30),
          ),
        );
      }
    }
  }
}

// ════════════════════════════════════════════════════════════
// FLOATING PARTICLES
// ════════════════════════════════════════════════════════════

class _FloatingParticles extends StatelessWidget {
  final AnimationController controller;
  final double brightness;

  const _FloatingParticles({
    required this.controller,
    required this.brightness,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return CustomPaint(
          size: MediaQuery.of(context).size,
          painter: _ParticlePainter(
            progress: controller.value,
            brightness: brightness,
          ),
        );
      },
    );
  }
}

// ════════════════════════════════════════════════════════════
// PARTICLE PAINTER
// ════════════════════════════════════════════════════════════

class _ParticlePainter extends CustomPainter {
  final double progress;
  final double brightness;
  final Random _random = Random(42); // Deterministic seed

  _ParticlePainter({required this.progress, required this.brightness});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    for (int i = 0; i < 40; i++) {
      final baseX = _random.nextDouble() * size.width;
      final baseY = _random.nextDouble() * size.height;
      final speed = 0.3 + _random.nextDouble() * 0.7;
      final particleSize = 1.0 + _random.nextDouble() * 2.5;

      // Gentle floating motion
      final offsetX = sin((progress * 2 * pi) + i * 0.5) * 15;
      final offsetY = cos((progress * 2 * pi) + i * 0.3) * 20 -
          (progress * speed * size.height * 0.3);

      final x = (baseX + offsetX) % size.width;
      final y = (baseY + offsetY) % size.height;

      // Twinkle effect
      final twinkle = (sin(progress * 2 * pi * 3 + i) + 1) / 2;
      final alpha = (brightness * 255 * (0.3 + twinkle * 0.7)).toInt().clamp(0, 255);

      // Gold-ish color with varying warmth
      final isGold = i % 3 == 0;
      paint.color = isGold
          ? Color.fromARGB(alpha, 212, 175, 55) // Gold
          : Color.fromARGB(alpha, 245, 240, 232); // Warm white

      canvas.drawCircle(Offset(x, y), particleSize, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _ParticlePainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.brightness != brightness;
  }
}

// ════════════════════════════════════════════════════════════
// LIGHT BURST PAINTER
// ════════════════════════════════════════════════════════════

class _LightBurstPainter extends CustomPainter {
  final double progress;
  final Color color;

  _LightBurstPainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    // Expanding rings
    for (int i = 0; i < 4; i++) {
      final ringProgress = (progress - i * 0.15).clamp(0.0, 1.0);
      if (ringProgress <= 0) continue;

      final radius = ringProgress * size.width * 0.6;
      final alpha = ((1 - ringProgress) * 80).toInt().clamp(0, 255);

      final paint = Paint()
        ..color = color.withAlpha(alpha)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0 * (1 - ringProgress);

      canvas.drawCircle(center, radius, paint);
    }

    // Radial rays
    for (int i = 0; i < 12; i++) {
      final angle = (i / 12) * 2 * pi;
      final rayLength = progress * size.width * 0.4;
      final alpha = ((1 - progress) * 60).toInt().clamp(0, 255);

      final paint = Paint()
        ..color = color.withAlpha(alpha)
        ..strokeWidth = 1.0
        ..style = PaintingStyle.stroke;

      final start = Offset(
        center.dx + cos(angle) * 30,
        center.dy + sin(angle) * 30,
      );
      final end = Offset(
        center.dx + cos(angle) * rayLength,
        center.dy + sin(angle) * rayLength,
      );

      canvas.drawLine(start, end, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _LightBurstPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
