# OrBeit Project Architecture

## 📐 Clean Architecture Layers

This project strictly follows Clean Architecture principles to ensure modularity and maintainability. Future specialized agents can work on specific layers without breaking the build.

### Domain Layer (`lib/domain/`)
**Pure business logic - NO dependencies on Flutter, Drift, or Firebase**

- **`entities/`**: Core domain models (Building, Task, LifeEvent)
- **`repositories/`**: Abstract interfaces defining data contracts

**Rules:**
- Never import Flutter, Drift, or HTTP libraries
- All models are immutable
- Use `copyWith()` for updates

### Data Layer (`lib/data/`)
**Persistence implementations - depends on Domain only**

- **`database.dart`**: Drift SQLite configuration
- **`tables.dart`**: Database schema definitions
- **`repositories/`**: Concrete implementations of domain repositories

**Rules:**
- Implements domain repository interfaces
- Converts between database models and domain entities
- Handles all SQL/Drift-specific logic

### Presentation Layer (`lib/game/`, `lib/main.dart`)
**UI and game rendering - depends on Domain and Services**

- **`game/`**: Flame game components (grid, buildings, camera)
- **`main.dart`**: Flutter app entry point and Material theming

**Rules:**
- Uses domain entities via repositories
- Calls AI services via abstract interfaces
- Never accesses database directly

### Services Layer (`lib/services/`)
**External integrations - depends on Domain only**

- **`ai_interface.dart`**: Abstract AI service contract
- **`ai_service_impl.dart`**: Firebase Cloud Functions implementation (TODO)

**Rules:**
- Defines DTOs (Data Transfer Objects) for requests/responses
- Converts external formats to domain entities
- Handles HTTP, error codes, retries

## 🤝 Agent Handoff Guidelines

### For AI Services Agent
**Focus:** Implement `ai_interface.dart`

1. Read `lib/services/ai_interface.dart` for complete contract
2. Create `lib/services/ai_service_impl.dart`
3. Use `cloud_functions` package to call:
   - `generateAsset` → Cloud Function endpoint
   - `distillContext` → Cloud Function endpoint
4. DO NOT modify domain or data layers
5. Run tests: `flutter test test/services/`

### For UI/Game Agent
**Focus:** Enhance `lib/game/` components

1. Read `lib/domain/entities/building.dart` for entity contract
2. Read `lib/domain/repositories/building_repository.dart` for data access
3. Add new components to `world_game.dart`
4. Use `BuildingRepository` to load/save buildings
5. DO NOT access database directly (use repository)
6. Run: `flutter run` to test visually

### For Data Agent
**Focus:** Database migrations and new tables

1. Add tables to `lib/data/tables.dart`
2. Update `@DriftDatabase` annotation in `database.dart`
3. Increment `schemaVersion`
4. Run: `dart run build_runner build`
5. Implement new repository in `lib/data/repositories/`
6. DO NOT modify domain entities without approval

## 🎨 Sovereign Sanctum Design System

All visual components MUST use these colors:

```dart
// Primary
const sovereignGold = Color(0xFFD4AF37);     // Geometric gold
const deepTeal = Color(0xFF134E5E);           // Accent teal
const darkSlate = Color(0xFF1A1A2E);          // Background

// Secondary
const softWhite = Color(0xFFF5F5F5);          // Text on dark
const mysteryPurple = Color(0xFF2D1B4E);      // Rare highlights
```

**Typography:** Roboto (default), upgrade to custom font later

**Grid:** 64x32 tile dimensions (isometric)

## 🔐 Security Standards

From `.agent/rules/standards.md`:

- All API keys via Firebase Secrets (NEVER hardcoded)
- No sensitive data in Git
- TypeScript strict mode for Cloud Functions
- DartDoc required for all public APIs

## 📦 Dependencies

### Production
- `flame`: Game engine
- `drift`: Local database
- `flutter_riverpod`: State management
- `firebase_core`, `cloud_functions`: Backend connection

### Dev
- `drift_dev`, `build_runner`: Code generation
- `flutter_lints`: Linting

## 🚀 Quick Start for New Agents

```bash
# 1. Clone and setup
git clone <repo>
cd OrBeit AG Build/app
flutter pub get

# 2. Generate database code (if schema changed)
dart run build_runner build

# 3. Run on emulator
flutter run

# 4. Run tests
flutter test

# 5. Deploy Cloud Functions (backend team only)
cd ../functions
npm run deploy
```

## 📝 Mandatory Documentation

Every file MUST have:

```dart
/// [One-line summary]
///
/// [Detailed description]
///
/// **For Future Agents:**
/// - [Key point 1]
/// - [Key point 2]
///
/// **[Context-specific header]:**
/// [Additional guidance]
```

## ⚠️ Breaking Changes Protocol

If you MUST change a domain entity or repository interface:

1. Create a new task in `task.md`
2. Notify all dependent agents
3. Update this README with migration guide
4. Increment version in `pubspec.yaml`

## 🧪 Testing Strategy

- **Unit Tests:** `test/domain/`, `test/data/`
- **Widget Tests:** `test/game/`
- **Integration Tests:** `test/integration/`

Run: `flutter test` before any PR.
