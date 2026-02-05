# OrBeit Project Standards & Governance

> **This document governs ALL agents, developers, and AI assistants working in this workspace.**
> **Violations of these standards will result in rejected code and required refactoring.**

---

## 🔒 Project Identity (IMMUTABLE)

| Property | Value | Notes |
|----------|-------|-------|
| **Project ID** | `orbeit-613` | ALL Firebase/GCloud commands MUST use this |
| **Project Name** | OrBeit | The Sovereign Life OS |
| **Owner Account** | jonnypage100@gmail.com | Primary Firebase & GCloud auth |
| **Workspace Path** | `/Users/tekhletvault/OrBeit AG Build` | Root directory for all code |

```bash
# REQUIRED: Every gcloud/firebase command MUST include project reference
firebase deploy --project orbeit-613
gcloud run deploy --project orbeit-613
```

---

## 📚 Tech Stack (Mandatory)

### Core Stack
| Layer | Technology | Version | Purpose |
|-------|------------|---------|---------|
| **Frontend** | Flutter + Flame | Latest Stable | Cross-platform UI + game engine |
| **Local DB** | Drift (SQLite) | ^2.x | Offline-first local persistence |
| **Backend** | Firebase Functions | Node 22+ | Serverless API endpoints |
| **Database** | Cloud Firestore | - | Encrypted sync relay only |
| **Hosting** | Firebase Hosting | - | Web app deployment |
| **Auth** | Firebase Auth | - | User identity management |
| **AI** | Gemini 2.5 Pro | - | Cloud fallback intelligence |
| **On-Device AI** | Gemini Nano | - | Local inference (privacy) |

### Google AI Ultra Resources (Available)
| Resource | Allocation | Use Case |
|----------|------------|----------|
| **AI Credits** | 25,000/month | Flow, Whisk, Gemini API calls |
| **GCP Credits** | $100/month | Vertex AI, AI Studio, Cloud Run |
| **Storage** | 30 TB | Backup, assets, user data |
| **Gemini 2.5 Pro** | Unlimited | Deep Think, complex reasoning |
| **Veo 3** | Included | Video generation for marketing/assets |
| **Flow** | 25k credits | Automated workflows, AI pipelines |
| **Whisk** | 25k credits | Image generation, asset creation |

---

## 🛡️ Security Standards

### Secret Management
```typescript
// ❌ NEVER DO THIS
const apiKey = "AIzaSy..."; // Hardcoded secrets = REJECTED

// ✅ ALWAYS DO THIS
import { defineSecret } from "firebase-functions/params";
const geminiApiKey = defineSecret("GEMINI_API_KEY");

export const myFunction = onRequest(
  { secrets: [geminiApiKey] },
  async (req, res) => {
    const key = geminiApiKey.value();
  }
);
```

### Secrets Registry (Firebase Secrets Manager)
| Secret Name | Purpose | Set Via |
|-------------|---------|---------|
| `GEMINI_API_KEY` | Gemini Pro API access | `firebase functions:secrets:set` |
| `MAPS_API_KEY` | Google Maps integration | `firebase functions:secrets:set` |
| `ENCRYPTION_KEY` | E2E encryption master key | `firebase functions:secrets:set` |

### Files That MUST Be in .gitignore
```
.env
.env.*
*.local
google-services.json
GoogleService-Info.plist
service-account*.json
keys_manifest.txt
```

### Firestore Security Rules
- **NEVER** use `allow read, write: if true;` in production
- ALL user data MUST be scoped to `userId` path
- Encryption relay documents MUST validate sender ownership

---

## 📝 TypeScript Standards (Mandatory for Functions)

### Configuration
All Cloud Functions MUST use TypeScript. Create `functions/tsconfig.json`:
```json
{
  "compilerOptions": {
    "target": "ES2022",
    "module": "NodeNext",
    "moduleResolution": "NodeNext",
    "strict": true,
    "noImplicitAny": true,
    "strictNullChecks": true,
    "noUnusedLocals": true,
    "noUnusedParameters": true,
    "esModuleInterop": true,
    "skipLibCheck": true,
    "outDir": "./lib"
  },
  "include": ["src/**/*"],
  "exclude": ["node_modules"]
}
```

### ESLint Configuration
```javascript
// .eslintrc.js
module.exports = {
  root: true,
  env: { node: true, es2022: true },
  extends: [
    "eslint:recommended",
    "plugin:@typescript-eslint/strict-type-checked",
    "google"
  ],
  parser: "@typescript-eslint/parser",
  parserOptions: { project: "./tsconfig.json" },
  rules: {
    "@typescript-eslint/no-explicit-any": "error",
    "@typescript-eslint/explicit-function-return-type": "error",
    "require-jsdoc": "error",
    "valid-jsdoc": "error"
  }
};
```

