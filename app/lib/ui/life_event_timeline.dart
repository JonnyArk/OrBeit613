/// OrBeit UI - Life Event Timeline
///
/// Vertical scrolling timeline that captures the narrative of a user's life.
/// Events are type-coded with icons and colors, ordered newest-first,
/// and connected by a golden timeline line.
///
/// **Event Types:**
/// - Purchase 🛒 (Teal)
/// - Appointment 📅 (Gold)
/// - Milestone 🏆 (Ruby)
/// - Memory 💭 (Warm White)

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../data/repositories/life_event_repository_impl.dart';
import '../providers/life_event_provider.dart';

/// Life Event Timeline panel widget
class LifeEventTimeline extends ConsumerStatefulWidget {
  const LifeEventTimeline({super.key});

  @override
  ConsumerState<LifeEventTimeline> createState() => _LifeEventTimelineState();
}

class _LifeEventTimelineState extends ConsumerState<LifeEventTimeline> {
  List<LifeEvent> _events = [];
  bool _loading = true;
  LifeEventType? _filterType;

  @override
  void initState() {
    super.initState();
    _loadEvents();
  }

  Future<void> _loadEvents() async {
    final repo = ref.read(lifeEventRepositoryProvider);
    final events = _filterType != null
        ? await repo.getEventsByType(_filterType!)
        : await repo.getAllEvents();
    if (mounted) {
      setState(() {
        _events = events;
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 360,
      height: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF0A0A12).withAlpha(245),
        border: const Border(
          left: BorderSide(color: Color(0xFFD4AF37), width: 2),
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFD4AF37).withAlpha(20),
            blurRadius: 20,
            offset: const Offset(-5, 0),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildHeader(),
          _buildFilterChips(),
          Expanded(child: _buildTimeline()),
          _buildAddButton(),
        ],
      ),
    );
  }

  // ── Header ────────────────────────────────────────────────

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Color(0xFF1A1A2E), width: 1),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFD4AF37).withAlpha(25),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.timeline,
              color: Color(0xFFD4AF37),
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Life Timeline',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
                Text(
                  'Your story unfolds here',
                  style: TextStyle(
                    color: Colors.white38,
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFF134E5E).withAlpha(60),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '${_events.length}',
              style: const TextStyle(
                color: Color(0xFFD4AF37),
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Filter Chips ──────────────────────────────────────────

  Widget _buildFilterChips() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _FilterChip(
              label: 'All',
              icon: Icons.all_inclusive,
              color: const Color(0xFFD4AF37),
              isSelected: _filterType == null,
              onTap: () => _applyFilter(null),
            ),
            const SizedBox(width: 8),
            _FilterChip(
              label: 'Purchases',
              icon: Icons.shopping_cart_outlined,
              color: const Color(0xFF134E5E),
              isSelected: _filterType == LifeEventType.purchase,
              onTap: () => _applyFilter(LifeEventType.purchase),
            ),
            const SizedBox(width: 8),
            _FilterChip(
              label: 'Appointments',
              icon: Icons.calendar_today_outlined,
              color: const Color(0xFFD4AF37),
              isSelected: _filterType == LifeEventType.appointment,
              onTap: () => _applyFilter(LifeEventType.appointment),
            ),
            const SizedBox(width: 8),
            _FilterChip(
              label: 'Milestones',
              icon: Icons.emoji_events_outlined,
              color: const Color(0xFF9B1B30),
              isSelected: _filterType == LifeEventType.milestone,
              onTap: () => _applyFilter(LifeEventType.milestone),
            ),
            const SizedBox(width: 8),
            _FilterChip(
              label: 'Memories',
              icon: Icons.favorite_outline,
              color: const Color(0xFFF5F0E8),
              isSelected: _filterType == LifeEventType.memory,
              onTap: () => _applyFilter(LifeEventType.memory),
            ),
          ],
        ),
      ),
    );
  }

  void _applyFilter(LifeEventType? type) {
    setState(() {
      _filterType = type;
      _loading = true;
    });
    _loadEvents();
  }

  // ── Timeline ──────────────────────────────────────────────

  Widget _buildTimeline() {
    if (_loading) {
      return const Center(
        child: CircularProgressIndicator(color: Color(0xFFD4AF37)),
      );
    }

    if (_events.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.auto_stories_outlined,
              size: 56,
              color: Colors.white.withAlpha(40),
            ),
            const SizedBox(height: 16),
            Text(
              'No events yet',
              style: TextStyle(
                color: Colors.white.withAlpha(80),
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Your story begins with the first entry',
              style: TextStyle(
                color: Colors.white.withAlpha(40),
                fontSize: 13,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      itemCount: _events.length,
      itemBuilder: (context, index) {
        final event = _events[index];
        final isFirst = index == 0;
        final isLast = index == _events.length - 1;

        // Check if we need a date separator
        final showDateHeader = isFirst ||
            !_isSameDay(
              _events[index - 1].occurredAt,
              event.occurredAt,
            );

        return Column(
          children: [
            if (showDateHeader) _buildDateHeader(event.occurredAt),
            _TimelineEventCard(
              event: event,
              isFirst: isFirst,
              isLast: isLast,
              onDelete: () => _deleteEvent(event.id),
            )
                .animate()
                .fadeIn(duration: 400.ms, delay: Duration(milliseconds: index * 50))
                .slideX(begin: 0.1, end: 0, duration: 400.ms),
          ],
        );
      },
    );
  }

  Widget _buildDateHeader(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final eventDay = DateTime(date.year, date.month, date.day);
    
    String label;
    if (eventDay == today) {
      label = 'Today';
    } else if (eventDay == today.subtract(const Duration(days: 1))) {
      label = 'Yesterday';
    } else {
      label = _formatFullDate(date);
    }

    return Padding(
      padding: const EdgeInsets.only(left: 40, top: 8, bottom: 4),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0xFFD4AF37).withAlpha(15),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: const Color(0xFFD4AF37).withAlpha(40),
            ),
          ),
          child: Text(
            label,
            style: const TextStyle(
              color: Color(0xFFD4AF37),
              fontSize: 11,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.0,
            ),
          ),
        ),
      ),
    );
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  // ── Add Button ────────────────────────────────────────────

  Widget _buildAddButton() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(color: Color(0xFF1A1A2E), width: 1),
        ),
      ),
      child: ElevatedButton.icon(
        onPressed: _showAddEventDialog,
        icon: const Icon(Icons.add_circle_outline, size: 20),
        label: const Text(
          'Record Event',
          style: TextStyle(fontWeight: FontWeight.w600, letterSpacing: 0.5),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFD4AF37).withAlpha(20),
          foregroundColor: const Color(0xFFD4AF37),
          side: const BorderSide(color: Color(0xFFD4AF37), width: 1),
          minimumSize: const Size(double.infinity, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
      ),
    );
  }

  // ── Actions ───────────────────────────────────────────────

  Future<void> _deleteEvent(int id) async {
    final repo = ref.read(lifeEventRepositoryProvider);
    await repo.deleteEvent(id);
    _loadEvents();
  }

  void _showAddEventDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _AddLifeEventSheet(
        onSave: (type, title, description, location, date) async {
          final repo = ref.read(lifeEventRepositoryProvider);
          await repo.createEvent(
            eventType: type,
            title: title,
            description: description,
            locationLabel: location,
            occurredAt: date,
          );
          Navigator.pop(ctx);
          _loadEvents();
        },
      ),
    );
  }

  String _formatFullDate(DateTime date) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}

