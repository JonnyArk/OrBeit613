## 2024-06-21 - Fix Missing Authentication on Sensitive Endpoints
**Vulnerability:** Missing authentication on AI service endpoints (`generateAsset`, `distillContext`).
**Learning:** These endpoints had `secrets` configured (e.g., `googleAIUltraKey`), but lacked explicit authentication checks like `requireAuth`. This meant anyone could access the AI services, potentially exhausting quota or generating unwanted assets.
**Prevention:** When exposing sensitive HTTP functions via `onRequest` that aren't strictly public, verify that authentication middleware (e.g., combining `requireAuth` with CORS) wraps the core function logic.
