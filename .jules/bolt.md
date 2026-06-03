## 2026-06-03 - Optimize getMonthlyUsage using server-side aggregation
**Learning:** Calling `snapshot.forEach` on a large Firebase collection directly on the client to calculate a single summary statistic (like a sum) forces unnecessary reads, O(n) memory allocation, and high bandwidth usage.
**Action:** Use Firestore's native server-side aggregation (`AggregateField.sum`) instead. It converts O(n) processing overhead into an O(1) database operation and dramatically speeds up metrics-heavy Cloud Functions.
