/// OrBeit Domain Entity: Genesis Kit (Archetype)
///
/// A pre-defined cluster of nodes (buildings, vehicles, objects) that
/// form a cohesive "Starter Pack" for the user's sovereign life.
///
/// **Philosophy:**
/// Users don't buy a single brick. They adopt a lifestyle.
/// The "Steward" archetype is the foundational unit of production.
class GenesisKit {
  final String id;
  final String name;
  final String description;
  final List<GenesisNode> nodes;
  final List<GenesisTask> tasks;

  const GenesisKit({
    required this.id,
    required this.name,
    required this.description,
    required this.nodes,
    this.tasks = const [],
  });

  /// The "Steward" Archetype: Home, Barn, Truck, Feed Log
  static const steward = GenesisKit(
    id: 'steward_archetype',
    name: 'The Steward',
    description: 'The foundation of sovereignty: Home, Barn, and Transport.',
    nodes: [
      GenesisNode(
        type: 'farmhouse_base',
        offsetX: 0,
        offsetY: 0,
        rotation: 0,
      ),
      GenesisNode(
        type: 'barn_red_big',
        offsetX: 3,
        offsetY: -2,
        rotation: 90,
      ),
      GenesisNode(
        type: 'pickup_truck_white',
        offsetX: -2,
        offsetY: 1,
        rotation: 0,
      ),
      GenesisNode(
        type: 'feed_log_station', // Represents the core operational record
        offsetX: 2,
        offsetY: -2, // Located near/in the barn
        rotation: 0,
      ),
    ],
    tasks: [
      GenesisTask(
        title: 'Inspect the Perimeter',
        description: 'Walk the property line and verify security.',
        relativeX: 0,
        relativeY: 4, // At the edge
      ),
      GenesisTask(
        title: 'Log Initial Inventory',
        description: 'Record existing tools and feed levels.',
        relativeX: 2,
        relativeY: -2, // At the barn/feed log
      ),
    ],
  );

  /// The "Town" Archetype: Pharmacy, Doctor, Garden, Trees
  static const town = GenesisKit(
    id: 'town_archetype',
    name: 'The Settlement',
    description: 'A small community hub with health and growth.',
    nodes: [
      GenesisNode(
        type: 'pharmacy_small',
        offsetX: 0,
        offsetY: 0,
      ),
      GenesisNode(
        type: 'doctor_office',
        offsetX: 4,
        offsetY: 0,
      ),
      GenesisNode(
        type: 'garden_plot',
        offsetX: 2,
        offsetY: 3,
      ),
      GenesisNode(
        type: 'oak_tree',
        offsetX: -2,
        offsetY: 2,
      ),
       GenesisNode(
        type: 'pine_tree',
        offsetX: 6,
        offsetY: 2,
      ),
    ],
    tasks: [
      GenesisTask(
        title: 'Register with Dr. Smith',
        description: 'Set up initial health consultation.',
        relativeX: 4,
        relativeY: 0, 
      ),
       GenesisTask(
        title: 'Plant Spring Seeds',
        description: 'Prepare the garden plot for the season.',
        relativeX: 2,
        relativeY: 3, 
      ),
    ],
  );
}

/// A node definition within a Genesis Kit
class GenesisNode {
  final String type;
  final double offsetX; // Relative to click point
  final double offsetY; // Relative to click point
  final int rotation;

  const GenesisNode({
    required this.type,
    required this.offsetX,
    required this.offsetY,
    this.rotation = 0,
  });
}

/// A task definition within a Genesis Kit
class GenesisTask {
  final String title;
  final String description;
  final double relativeX;
  final double relativeY;

  const GenesisTask({
    required this.title,
    required this.description,
    required this.relativeX,
    required this.relativeY,
  });
}
