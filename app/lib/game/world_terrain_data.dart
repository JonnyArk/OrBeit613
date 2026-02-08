/// OrBeit Spatial Layer - World Terrain Data
///
/// Generates and stores the terrain layout for the isometric world.
/// Uses procedural generation with seeded randomness to create
/// a natural-feeling landscape with grass, paths, water, and variety.

import 'dart:math';
import 'terrain_tile.dart';

/// Holds the terrain data for the entire world grid
class WorldTerrainData {
  final int columns;
  final int rows;
  late final List<List<TerrainType>> _grid;

  WorldTerrainData({
    this.columns = 20,
    this.rows = 20,
    int? seed,
  }) {
    _grid = _generateTerrain(seed ?? 42);
  }

  /// Gets the terrain type at a specific grid position
  TerrainType getTile(int col, int row) {
    if (col < 0 || col >= columns || row < 0 || row >= rows) {
      return TerrainType.empty;
    }
    return _grid[col][row];
  }

  /// Sets a tile type at a specific position (for user terrain painting)
  void setTile(int col, int row, TerrainType type) {
    if (col >= 0 && col < columns && row >= 0 && row < rows) {
      _grid[col][row] = type;
    }
  }

  /// Generates a natural-feeling terrain layout
  List<List<TerrainType>> _generateTerrain(int seed) {
    final random = Random(seed);
    final grid = List.generate(
      columns,
      (_) => List.filled(rows, TerrainType.grass),
    );

    // 1. Scatter darker grass patches for visual variety
    for (int col = 0; col < columns; col++) {
      for (int row = 0; row < rows; row++) {
        if (random.nextDouble() < 0.25) {
          grid[col][row] = TerrainType.grassDark;
        }
      }
    }

    // 2. Create a winding river through the world
    _carveRiver(grid, random);

    // 3. Add a main road system
    _carveRoads(grid);

    // 4. Add a small pond area
    _carvePond(grid, random);

    // 5. Add some sandy patches near water
    _addSandBanks(grid);

    // 6. Add dirt paths branching off roads
    _addDirtPaths(grid, random);

    return grid;
  }

  /// Creates a winding river across the map
  void _carveRiver(List<List<TerrainType>> grid, Random random) {
    // River flows roughly from top-right to bottom-left
    double riverRow = 2.0 + random.nextDouble() * 3;
    for (int col = columns - 1; col >= 0; col--) {
      // Meander
      riverRow += (random.nextDouble() - 0.4) * 1.5;
      riverRow = riverRow.clamp(1, rows - 2);

      final r = riverRow.round();
      // Make river 2 tiles wide
      for (int w = 0; w < 2; w++) {
        final rr = r + w;
        if (rr >= 0 && rr < rows) {
          grid[col][rr] = TerrainType.water;
        }
      }
    }
  }

  /// Creates a simple road grid (horizontal + vertical through center)
  void _carveRoads(List<List<TerrainType>> grid) {
    // Horizontal road through the lower-middle area
    final roadRow = rows ~/ 2 + 3;
    for (int col = 0; col < columns; col++) {
      if (roadRow < rows && grid[col][roadRow] != TerrainType.water) {
        grid[col][roadRow] = TerrainType.road;
      }
    }

    // Vertical road down the left-center
    final roadCol = columns ~/ 3;
    for (int row = 0; row < rows; row++) {
      if (grid[roadCol][row] != TerrainType.water) {
        grid[roadCol][row] = TerrainType.road;
      }
    }
  }

  /// Creates a small pond
  void _carvePond(List<List<TerrainType>> grid, Random random) {
    // Pond in the lower-right quadrant
    final centerCol = columns * 3 ~/ 4;
    final centerRow = rows * 3 ~/ 4;

    for (int col = centerCol - 2; col <= centerCol + 2; col++) {
      for (int row = centerRow - 1; row <= centerRow + 1; row++) {
        if (col >= 0 && col < columns && row >= 0 && row < rows) {
          final dist = ((col - centerCol).abs() + (row - centerRow).abs());
          if (dist <= 2 && grid[col][row] != TerrainType.road) {
            grid[col][row] = TerrainType.water;
          }
        }
      }
    }
  }

  /// Adds sand tiles adjacent to water
  void _addSandBanks(List<List<TerrainType>> grid) {
    // Create a copy to check neighbors without modifying during iteration
    final snapshot = List.generate(
      columns,
      (c) => List<TerrainType>.from(grid[c]),
    );

    for (int col = 0; col < columns; col++) {
      for (int row = 0; row < rows; row++) {
        if (snapshot[col][row] != TerrainType.water) continue;

        // Check all 4 neighbors
        for (final d in [[-1, 0], [1, 0], [0, -1], [0, 1]]) {
          final nc = col + d[0];
          final nr = row + d[1];
          if (nc >= 0 && nc < columns && nr >= 0 && nr < rows) {
            if (snapshot[nc][nr] == TerrainType.grass ||
                snapshot[nc][nr] == TerrainType.grassDark) {
              grid[nc][nr] = TerrainType.sand;
            }
          }
        }
      }
    }
  }

  /// Adds small dirt path segments branching from roads
  void _addDirtPaths(List<List<TerrainType>> grid, Random random) {
    for (int col = 0; col < columns; col++) {
      for (int row = 0; row < rows; row++) {
        if (grid[col][row] != TerrainType.road) continue;

        // 15% chance of a dirt path branching off
        if (random.nextDouble() < 0.15) {
          final dir = random.nextInt(4); // 0=up, 1=right, 2=down, 3=left
          final dx = [0, 1, 0, -1][dir];
          final dy = [-1, 0, 1, 0][dir];

          // Extend 2-3 tiles
          final length = 2 + random.nextInt(2);
          for (int i = 1; i <= length; i++) {
            final nc = col + dx * i;
            final nr = row + dy * i;
            if (nc >= 0 && nc < columns && nr >= 0 && nr < rows) {
              if (grid[nc][nr] == TerrainType.grass ||
                  grid[nc][nr] == TerrainType.grassDark) {
                grid[nc][nr] = TerrainType.dirtPath;
              }
            }
          }
        }
      }
    }
  }
}
