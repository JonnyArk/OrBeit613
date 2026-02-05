import '../entities/life_event.dart';

/// Repository interface for LifeEvent persistence operations.
///
/// This interface defines the contract for managing life events -
/// purchases, appointments, milestones, and memories that form
/// the narrative of the user's Sovereign OS.
///
/// **Clean Architecture:**
/// Domain layer interface - no implementation dependencies.
abstract class LifeEventRepository {
  /// Retrieves all life events from the data source.
  ///
  /// Returns events ordered by [occurredAt] descending (most recent first).
  Future<List<LifeEvent>> getAllEvents();

  /// Retrieves events filtered by type.
  ///
  /// Valid types: 'purchase', 'appointment', 'milestone', 'memory'.
  Future<List<LifeEvent>> getEventsByType(String eventType);

  /// Retrieves events within a date range.
  ///
  /// Useful for timeline views and monthly summaries.
  Future<List<LifeEvent>> getEventsInRange(DateTime start, DateTime end);

  /// Retrieves a specific event by its unique identifier.
  ///
  /// Returns `null` if no event with the given [id] exists.
  Future<LifeEvent?> getEventById(int id);

  /// Creates a new life event.
  ///
  /// Returns the persisted [LifeEvent] with its generated ID.
  Future<LifeEvent> createEvent({
    required String eventType,
    required String title,
    String? description,
    String? locationLabel,
    required DateTime occurredAt,
    String? metadata,
  });

  /// Updates an existing life event.
  ///
  /// Returns the updated [LifeEvent].
  Future<LifeEvent> updateEvent(LifeEvent event);

  /// Removes a life event from the data source.
  ///
  /// Returns `true` if deleted, `false` if it didn't exist.
  Future<bool> deleteEvent(int id);

  /// Searches events by title or description.
  ///
  /// Case-insensitive substring matching.
  Future<List<LifeEvent>> searchEvents(String query);
}
