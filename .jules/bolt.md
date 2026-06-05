## 2026-06-05 - Server-side Aggregation in Firestore
**Learning:** Using `snapshot.forEach()` on client-side to calculate sums over a Firestore collection causes unnecessary network overhead and memory usage by downloading every document.
**Action:** Use `AggregateField.sum()` from `firebase-admin/firestore` to let the database calculate the sum server-side and only return the final value, reducing data transfer significantly.
