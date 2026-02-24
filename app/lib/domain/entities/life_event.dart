/// OrBeit Domain Entity: LifeEvent
///
/// Represents a significant moment in the user's life.
/// Captures purchases, appointments, milestones, and memories.
///
/// **Sovereign OS Context:**
/// LifeEvents form the narrative of the user's existence. They're not
/// just calendar entries—they're the story of a life, spatially anchored
/// and AI-enhanced for recall and pattern recognition.

/// Types of life events
enum LifeEventType { purchase, appointment, milestone, memory }

class LifeEvent {
  /// Unique identifier for this event
  final int id;

  /// Event type: purchase, appointment, milestone, memory
  final LifeEventType eventType;

  /// Event title
  final String title;

  /// Optional detailed description
  final String? description;

  /// Human-readable location label
  final String? locationLabel;

  /// When the event occurred
  final DateTime occurredAt;

  /// Metadata (receipts, links, etc.)
  final Map<String, dynamic>? metadata;

  /// Created timestamp
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

  /// Creates a copy with modified fields
  LifeEvent copyWith({
    int? id,
    LifeEventType? eventType,
    String? title,
    String? description,
    String? locationLabel,
    DateTime? occurredAt,
    Map<String, dynamic>? metadata,
    DateTime? createdAt,
  }) {
    return LifeEvent(
      id: id ?? this.id,
      eventType: eventType ?? this.eventType,
      title: title ?? this.title,
      description: description ?? this.description,
      locationLabel: locationLabel ?? this.locationLabel,
      occurredAt: occurredAt ?? this.occurredAt,
      metadata: metadata ?? this.metadata,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() => 'LifeEvent(id: $id, type: $eventType, title: $title)';
}
