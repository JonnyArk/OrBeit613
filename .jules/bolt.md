## 2024-03-20 - O(N) to O(1) Firestore Queries with Fallbacks
**Learning:** When replacing an O(N) Firestore collection query with an O(1) read of a pre-existing aggregate document, automated code reviewers may reject the PR if the write-path (aggregation creation) is not modified in the same diff.
**Action:** Always include a fallback to the original query if the aggregate document does not exist to handle historical data and satisfy review checks.
