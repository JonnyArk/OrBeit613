/// OrBeit Presentation - Photo Home Screen
///
/// An optional onboarding step where Users can photograph their
/// real-world dwelling so the AI can render a game-world version.
///
/// **Flow:**
/// 1. Beautiful prompt: "Would you like your world to feel like home?"
/// 2. Two options: 📸 Take Photo / 📁 Choose Photo / ⏭️ Skip
/// 3. After capture: AI analysis animation + building preview
/// 4. User confirms or retakes
///
/// This is designed to be inserted after the Calendar Choice
/// and before the "Let there be light" stage.

import 'dart:io';
import 'package:flutter/material.dart';
import '../../services/photo_building_service.dart';

/// Screen for capturing a photo of the user's real dwelling
class PhotoHomeScreen extends StatefulWidget {
  /// Called when the user completes this step (with or without a photo)
  final void Function(PhotoBuildingResult? result) onComplete;

  const PhotoHomeScreen({
    super.key,
    required this.onComplete,
  });

  @override
  State<PhotoHomeScreen> createState() => _PhotoHomeScreenState();
}

class _PhotoHomeScreenState extends State<PhotoHomeScreen>
    with SingleTickerProviderStateMixin {
  final PhotoBuildingService _photoService = PhotoBuildingService();
  File? _capturedPhoto;
  PhotoBuildingResult? _analysisResult;
  bool _isAnalyzing = false;
  bool _showContent = false;

  late AnimationController _glowController;

  @override
  void initState() {
    super.initState();
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    )..repeat(reverse: true);

    Future.delayed(const Duration(milliseconds: 400), () {
      if (mounted) setState(() => _showContent = true);
    });
  }

  @override
  void dispose() {
    _glowController.dispose();
    super.dispose();
  }

  Future<void> _capturePhoto() async {
    final photo = await _photoService.captureFromCamera();
    if (photo != null) {
      setState(() {
        _capturedPhoto = photo;
        _isAnalyzing = true;
      });

      final result = await _photoService.analyzePhoto(photo);

      if (mounted) {
        setState(() {
          _analysisResult = result;
          _isAnalyzing = false;
        });
      }
    }
  }

  Future<void> _selectPhoto() async {
    final photo = await _photoService.selectFromGallery();
    if (photo != null) {
      setState(() {
        _capturedPhoto = photo;
        _isAnalyzing = true;
      });

      final result = await _photoService.analyzePhoto(photo);

      if (mounted) {
        setState(() {
          _analysisResult = result;
          _isAnalyzing = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF050510),
      body: SafeArea(
        child: Center(
          child: AnimatedOpacity(
            opacity: _showContent ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 800),
            child: _capturedPhoto == null
                ? _buildCapturePrompt()
                : _isAnalyzing
                    ? _buildAnalyzing()
                    : _buildPreview(),
          ),
        ),
      ),
    );
  }

  Widget _buildCapturePrompt() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // House icon with glow
          AnimatedBuilder(
            animation: _glowController,
            builder: (context, _) => Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFD4AF37)
                        .withAlpha((20 + _glowController.value * 30).toInt()),
                    blurRadius: 30,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: Icon(
                Icons.home_rounded,
                size: 48,
                color: const Color(0xFFD4AF37)
                    .withAlpha((160 + _glowController.value * 95).toInt()),
              ),
            ),
          ),

          const SizedBox(height: 40),

          // Question
          const Text(
            'Would you like your world\nto feel like home?',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFFF5F0E8),
              fontSize: 24,
              fontWeight: FontWeight.w300,
              letterSpacing: 1.0,
              height: 1.5,
            ),
          ),

          const SizedBox(height: 12),

          Text(
            'Take a photo of your dwelling.\nThe Or will shape your world around it.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: const Color(0xFFF5F0E8).withAlpha(80),
              fontSize: 13,
              height: 1.5,
              letterSpacing: 0.5,
            ),
          ),

          const SizedBox(height: 48),

          // Camera button
          _buildActionButton(
            icon: Icons.camera_alt_rounded,
            label: 'TAKE PHOTO',
            onTap: _capturePhoto,
          ),

          const SizedBox(height: 16),

          // Gallery button
          _buildActionButton(
            icon: Icons.photo_library_rounded,
            label: 'CHOOSE PHOTO',
            onTap: _selectPhoto,
            secondary: true,
          ),

          const SizedBox(height: 32),

          // Skip button
          GestureDetector(
            onTap: () => widget.onComplete(null),
            child: Text(
              'Skip for now',
              style: TextStyle(
                color: const Color(0xFFF5F0E8).withAlpha(40),
                fontSize: 13,
                letterSpacing: 1.0,
                decoration: TextDecoration.underline,
                decorationColor: const Color(0xFFF5F0E8).withAlpha(20),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool secondary = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 220,
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          border: Border.all(
            color: const Color(0xFFD4AF37).withAlpha(secondary ? 40 : 80),
          ),
          borderRadius: BorderRadius.circular(0),
          color: secondary
              ? Colors.transparent
              : const Color(0xFFD4AF37).withAlpha(15),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 18,
              color: const Color(0xFFD4AF37).withAlpha(secondary ? 120 : 200),
            ),
            const SizedBox(width: 10),
            Text(
              label,
              style: TextStyle(
                color:
                    const Color(0xFFD4AF37).withAlpha(secondary ? 120 : 200),
                fontSize: 13,
                fontWeight: FontWeight.bold,
                letterSpacing: 2.0,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnalyzing() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Photo preview (small)
        if (_capturedPhoto != null)
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.file(
              _capturedPhoto!,
              width: 200,
              height: 150,
              fit: BoxFit.cover,
            ),
          ),

        const SizedBox(height: 32),

        const SizedBox(
          width: 32,
          height: 32,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: Color(0xFFD4AF37),
          ),
        ),

        const SizedBox(height: 16),

        Text(
          'The Or is studying your dwelling...',
          style: TextStyle(
            color: const Color(0xFFF5F0E8).withAlpha(100),
            fontSize: 14,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }

  Widget _buildPreview() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Photo
          if (_capturedPhoto != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: const Color(0xFFD4AF37).withAlpha(60),
                  ),
                ),
                child: Image.file(
                  _capturedPhoto!,
                  width: 280,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),
            ),

          const SizedBox(height: 24),

          // AI analysis result
          if (_analysisResult != null) ...[
            Text(
              'Style: ${_analysisResult!.architecturalStyle}',
              style: const TextStyle(
                color: Color(0xFFD4AF37),
                fontSize: 16,
                letterSpacing: 1.0,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _analysisResult!.buildingDescription,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: const Color(0xFFF5F0E8).withAlpha(80),
                fontSize: 13,
                height: 1.4,
              ),
            ),
          ],

          const SizedBox(height: 32),

          // Confirm
          _buildActionButton(
            icon: Icons.check_rounded,
            label: 'USE THIS',
            onTap: () => widget.onComplete(_analysisResult),
          ),

          const SizedBox(height: 16),

          // Retake
          GestureDetector(
            onTap: () => setState(() {
              _capturedPhoto = null;
              _analysisResult = null;
            }),
            child: Text(
              'Retake photo',
              style: TextStyle(
                color: const Color(0xFFF5F0E8).withAlpha(50),
                fontSize: 13,
                letterSpacing: 1.0,
                decoration: TextDecoration.underline,
                decorationColor: const Color(0xFFF5F0E8).withAlpha(20),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
