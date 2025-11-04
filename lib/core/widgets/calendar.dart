import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_dimensions.dart';
import '../theme/app_typography.dart';

/// Simple calendar widget
class SimpleCalendar extends StatefulWidget {
  final DateTime? initialDate;
  final DateTime? minDate;
  final DateTime? maxDate;
  final Function(DateTime)? onDateSelected;
  final List<DateTime>? highlightedDates;
  final List<CalendarEvent>? events;
  final bool showEvents;

  const SimpleCalendar({
    super.key,
    this.initialDate,
    this.minDate,
    this.maxDate,
    this.onDateSelected,
    this.highlightedDates,
    this.events,
    this.showEvents = false,
  });

  @override
  State<SimpleCalendar> createState() => _SimpleCalendarState();
}

class _SimpleCalendarState extends State<SimpleCalendar> {
  late DateTime _currentMonth;
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _currentMonth = widget.initialDate ?? DateTime.now();
    _selectedDate = widget.initialDate;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildHeader(),
        _buildWeekDays(),
        _buildCalendarGrid(),
        if (widget.showEvents && widget.events != null) _buildEventsList(),
      ],
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () {
              setState(() {
                _currentMonth = DateTime(
                  _currentMonth.year,
                  _currentMonth.month - 1,
                );
              });
            },
            icon: const Icon(Icons.chevron_left),
          ),
          Text(_getMonthYearText(_currentMonth), style: AppTypography.h6),
          IconButton(
            onPressed: () {
              setState(() {
                _currentMonth = DateTime(
                  _currentMonth.year,
                  _currentMonth.month + 1,
                );
              });
            },
            icon: const Icon(Icons.chevron_right),
          ),
        ],
      ),
    );
  }

  Widget _buildWeekDays() {
    const weekDays = ['CN', 'T2', 'T3', 'T4', 'T5', 'T6', 'T7'];

    return Container(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Row(
        children: weekDays.map((day) {
          return Expanded(
            child: Center(
              child: Text(
                day,
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.grey600,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildCalendarGrid() {
    final firstDayOfMonth = DateTime(
      _currentMonth.year,
      _currentMonth.month,
      1,
    );
    final lastDayOfMonth = DateTime(
      _currentMonth.year,
      _currentMonth.month + 1,
      0,
    );
    final startDate = firstDayOfMonth.subtract(
      Duration(days: firstDayOfMonth.weekday % 7),
    );

    final weeks = <List<DateTime>>[];
    var currentDate = startDate;

    while (currentDate.isBefore(lastDayOfMonth.add(const Duration(days: 7)))) {
      final week = <DateTime>[];
      for (int i = 0; i < 7; i++) {
        week.add(currentDate);
        currentDate = currentDate.add(const Duration(days: 1));
      }
      weeks.add(week);

      if (week.every((date) => date.month != _currentMonth.month)) {
        break;
      }
    }

    return Column(
      children: weeks.map((week) {
        return Row(
          children: week.map((date) {
            return Expanded(child: _buildDateCell(date));
          }).toList(),
        );
      }).toList(),
    );
  }

  Widget _buildDateCell(DateTime date) {
    final isCurrentMonth = date.month == _currentMonth.month;
    final isSelected =
        _selectedDate != null &&
        date.year == _selectedDate!.year &&
        date.month == _selectedDate!.month &&
        date.day == _selectedDate!.day;
    final isToday = _isToday(date);
    final isHighlighted =
        widget.highlightedDates?.any((d) => _isSameDay(d, date)) ?? false;
    final hasEvents =
        widget.events?.any((e) => _isSameDay(e.date, date)) ?? false;

    return GestureDetector(
      onTap: () {
        if (isCurrentMonth) {
          setState(() {
            _selectedDate = date;
          });
          widget.onDateSelected?.call(date);
        }
      },
      child: Container(
        height: 48,
        margin: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(AppRadius.sm),
          border: isToday
              ? Border.all(color: AppColors.primary, width: 2)
              : null,
        ),
        child: Stack(
          children: [
            Center(
              child: Text(
                date.day.toString(),
                style: AppTypography.bodyMedium.copyWith(
                  color: isSelected
                      ? AppColors.white
                      : isCurrentMonth
                      ? isToday
                            ? AppColors.primary
                            : Theme.of(context).colorScheme.onSurface
                      : AppColors.grey400,
                  fontWeight: isSelected || isToday
                      ? FontWeight.w600
                      : FontWeight.normal,
                ),
              ),
            ),
            if (hasEvents)
              Positioned(
                bottom: 4,
                left: 0,
                right: 0,
                child: Center(
                  child: Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.white : AppColors.accent,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
            if (isHighlighted && !isSelected)
              Positioned(
                top: 4,
                right: 4,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: AppColors.warning,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildEventsList() {
    if (_selectedDate == null) return const SizedBox.shrink();

    final eventsForSelectedDate =
        widget.events
            ?.where((event) => _isSameDay(event.date, _selectedDate!))
            .toList() ??
        [];

    if (eventsForSelectedDate.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Text(
          'Không có sự kiện nào trong ngày này',
          style: AppTypography.bodyMedium.copyWith(color: AppColors.grey600),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Text(
            'Sự kiện ngày ${_selectedDate!.day}/${_selectedDate!.month}',
            style: AppTypography.h6,
          ),
        ),
        ...eventsForSelectedDate.map((event) {
          return Container(
            margin: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.xs,
            ),
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color:
                  event.color?.withValues(alpha: 0.1) ??
                  AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppRadius.sm),
              border: Border.all(
                color:
                    event.color?.withValues(alpha: 0.3) ??
                    AppColors.primary.withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 4,
                  height: 32,
                  decoration: BoxDecoration(
                    color: event.color ?? AppColors.primary,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        event.title,
                        style: AppTypography.bodyMedium.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (event.description != null) ...[
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          event.description!,
                          style: AppTypography.bodySmall.copyWith(
                            color: AppColors.grey600,
                          ),
                        ),
                      ],
                      if (event.time != null) ...[
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          event.time!,
                          style: AppTypography.bodySmall.copyWith(
                            color: AppColors.grey500,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  String _getMonthYearText(DateTime date) {
    const months = [
      'Tháng 1',
      'Tháng 2',
      'Tháng 3',
      'Tháng 4',
      'Tháng 5',
      'Tháng 6',
      'Tháng 7',
      'Tháng 8',
      'Tháng 9',
      'Tháng 10',
      'Tháng 11',
      'Tháng 12',
    ];

    return '${months[date.month - 1]} ${date.year}';
  }

  bool _isToday(DateTime date) {
    final today = DateTime.now();
    return date.year == today.year &&
        date.month == today.month &&
        date.day == today.day;
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }
}

/// Calendar event model
class CalendarEvent {
  final DateTime date;
  final String title;
  final String? description;
  final String? time;
  final Color? color;

  CalendarEvent({
    required this.date,
    required this.title,
    this.description,
    this.time,
    this.color,
  });
}

/// Compact calendar widget for date selection
class CompactCalendar extends StatefulWidget {
  final DateTime? initialDate;
  final DateTime? minDate;
  final DateTime? maxDate;
  final Function(DateTime)? onDateSelected;

  const CompactCalendar({
    super.key,
    this.initialDate,
    this.minDate,
    this.maxDate,
    this.onDateSelected,
  });

  @override
  State<CompactCalendar> createState() => _CompactCalendarState();
}

class _CompactCalendarState extends State<CompactCalendar> {
  late DateTime _selectedDate;
  late PageController _pageController;
  late DateTime _currentMonth;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate ?? DateTime.now();
    _currentMonth = DateTime(_selectedDate.year, _selectedDate.month);
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: Column(
        children: [
          _buildCompactHeader(),
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentMonth = DateTime(
                    _currentMonth.year,
                    _currentMonth.month + index - 1000,
                  );
                });
              },
              itemBuilder: (context, index) {
                final month = DateTime(
                  _currentMonth.year,
                  _currentMonth.month + index - 1000,
                );
                return _buildMonthView(month);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompactHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.1),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(AppRadius.md),
          topRight: Radius.circular(AppRadius.md),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () {
              _pageController.previousPage(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            },
            icon: Icon(Icons.chevron_left, color: AppColors.primary),
          ),
          Text(
            _getMonthYearText(_currentMonth),
            style: AppTypography.h6.copyWith(color: AppColors.primary),
          ),
          IconButton(
            onPressed: () {
              _pageController.nextPage(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            },
            icon: Icon(Icons.chevron_right, color: AppColors.primary),
          ),
        ],
      ),
    );
  }

  Widget _buildMonthView(DateTime month) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.sm),
      child: Column(
        children: [
          _buildWeekDaysHeader(),
          Expanded(child: _buildCalendarGridForMonth(month)),
        ],
      ),
    );
  }

  Widget _buildWeekDaysHeader() {
    const weekDays = ['CN', 'T2', 'T3', 'T4', 'T5', 'T6', 'T7'];

    return Row(
      children: weekDays.map((day) {
        return Expanded(
          child: Center(
            child: Text(
              day,
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.grey600,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildCalendarGridForMonth(DateTime month) {
    final firstDayOfMonth = DateTime(month.year, month.month, 1);
    final startDate = firstDayOfMonth.subtract(
      Duration(days: firstDayOfMonth.weekday % 7),
    );

    final weeks = <List<DateTime>>[];
    var currentDate = startDate;

    while (weeks.length < 6) {
      final week = <DateTime>[];
      for (int i = 0; i < 7; i++) {
        week.add(currentDate);
        currentDate = currentDate.add(const Duration(days: 1));
      }
      weeks.add(week);
    }

    return Column(
      children: weeks.map((week) {
        return Expanded(
          child: Row(
            children: week.map((date) {
              return Expanded(child: _buildCompactDateCell(date, month));
            }).toList(),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildCompactDateCell(DateTime date, DateTime month) {
    final isCurrentMonth = date.month == month.month;
    final isSelected =
        date.year == _selectedDate.year &&
        date.month == _selectedDate.month &&
        date.day == _selectedDate.day;
    final isToday = _isToday(date);
    final isDisabled =
        (widget.minDate != null && date.isBefore(widget.minDate!)) ||
        (widget.maxDate != null && date.isAfter(widget.maxDate!));

    return GestureDetector(
      onTap: isDisabled
          ? null
          : () {
              setState(() {
                _selectedDate = date;
              });
              widget.onDateSelected?.call(date);
            },
      child: Container(
        margin: const EdgeInsets.all(1),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary
              : isToday
              ? AppColors.primary.withValues(alpha: 0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(AppRadius.sm),
          border: isToday && !isSelected
              ? Border.all(color: AppColors.primary.withValues(alpha: 0.5))
              : null,
        ),
        child: Center(
          child: Text(
            date.day.toString(),
            style: AppTypography.bodySmall.copyWith(
              color: isDisabled
                  ? AppColors.grey400
                  : isSelected
                  ? AppColors.white
                  : isCurrentMonth
                  ? isToday
                        ? AppColors.primary
                        : Theme.of(context).colorScheme.onSurface
                  : AppColors.grey400,
              fontWeight: isSelected || isToday
                  ? FontWeight.w600
                  : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }

  String _getMonthYearText(DateTime date) {
    const months = [
      'Tháng 1',
      'Tháng 2',
      'Tháng 3',
      'Tháng 4',
      'Tháng 5',
      'Tháng 6',
      'Tháng 7',
      'Tháng 8',
      'Tháng 9',
      'Tháng 10',
      'Tháng 11',
      'Tháng 12',
    ];

    return '${months[date.month - 1]} ${date.year}';
  }

  bool _isToday(DateTime date) {
    final today = DateTime.now();
    return date.year == today.year &&
        date.month == today.month &&
        date.day == today.day;
  }
}

/// Date range picker
class DateRangePicker extends StatefulWidget {
  final DateTime? startDate;
  final DateTime? endDate;
  final Function(DateTime?, DateTime?)? onDateRangeSelected;

  const DateRangePicker({
    super.key,
    this.startDate,
    this.endDate,
    this.onDateRangeSelected,
  });

  @override
  State<DateRangePicker> createState() => _DateRangePickerState();
}

class _DateRangePickerState extends State<DateRangePicker> {
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  void initState() {
    super.initState();
    _startDate = widget.startDate;
    _endDate = widget.endDate;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildSelectedRangeDisplay(),
        const SizedBox(height: AppSpacing.md),
        SimpleCalendar(onDateSelected: _onDateSelected),
      ],
    );
  }

  Widget _buildSelectedRangeDisplay() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Row(
        children: [
          Expanded(child: _buildDateDisplay('Từ ngày', _startDate)),
          Icon(Icons.arrow_forward, color: AppColors.primary),
          Expanded(child: _buildDateDisplay('Đến ngày', _endDate)),
        ],
      ),
    );
  }

  Widget _buildDateDisplay(String label, DateTime? date) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          label,
          style: AppTypography.bodySmall.copyWith(color: AppColors.grey600),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          date != null ? '${date.day}/${date.month}/${date.year}' : 'Chọn ngày',
          style: AppTypography.bodyMedium.copyWith(
            fontWeight: FontWeight.w600,
            color: date != null ? AppColors.primary : AppColors.grey500,
          ),
        ),
      ],
    );
  }

  void _onDateSelected(DateTime date) {
    setState(() {
      if (_startDate == null || (_startDate != null && _endDate != null)) {
        _startDate = date;
        _endDate = null;
      } else if (_endDate == null) {
        if (date.isAfter(_startDate!)) {
          _endDate = date;
        } else {
          _startDate = date;
          _endDate = null;
        }
      }
    });

    widget.onDateRangeSelected?.call(_startDate, _endDate);
  }
}
