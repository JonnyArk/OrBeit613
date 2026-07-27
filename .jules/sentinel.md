## YYYY-MM-DD - Convert onRequest to onCall for httpsCallable Auth
**Vulnerability:** Firebase Cloud Functions for AI asset generation were exposed as public `onRequest` REST APIs without authentication checks.
**Learning:** When a Flutter client uses `httpsCallable`, it assumes the backend uses `onCall`. If the backend mistakenly uses `onRequest`, it fails to natively unwrap the `{"data": payload}` structure and completely bypasses Firebase Authentication validation, leaving the endpoint publicly exposed.
**Prevention:** Always pair Flutter's `httpsCallable` with Firebase's `onCall` (never `onRequest`) to ensure built-in payload unwrapping and automatic authentication (`request.auth`) validation.
