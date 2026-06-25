## 2024-05-24 - Optimizing Task List Rendering correctly
**Learning:** In Flutter, passing pre-instantiated widgets into a `ListView.builder` doesn't provide performance optimization over `ListView`. The widgets will be instantiated upfront.
**Action:** When using `ListView.builder` to lazily construct lists from complex heterogeneous data, dynamically build the widget inside `itemBuilder` based on the item index. A good way is to flatten data into an array of objects representing what type of item it is, and map it inside the `itemBuilder`.