// ════════════════════════════════════════════════════════════
// TIMELINE EVENT CARD
// ════════════════════════════════════════════════════════════

class _TimelineEventCard extends StatelessWidget {
  final LifeEvent event;
  final bool isFirst;
  final bool isLast;
  final VoidCallback onDelete;

  const _TimelineEventCard({
    required this.event,
    required this.isFirst,
    required this.isLast,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Timeline line + dot
          SizedBox(
            width: 40,
            child: Column(
              children: [
                // Line above dot
                Expanded(
                  child: Container(
                    width: 2,
                    color: isFirst
                        ? Colors.transparent
                        : const Color(0xFFD4AF37).withAlpha(60),
                  ),
                ),
                // Dot
                Container(
                  width: 14,
                  height: 14,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _eventColor,
                    border: Border.all(
                      color: const Color(0xFFD4AF37).withAlpha(80),
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: _eventColor.withAlpha(80),
                        blurRadius: 6,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                ),
                // Line below dot
                Expanded(
                  child: Container(
                    width: 2,
                    color: isLast
                        ? Colors.transparent
                        : const Color(0xFFD4AF37).withAlpha(60),
                  ),
                ),
              ],
            ),
          ),

          // Event card
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(8),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: _eventColor.withAlpha(40),
                    width: 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Type badge + time
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: _eventColor.withAlpha(25),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(_eventIcon, size: 13, color: _eventColor),
                              const SizedBox(width: 4),
                              Text(
                                _eventLabel,
                                style: TextStyle(
                                  color: _eventColor,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Spacer(),
                        Text(
                          _formatTime(event.occurredAt),
                          style: TextStyle(
                            color: Colors.white.withAlpha(80),
                            fontSize: 11,
                          ),
                        ),
                        const SizedBox(width: 4),
                        GestureDetector(
                          onTap: onDelete,
                          child: Icon(
                            Icons.close,
                            size: 14,
                            color: Colors.white.withAlpha(40),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    // Title
                    Text(
                      event.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    // Description
                    if (event.description != null &&
                        event.description!.isNotEmpty) ...[
                      const SizedBox(height: 6),
                      Text(
                        event.description!,
                        style: TextStyle(
                          color: Colors.white.withAlpha(120),
                          fontSize: 13,
                          height: 1.4,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    // Location
                    if (event.locationLabel != null &&
                        event.locationLabel!.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            Icons.place_outlined,
                            size: 13,
                            color: Colors.white.withAlpha(60),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            event.locationLabel!,
                            style: TextStyle(
                              color: Colors.white.withAlpha(60),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color get _eventColor {
    switch (event.eventType) {
      case LifeEventType.purchase:
        return const Color(0xFF26A69A); // Teal
      case LifeEventType.appointment:
        return const Color(0xFFD4AF37); // Gold
      case LifeEventType.milestone:
        return const Color(0xFF9B1B30); // Ruby
      case LifeEventType.memory:
        return const Color(0xFFF5F0E8); // Warm White
    }
  }

  IconData get _eventIcon {
    switch (event.eventType) {
      case LifeEventType.purchase:
        return Icons.shopping_cart_outlined;
      case LifeEventType.appointment:
        return Icons.calendar_today_outlined;
      case LifeEventType.milestone:
        return Icons.emoji_events_outlined;
      case LifeEventType.memory:
        return Icons.favorite_outline;
    }
  }

  String get _eventLabel {
    switch (event.eventType) {
      case LifeEventType.purchase:
        return 'Purchase';
      case LifeEventType.appointment:
        return 'Appointment';
      case LifeEventType.milestone:
        return 'Milestone';
      case LifeEventType.memory:
        return 'Memory';
    }
  }

  String _formatTime(DateTime date) {
    final hour = date.hour > 12 ? date.hour - 12 : (date.hour == 0 ? 12 : date.hour);
    final period = date.hour >= 12 ? 'PM' : 'AM';
    final minute = date.minute.toString().padLeft(2, '0');
    return '$hour:$minute $period';
  }
}

// ════════════════════════════════════════════════════════════
// ADD LIFE EVENT SHEET
// ════════════════════════════════════════════════════════════

class _AddLifeEventSheet extends StatefulWidget {
  final Future<void> Function(
    LifeEventType type,
    String title,
    String? description,
    String? location,
    DateTime occurredAt,
  ) onSave;

  const _AddLifeEventSheet({required this.onSave});

  @override
  State<_AddLifeEventSheet> createState() => _AddLifeEventSheetState();
}

class _AddLifeEventSheetState extends State<_AddLifeEventSheet> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  LifeEventType _selectedType = LifeEventType.memory;
  DateTime _selectedDate = DateTime.now();
  bool _saving = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 80),
      decoration: const BoxDecoration(
        color: Color(0xFF0A0A12),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        border: Border(
          top: BorderSide(color: Color(0xFFD4AF37), width: 2),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          24, 20, 24,
          MediaQuery.of(context).viewInsets.bottom + 24,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle bar
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Title
              const Text(
                'Record a Moment',
                style: TextStyle(
                  color: Color(0xFFD4AF37),
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Capture what matters to you',
                style: TextStyle(
                  color: Colors.white.withAlpha(80),
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 24),

              // Event Type Selector
              const Text(
                'TYPE',
                style: TextStyle(
                  color: Colors.white54,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 8),
              _buildTypeSelector(),
              const SizedBox(height: 20),

              // Title Input
              _buildTextField(
                controller: _titleController,
                label: 'TITLE',
                hint: 'What happened?',
                required: true,
              ),
              const SizedBox(height: 16),

              // Description Input
              _buildTextField(
                controller: _descriptionController,
                label: 'DESCRIPTION',
                hint: 'Tell the story... (optional)',
                maxLines: 3,
              ),
              const SizedBox(height: 16),

              // Location Input
              _buildTextField(
                controller: _locationController,
                label: 'LOCATION',
                hint: 'Where did this happen? (optional)',
                prefixIcon: Icons.place_outlined,
              ),
              const SizedBox(height: 16),

              // Date Picker
              const Text(
                'WHEN',
                style: TextStyle(
                  color: Colors.white54,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 8),
              _buildDatePicker(),
              const SizedBox(height: 28),

              // Save / Cancel
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.white54,
                        minimumSize: const Size(0, 48),
                      ),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: _saving ? null : _handleSave,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFD4AF37),
                        foregroundColor: const Color(0xFF0A0A12),
                        minimumSize: const Size(0, 48),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: _saving
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Color(0xFF0A0A12),
                              ),
                            )
                          : const Text(
                              'Save Event',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTypeSelector() {
    return Row(
      children: LifeEventType.values.map((type) {
        final isSelected = _selectedType == type;
        return Expanded(
          child: GestureDetector(
            onTap: () => setState(() => _selectedType = type),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 3),
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: isSelected
                    ? _colorForType(type).withAlpha(30)
                    : Colors.white.withAlpha(5),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: isSelected
                      ? _colorForType(type).withAlpha(120)
                      : Colors.white.withAlpha(15),
                  width: isSelected ? 1.5 : 1,
                ),
              ),
              child: Column(
                children: [
                  Icon(
                    _iconForType(type),
                    size: 20,
                    color: isSelected
                        ? _colorForType(type)
                        : Colors.white.withAlpha(60),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _labelForType(type),
                    style: TextStyle(
                      fontSize: 10,
                      color: isSelected
                          ? _colorForType(type)
                          : Colors.white.withAlpha(60),
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    bool required = false,
    int maxLines = 1,
    IconData? prefixIcon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: const TextStyle(
                color: Colors.white54,
                fontSize: 11,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.5,
              ),
            ),
            if (required)
              const Text(
                ' *',
                style: TextStyle(color: Color(0xFF9B1B30), fontSize: 11),
              ),
          ],
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: maxLines,
          style: const TextStyle(color: Colors.white, fontSize: 15),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.white.withAlpha(40)),
            prefixIcon: prefixIcon != null
                ? Icon(prefixIcon, size: 18, color: Colors.white38)
                : null,
            filled: true,
            fillColor: Colors.white.withAlpha(8),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.white.withAlpha(20)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.white.withAlpha(20)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFFD4AF37)),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 12,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDatePicker() {
    return GestureDetector(
      onTap: _pickDate,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white.withAlpha(8),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.white.withAlpha(20)),
        ),
        child: Row(
          children: [
            Icon(
              Icons.calendar_today_outlined,
              size: 18,
              color: Colors.white.withAlpha(100),
            ),
            const SizedBox(width: 10),
            Text(
              _formatDateFull(_selectedDate),
              style: const TextStyle(color: Colors.white, fontSize: 15),
            ),
            const Spacer(),
            Icon(
              Icons.edit_outlined,
              size: 16,
              color: Colors.white.withAlpha(60),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Color(0xFFD4AF37),
              surface: Color(0xFF1A1A2E),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_selectedDate),
        builder: (context, child) {
          return Theme(
            data: ThemeData.dark().copyWith(
              colorScheme: const ColorScheme.dark(
                primary: Color(0xFFD4AF37),
                surface: Color(0xFF1A1A2E),
              ),
            ),
            child: child!,
          );
        },
      );

      setState(() {
        _selectedDate = DateTime(
          picked.year,
          picked.month,
          picked.day,
          time?.hour ?? picked.hour,
          time?.minute ?? picked.minute,
        );
      });
    }
  }

  Future<void> _handleSave() async {
    if (_titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a title'),
          backgroundColor: Color(0xFF9B1B30),
        ),
      );
      return;
    }

    setState(() => _saving = true);

    await widget.onSave(
      _selectedType,
      _titleController.text.trim(),
      _descriptionController.text.trim().isEmpty
          ? null
          : _descriptionController.text.trim(),
      _locationController.text.trim().isEmpty
          ? null
          : _locationController.text.trim(),
      _selectedDate,
    );
  }

  String _formatDateFull(DateTime date) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December',
    ];
    final hour = date.hour > 12 ? date.hour - 12 : (date.hour == 0 ? 12 : date.hour);
    final period = date.hour >= 12 ? 'PM' : 'AM';
    final minute = date.minute.toString().padLeft(2, '0');
    return '${months[date.month - 1]} ${date.day}, ${date.year} · $hour:$minute $period';
  }

  Color _colorForType(LifeEventType type) {
    switch (type) {
      case LifeEventType.purchase:
        return const Color(0xFF26A69A);
      case LifeEventType.appointment:
        return const Color(0xFFD4AF37);
      case LifeEventType.milestone:
        return const Color(0xFF9B1B30);
      case LifeEventType.memory:
        return const Color(0xFFF5F0E8);
    }
  }

  IconData _iconForType(LifeEventType type) {
    switch (type) {
      case LifeEventType.purchase:
        return Icons.shopping_cart_outlined;
      case LifeEventType.appointment:
        return Icons.calendar_today_outlined;
      case LifeEventType.milestone:
        return Icons.emoji_events_outlined;
      case LifeEventType.memory:
        return Icons.favorite_outline;
    }
  }

  String _labelForType(LifeEventType type) {
    switch (type) {
      case LifeEventType.purchase:
        return 'Purchase';
      case LifeEventType.appointment:
        return 'Appt';
      case LifeEventType.milestone:
        return 'Milestone';
      case LifeEventType.memory:
        return 'Memory';
    }
  }
}

// ════════════════════════════════════════════════════════════
// FILTER CHIP WIDGET
// ════════════════════════════════════════════════════════════

class _FilterChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.icon,
    required this.color,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? color.withAlpha(25) : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? color.withAlpha(100) : Colors.white.withAlpha(20),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: isSelected ? color : Colors.white38),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: isSelected ? color : Colors.white38,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
