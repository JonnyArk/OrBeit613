/// OrBeit Presentation - Calendar Choice Screen
///
/// A cinematic onboarding step where the user chooses their
/// cultural calendar mode: Western or Hebrew.
///
/// **Design:**
/// Two glowing orbs/cards side by side, each representing a path.
/// - Left: Western (sun icon, Gregorian script)
/// - Right: Hebrew (menorah/candle icon, Hebrew script)
///
/// The selection animates with a golden pulse that fills the chosen
/// path, then fades to the next onboarding stage.

import 'dart:math';
import 'package:flutter/material.dart';
import '../../domain/entities/calendar_mode.dart';

/// Onboarding screen for choosing Western vs Hebrew calendar mode
class CalendarChoiceScreen extends StatefulWidget {
  /// Called when the user makes their selection
  final void Function(CalendarMode mode) onModeSelected;

  const CalendarChoiceScreen({
    super.key,
    required this.onModeSelected,
  });

  @override
  State<CalendarChoiceScreen> createState() => _CalendarChoiceScreenState();
}

class _CalendarChoiceScreenState extends State<CalendarChoiceScreen>
    with TickerProviderStateMixin {
  CalendarMode? _hoveredMode;
  CalendarMode? _selectedMode;
  bool _showContent = false;
  bool _showCards = false;

  late AnimationController _glowController;
  late AnimationController _particleController;

  @override
  void initState() {
    super.initState();

    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);

    _particleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 6000),
    )..repeat();

    // Staggered entrance
    Future.delayed(const Duration(milliseconds: 400), () {
      if (mounted) setState(() => _showContent = true);
    });
    Future.delayed(const Duration(milliseconds: 900), () {
      if (mounted) setState(() => _showCards = true);
    });
  }

  @override
  void dispose() {
    _glowController.dispose();
    _particleController.dispose();
    super.dispose();
  }

  void _selectMode(CalendarMode mode) {
    if (_selectedMode != null) return; // Already selected
    setState(() => _selectedMode = mode);

    // Animate out, then callback
    Future.delayed(const Duration(milliseconds: 1200), () {
      widget.onModeSelected(mode);
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isLandscape = size.width > size.height;

    return Scaffold(
      backgroundColor: Colors.black,
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 800),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: _selectedMode == CalendarMode.hebrew
                ? [const Color(0xFF0D0D1A), const Color(0xFF141428)]
                : _selectedMode == CalendarMode.western
                    ? [const Color(0xFF050510), const Color(0xFF0A0A1A)]
                    : [Colors.black, const Color(0xFF050510)],
          ),
        ),
        child: Stack(
          children: [
            // Background particles
            AnimatedBuilder(
              animation: _particleController,
              builder: (context, _) => CustomPaint(
                size: size,
                painter: _ChoiceParticlePainter(
                  progress: _particleController.value,
                  selectedMode: _selectedMode,
                ),
              ),
            ),

            // Main content
            SafeArea(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Title
                    AnimatedOpacity(
                      opacity: _showContent ? 1.0 : 0.0,
                      duration: const Duration(milliseconds: 800),
                      child: AnimatedSlide(
                        offset: _showContent
                            ? Offset.zero
                            : const Offset(0, -0.2),
                        duration: const Duration(milliseconds: 800),
                        curve: Curves.easeOutCubic,
                        child: Column(
                          children: [
                            const Text(
                              'Choose Your Path',
                              style: TextStyle(
                                color: Color(0xFFF5F0E8),
                                fontSize: 28,
                                fontWeight: FontWeight.w300,
                                letterSpacing: 2.0,
                                height: 1.4,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'This shapes how your world breathes.',
                              style: TextStyle(
                                color: const Color(0xFFF5F0E8)
                                    .withAlpha(100),
                                fontSize: 14,
                                fontWeight: FontWeight.w300,
                                letterSpacing: 1.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: isLandscape ? 40 : 60),

                    // Calendar mode cards
                    AnimatedOpacity(
                      opacity: _showCards ? 1.0 : 0.0,
                      duration: const Duration(milliseconds: 800),
                      child: AnimatedSlide(
                        offset: _showCards
                            ? Offset.zero
                            : const Offset(0, 0.15),
                        duration: const Duration(milliseconds: 800),
                        curve: Curves.easeOutCubic,
                        child: isLandscape
                            ? Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.center,
                                children: [
                                  _buildModeCard(
                                      CalendarMode.western, size),
                                  const SizedBox(width: 32),
                                  _buildModeCard(
                                      CalendarMode.hebrew, size),
                                ],
                              )
                            : Column(
                                children: [
                                  _buildModeCard(
                                      CalendarMode.western, size),
                                  const SizedBox(height: 24),
                                  _buildModeCard(
                                      CalendarMode.hebrew, size),
                                ],
                              ),
                      ),
                    ),

                    SizedBox(height: isLandscape ? 20 : 40),

                    // Subtle note
                    AnimatedOpacity(
                      opacity: _showCards ? 1.0 : 0.0,
                      duration: const Duration(milliseconds: 600),
                      child: Text(
                        'You can change this later in settings.',
                        style: TextStyle(
                          color:
                              const Color(0xFFF5F0E8).withAlpha(50),
                          fontSize: 12,
                          letterSpacing: 1.0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Selection overlay (fade to chosen path)
            if (_selectedMode != null)
              AnimatedOpacity(
                opacity: 1.0,
                duration: const Duration(milliseconds: 1000),
                child: Container(
                  color: Colors.black.withAlpha(0),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildModeCard(CalendarMode mode, Size screenSize) {
    final isSelected = _selectedMode == mode;
    final isOther =
        _selectedMode != null && _selectedMode != mode;
    final isHovered = _hoveredMode == mode;
    final isLandscape = screenSize.width > screenSize.height;

    final cardWidth = isLandscape
        ? screenSize.width * 0.3
        : screenSize.width * 0.7;
    final cardHeight = isLandscape ? 280.0 : 180.0;

    return AnimatedOpacity(
      opacity: isOther ? 0.2 : 1.0,
      duration: const Duration(milliseconds: 600),
      child: AnimatedScale(
        scale: isSelected
            ? 1.05
            : isOther
                ? 0.9
                : 1.0,
        duration: const Duration(milliseconds: 400),
        child: MouseRegion(
          onEnter: (_) => setState(() => _hoveredMode = mode),
          onExit: (_) => setState(() => _hoveredMode = null),
          child: GestureDetector(
            onTap: () => _selectMode(mode),
            child: AnimatedBuilder(
              animation: _glowController,
              builder: (context, child) {
                final glowIntensity =
                    isHovered || isSelected ? 1.0 : 0.4;
                final glowValue = _glowController.value;

                final borderColor = mode == CalendarMode.hebrew
                    ? const Color(0xFFE5C06B) // Warm candle gold
                    : const Color(0xFFD4AF37); // Standard gold

                return Container(
                  width: cardWidth,
                  height: cardHeight,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: borderColor.withAlpha(
                        (60 + glowValue * 40 * glowIntensity)
                            .toInt(),
                      ),
                      width: isSelected ? 2.0 : 1.0,
                    ),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: mode == CalendarMode.hebrew
                          ? [
                              const Color(0xFF0D0D1A)
                                  .withAlpha(200),
                              const Color(0xFF1A1530)
                                  .withAlpha(180),
                            ]
                          : [
                              const Color(0xFF0A0A14)
                                  .withAlpha(200),
                              const Color(0xFF141420)
                                  .withAlpha(180),
                            ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: borderColor.withAlpha(
                          (15 + glowValue * 25 * glowIntensity)
                              .toInt(),
                        ),
                        blurRadius: 20 + glowValue * 10,
                        spreadRadius: glowValue * 3,
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Icon
                      _buildModeIcon(mode, borderColor,
                          glowIntensity, glowValue),
                      const SizedBox(height: 20),

                      // Title
                      Text(
                        mode == CalendarMode.hebrew
                            ? 'HEBREW'
                            : 'WESTERN',
                        style: TextStyle(
                          color: borderColor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 4.0,
                        ),
                      ),

                      const SizedBox(height: 8),

                      // Subtitle
                      Text(
                        mode == CalendarMode.hebrew
                            ? 'שַׁבָּת שָׁלוֹם'
                            : 'Gregorian Calendar',
                        style: TextStyle(
                          color: borderColor.withAlpha(120),
                          fontSize: 13,
                          fontWeight: FontWeight.w300,
                          letterSpacing: 1.0,
                        ),
                      ),

                      const SizedBox(height: 14),

                      // Description
                      Text(
                        mode == CalendarMode.hebrew
                            ? 'Shabbat rest · Tabernacle · Hebrew tint'
                            : 'Standard schedule · Modern structures',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: const Color(0xFFF5F0E8)
                              .withAlpha(60),
                          fontSize: 11,
                          height: 1.4,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildModeIcon(
    CalendarMode mode,
    Color color,
    double glowIntensity,
    double glowValue,
  ) {
    if (mode == CalendarMode.hebrew) {
      // Menorah / candles icon
      return Stack(
        alignment: Alignment.center,
        children: [
          // Glow behind
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: color.withAlpha(
                    (20 + glowValue * 30 * glowIntensity).toInt(),
                  ),
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
              ],
            ),
          ),
          Icon(
            Icons.local_fire_department_rounded,
            size: 40,
            color: color.withAlpha(
              (160 + glowValue * 95 * glowIntensity).toInt(),
            ),
          ),
        ],
      );
    }

    // Western — sun/globe icon
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: color.withAlpha(
                  (15 + glowValue * 25 * glowIntensity).toInt(),
                ),
                blurRadius: 15,
                spreadRadius: 3,
              ),
            ],
          ),
        ),
        Icon(
          Icons.wb_sunny_rounded,
          size: 36,
          color: color.withAlpha(
            (160 + glowValue * 95 * glowIntensity).toInt(),
          ),
        ),
      ],
    );
  }
}

// ════════════════════════════════════════════════════════════
// CHOICE PARTICLES — ambient particles that shift with selection
// ════════════════════════════════════════════════════════════

class _ChoiceParticlePainter extends CustomPainter {
  final double progress;
  final CalendarMode? selectedMode;
  final Random _random = Random(314);

  _ChoiceParticlePainter({
    required this.progress,
    this.selectedMode,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    for (int i = 0; i < 30; i++) {
      final baseX = _random.nextDouble() * size.width;
      final baseY = _random.nextDouble() * size.height;
      final particleSize = 0.8 + _random.nextDouble() * 2.0;

      // Floating motion
      final offsetX =
          sin((progress * 2 * pi) + i * 0.4) * 12;
      final offsetY =
          cos((progress * 2 * pi) + i * 0.3) * 18;

      final x = (baseX + offsetX) % size.width;
      final y = (baseY + offsetY) % size.height;

      // Twinkle
      final twinkle =
          (sin(progress * 2 * pi * 2 + i) + 1) / 2;
      final alpha = (0.1 * 255 * (0.3 + twinkle * 0.7))
          .toInt()
          .clamp(0, 255);

      // Color based on selection
      final isGold = i % 4 == 0;
      if (selectedMode == CalendarMode.hebrew) {
        paint.color = isGold
            ? Color.fromARGB(alpha, 229, 192, 107) // Candle gold
            : Color.fromARGB(alpha, 200, 180, 150); // Warm
      } else {
        paint.color = isGold
            ? Color.fromARGB(alpha, 212, 175, 55) // Gold
            : Color.fromARGB(alpha, 245, 240, 232); // White
      }

      canvas.drawCircle(Offset(x, y), particleSize, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _ChoiceParticlePainter old) {
    return old.progress != progress ||
        old.selectedMode != selectedMode;
  }
}
