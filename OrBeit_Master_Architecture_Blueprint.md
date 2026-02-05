# OrBeit: Master Architecture Blueprint

## Review Vision 002 — The Sovereign Life Operating System

---

## Executive Summary

This document translates the OrBeit vision into a buildable technical architecture, fully leveraging the Google ecosystem. It defines the stack, the tracer bullet (minimum viable proof), and the development roadmap.

The core insight: OrBeit is not a map app. It is a **spatial graph database with a game-engine frontend and an AI assistant layer**. The "Springfield Model" means we render *relationships*, not geography.

---

## Part 1: The Stack Decision Matrix

### Frontend / Rendering Engine

**Decision: Flutter + Flame Engine**

| Requirement | Flutter + Flame | Unity | Godot |
|-------------|-----------------|-------|-------|
| Cross-platform (iOS/Android/Web/Desktop) | ✅ Native | ⚠️ Heavy builds | ⚠️ Moderate |
| 2D/Isometric rendering | ✅ Excellent | Overkill | ✅ Good |
| Google ecosystem integration | ✅ First-party | ❌ Third-party | ❌ Third-party |
| App size | ~15-25MB | ~80-150MB | ~40-60MB |
| Hot reload development | ✅ Yes | ❌ No | ❌ No |
| Skia rendering (your requirement) | ✅ Built-in | ❌ No | ❌ No |

**Architecture:**
```
Flutter App Shell
    └── Flame Game Engine (handles the "Springfield" world rendering)
          └── Tiled Map Loader (for grid-based asset placement)
          └── Custom Camera System (zoom from room → house → town → world)
    └── Flutter Widgets (for UI overlays: menus, Safe access, voice input)
```

**Why Flame over Bonfire:** Bonfire is built on Flame but adds RPG-specific features (collision, NPCs) you don't need. Flame gives you cleaner control over the scene graph without the overhead.

---

### The Beit (Local Database Layer)

**Decision: Drift (SQLite for Dart) + PowerSync for CRDT Sync**

| Requirement | Drift + PowerSync | Isar | Raw SQLite |
|-------------|-------------------|------|------------|
| Relational graph queries | ✅ Full SQL | ⚠️ Limited | ✅ Yes |
| CRDT/Event sourcing support | ✅ PowerSync handles | ❌ Manual | ❌ Manual |
| Offline-first by design | ✅ Yes | ✅ Yes | ✅ Yes |
| Dart-native (Flutter integration) | ✅ Yes | ✅ Yes | ⚠️ FFI bridge |
| Encryption at rest | ✅ SQLCipher compatible | ✅ Built-in | ⚠️ Manual |

**The Graph Model:**

