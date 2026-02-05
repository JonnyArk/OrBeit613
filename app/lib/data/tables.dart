/// OrBeit Data Layer - Table Definitions
///
/// Defines the database schema for the OrBeit Sovereign OS.
///
/// **Schema Philosophy:**
/// - Minimal columns for rapid iteration
/// - Spatial data (x, y) for isometric positioning
/// - Timestamps for synchronization and analytics
///
/// **For Future Agents:**
/// - Define new tables as classes extending `Table`
/// - All primary keys should use `autoIncrement()`
/// - Use `withDefault()` for optional fields with defaults
/// - After changes, run: `dart run build_runner build`

import 'package:drift/drift.dart';

/// Buildings table - stores all placed structures in the Sovereign Sanctum
///
/// Each row represents a single building (house, workspace, etc.)
/// positioned on the isometric grid.
class Buildings extends Table {
  /// Auto-incrementing primary key
  IntColumn get id => integer().autoIncrement()();
  
  /// Building type identifier (e.g., 'farmhouse_white', 'modern_office')
  /// Used to determine visual asset and behavior
  TextColumn get type => text()();
  
  /// X coordinate in isometric grid space
  RealColumn get x => real()();
  
  /// Y coordinate in isometric grid space
  RealColumn get y => real()();
  
  /// Rotation in degrees (0, 90, 180, 270)
  /// Defaults to 0 (facing north)
  IntColumn get rotation => integer().withDefault(const Constant(0))();
  
  /// Timestamp when building was placed
  /// Automatically set to current time
  DateTimeColumn get placedAt => dateTime().withDefault(currentDateAndTime)();
}

/// Tasks table - stores spatial task markers in the Sovereign Sanctum
///
/// Tasks can be anchored to buildings or placed freely on the grid.
/// Used for "Fix the fence" type contextual reminders.
class Tasks extends Table {
  /// Auto-incrementing primary key
  IntColumn get id => integer().autoIncrement()();

  /// Task title (e.g., "Fix the fence")
  TextColumn get title => text()();

  /// Optional detailed description
  TextColumn get description => text().nullable()();

  /// Foreign key to building (nullable for grid-only tasks)
  IntColumn get buildingId => integer().nullable().references(Buildings, #id)();

  /// X coordinate for task marker position
  RealColumn get gridX => real().nullable()();

  /// Y coordinate for task marker position
  RealColumn get gridY => real().nullable()();

  /// Due date for the task (nullable for open-ended tasks)
  DateTimeColumn get dueDate => dateTime().nullable()();

  /// Completion timestamp (null = not completed)
  DateTimeColumn get completedAt => dateTime().nullable()();

  /// Priority level: 0=low, 1=normal, 2=high, 3=urgent
  IntColumn get priority => integer().withDefault(const Constant(1))();

  /// Created timestamp
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  /// Updated timestamp
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

/// LifeEvents table - stores significant moments and transactions
///
/// Captures purchases, appointments, milestones, and memories
/// that form the narrative of the user's "Sovereign OS" life.
class LifeEvents extends Table {
  /// Auto-incrementing primary key
  IntColumn get id => integer().autoIncrement()();

  /// Event type: 'purchase', 'appointment', 'milestone', 'memory'
  TextColumn get eventType => text()();

  /// Event title (e.g., "Bought new laptop", "Doctor appointment")
  TextColumn get title => text()();

  /// Optional detailed description
  TextColumn get description => text().nullable()();

  /// Human-readable location (e.g., "Home Office", "Downtown Clinic")
  TextColumn get locationLabel => text().nullable()();

  /// When the event occurred
  DateTimeColumn get occurredAt => dateTime()();

  /// JSON blob for flexible metadata (receipts, notes, links)
  TextColumn get metadata => text().nullable()();

  /// Created timestamp
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}
