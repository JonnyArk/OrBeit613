## 2025-04-18 - Missing Authentication on Cloud Functions Endpoints
**Vulnerability:** The `generateAsset` and `distillContext` endpoints in `functions/src/index.ts` did not verify authentication tokens and blindly trusted the `userId` passed in the request payload.
**Learning:** This exposes the application to Insecure Direct Object Reference (IDOR) / user spoofing, and allows unauthenticated attackers to trigger expensive API calls to Google AI Ultra.
**Prevention:** Always wrap sensitive `onRequest` Cloud Functions with token validation (e.g., using a custom `requireAuth` helper and `getAuth().verifyIdToken()`). Never trust the client's `userId`; override `body.userId` with the `uid` derived from the verified token.
