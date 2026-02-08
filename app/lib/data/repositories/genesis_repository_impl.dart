import 'package:drift/drift.dart';
import '../../domain/entities/genesis_kit.dart';
import '../../domain/repositories/genesis_repository.dart';
import '../database.dart';


/// Concrete implementation of [GenesisRepository] using drift transactions.
class GenesisRepositoryImpl implements GenesisRepository {
  final AppDatabase database;

  GenesisRepositoryImpl(this.database);

  @override
  Future<void> spawnKit(GenesisKit kit, double originX, double originY) async {
    await database.transaction(() async {
      // 1. Spawn Nodes (Buildings/Objects)
      for (final node in kit.nodes) {
        await database.into(database.buildings).insert(
              BuildingsCompanion.insert(
                type: node.type,
                x: originX + node.offsetX,
                y: originY + node.offsetY,
                rotation: Value(node.rotation),
                placedAt: Value(DateTime.now()),
              ),
            );
      }

      // 2. Spawn Tasks
      for (final task in kit.tasks) {
        await database.into(database.tasks).insert(
              TasksCompanion.insert(
                title: task.title,
                description: Value(task.description),
                // Tasks are placed relative to the origin
                gridX: Value(originX + task.relativeX),
                gridY: Value(originY + task.relativeY),
                createdAt: Value(DateTime.now()),
                updatedAt: Value(DateTime.now()),
                priority: const Value(2), // Give initial tasks high visibility
              ),
            );
      }
    });
  }
}