---

## 📖 Documentation Requirements

### JSDoc (MANDATORY for all functions)
Every exported function MUST include JSDoc comments:

```typescript
/**
 * Syncs encrypted user world data to Firestore relay.
 * 
 * @param userId - The authenticated user's UID
 * @param encryptedPayload - AES-256-GCM encrypted world state
 * @param timestamp - Client-side timestamp for conflict resolution
 * @returns Promise resolving to sync confirmation with server timestamp
 * @throws {AuthError} If user is not authenticated
 * @throws {QuotaError} If user exceeds sync rate limit
 * 
 * @example
 * const result = await syncWorldData(uid, encrypted, Date.now());
 * console.log(result.serverTimestamp);
 */
export async function syncWorldData(
  userId: string,
  encryptedPayload: string,
  timestamp: number
): Promise<SyncResult> {
  // Implementation
}
```

### README Requirements
Every new module/feature MUST include:
- Purpose description
- Setup instructions
- Usage examples
- Environment variables required

---

## 📁 Folder Structure (Mandatory)

```
/Users/tekhletvault/OrBeit AG Build/
├── .agent/
│   ├── rules/
│   │   └── standards.md          # THIS FILE
│   └── workflows/                # Automation scripts
├── functions/                    # Firebase Cloud Functions
│   ├── src/
│   │   ├── index.ts              # Entry point
│   │   ├── auth/                 # Auth-related functions
│   │   ├── sync/                 # Data sync functions
│   │   ├── ai/                   # Gemini integration
│   │   └── utils/                # Shared utilities
│   ├── tsconfig.json
│   ├── package.json
│   └── .eslintrc.js
├── lib/                          # Shared Dart packages
│   ├── core/                     # Core domain logic
│   ├── data/                     # Data layer (Drift, repos)
│   └── presentation/             # UI components
├── app/                          # Flutter application
│   ├── lib/
│   ├── assets/
│   └── pubspec.yaml
├── public/                       # Firebase Hosting assets
├── firestore.rules
├── firestore.indexes.json
├── firebase.json
└── .firebaserc
```

---

## 🧪 Testing Standards

| Type | Tool | Coverage Target |
|------|------|-----------------|
| **Unit Tests** | Jest (TS) / Flutter Test | 80% minimum |
| **Integration** | Firebase Emulator Suite | All sync paths |
| **E2E** | Patrol / Integration Test | Critical user flows |

### Pre-Commit Hooks (Required)
```bash
# Install husky
npm install --save-dev husky lint-staged

# Pre-commit checks
npx husky add .husky/pre-commit "npm run lint && npm run test"
```

---

## 🚀 Deployment Protocol

### Development
```bash
firebase emulators:start --project orbeit-613
```

### Staging (Preview Channels)
```bash
firebase hosting:channel:deploy preview --project orbeit-613
```

### Production
```bash
# Full deploy (requires passing CI)
firebase deploy --project orbeit-613

# Functions only
firebase deploy --only functions --project orbeit-613
```

---

## 🤖 AI Agent Instructions

### When Using Gemini/Vertex AI
1. **Always use Firebase Secrets** for API keys
2. **Prefer Gemini Nano** for on-device tasks (privacy)
3. **Fall back to Gemini 2.5 Pro** only when Nano unavailable
4. **Log all AI calls** with sanitized prompts (no PII)

### When Using Flow/Whisk Credits
1. **Track credit usage** in a dedicated Firestore collection
2. **Implement rate limiting** to prevent credit exhaustion
3. **Cache generated assets** to avoid duplicate generation
4. **Document all AI-generated content** with provenance metadata

### When Creating Functions
1. **Use TypeScript** - JavaScript functions will be rejected
2. **Include JSDoc** - Undocumented functions will be rejected
3. **Handle errors** - All async functions need try/catch
4. **Log appropriately** - Use `firebase-functions/logger`

---

## 📋 Code Review Checklist

Before any PR/merge, verify:

- [ ] Project ID is `orbeit-613` in all commands
- [ ] No hardcoded secrets or API keys
- [ ] TypeScript strict mode passes
- [ ] ESLint has zero errors
- [ ] JSDoc present on all exports
- [ ] Unit tests pass with 80%+ coverage
- [ ] Firestore rules don't expose user data
- [ ] .gitignore includes all sensitive files

---

## 🔄 Version History

| Version | Date | Author | Changes |
|---------|------|--------|---------|
| 1.0.0 | 2026-02-05 | Claude (Architect) | Initial standards document |

---

> **This document is LAW.** All agents and developers MUST comply.
> Updates require approval from project owner (jonnypage100@gmail.com).
