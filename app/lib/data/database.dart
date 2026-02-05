/// OrBeit Local Database - Drift Configuration
///
/// This file defines the main database connection and table registry
/// for the OrBeit application's local persistence layer.
///
/// **Architecture:**
/// - Uses Drift for type-safe SQL operations
/// - SQLite backend via NativeDatabase
/// - All tables defined in separate `tables.dart` file
///
/// **For Future Agents:**
/// - Add new tables to the @DriftDatabase annotation
/// - Increment schemaVersion when modifying schema
/// - Run `dart run build_runner build` after changes
/// - Database file location: `<app_documents>/db.sqlite`
///
/// **Sovereign OS Context:**
/// This database stores the user's "spatial life data" - buildings,
/// tasks, life events - all anchored to the isometric world.

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'dart:io';

import 'tables.dart';

part 'database.g.dart';

/// Main application database
///
/// Manages all persistent data for the OrBeit Sovereign OS.
/// Auto-generates DAO methods via Drift code generation.
@DriftDatabase(tables: [Buildings, Tasks, LifeEvents])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        if (from < 2) {
          // Schema v2: Add Tasks and LifeEvents tables
          await m.createTable(tasks);
          await m.createTable(lifeEvents);
        }
      },
    );
  }
}

/// Opens the SQLite database connection
///
/// Uses application documents directory for persistent storage.
/// Creates database file lazily on first access.
LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}

