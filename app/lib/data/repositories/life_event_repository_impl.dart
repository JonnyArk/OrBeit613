import 'package:drift/drift.dart';
import '../../domain/entities/life_event.dart' as domain;
import '../../domain/repositories/life_event_repository.dart';
import '../database.dart';

/// Drift-based implementation of [LifeEventRepository].
///
/// Bridges the domain layer with the Drift database,
/// converting between database models and domain entities.
class LifeEventRepositoryImpl implements LifeEventRepository {
  final AppDatabase _database;

  LifeEventRepositoryImpl(this._database);

  @override
  Future<List<domain.LifeEvent>> getAllEvents() async {
    final query = _database.select(_database.lifeEvents)
      ..orderBy([
        (e) => OrderingTerm(expression: e.occurredAt, mode: OrderingMode.desc),
      ]);
    final rows = await query.get();
    return rows.map(_toDomainEvent).toList();
  }

  @override
  Future<List<domain.LifeEvent>> getEventsByType(String eventType) async {
    final query = _database.select(_database.lifeEvents)
      ..where((e) => e.eventType.equals(eventType))
      ..orderBy([
        (e) => OrderingTerm(expression: e.occurredAt, mode: OrderingMode.desc),
      ]);
    final rows = await query.get();
    return rows.map(_toDomainEvent).toList();
  }

  @override
  Future<List<domain.LifeEvent>> getEventsInRange(
    DateTime start,
    DateTime end,
  ) async {
    final query = _database.select(_database.lifeEvents)
      ..where((e) =>
          e.occurredAt.isBiggerOrEqualValue(start) &
          e.occurredAt.isSmallerOrEqualValue(end))
      ..orderBy([
        (e) => OrderingTerm(expression: e.occurredAt, mode: OrderingMode.desc),
      ]);
    final rows = await query.get();
    return rows.map(_toDomainEvent).toList();
  }

  @override
  Future<domain.LifeEvent?> getEventById(int id) async {
    final query = _database.select(_database.lifeEvents)
      ..where((e) => e.id.equals(id));
    final row = await query.getSingleOrNull();
    return row != null ? _toDomainEvent(row) : null;
  }

  @override
  Future<domain.LifeEvent> createEvent({
    required String eventType,
    required String title,
    String? description,
    String? locationLabel,
    required DateTime occurredAt,
    String? metadata,
  }) async {
    final now = DateTime.now();
    final id = await _database.into(_database.lifeEvents).insert(
      LifeEventsCompanion.insert(
        eventType: eventType,
        title: title,
        description: Value(description),
        locationLabel: Value(locationLabel),
        occurredAt: occurredAt,
        metadata: Value(metadata),
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
      createdAt: now,
    );
  }

  @override
  Future<domain.LifeEvent> updateEvent(domain.LifeEvent event) async {
    await (_database.update(_database.lifeEvents)
          ..where((e) => e.id.equals(event.id)))
        .write(
      LifeEventsCompanion(
        eventType: Value(event.eventType),
        title: Value(event.title),
        description: Value(event.description),
        locationLabel: Value(event.locationLabel),
        occurredAt: Value(event.occurredAt),
        metadata: Value(event.metadata),
      ),
    );
    return event;
  }

  @override
  Future<bool> deleteEvent(int id) async {
    final count = await (_database.delete(_database.lifeEvents)
          ..where((e) => e.id.equals(id)))
        .go();
    return count > 0;
  }

  @override
  Future<List<domain.LifeEvent>> searchEvents(String query) async {
    final pattern = '%$query%';
    final dbQuery = _database.select(_database.lifeEvents)
      ..where((e) => e.title.like(pattern) | e.description.like(pattern))
      ..orderBy([
        (e) => OrderingTerm(expression: e.occurredAt, mode: OrderingMode.desc),
      ]);
    final rows = await dbQuery.get();
    return rows.map(_toDomainEvent).toList();
  }

  domain.LifeEvent _toDomainEvent(LifeEvent row) {
    return domain.LifeEvent(
      id: row.id,
      eventType: row.eventType,
      title: row.title,
      description: row.description,
      locationLabel: row.locationLabel,
      occurredAt: row.occurredAt,
      metadata: row.metadata,
      createdAt: row.createdAt,
    );
  }
}
