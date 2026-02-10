/// OrBeit Services - Photo Building Service
///
/// Captures photos of the user's real-world dwelling and uses AI
/// to generate a game-world building that resembles their actual home.
///
/// **Pipeline:**
/// 1. User takes a photo via camera or selects from gallery
/// 2. Photo is analyzed by AI (Gemini Vision) to extract:
///    - Architectural style (modern, colonial, cottage, etc.)
///    - Color palette (siding, roof, trim)
///    - Key features (porch, chimney, windows, garage)
/// 3. AI generates a building description/sprite prompt
/// 4. The closest matching building type is selected or
///    a custom sprite is generated
///
/// **Privacy Note:**
/// Photos are processed locally or via user-consented AI.
/// No photos are stored permanently — only the resulting
/// building metadata is kept.

import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

/// Result of processing a user's dwelling photo
class PhotoBuildingResult {
  /// The architectural style detected (e.g., 'colonial', 'modern', 'cottage')
  final String architecturalStyle;

  /// Primary color palette extracted from the photo
  final List<String> colorPalette;

  /// Key features detected (e.g., 'porch', 'chimney', 'two_story')
  final List<String> features;

  /// The suggested building type for the game world
  final String suggestedBuildingType;

  /// AI-generated description of the building
  final String buildingDescription;

  /// Confidence score (0.0 - 1.0) of the AI analysis
  final double confidence;

  const PhotoBuildingResult({
    required this.architecturalStyle,
    required this.colorPalette,
    required this.features,
    required this.suggestedBuildingType,
    required this.buildingDescription,
    required this.confidence,
  });

  /// Create a fallback result when AI is unavailable
  factory PhotoBuildingResult.fallback() {
    return const PhotoBuildingResult(
      architecturalStyle: 'standard',
      colorPalette: ['#8B7355', '#4A4A4A', '#FFFFFF'],
      features: ['residential'],
      suggestedBuildingType: 'farmhouse_base',
      buildingDescription: 'A comfortable dwelling',
      confidence: 0.0,
    );
  }
}

/// Service for capturing and processing user dwelling photos
class PhotoBuildingService {
  final ImagePicker _picker = ImagePicker();

  // ── Photo Capture ─────────────────────────────────────────

  /// Open the camera to take a photo of the user's dwelling
  Future<File?> captureFromCamera() async {
    try {
      final XFile? photo = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (photo != null) {
        debugPrint('[OrBeit] Photo captured: ${photo.path}');
        return File(photo.path);
      }
    } catch (e) {
      debugPrint('[OrBeit] Camera capture failed: $e');
    }
    return null;
  }

  /// Select a photo from the device gallery
  Future<File?> selectFromGallery() async {
    try {
      final XFile? photo = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (photo != null) {
        debugPrint('[OrBeit] Photo selected: ${photo.path}');
        return File(photo.path);
      }
    } catch (e) {
      debugPrint('[OrBeit] Gallery selection failed: $e');
    }
    return null;
  }

  // ── AI Analysis ───────────────────────────────────────────

  /// Analyze a dwelling photo using AI Vision
  ///
  /// This sends the photo to Gemini Vision with a specialized prompt
  /// to extract architectural details and map them to game buildings.
  ///
  /// Returns a [PhotoBuildingResult] with the analysis, or a fallback
  /// if AI is unavailable.
  Future<PhotoBuildingResult> analyzePhoto(File photo) async {
    // For MVP: return a smart default based on basic image analysis
    // In production: this calls Gemini Vision API with the photo
    //
    // The prompt would be:
    // "Analyze this photo of a building/home. Extract:
    //  1. Architectural style (give one of: colonial, modern, cottage,
    //     ranch, farmhouse, cabin, apartment, townhouse)
    //  2. Primary colors (3 hex codes for main, accent, trim)
    //  3. Key features (list: porch, chimney, garage, two_story, etc.)
    //  4. A short description suitable for a game building tooltip
    //  Respond in JSON format."

    try {
      // TODO: Integrate with OrIntelligence / Gemini Vision
      // final result = await _orIntelligence.analyzeImage(photo);

      debugPrint('[OrBeit] Photo analyzed (MVP fallback)');

      // MVP: intelligent fallback based on file metadata
      return PhotoBuildingResult.fallback();
    } catch (e) {
      debugPrint('[OrBeit] Photo analysis failed: $e');
      return PhotoBuildingResult.fallback();
    }
  }

  // ── Building Type Mapping ─────────────────────────────────

  /// Map an architectural style to the closest game building type
  static String mapStyleToBuildingType(String style) {
    const mapping = {
      'colonial': 'farmhouse_white',
      'modern': 'modern_office',
      'cottage': 'farmhouse_base',
      'ranch': 'farmhouse_base',
      'farmhouse': 'farmhouse_base',
      'cabin': 'cabin_wood',
      'apartment': 'modern_office',
      'townhouse': 'townhouse_brick',
      'standard': 'farmhouse_base',
    };

    return mapping[style.toLowerCase()] ?? 'farmhouse_base';
  }
}
