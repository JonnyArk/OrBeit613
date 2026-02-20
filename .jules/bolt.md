## 2024-05-23 - Flutter Environment Verification
**Learning:** Modifying `pubspec.yaml` to fix SDK constraints for verification can inadvertently modify `pubspec.lock` and introduce breaking changes by removing dependencies.
**Action:** Always backup `pubspec.lock` before modifying `pubspec.yaml` for verification, and restore both before submission. Alternatively, avoid verifying with modified environment if possible.
