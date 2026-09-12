1. **Wrap the `GestureDetector` in `app/lib/ui/or_beacon.dart` with a `Semantics` widget.**
   - Add a `Semantics` widget with `button: true` and an appropriate label like `'Activate voice assistant'` to make the main OrBeacon button accessible.
2. **Verify changes.**
   - Run `cd app && flutter analyze` to verify.
3. **Log learning.**
   - Add a journal entry to `.jules/palette.md` for this accessibility improvement, noting the importance of adding Semantics to custom widget interactions.
4. Complete pre-commit steps to ensure proper testing, verification, review, and reflection are done.
5. **Submit.**
   - Use `request_code_review` to submit the PR.
