import '../entities/life_event.dart';

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
