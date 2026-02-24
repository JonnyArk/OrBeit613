/// OrBeit Data Layer - Life Events Repository Implementation
///
/// Drift-based implementation for life event persistence.
/// Handles purchases, appointments, milestones, and memories.

import 'package:drift/drift.dart';
import '../../domain/entities/life_event.dart' as domain;
import '../../domain/repositories/life_event_repository.dart';
import '../database.dart';

/// Drift implementation of LifeEventRepository
class LifeEventRepositoryImpl implements LifeEventRepository {
  final AppDatabase _database;

  LifeEventRepositoryImpl(this._database);

  @override
  Future<List<domain.LifeEvent>> getAllEvents() async {
    final rows = await (_database.select(_database.lifeEvents)
      ..orderBy([(t) => OrderingTerm.desc(t.occurredAt)]))
      .get();
    return rows.map((row) => _toDomain(row)).toList();
  }

  @override
  Future<List<domain.LifeEvent>> getEventsByType(domain.LifeEventType type) async {
    final typeStr = _typeToString(type);
    final query = _database.select(_database.lifeEvents)
      ..where((t) => t.eventType.equals(typeStr))
      ..orderBy([(t) => OrderingTerm.desc(t.occurredAt)]);
    final rows = await query.get();
    return rows.map((row) => _toDomain(row)).toList();
  }

  @override
  Future<List<domain.LifeEvent>> getEventsInRange(DateTime start, DateTime end) async {
    final query = _database.select(_database.lifeEvents)
      ..where((t) => 
        t.occurredAt.isBiggerOrEqualValue(start) & 
        t.occurredAt.isSmallerThanValue(end))
      ..orderBy([(t) => OrderingTerm.desc(t.occurredAt)]);
    final rows = await query.get();
    return rows.map((row) => _toDomain(row)).toList();
  }

  @override
  Future<domain.LifeEvent> createEvent({
    required domain.LifeEventType eventType,
    required String title,
    String? description,
    String? locationLabel,
    required DateTime occurredAt,
    Map<String, dynamic>? metadata,
  }) async {
    final id = await _database.into(_database.lifeEvents).insert(
      LifeEventsCompanion.insert(
        eventType: _typeToString(eventType),
        title: title,
        description: Value(description),
        locationLabel: Value(locationLabel),
        occurredAt: occurredAt,
        metadata: Value(metadata?.toString()),
      ),
    );

    return domain.LifeEvent(
      id: id,
      eventType: eventType,
      title: title,
      description: description,
      locationLabel: locationLabel,
      occurredAt: occurredAt,
      metadata: metadata,
      createdAt: DateTime.now(),
    );
  }

  @override
  Future<bool> deleteEvent(int id) async {
    final count = await (_database.delete(_database.lifeEvents)
          ..where((t) => t.id.equals(id)))
        .go();
    return count > 0;
  }

  domain.LifeEvent _toDomain(dynamic row) {
    return domain.LifeEvent(
      id: row.id as int,
      eventType: _stringToType(row.eventType as String),
      title: row.title as String,
      description: row.description as String?,
      locationLabel: row.locationLabel as String?,
      occurredAt: row.occurredAt as DateTime,
      createdAt: row.createdAt as DateTime,
      // Metadata is currently ignored in retrieval as per original implementation
    );
  }

  String _typeToString(domain.LifeEventType type) {
    switch (type) {
      case domain.LifeEventType.purchase: return 'purchase';
      case domain.LifeEventType.appointment: return 'appointment';
      case domain.LifeEventType.milestone: return 'milestone';
      case domain.LifeEventType.memory: return 'memory';
    }
  }

  domain.LifeEventType _stringToType(String type) {
    switch (type) {
      case 'purchase': return domain.LifeEventType.purchase;
      case 'appointment': return domain.LifeEventType.appointment;
      case 'milestone': return domain.LifeEventType.milestone;
      default: return domain.LifeEventType.memory;
    }
  }
}
