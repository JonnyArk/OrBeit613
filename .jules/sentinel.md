
## 2024-04-02 - Unauthenticated AI Service Endpoints & IDOR Prevention
**Vulnerability:** Core AI endpoints (\`creditUsage\`, \`generateAsset\`, \`distillContext\`) using \`onRequest\` lacked authentication checks and trusted client-provided \`userId\` payloads, allowing unauthorized execution and IDOR (spoofing credit usage or caching behavior for other users).
**Learning:** When using standard HTTP endpoints (\`onRequest\`) instead of callable functions (\`onCall\`), authentication must be manually verified via headers, and any business logic requiring an identity must securely inject the derived \`uid\` from the token to override the client request body.
**Prevention:** Always use \`getAuth().verifyIdToken()\` on \`onRequest\` endpoints handling sensitive data, and overwrite \`body.userId\` with the verified token's \`uid\` before passing it to internal services.
