---
description: Master OrBeit development workflow - the complete roadmap
---

# OrBeit Master Workflow

This is the master orchestration document. Updated Feb 8, 2026.

## Current System State (Feb 8, 2026)

### ✅ COMPLETED PHASES
- [x] Phase 0: Security Lockdown → sensitive files gitignored, secure storage service live
- [x] Phase 1: Database Foundation → Drift schema, 4 tables, generated queries
- [x] Phase 2: Domain Layer → Building, Task, LifeEvent, GenesisKit entities
- [x] Phase 3: Repository Layer → BuildingRepo, TaskRepo, LifeEventRepo, GenesisRepo
- [x] Phase 4: AI Service Bridge → AIInterface, AIServiceImpl, Cloud Functions
- [x] Phase 5: Game Engine Core → Flame WorldGame, IsometricGrid, terrain, decorations
- [x] Phase 6: UI Foundation → CovenantScreen, GameScreen, toolbar, task panel, AI dialog
- [x] Phase 7: Environment Setup → Flutter SDK, CocoaPods, pubspec resolved
- [x] Phase 8: Visual Assets → 22 sprite PNGs, procedural terrain, decorations
- [x] Phase 9: Package Integration → 20 packages installed (voice, cache, security, animation, AI)
- [x] Phase 10: Service Layer → SecureStorage, CacheService, VoiceService, DeviceCapability
- [x] Phase 11: Or Intelligence → OrBrain with system prompt, intent parsing, Gemini integration
- [x] Phase 12: Or Beacon UI → Pulsing golden orb with voice activation and state animations

### 🔴 IMMEDIATE NEXT (Required for First Test)
- [ ] Phase 13: Build Verification → `flutter build macos --debug` from Terminal.app
- [ ] Phase 14: Gemini API Key → Set key in SecureStorage for full AI capability

### 🟡 NEXT DEVELOPMENT
- [ ] Phase 15: Springfield Model → Spatial relationships between buildings (not GPS)
- [ ] Phase 16: Life Event UI → Voice → text → AI distill → save flow
- [ ] Phase 17: Task-Building Link → Tasks anchored to spatial buildings
- [ ] Phase 18: Whiteboard Engine → 4-view project visualization

### 🟢 FUTURE
- [ ] Phase 19: Buyer's Agent → Deal-finding revenue engine
- [ ] Phase 20: Duress Protocol → Security dummy world
- [ ] Phase 21: PowerSync → Offline-first cloud sync
- [ ] Phase 22: App Store Prep → iOS/Android builds, TestFlight

---

## Quick Commands

| Command | Purpose |
|---------|---------|
| `/verify-all` | Run all verification workflows |
| `/continue-build` | Pick up where we left off |
| `/system-status` | Full component map |
| `/verify-database` | Check Drift schema health |
| `/verify-security` | Check security lockdown |

---

## Build Verification Checklist

Before each session:
1. `dart analyze lib/` → must be 0 errors, 0 warnings
2. `git status` → clean working tree
3. `git push origin main` → all work on GitHub

## Architecture Rules

- **Clean Architecture:** domain → data → presentation (never reverse)
- **Riverpod:** All services injected via ProviderScope overrides
- **Local First:** Gemini is fallback, not primary. Local intent parsing first.
- **Sovereign Gold:** `0xFFD4AF37` on Void Black `0xFF1A1A2E`
- **Privacy:** User data stays in Drift (SQLite). Cloud sees only anonymized context.
