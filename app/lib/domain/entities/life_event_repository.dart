/// OrBeit Domain - LifeEvent Repository Interface
///
/// Repository contract for persisting and retrieving Life Events.
/// Implementations can use Drift, Firestore, or any data source.

import 'life_event.dart';

/// Repository interface for LifeEvent persistence operations
abstract class LifeEventRepository {
  /// Retrieves all life events, ordered by occurredAt descending
  Future<List<LifeEvent>> getAllEvents();

  /// Retrieves events filtered by type
  Future<List<LifeEvent>> getEventsByType(String eventType);

  /// Retrieves events within a date range
  Future<List<LifeEvent>> getEventsBetween(DateTime start, DateTime end);

  /// Retrieves a specific event by ID
  Future<LifeEvent?> getEventById(int id);

  /// Creates a new life event
  Future<LifeEvent> createEvent({
    required String eventType,
    required String title,
    String? description,
    String? locationLabel,
    required DateTime occurredAt,
    String? metadata,
  });

  /// Updates an existing event
  Future<LifeEvent> updateEvent(LifeEvent event);

  /// Deletes an event
  Future<bool> deleteEvent(int id);

  /// Watches all events (reactive stream)
  Stream<List<LifeEvent>> watchAllEvents();

  /// Searches events by title/description
  Future<List<LifeEvent>> searchEvents(String query);
}
