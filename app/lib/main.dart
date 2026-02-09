import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flame/game.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'firebase_options.dart';
import 'game/world_game.dart';
import 'game/building_component.dart';
import 'game/building_selector.dart';
import 'providers/building_provider.dart';
import 'providers/ai_service_provider.dart';
import 'providers/life_event_provider.dart';
import 'providers/task_provider.dart';
import 'providers/service_providers.dart';
import 'data/repositories/building_repository_impl.dart';
import 'data/database.dart' hide Building; // Fix ambiguous import
import 'services/ai_service_impl.dart';
import 'services/secure_storage_service.dart';
import 'services/cache_service.dart';
import 'services/voice_service.dart';
import 'services/device_capability_service.dart';
import 'services/or_intelligence.dart';
import 'data/repositories/task_repository_impl.dart';
import 'ui/task_list_panel.dart';
import 'ui/life_event_timeline.dart';
import 'ui/ai_architect_dialog.dart';
import 'data/repositories/life_event_repository_impl.dart';
import 'presentation/screens/onboarding_screen.dart';
import 'providers/genesis_provider.dart';
import 'data/repositories/genesis_repository_impl.dart';
import 'providers/database_provider.dart';
import 'domain/entities/building.dart'; // For Logic check
import 'ui/or_beacon.dart';
import 'services/auth_service_impl.dart';
import 'providers/auth_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // ── Database & Repositories ─────────────────────────────
  final database = AppDatabase();
  final buildingRepository = BuildingRepositoryImpl(database);
  final taskRepository = TaskRepositoryImpl(database);
  final lifeEventRepository = LifeEventRepositoryImpl(database);
  final genesisRepository = GenesisRepositoryImpl(database);
  
  // ── AI Service ──────────────────────────────────────────
  final aiService = AIServiceImpl();

  // ── Auth Service ────────────────────────────────────────
  final authService = AuthServiceImpl();
  // Silent anonymous sign-in (MVP — no UI needed)
  try {
    await authService.signInAnonymously();
    debugPrint('[OrBeit] Auth: signed in as ${authService.currentUser?.uid}');
  } catch (e) {
    debugPrint('[OrBeit] Auth: anonymous sign-in failed (offline?): $e');
    // Non-blocking — local features still work without auth
  }

  // ── Core Services (new) ─────────────────────────────────
  final secureStorage = SecureStorageService();
  final cacheService = CacheService();
  final voiceService = VoiceService();
  final deviceCapability = DeviceCapabilityService();

  // Initialize Hive cache (must happen before runApp)
  await cacheService.initialize();

  // ── The Or's Brain ──────────────────────────────────────
  final orIntelligence = OrIntelligence(
    secureStorage: secureStorage,
    cacheService: cacheService,
  );
  // Attempt to initialize Gemini (non-blocking — works offline)
  await orIntelligence.initialize();

  runApp(
    ProviderScope(
      overrides: [
        // Database & Repositories
        databaseProvider.overrideWithValue(database),
        buildingRepositoryProvider.overrideWithValue(buildingRepository),
        genesisRepositoryProvider.overrideWithValue(genesisRepository),
        aiServiceProvider.overrideWithValue(aiService),
        taskRepositoryProvider.overrideWithValue(taskRepository),
        lifeEventRepositoryProvider.overrideWithValue(lifeEventRepository),
        // Core Services
        secureStorageProvider.overrideWithValue(secureStorage),
        cacheServiceProvider.overrideWithValue(cacheService),
        voiceServiceProvider.overrideWithValue(voiceService),
        deviceCapabilityProvider.overrideWithValue(deviceCapability),
        orIntelligenceProvider.overrideWithValue(orIntelligence),
        // Auth
        authServiceProvider.overrideWithValue(authService),
      ],
      child: const OrBeitApp(),
    ),
  );
}

// All providers are now defined in providers/ directory
// buildingRepositoryProvider → providers/building_provider.dart
// taskRepositoryProvider     → providers/task_provider.dart
// aiServiceProvider          → providers/ai_service_provider.dart
// lifeEventRepositoryProvider → providers/life_event_provider.dart
// genesisRepositoryProvider  → providers/genesis_provider.dart
// databaseProvider           → providers/database_provider.dart

/// Root application widget
class OrBeitApp extends StatelessWidget {
  const OrBeitApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OrBeit - Sovereign OS',
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: const Color(0xFFD4AF37),
        scaffoldBackgroundColor: const Color(0xFF1A1A2E),
      ),
      // TODO: Wrap with a proper splash/loading screen that checks DB state
      // For now, we assume if you launch the app, you hit the Gate first unless persisted.
      // We will implement a proper wrapper that checks `buildingRepository.count()` next.
      home: const LandingWrapper(), 
      debugShowCheckedModeBanner: false,
    );
  }
}

