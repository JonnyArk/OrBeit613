---
description: Complete system status and component map
---

# OrBeit System Status

Last Updated: February 6, 2026

## Component Registry

### Domain Layer (`app/lib/domain/`)

| File | Status | Purpose |
|------|--------|---------|
| `entities/building.dart` | ✅ Complete | Building domain entity |
| `entities/task.dart` | ✅ Complete | Task domain entity with priorities |
| `entities/life_event.dart` | ✅ Complete | LifeEvent domain entity |
| `entities/task_repository.dart` | ✅ Complete | Task repository interface |
| `entities/life_event_repository.dart` | ✅ Complete | LifeEvent repository interface |
| `repositories/building_repository.dart` | ✅ Complete | Building repository interface |

### Data Layer (`app/lib/data/`)

| File | Status | Purpose |
|------|--------|---------|
| `tables.dart` | ✅ Complete | Drift table definitions |
| `database.dart` | ✅ Complete | AppDatabase with all tables |
| `database.g.dart` | ✅ Generated | Drift generated code |
| `repositories/building_repository_impl.dart` | ✅ Complete | Building CRUD + watchAll stream |
| `repositories/task_repository_impl.dart` | ✅ Complete | Task CRUD |
| `repositories/life_event_repository_impl.dart` | ✅ Complete | LifeEvent CRUD |

### Game Layer (`app/lib/game/`)

| File | Status | Purpose |
|------|--------|---------|
| `world_game.dart` | ✅ Complete | Main FlameGame with reactive DB sync |
| `building_component.dart` | ✅ Complete | Sprite-based building renderer |
| `building_selector.dart` | ✅ Complete | Building type selection UI |
| `isometric_grid.dart` | ✅ Complete | Grid background renderer |
| `sprite_manager.dart` | ✅ Complete | Sprite loading utilities |

### Services (`app/lib/services/`)

| File | Status | Purpose |
|------|--------|---------|
| `ai_interface.dart` | ✅ Complete | AI service contract with types |
| `ai_service_impl.dart` | ✅ Complete | Cloud Functions implementation |

### UI Layer (`app/lib/ui/`)

| File | Status | Purpose |
|------|--------|---------|
| `task_list_panel.dart` | ✅ Complete | Task management overlay |
| `ai_architect_dialog.dart` | ✅ Complete | AI interaction (Architect + Scribe) |

### Providers (`app/lib/providers/`)

| File | Status | Purpose |
|------|--------|---------|
| `building_provider.dart` | ✅ Complete | Building state providers |
| `task_provider.dart` | ✅ Complete | Task state providers |
| `database_provider.dart` | ✅ Complete | Database instance provider |

### Cloud Functions (`functions/src/`)

| File | Status | Purpose |
|------|--------|---------|
| `index.ts` | ✅ Complete | Function exports |
| `ai/ai_manager.ts` | ✅ Complete | Credit tracking, rate limiting |
| `ai/whisk_service.ts` | ✅ Complete | Image generation |
| `ai/flow_service.ts` | ✅ Complete | Context distillation |

### Assets (`app/assets/`)

| Type | Files | Status |
|------|-------|--------|
| Sprites | house.png, well.png, sanctum.png | ✅ Present |

### Configuration

| File | Status | Notes |
|------|--------|-------|
| `.gitignore` | ✅ Secured | Excludes firebase_options, google-services |
| `firestore.rules` | ✅ Secured | Auth-required access |
| `storage.rules` | ✅ Secured | User-isolated paths |
| `firebase.json` | ✅ Configured | All services defined |

---

## Integration Map

```
┌─────────────────────────────────────────────────────────────────┐
│                         MAIN.DART                                │
│  Initializes: Database, Repositories, AIService                 │
│  Provides: buildingRepositoryProvider, aiServiceProvider,       │
│            taskRepositoryProvider, lifeEventRepositoryProvider  │
└───────────────────────────┬─────────────────────────────────────┘
                            │
        ┌───────────────────┼───────────────────┐
        ▼                   ▼                   ▼
┌───────────────┐  ┌─────────────────┐  ┌─────────────────┐
│  GameScreen   │  │ TaskListPanel   │  │ AIArchitectDialog│
│  (WorldGame)  │  │                 │  │ ┌─────┬────────┐ │
│               │  │ • View tasks    │  │ │Archi│ Scribe │ │
│ • Flame game  │  │ • Complete task │  │ │tect │        │ │
│ • Auto-sync   │  │ • Create task   │  │ └─────┴────────┘ │
└───────┬───────┘  └────────┬────────┘  └────────┬────────┘
        │                   │                    │
        ▼                   ▼                    ▼
┌───────────────────────────────────────────────────────────────┐
│                      REPOSITORIES                              │
│  BuildingRepo ←→ TaskRepo ←→ LifeEventRepo                   │
│       │              │              │                          │
│       ▼              ▼              ▼                          │
│  ──────────────── DRIFT DATABASE ────────────────             │
│  Buildings | Tasks | LifeEvents                               │
└───────────────────────────────────────────────────────────────┘
        │
        ▼ (AI Calls)
┌───────────────────────────────────────────────────────────────┐
│                    CLOUD FUNCTIONS                             │
│  generateAsset() ←→ distillContext() ←→ creditUsage()        │
└───────────────────────────────────────────────────────────────┘
```

---

## Known Issues

| Issue | Severity | Resolution |
|-------|----------|------------|
| CocoaPods not installed | 🔴 Blocking | User must run `sudo gem install cocoapods` |
| Duplicate LifeEvent definitions | 🟡 Technical Debt | Consolidate to domain layer |
| No dynamic sprite loading | 🟡 Feature Gap | Phase 8 will address |

---

## Test Commands

```bash
# Full analysis
cd /Users/tekhletvault/OrBeit\ AG\ Build/app && dart analyze lib/

# Check git status
cd /Users/tekhletvault/OrBeit\ AG\ Build && git status

# Build macOS (after CocoaPods)
cd /Users/tekhletvault/OrBeit\ AG\ Build/app && flutter build macos --debug
```
