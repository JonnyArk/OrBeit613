/// OrBeit Domain Entity: LifeEvent
///
/// Represents a significant moment in the user's life.
/// Captures purchases, appointments, milestones, and memories.
///
/// **Sovereign OS Context:**
/// LifeEvents form the narrative of the user's existence. They're not
/// just calendar entries—they're the story of a life, spatially anchored
/// and AI-enhanced for recall and pattern recognition.
class LifeEvent {
  /// Unique identifier for this event
  final int id;

  /// Event type: 'purchase', 'appointment', 'milestone', 'memory'
  final String eventType;

  /// Event title
  final String title;

  /// Optional detailed description
  final String? description;

  /// Human-readable location label
  final String? locationLabel;

  /// When the event occurred
  final DateTime occurredAt;

  /// JSON-encoded metadata (receipts, links, etc.)
  final String? metadata;

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

  /// Creates a copy with optional field overrides
  LifeEvent copyWith({
    int? id,
    String? eventType,
    String? title,
    String? description,
    String? locationLabel,
    DateTime? occurredAt,
    String? metadata,
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