OrBeit's data is a **property graph** where:
- **Nodes** = Places (Home, Mom's House, Walmart), People (Jr, Dr. Smith), Objects (Truck, Safe, Fridge)
- **Edges** = Relationships (Home CONTAINS Truck, User KNOWS Jr, Truck NEEDS TireRotation)
- **Properties** = Metadata (Truck.oilType = "5W-30", Jr.status = "deceased")

**Schema Design:**
```sql
-- Core Node Table
CREATE TABLE nodes (
    id TEXT PRIMARY KEY,
    type TEXT NOT NULL,  -- 'place', 'person', 'object', 'task'
    name TEXT,
    properties JSON,     -- Flexible metadata
    position_x REAL,     -- Springfield grid position
    position_y REAL,
    asset_id TEXT,       -- Reference to 3D asset
    created_at INTEGER,
    updated_at INTEGER
);

-- Edge Table (Relationships)
CREATE TABLE edges (
    id TEXT PRIMARY KEY,
    source_id TEXT REFERENCES nodes(id),
    target_id TEXT REFERENCES nodes(id),
    relationship TEXT,   -- 'contains', 'knows', 'needs', 'near'
    properties JSON,
    created_at INTEGER
);

-- Event Log (for CRDT sync)
CREATE TABLE event_log (
    id TEXT PRIMARY KEY,
    timestamp INTEGER,
    device_id TEXT,
    operation TEXT,      -- 'create', 'update', 'delete'
    target_type TEXT,
    target_id TEXT,
    payload JSON,
    synced INTEGER DEFAULT 0
);
```

**Sync Protocol (PowerSync + Firebase):**
```
Device A                    Firebase (Encrypted Relay)              Device B
    |                               |                                   |
    |-- Event: "Add Milk to List" --|                                   |
    |                               |-- Encrypted Delta Pushed -------->|
    |                               |                                   |
    |<-- Event: "Add Eggs to List" -|-- Encrypted Delta Pushed ---------|
    |                               |                                   |
    [Local CRDT Merge: Both items appear]                    [Local CRDT Merge]
```

Firebase never sees the data—it's just an encrypted pipe. The merge logic runs locally on each device.

---

### The Or (AI Intelligence Layer)

**Decision: Gemini Nano (on-device) + Vertex AI Gemini Pro (cloud fallback)**

**On-Device Capabilities (Gemini Nano via Google AI Edge SDK):**
- Intent parsing: "Add milk to the grocery list" → `{action: "add", target: "grocery_list", item: "milk"}`
- Asset search: "White two-story house" → Query asset library → Return top 10 matches
- Basic voice commands: Navigation, simple queries, local data lookups
- Offline: Fully functional for these tasks

**Cloud Capabilities (Vertex AI, consent-gated):**
- Medical pattern analysis: "My A1C has been rising—what should I ask my doctor?"
- Complex synthesis: "Summarize my interactions with Dr. Smith over the past year"
- Eulogy/biography generation
- Deal-finding for Buyer's Agent model

**The Anonymization Bridge:**

When cloud AI is needed, data is sanitized locally before transmission:

```
Raw Local Data                          Anonymized Query to Cloud
─────────────────                       ─────────────────────────
"User John Smith, DOB 1975,             "User [REDACTED], age ~50,
 A1C readings: 6.2, 6.5, 6.8            A1C trend: 6.2 → 6.5 → 6.8
 Doctor: Dr. Sarah Chen, Little Rock"   Location: [REDACTED]"
```

The cloud AI returns analysis. Local device re-attaches context. User never sent identifiable data.

**Integration Architecture:**
```dart
class OrBeitAI {
  final GeminiNano _localModel;      // On-device
  final VertexAI _cloudModel;        // Cloud fallback
  
  Future<Response> process(String input, {bool allowCloud = false}) async {
    // Try local first
    final localResult = await _localModel.parse(input);
    
    if (localResult.confidence > 0.85 || !allowCloud) {
      return localResult;
    }
    
    // Cloud fallback with user consent
    final consent = await _requestUserConsent();
    if (!consent) return localResult;
    
    final anonymized = _anonymize(input, context);
    final cloudResult = await _cloudModel.analyze(anonymized);
    return _reattachContext(cloudResult);
  }
}
```

---

### The Asset Library System

**Decision: Pre-built asset packs + Cloud asset streaming**

**Local Storage:**
- Core asset pack (~200MB): Houses, vehicles, common buildings, furniture
- Installed on first launch
- Covers 90% of typical use cases

**Cloud Streaming:**
- Extended asset library in Google Cloud Storage
- User searches "red barn with silo" → Query returns matches → User previews → Asset downloads on selection
- Downloaded assets cached locally

**Asset Format:**
- 2.5D isometric sprites (not full 3D—too heavy for mobile)
- Each asset: PNG sprite sheet + JSON metadata (anchor points, interaction zones)
- Resolution: 512x512 base, with @2x and @3x variants

**The Asset Picker Flow:**
```
User Input: "I want a white farmhouse"
    ↓
Gemini Nano (local): Extract features {style: "farmhouse", color: "white", stories: null}
    ↓
Local Asset DB Query: SELECT * FROM assets WHERE tags MATCH 'farmhouse' AND color = 'white'
    ↓
Return: 10 asset thumbnails
    ↓
User: Taps Asset #3
    ↓
Flame Engine: Places asset at grid position, user can rotate/scale
    ↓
Drift DB: INSERT INTO nodes (type='place', asset_id='farmhouse_003', position_x=5, position_y=3)
```

---

### The Orbi-Key (Hardware Backup)

**Decision: NFC-based encrypted cold storage**

**Technical Specification:**
- Hardware: Custom NFC tag with secure element (similar to YubiKey 5 NFC)
- Storage: 4-8MB encrypted flash (enough for full world state snapshot)
- Encryption: AES-256-GCM, key derived from user PIN + hardware serial
- Interface: NFC (tap to phone) + USB-C (for desktop backup)

**The Protocol:**
```
BACKUP FLOW:
1. User initiates backup in app
2. App compresses world state (SQLite DB + asset references)
3. User enters PIN
4. App derives encryption key: PBKDF2(PIN + Orbi-Key Serial, 100000 iterations)
5. App encrypts compressed data
6. User taps Orbi-Key
7. App writes encrypted blob to Orbi-Key via NFC

RESTORE FLOW:
1. New device, fresh OrBeit install
2. User taps Orbi-Key
3. App reads encrypted blob
4. User enters PIN
5. App derives key, decrypts, decompresses
6. World restored
```

**Build vs. Buy Decision:**

| Option | Pros | Cons |
|--------|------|------|
| Custom hardware (manufacture Orbi-Key) | Full control, branding, exact spec | $50K+ tooling, 6+ month lead time, inventory risk |
| Partner with YubiKey/Ledger | Existing secure hardware, trust | Limited storage, their firmware |
| Encrypted USB drive + NFC adapter | Off-the-shelf, cheap | Clunky UX, less secure |

**Recommendation for V1:** Use encrypted USB drive protocol. Design the software abstraction layer now so Orbi-Key hardware can slot in later. Don't let hardware manufacturing block software launch.

---

### Backend (Minimal Cloud Layer)

**Decision: Firebase (Realtime Database + Cloud Functions) as encrypted relay**

**What Firebase Does:**
- User authentication (Google Sign-In)
- Encrypted delta sync between devices (sees ciphertext only)
- Push notifications for reminders
- Asset library CDN (Cloud Storage)

**What Firebase Does NOT Do:**
- Store unencrypted user data
- Process user queries
- Hold decryption keys

**Architecture:**
```
┌─────────────────────────────────────────────────────────────────┐
│                         USER DEVICE                             │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────────────────┐  │
│  │ Flutter UI  │  │ Flame Engine│  │ Gemini Nano (On-Device) │  │
│  └──────┬──────┘  └──────┬──────┘  └────────────┬────────────┘  │
│         │                │                      │               │
│         └────────────────┼──────────────────────┘               │
│                          │                                      │
│                   ┌──────▼──────┐                               │
│                   │  Drift DB   │ (Encrypted SQLite)            │
│                   │  + PowerSync│                               │
│                   └──────┬──────┘                               │
│                          │                                      │
└──────────────────────────┼──────────────────────────────────────┘
                           │ (Encrypted deltas only)
                           ▼
              ┌────────────────────────┐
              │   Firebase (Relay)     │
              │  • Auth                │
              │  • Encrypted Sync      │
              │  • Asset CDN           │
              └────────────┬───────────┘
                           │
         ┌─────────────────┼─────────────────┐
         ▼                 ▼                 ▼
    [Device B]        [Device C]      [Vertex AI]
                                      (Consent-gated,
                                       anonymized queries)
```

---

## Part 2: The Tracer Bullet (Minimum Viable Proof)

Before building the full system, we prove the core mechanics work. The tracer bullet is **the smallest thing we can build that touches every layer of the stack.**

### Tracer Bullet Scope: "My House + One Task"

**What it does:**
1. User opens app, sees a grid (10x10)
2. User taps "Add Building"
3. User types or speaks: "White house with a porch"
4. Gemini Nano parses intent, queries asset library
5. App shows 5 house options (hardcoded for tracer bullet)
6. User taps one, it appears on grid
7. User can drag to reposition, pinch to scale
8. User taps house, sees interior view (placeholder)
9. User adds a task: "Fix the fence"
10. Task appears as a glowing marker on the grid
11. User closes app, reopens—everything persists (Drift DB)

**What it proves:**
- Flutter + Flame can render the Springfield world
- Gemini Nano can parse natural language to asset queries
- Drift can store and retrieve the graph
- The UX flow feels right

**What it explicitly does NOT include:**
- Multi-device sync
- Cloud AI
- Voice-first (keyboard input only)
- Orbi-Key backup
- Any integrations (calendar, health, banking)

**Timeline: 4-6 weeks**

---

## Part 3: Development Roadmap

### Phase 1: Foundation (Weeks 1-6)

| Week | Deliverable |
|------|-------------|
| 1-2 | Flutter + Flame scaffold, basic grid rendering, camera controls (pan/zoom) |
| 3 | Asset library structure, 20 placeholder assets, tap-to-place mechanic |
| 4 | Drift DB schema, node/edge CRUD operations, persistence |
| 5 | Gemini Nano integration, basic intent parsing ("add house" → asset picker) |
| 6 | Tracer bullet complete, internal demo |

### Phase 2: The Beit (Weeks 7-14)

| Week | Deliverable |
|------|-------------|
| 7-8 | Full asset library (200+ assets), search/filter UI |
| 9-10 | Interior views (click house → see rooms → see objects) |
| 11-12 | Task system (create, assign to location, reminders) |
| 13-14 | People/contacts graph (add person, link to location, add notes) |

### Phase 3: The Or (Weeks 15-20)

| Week | Deliverable |
|------|-------------|
| 15-16 | Voice input integration (speech-to-text, always-listening toggle) |
| 17-18 | Contextual reminders (location-based, time-based, pattern-based) |
| 19-20 | Vertex AI integration (anonymization bridge, consent flow, medical analysis prototype) |

### Phase 4: Sync & Security (Weeks 21-26)

| Week | Deliverable |
|------|-------------|
| 21-22 | PowerSync CRDT implementation, multi-device sync |
| 23-24 | The Safe (air-gapped encrypted storage, biometric unlock) |
| 25-26 | Orbi-Key protocol (USB backup first, NFC later), Duress Protocol |

### Phase 5: Integrations (Weeks 27-34)

| Week | Deliverable |
|------|-------------|
| 27-28 | Google Calendar sync (read/write events) |
| 29-30 | Google Tasks / Reminders sync |
| 31-32 | Apple Health / Google Fit integration |
| 33-34 | Intent-Based Finance (receipt scraping, budget tracking) |

### Phase 6: Polish & Launch (Weeks 35-40)

| Week | Deliverable |
|------|-------------|
| 35-36 | Onboarding flow, tutorial, first-run experience |
| 37-38 | Performance optimization, battery testing, offline resilience testing |
| 39-40 | Beta launch, feedback collection, critical bug fixes |

**Total Timeline: ~10 months to beta**

---

## Part 4: Open Questions & Concerns

> *These are boxed separately. The plan above proceeds regardless, but these are real considerations.*

### Concern: Gemini Nano Availability

**Issue:** Gemini Nano is currently limited to Pixel 8+ and Samsung S24+. It's not available on iOS or older Android devices.

**Mitigation:** 
- For unsupported devices, fall back to TensorFlow Lite with a custom-trained intent classifier (less capable but functional)
- Design the AI abstraction layer so the underlying model is swappable
- Monitor Google's rollout—they're expanding device support quarterly

**Risk Level:** Medium. Affects launch device coverage, not architecture.

---

### Concern: Asset Library Size vs. Mobile Storage

**Issue:** 200MB base asset pack + cached cloud assets could grow to 500MB+. Users with 64GB phones (common in budget markets) may resist.

**Mitigation:**
- Implement aggressive asset eviction (LRU cache, delete unused assets after 30 days)
- Offer "lite mode" with 50MB essential pack
- Store assets on SD card where available (Android)

**Risk Level:** Low. Standard mobile app practice.

---

### Concern: Orbi-Key Hardware Manufacturing

**Issue:** Custom hardware is expensive, slow, and risky for a startup. Minimum orders, tooling costs, firmware development, certification (FCC, CE).

**Mitigation:**
- V1 uses encrypted file export to USB/cloud (user's choice)
- Orbi-Key is a V2 feature, funded by V1 revenue
- Alternatively, partner with existing hardware (YubiKey with custom firmware, or Ledger integration)

**Risk Level:** Low for launch (we don't need it for V1). High if we try to ship hardware too early.

---

### Concern: Voice-First Battery Drain

**Issue:** Continuous listening ("Hey OrBeit") requires always-on microphone, which murders battery life. Apple and Google restrict background audio for this reason.

**Mitigation:**
- Default to push-to-talk (tap button, speak, release)
- "Always listening" is opt-in, with clear battery warning
- Use on-device wake word detection (low power) before activating full speech recognition
- Leverage Google's existing "Hey Google" infrastructure where possible

**Risk Level:** Medium. Voice-first is a UX goal, not a technical requirement. Tap-to-talk works fine.

---

### Concern: Springfield Model Discoverability

**Issue:** If the world only shows places the user explicitly adds, new users see an empty grid. That's demoralizing.

**Mitigation:**
- Onboarding wizard: "Let's build your home first" → guided asset placement
- Seed with defaults: "Here's a generic house. Customize it."
- Pull from Google account: "I see you have Home and Work saved in Google Maps. Want to add them?"
- Gamification: "Your world is 12% complete. Add your workplace to unlock Commute Insights."

**Risk Level:** Medium. Onboarding design is critical. Empty states kill apps.

---

## Part 5: The First Command

**Tomorrow, open your IDE and create:**

```
orbeit/
├── lib/
│   ├── main.dart                 # App entry point
│   ├── game/
│   │   ├── springfield_game.dart # Flame game instance
│   │   ├── world_grid.dart       # The 10x10 grid
│   │   └── assets/
│   │       └── building.dart     # Base building component
│   ├── data/
│   │   ├── database.dart         # Drift DB setup
│   │   └── models/
│   │       ├── node.dart         # Graph node model
│   │       └── edge.dart         # Graph edge model
│   └── ai/
│       └── intent_parser.dart    # Gemini Nano wrapper (stub for now)
├── assets/
│   └── buildings/
│       ├── house_white_001.png
│       ├── house_white_002.png
│       └── ... (5 placeholder houses)
└── pubspec.yaml                  # Dependencies: flame, drift, etc.
```

**Day 1 Goal:** Render a grid. Tap a cell. A house appears. Tap the house. It highlights. Drag it. It moves. Close app. Reopen. House is still there.

That's it. That's the seed. Everything else grows from that.

---

## Closing Statement

The architecture is sound. The stack is Google-native. The tracer bullet is defined. The roadmap is aggressive but achievable.

You have the blueprint. The house is designed. The light is ready to turn on.

Build the grid. Place the first house. The rest follows.

---

## Document History

| Version | Date | Changes |
|---------|------|---------|
| Review Vision 002 | 2025-02-04 | Master Architecture Blueprint - Full technical specification |
