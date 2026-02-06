---
description: Verify all core systems are functional
---

# Full System Verification
// turbo-all

Run all verification checks in sequence.

## 1. Flutter Environment
```bash
cd /Users/tekhletvault/OrBeit\ AG\ Build/app
flutter doctor -v | head -30
```

## 2. Dependencies
```bash
cd /Users/tekhletvault/OrBeit\ AG\ Build/app
flutter pub get
```

## 3. Static Analysis
```bash
cd /Users/tekhletvault/OrBeit\ AG\ Build/app
dart analyze lib/
```

## 4. File Structure Verification
```bash
cd /Users/tekhletvault/OrBeit\ AG\ Build/app/lib
echo "=== Domain Layer ==="
ls domain/entities/
ls domain/repositories/
echo "=== Data Layer ==="
ls data/
ls data/repositories/
echo "=== Game Layer ==="
ls game/
echo "=== Services ==="
ls services/
echo "=== UI ==="
ls ui/
echo "=== Providers ==="
ls providers/
```

## 5. Cloud Functions
```bash
cd /Users/tekhletvault/OrBeit\ AG\ Build/functions
npm run lint 2>&1 | tail -10 || echo "Lint check complete"
```

## 6. Git Status
```bash
cd /Users/tekhletvault/OrBeit\ AG\ Build
git status --short
```

## Expected Output
- No analyzer errors (warnings OK)
- All directories populated
- Clean git status (or known pending changes)

## Pass Criteria
```
dart analyze lib/ => "No issues found!"
```
