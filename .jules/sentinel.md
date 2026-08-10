## 2025-05-18 - Missing Authentication on onRequest Endpoints
**Vulnerability:** The \`creditUsage\`, \`generateAsset\`, and \`distillContext\` endpoints were exposed without any authentication, allowing unauthenticated attackers to trigger AI operations.
**Learning:** When using \`onRequest\` instead of \`onCall\`, authentication is not handled automatically by Firebase. We must manually verify the ID token.
**Prevention:** Always implement an authentication check (e.g., using \`getAuth().verifyIdToken\`) for \`onRequest\` endpoints that perform sensitive or resource-intensive operations.
