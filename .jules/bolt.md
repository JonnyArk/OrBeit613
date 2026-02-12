## 2024-05-22 - [Image Decoding Optimization]
**Learning:** The Flutter `Image.file` widget decodes images to their full resolution by default, leading to excessive memory usage when displaying thumbnails or previews.
**Action:** Always specify `cacheWidth` or `cacheHeight` on `Image` widgets (especially in lists or grids) to decode only the necessary dimensions, significantly reducing memory footprint.
