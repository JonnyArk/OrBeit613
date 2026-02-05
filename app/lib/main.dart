/// OrBeit Presentation Layer - Application Entry Point
///
/// Initializes Firebase, creates the Flame game instance, and
/// provides the Material app wrapper with UI overlays.
///
/// **Architecture:**
/// - Firebase initialized before app starts
/// - GameWidget wraps WorldGame for Flame rendering
/// - UI overlays (buttons, dialogs) built with Flutter widgets
///
/// **For Future Agents:**
/// - Add new UI overlays as siblings to GameWidget in Stack
/// - Use Riverpod providers for state management
/// - Theme uses Sovereign Sanctum colors

import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'firebase_options.dart';
import 'game/world_game.dart';
import 'game/building_component.dart';
import 'domain/repositories/building_repository.dart';
import 'data/repositories/building_repository_impl.dart';
import 'data/database.dart';
import 'services/ai_interface.dart';
import 'services/ai_service_impl.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize database and repository
  final database = AppDatabase();
  final buildingRepository = BuildingRepositoryImpl(database);
  
  // Initialize AI service
  final aiService = AIServiceImpl();

  runApp(
    ProviderScope(
      overrides: [
        buildingRepositoryProvider.overrideWithValue(buildingRepository),
        aiServiceProvider.overrideWithValue(aiService),
      ],
      child: const OrBeitApp(),
    ),
  );
}

/// Provider for the building repository
///
/// Override this in main() with the concrete implementation.
/// Tests can override with mocks.
final buildingRepositoryProvider = Provider<BuildingRepository>((ref) {
  throw UnimplementedError('Must override in main()');
});

/// Provider for AI service
///
/// Used for generating visual assets and distilling context.
/// Connects to Firebase Cloud Functions backend.
final aiServiceProvider = Provider<AIService>((ref) {
  throw UnimplementedError('Must override in main()');
});

/// Root application widget
class OrBeitApp extends StatelessWidget {
  const OrBeitApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OrBeit',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFD4AF37), // Sovereign Gold
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: const Color(0xFF1A1A2E), // Dark Slate
        useMaterial3: true,
      ),
      home: const GameScreen(),
    );
  }
}

/// Main game screen with UI overlays
class GameScreen extends ConsumerStatefulWidget {
  const GameScreen({super.key});

  @override
  ConsumerState<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends ConsumerState<GameScreen> {
  WorldGame? _game;

  @override
  Widget build(BuildContext context) {
    final repository = ref.watch(buildingRepositoryProvider);

    return Scaffold(
      body: Stack(
        children: [
          // Game canvas (Flame)
          GameWidget<WorldGame>(
            game: _game ??= WorldGame(buildingRepository: repository),
          ),
          
          // UI Overlays
          Positioned(
            bottom: 32,
            right: 32,
            child: FloatingActionButton.extended(
              onPressed: () => _placeHouse(context, repository),
              backgroundColor: const Color(0xFFD4AF37), // Sovereign Gold
              icon: const Icon(Icons.home, color: Color(0xFF1A1A2E)),
              label: const Text(
                'Place House',
                style: TextStyle(
                  color: Color(0xFF1A1A2E),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Handles building placement
  ///
  /// **Clean Architecture Flow:**
  /// 1. Use case logic (simple for now)
  /// 2. Call repository to persist
  /// 3. Notify game to render immediately
  Future<void> _placeHouse(BuildContext context, BuildingRepository repository) async {
    try {
      // For now, place at a random-ish location
      // TODO: Allow user to tap grid for placement
      final x = 5.0 + (DateTime.now().millisecond % 5).toDouble();
      final y = 5.0 + (DateTime.now().millisecond % 3).toDouble();
      
      final building = await repository.createBuilding(
        type: 'farmhouse_white',
        x: x,
        y: y,
        rotation: 0,
      );

      // Add to game immediately without restart
      if (_game != null) {
        _game!.addBuilding(BuildingComponent(building: building));
      }

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('House placed at (${building.x.toStringAsFixed(1)}, ${building.y.toStringAsFixed(1)})'),
            backgroundColor: const Color(0xFF134E5E), // Deep Teal
            duration: const Duration(seconds: 2),
          ),
        );
      }

      print('Building created: $building');
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to place house: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
