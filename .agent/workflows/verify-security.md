---
description: Verify security lockdown is complete
---

# Security Verification Workflow

Verifies that all security measures from Phase 0 are in place.

## Checklist

### 1. Sensitive Files Untracked
// turbo
```bash
cd /Users/tekhletvault/OrBeit\ AG\ Build/app
git ls-files --error-unmatch lib/firebase_options.dart 2>&1 | grep -q "not in version control" && echo "✅ firebase_options.dart untracked" || echo "❌ firebase_options.dart still tracked"
```

### 2. .gitignore Contains Security Rules
// turbo
```bash
cd /Users/tekhletvault/OrBeit\ AG\ Build
grep -q "firebase_options.dart" .gitignore && echo "✅ firebase_options in gitignore" || echo "❌ Missing from gitignore"
grep -q "google-services.json" .gitignore && echo "✅ google-services in gitignore" || echo "❌ Missing from gitignore"
grep -q "GoogleService-Info.plist" .gitignore && echo "✅ GoogleService-Info in gitignore" || echo "❌ Missing from gitignore"
```

### 3. Firestore Rules Secure
// turbo
```bash
cd /Users/tekhletvault/OrBeit\ AG\ Build
grep -q "request.auth.uid" firestore.rules && echo "✅ Firestore rules require auth" || echo "❌ Firestore rules may be open"
```

### 4. Storage Rules Exist
// turbo
```bash
cd /Users/tekhletvault/OrBeit\ AG\ Build
test -f storage.rules && echo "✅ storage.rules exists" || echo "❌ storage.rules missing"
```

### 5. No Hardcoded Secrets
// turbo
```bash
cd /Users/tekhletvault/OrBeit\ AG\ Build/app/lib
grep -rn "AIza\|sk-\|pk_live\|sk_live" . 2>/dev/null | head -5 || echo "✅ No hardcoded API keys found"
```

## Expected Result
All items should show ✅. Any ❌ requires immediate remediation.

## If Failed
Run `/fix-security` to address issues.
