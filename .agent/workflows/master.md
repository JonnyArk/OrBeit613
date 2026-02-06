---
description: Master OrBeit development workflow - the complete roadmap
---

# OrBeit Master Workflow

This is the master orchestration document. It references individual workflows for each phase.

## Current System State (Feb 6, 2026)

### ✅ COMPLETED PHASES
- [x] Phase 0: Security Lockdown → `/verify-security`
- [x] Phase 1: Database Foundation → `/verify-database`
- [x] Phase 2: Domain Layer → `/verify-domain`
- [x] Phase 3: Repository Layer → `/verify-repositories`
- [x] Phase 4: AI Service Bridge → `/verify-ai-bridge`
- [x] Phase 5: Game Engine Core → `/verify-game-engine`
- [x] Phase 6: UI Foundation → `/verify-ui-foundation`

### 🚧 IN PROGRESS
- [ ] Phase 7: Environment Setup → `/setup-environment`

### 📋 NEXT PHASES
- [ ] Phase 8: Visual Assets → `/build-visual-assets`
- [ ] Phase 9: LifeEvents UI → `/build-life-events-ui`
- [ ] Phase 10: Task-Building Integration → `/build-task-building-link`
- [ ] Phase 11: Cloud Deploy → `/deploy-cloud`
- [ ] Phase 12: App Store Prep → `/prepare-app-store`

---

## Quick Commands

| Command | Purpose |
|---------|---------|
| `/verify-all` | Run all verification workflows |
| `/continue-build` | Pick up where we left off |
| `/fix-blockers` | Address any blocking issues |
| `/deploy` | Full deployment pipeline |

---

## Autonomous Execution Mode

To enable continuous autonomous work, use:
```
/continue-build
```

This will:
1. Run verification on completed phases
2. Identify the next incomplete phase
3. Execute that phase
4. Loop until complete or blocked
