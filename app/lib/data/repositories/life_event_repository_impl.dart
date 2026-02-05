/// OrBeit Data Layer - Life Events Repository Implementation
///
/// Drift-based implementation for life event persistence.
/// Handles purchases, appointments, milestones, and memories.

import 'package:drift/drift.dart';
import '../database.dart';

/// Types of life events
enum LifeEventType { purchase, appointment, milestone, memory }

/// Domain entity for a Life Event
class LifeEvent {
  final int id;
  final LifeEventType eventType;
  final String title;
  final String? description;
  final String? locationLabel;
  final DateTime occurredAt;
  final Map<String, dynamic>? metadata;
  final DateTime createdAt;

  const LifeEvent({
    required this.id,
    required this.eventType,
    required this.title,
    this.description,
    this.locationLabel,
    required this.occurredAt,
    this.metadata,
    required this.createdAt,
  });
}

/// Repository for life events
abstract class LifeEventRepository {
  Future<List<LifeEvent>> getAllEvents();
  Future<List<LifeEvent>> getEventsByType(LifeEventType type);
  Future<List<LifeEvent>> getEventsInRange(DateTime start, DateTime end);
  Future<LifeEvent> createEvent({
    required LifeEventType eventType,
    required String title,
    String? description,
    String? locationLabel,
    required DateTime occurredAt,
    Map<String, dynamic>? metadata,
  });
  Future<bool> deleteEvent(int id);
}

/// Drift implementation of LifeEventRepository
class LifeEventRepositoryImpl implements LifeEventRepository {
  final AppDatabase _database;

  LifeEventRepositoryImpl(this._database);

  @override
  Future<List<LifeEvent>> getAllEvents() async {
    final rows = await (_database.select(_database.lifeEvents)
      ..orderBy([(t) => OrderingTerm.desc(t.occurredAt)]))
      .get();
    return rows.map((row) => _toDomain(row)).toList();
  }

  @override
  Future<List<LifeEvent>> getEventsByType(LifeEventType type) async {
    final typeStr = _typeToString(type);
    final query = _database.select(_database.lifeEvents)
      ..where((t) => t.eventType.equals(typeStr))
      ..orderBy([(t) => OrderingTerm.desc(t.occurredAt)]);
    final rows = await query.get();
    return rows.map((row) => _toDomain(row)).toList();
  }

  @override
  Future<List<LifeEvent>> getEventsInRange(DateTime start, DateTime end) async {
    final query = _database.select(_database.lifeEvents)
      ..where((t) => 
        t.occurredAt.isBiggerOrEqualValue(start) & 
        t.occurredAt.isSmallerThanValue(end))
      ..orderBy([(t) => OrderingTerm.desc(t.occurredAt)]);
    final rows = await query.get();
    return rows.map((row) => _toDomain(row)).toList();
  }

  @override
  Future<LifeEvent> createEvent({
    required LifeEventType eventType,
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

    return LifeEvent(
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

  LifeEvent _toDomain(dynamic row) {
    return LifeEvent(
      id: row.id as int,
      eventType: _stringToType(row.eventType as String),
      title: row.title as String,
      description: row.description as String?,
      locationLabel: row.locationLabel as String?,
      occurredAt: row.occurredAt as DateTime,
      createdAt: row.createdAt as DateTime,
    );
  }

  String _typeToString(LifeEventType type) {
    switch (type) {
      case LifeEventType.purchase: return 'purchase';
      case LifeEventType.appointment: return 'appointment';
      case LifeEventType.milestone: return 'milestone';
      case LifeEventType.memory: return 'memory';
    }
  }

  LifeEventType _stringToType(String type) {
    switch (type) {
      case 'purchase': return LifeEventType.purchase;
      case 'appointment': return LifeEventType.appointment;
      case 'milestone': return LifeEventType.milestone;
      default: return LifeEventType.memory;
    }
  }
}
