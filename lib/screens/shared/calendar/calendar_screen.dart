import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'event_detail_screen.dart';

/// Event model for calendar
class CalendarEvent {
  final String id;
  final String title;
  final String description;
  final DateTime date;
  final String type; // assignment, quiz, livestream, deadline
  final String? courseId;
  final Color color;

  CalendarEvent({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.type,
    this.courseId,
    Color? color,
  }) : color = color ?? _getColorForType(type);

  static Color _getColorForType(String type) {
    switch (type) {
      case 'assignment':
        return Colors.green;
      case 'quiz':
        return Colors.blue;
      case 'livestream':
        return Colors.red;
      case 'deadline':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  String getTypeLabel() {
    switch (type) {
      case 'assignment':
        return 'Bài tập';
      case 'quiz':
        return 'Kiểm tra';
      case 'livestream':
        return 'Trực tiếp';
      case 'deadline':
        return 'Hạn chót';
      default:
        return 'Sự kiện';
    }
  }
}

/// Calendar Screen
class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  late DateTime _focusedDay;
  DateTime? _selectedDay;
  final Map<DateTime, List<CalendarEvent>> _events = {};
  late final ValueNotifier<List<CalendarEvent>> _selectedEvents;

  @override
  void initState() {
    super.initState();
    _focusedDay = DateTime.now();
    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
    _loadMockEvents();
  }

  /// Load mock events (replace with API call later)
  void _loadMockEvents() {
    final today = DateTime.now();
    final mockEvents = [
      CalendarEvent(
        id: '1',
        title: 'Bài tập Toán',
        description: 'Giải bài tập chương 3',
        date: today,
        type: 'assignment',
        courseId: 'math101',
      ),
      CalendarEvent(
        id: '2',
        title: 'Kiểm tra Tiếng Anh',
        description: 'Kiểm tra từ vựng và ngữ pháp',
        date: today.add(const Duration(days: 2)),
        type: 'quiz',
        courseId: 'english101',
      ),
      CalendarEvent(
        id: '3',
        title: 'Livestream Vật Lý',
        description: 'Bài giảng về điện từ học',
        date: today.add(const Duration(days: 3)),
        type: 'livestream',
        courseId: 'physics101',
      ),
      CalendarEvent(
        id: '4',
        title: 'Hạn nộp dự án',
        description: 'Deadline nộp dự án cuối kỳ',
        date: today.add(const Duration(days: 7)),
        type: 'deadline',
        courseId: 'cs101',
      ),
    ];

    for (var event in mockEvents) {
      final eventDate = DateTime.utc(event.date.year, event.date.month, event.date.day);
      if (_events[eventDate] == null) {
        _events[eventDate] = [];
      }
      _events[eventDate]!.add(event);
    }
  }

  List<CalendarEvent> _getEventsForDay(DateTime day) {
    final key = DateTime.utc(day.year, day.month, day.day);
    return _events[key] ?? [];
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
      });
      _selectedEvents.value = _getEventsForDay(selectedDay);
    }
  }

  @override
  void dispose() {
    _selectedEvents.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lịch học'),
        elevation: 0,
      ),
      body: ListView(
        children: [
          // Calendar
          TableCalendar(
            firstDay: DateTime.utc(2024, 1, 1),
            lastDay: DateTime.utc(2026, 12, 31),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            eventLoader: _getEventsForDay,
            onDaySelected: _onDaySelected,
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
            locale: 'vi_VN',
            calendarStyle: CalendarStyle(
              outsideDaysVisible: false,
              todayDecoration: BoxDecoration(
                color: Colors.blue.withValues(alpha:0.3),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.blue, width: 2),
              ),
              selectedDecoration: BoxDecoration(
                color: Colors.orange,
                shape: BoxShape.circle,
              ),
              markerDecoration: BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
              weekendTextStyle: const TextStyle(color: Colors.red),
            ),
            headerStyle: const HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
              leftChevronIcon: Icon(Icons.chevron_left),
              rightChevronIcon: Icon(Icons.chevron_right),
            ),
          ),
          const Divider(height: 20),
          // Events for selected day
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Sự kiện ngày ${_selectedDay?.day}/${_selectedDay?.month}/${_selectedDay?.year}',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
          ValueListenableBuilder<List<CalendarEvent>>(
            valueListenable: _selectedEvents,
            builder: (context, events, _) {
              return events.isEmpty
                  ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        children: [
                          Icon(
                            Icons.calendar_today,
                            size: 64,
                            color: Colors.grey[300],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Không có sự kiện nào',
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                  : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: events.length,
                    itemBuilder: (context, index) {
                      final event = events[index];
                      return _buildEventCard(context, event);
                    },
                  );
            },
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildEventCard(BuildContext context, CalendarEvent event) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: Container(
          width: 8,
          decoration: BoxDecoration(
            color: event.color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        title: Text(
          event.title,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(event.description),
            const SizedBox(height: 4),
            Chip(
              label: Text(
                event.getTypeLabel(),
                style: const TextStyle(fontSize: 12),
              ),
              backgroundColor: event.color.withValues(alpha:0.2),
              labelStyle: TextStyle(color: event.color),
              side: BorderSide(color: event.color.withValues(alpha:0.5)),
            ),
          ],
        ),
        trailing: Icon(Icons.arrow_forward, color: Colors.grey[400]),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => EventDetailScreen(event: event),
            ),
          );
        },
      ),
    );
  }
}
