---
description: Verify database schema and generated code
---

# Database Verification Workflow

Verifies that the Drift database layer is properly configured.

## Checklist

### 1. Tables Defined
// turbo
```bash
cd /Users/tekhletvault/OrBeit\ AG\ Build/app/lib/data
grep -q "class Buildings extends Table" tables.dart && echo "✅ Buildings table defined"
grep -q "class Tasks extends Table" tables.dart && echo "✅ Tasks table defined"
grep -q "class LifeEvents extends Table" tables.dart && echo "✅ LifeEvents table defined"
```

### 2. Generated Code Exists
// turbo
```bash
cd /Users/tekhletvault/OrBeit\ AG\ Build/app/lib/data
test -f database.g.dart && echo "✅ database.g.dart exists ($(wc -l < database.g.dart) lines)" || echo "❌ database.g.dart missing - run build_runner"
```

### 3. Database Class Complete
// turbo
```bash
cd /Users/tekhletvault/OrBeit\ AG\ Build/app/lib/data
grep -q "@DriftDatabase" database.dart && echo "✅ @DriftDatabase annotation present"
grep -q "buildings" database.dart && echo "✅ Buildings table referenced"
grep -q "tasks" database.dart && echo "✅ Tasks table referenced"
grep -q "lifeEvents" database.dart && echo "✅ LifeEvents table referenced"
```

### 4. No Drift Errors
// turbo
```bash
cd /Users/tekhletvault/OrBeit\ AG\ Build/app
dart analyze lib/data/ 2>&1 | grep -E "(error|warning)" || echo "✅ No analyzer issues in data layer"
```

## Regenerate Command
If database.g.dart is stale or missing:
```bash
cd /Users/tekhletvault/OrBeit\ AG\ Build/app
dart run build_runner build --delete-conflicting-outputs
```

## Schema Reference
| Table | Columns |
|-------|---------|
| Buildings | id, type, x, y, rotation, placedAt |
| Tasks | id, title, description, buildingId, gridX, gridY, dueDate, completedAt, priority, createdAt, updatedAt |
| LifeEvents | id, eventType, title, description, locationLabel, occurredAt, metadata, createdAt |