class LandingWrapper extends ConsumerWidget {
  const LandingWrapper({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Determine if we should show Covenant or Game
    // We check if any buildings exist. If key buildings exist, we assume Vow is made.
    final buildingRepo = ref.watch(buildingRepositoryProvider);
    
    return FutureBuilder<List<Building>>(
      future: buildingRepo.getAllBuildings(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
             body: Center(child: CircularProgressIndicator(color: Color(0xFFD4AF37))),
          );
        }

        final hasBuildings = snapshot.data != null && snapshot.data!.isNotEmpty;
        
        if (hasBuildings) {
          return const GameScreen();
        } else {
          return const OnboardingScreen();
        }
      },
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
  bool _showBuildingSelector = false;
  bool _showTaskPanel = false;
  bool _showTimeline = false;

  /// Handle voice commands from the Or
  void _handleVoiceCommand(String command) async {
    final or = ref.read(orIntelligenceProvider);
    final voice = ref.read(voiceServiceProvider);
    
    // Parse intent with the Or's intelligence
    final intent = or.parseIntent(command);
    
    // Route based on recognized intent
    switch (intent.intent) {
      case OrIntent.buildingCreate:
        setState(() {
          _showBuildingSelector = true;
          _showTaskPanel = false;
          _showTimeline = false;
        });
        break;
      case OrIntent.taskManage:
        setState(() {
          _showTaskPanel = true;
          _showBuildingSelector = false;
          _showTimeline = false;
        });
        break;
      case OrIntent.command:
        setState(() {
          _showBuildingSelector = false;
          _showTaskPanel = false;
          _showTimeline = false;
        });
        break;
      default:
        break;
    }

    // Generate and speak the Or's response
    final response = await or.generateResponse(command);
    await voice.speak(response);
  }

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
          
          // Building selector panel
          if (_showBuildingSelector)
            Positioned(
              left: 16,
              top: 100,
              child: BuildingSelectorPanel(
                onSelect: (type) => _placeBuilding(type),
                onClose: () => setState(() => _showBuildingSelector = false),
              ),
            ),
          
          // Task panel (right side)
          if (_showTaskPanel)
            const Positioned(
              right: 0,
              top: 0,
              bottom: 0,
              child: TaskListPanel(),
            ),
          
          // Life Event Timeline (right side)
          if (_showTimeline)
            const Positioned(
              right: 0,
              top: 0,
              bottom: 0,
              child: LifeEventTimeline(),
            ),
          
          // The Or — voice-first AI beacon (bottom-right)
          Positioned(
            right: 24,
            bottom: 80,
            child: OrBeacon(
              size: 56,
              onVoiceCommand: _handleVoiceCommand,
            ),
          ),

          // Bottom toolbar
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: _buildToolbar(),
          ),
        ],
      ),
    );
  }

  Widget _buildToolbar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.transparent,
            const Color(0xFF1A1A2E).withAlpha(230),
          ],
        ),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _ToolbarButton(
              icon: Icons.home_work,
              label: 'Build',
              isActive: _showBuildingSelector,
              onTap: () => setState(() {
                _showBuildingSelector = !_showBuildingSelector;
                _showTaskPanel = false;
                _showTimeline = false;
              }),
            ),
            const SizedBox(width: 24),
            _ToolbarButton(
              icon: Icons.task_alt,
              label: 'Tasks',
              isActive: _showTaskPanel,
              onTap: () => setState(() {
                _showTaskPanel = !_showTaskPanel;
                _showBuildingSelector = false;
                _showTimeline = false;
              }),
            ),
            const SizedBox(width: 24),
            _ToolbarButton(
              icon: Icons.timeline,
              label: 'Timeline',
              isActive: _showTimeline,
              onTap: () => setState(() {
                _showTimeline = !_showTimeline;
                _showTaskPanel = false;
                _showBuildingSelector = false;
              }),
            ),
            const SizedBox(width: 24),
            _ToolbarButton(
              icon: Icons.auto_awesome,
              label: 'AI',
              onTap: _showAIDialog,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _placeBuilding(BuildingType type) async {
    final repository = ref.read(buildingRepositoryProvider);
    
    // Place at center of visible grid (simplified)
    final building = await repository.createBuilding(
      type: type.id,
      x: 200.0 + (_game?.children.length ?? 0) * 50,
      y: 200.0 + (_game?.children.length ?? 0) * 30,
    );

    // Add component to game
    _game?.add(BuildingComponent(building: building));
    
    setState(() => _showBuildingSelector = false);
  }

  void _showAIDialog() {
    showDialog(
      context: context,
      builder: (ctx) => const AIArchitectDialog(),
    );
  }
}

class _ToolbarButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isActive;

  const _ToolbarButton({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isActive 
            ? const Color(0xFFD4AF37).withAlpha(50)
            : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isActive ? const Color(0xFFD4AF37) : Colors.white24,
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: isActive ? const Color(0xFFD4AF37) : Colors.white70),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: isActive ? const Color(0xFFD4AF37) : Colors.white70,
                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
