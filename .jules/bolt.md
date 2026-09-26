## 2024-10-24 - O(N) Firestore Document Reads on Aggregation
**Learning:** Computing aggregate values by reading and summing up all documents on the fly is an O(N) operation and a known anti-pattern in Firestore, which charges per document read.
**Action:** Replace the expensive collection query loop with an O(1) single-document read of a pre-aggregated counter document that is already maintained by the system.
