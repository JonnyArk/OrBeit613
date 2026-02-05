/// OrBeit Domain Entity: Building
///
/// Represents a physical structure placed in the Sovereign Sanctum world.
/// This is the core domain model, independent of database or UI concerns.
///
/// **Sovereign OS Context:**
/// In the OrBeit system, a Building is a persistent spatial anchor that
/// exists in the user's "Life Operating System". Buildings can be houses,
/// workspaces, or any structure that organizes the user's digital life.
class Building {
  /// Unique identifier for this building
  final int id;

  /// Building type identifier (e.g., 'farmhouse_white', 'modern_office')
  final String type;

  /// X coordinate in the isometric grid
  final double x;

  /// Y coordinate in the isometric grid
  final double y;

  /// Rotation in degrees (0, 90, 180, 270)
  final int rotation;

  /// Timestamp when the building was placed
  final DateTime placedAt;

  const Building({
    required this.id,
    required this.type,
    required this.x,
    required this.y,
    required this.rotation,
    required this.placedAt,
  });

  /// Creates a copy of this Building with optional field overrides
  Building copyWith({
    int? id,
    String? type,
    double? x,
    double? y,
    int? rotation,
    DateTime? placedAt,
  }) {
    return Building(
      id: id ?? this.id,
      type: type ?? this.type,
      x: x ?? this.x,
      y: y ?? this.y,
      rotation: rotation ?? this.rotation,
      placedAt: placedAt ?? this.placedAt,
    );
  }

  @override
  String toString() => 'Building(id: $id, type: $type, x: $x, y: $y)';
}
