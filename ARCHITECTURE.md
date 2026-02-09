# OrBeit Technology Architecture

> **Last Updated:** 2026-02-08

## Package Stack Overview

### USE (Battle-Tested, Stable, Purpose-Built)

#### Voice & Speech
| Package | Purpose | Status |
|---------|---------|--------|
| `speech_to_text` ^7.3.0 | Voice-first interaction — convert speech to text | ✅ Added |
| `flutter_tts` ^4.2.5 | The Or's voice responses (offline, on-device) | ✅ Added |

#### Local Database & Storage
| Package | Purpose | Status |
|---------|---------|--------|
| `drift` ^2.31.0 | Structured relational data (buildings, tasks, people, life events) | ✅ Active |
| `hive` ^2.2.3 + `hive_flutter` ^1.1.0 | Ultra-fast key-value cache (Or insights, cached images, settings) | ✅ Added |

#### Encryption & Security
| Package | Purpose | Status |
|---------|---------|--------|
| `flutter_secure_storage` ^10.0.0 | OS keychain for API keys & secrets (iOS Secure Enclave, Android Keystore) | ✅ Added |

#### State Management & Data Sync
| Package | Purpose | Status |
|---------|---------|--------|
| `flutter_riverpod` ^2.6.1 | Modern state management | ✅ Active |
| `powersync` | Offline-first sync engine (Drift ↔ remote DB) | 📋 Investigate |

#### UI & Animation
| Package | Purpose | Status |
|---------|---------|--------|
| `flutter_animate` ^4.5.2 | Declarative animations (Or pulsing, lighthouse beam, glow) | ✅ Added |
| `lottie` ^3.3.1 | Complex animations (Or's intricate animations, loading states) | ✅ Added |
| `carousel_slider` ^5.0.0 | Multi-angle house views (front/back/left/right crossfade) | ✅ Added |

#### AI & Language Models
| Package | Purpose | Status |
|---------|---------|--------|
| `google_generative_ai` ^0.4.7 | Gemini API (on-device Nano + cloud fallback) | ✅ Active |

#### Firebase & Backend
| Package | Purpose | Status |
|---------|---------|--------|
| `firebase_core` ^2.24.2 | Firebase initialization | ✅ Active |
| `firebase_auth` ^4.16.0 | Authentication | ✅ Active |
| `cloud_firestore` ^4.14.0 | Cloud database | ✅ Active |
| `cloud_functions` ^4.6.0 | Cloud Functions | ✅ Active |

#### Device & Platform
| Package | Purpose | Status |
|---------|---------|--------|
| `device_info_plus` ^12.3.0 | Detect capabilities (Face ID, Gemini Nano, screen size) | ✅ Added |
| `flame` ^1.35.0 | 2.5D isometric game engine | ✅ Active |

---

### MAYBE USE (Useful with tradeoffs)

| Package | Purpose | Decision |
|---------|---------|----------|
| `local_auth` | Biometric auth (Face ID, fingerprint) for The Safe | Use when implementing The Safe |
| `sqflite_common_ffi` | Extra SQLite control | Skip (Drift handles it) |
| `pointycastle` | Advanced cryptography | Skip for V1 (flutter_secure_storage is enough) |

### DO NOT USE

| Package | Reason |
|---------|--------|
| `google_maps_flutter` | No Maps API — Springfield Model uses spatial graph, not GPS |
| `geolocator` | Core product doesn't need real GPS for V1 |

---

## BUILD CUSTOM (Critical to Differentiation)

These are OrBeit's soul — they use the packages above as infrastructure but the logic is bespoke:

1. **The Or Logic Layer** — AI decision engine, proactive suggestions, Torah-bounded guardrails. Uses Gemini as backbone but system prompts, safety rules, and contextual understanding are custom.

2. **Springfield Model Graph System** — Relational spatial world that isn't GPS. Built on Drift as data layer. "Mom's house appears near the barn because they're emotionally close" — that's custom logic.

3. **Whiteboard Visualization Engine** — When a user drags a project onto the whiteboard and AI generates 4 views (roadmap, kanban, architecture, mindmap). Uses Flame for rendering + Gemini for generation.

4. **Buyer's Agent Deal-Finding Logic** — Scraping prices, anonymizing queries, matching deals to user needs, earning commissions transparently. Revenue model and secret sauce.

5. **Duress Protocol** — Show a dummy world if forced. Security-critical, requires careful threat modeling.

---

## Repository Structure (Future)

```
/orbeit-core      — Dart/Flutter app with all packages
/orbeit-ai        — Or's LLM logic, safety rules, proactive behavior
/orbeit-assets    — Pre-rendered sprites, Lottie files, audio
/orbeit-buyer-agent — Deal-finding service (cloud function)
```

---

## Data Architecture

```
┌─────────────────────────────────────────┐
│  Drift (SQLite)                          │
│  ├── Buildings (spatial entities)         │
│  ├── Tasks (anchored to buildings)       │
│  ├── LifeEvents (timeline/narrative)     │
│  └── People (relational graph)           │
├─────────────────────────────────────────┤
│  Hive (Key-Value Cache)                  │
│  ├── Or's recent insights                │
│  ├── Cached image paths                  │
│  ├── User preferences                    │
│  └── Quick lookup data                   │
├─────────────────────────────────────────┤
│  Flutter Secure Storage (OS Keychain)    │
│  ├── API keys                            │
│  ├── Firebase tokens                     │
│  └── Encryption keys                     │
├─────────────────────────────────────────┤
│  PowerSync (Future)                      │
│  └── Drift ↔ Remote DB offline sync      │
└─────────────────────────────────────────┘
```
