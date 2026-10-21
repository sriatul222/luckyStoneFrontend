import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:luckystone/extra/colors.dart';

class CalendarIcon extends StatelessWidget {
  final String? startDate;
  final String? endDate;
  final VoidCallback? onClear;

  const CalendarIcon({
    super.key,
    this.startDate,
    this.endDate,
    this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    final selectedDateText = startDate == null
        ? 'Select date range'
        : startDate == endDate
            ? startDate!
            : '$startDate – $endDate';

    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width / 1.2,
        padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 10),
        decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade400),
            borderRadius: BorderRadius.circular(8)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.calendar_today_outlined, size: 20),
            // const SizedBox(width: 10),
            Expanded(
              child: Text(
                selectedDateText,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
              ),
            ),
            if (onClear != null) ...[
              // const SizedBox(width: 10),
              GestureDetector(
                onTap: onClear,
                child: const Icon(Icons.close, size: 18),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

Future<DateTimeRange?> showAgendaDateRangePicker(
  BuildContext context, {
  DateTimeRange? initialRange,
}) {
  return showDialog<DateTimeRange>(
    context: context,
    builder: (context) => _AgendaDateRangeDialog(initialRange: initialRange),
  );
}

class _AgendaDateRangeDialog extends StatefulWidget {
  final DateTimeRange? initialRange;

  const _AgendaDateRangeDialog({
    this.initialRange,
  });

  @override
  State<_AgendaDateRangeDialog> createState() => _AgendaDateRangeDialogState();
}

class _AgendaDateRangeDialogState extends State<_AgendaDateRangeDialog> {
  late DateTime _visibleMonth;
  DateTime? _startDate;
  DateTime? _endDate;

  final DateFormat _monthFormatter = DateFormat('MMMM yyyy');
  final DateFormat _dateFormatter = DateFormat('MMM d, yyyy');

  @override
  void initState() {
    super.initState();
    final initialRange = widget.initialRange;
    _startDate = initialRange == null ? null : _dateOnly(initialRange.start);
    _endDate = initialRange == null ? null : _dateOnly(initialRange.end);
    final initialMonth = _startDate ?? DateTime.now();
    _visibleMonth = DateTime(initialMonth.year, initialMonth.month);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 560),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              // padding: EdgeInsets.all(5),
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildMonthHeader(),
                  const SizedBox(height: 10),
                  _buildSelectedDateFields(),
                  const SizedBox(height: 10),
                  _buildPresets(),
                  const SizedBox(height: 15),
                  _buildWeekHeader(),
                  const SizedBox(height: 10),
                  _buildCalendarGrid(),
                ],
              ),
            ),
            // Divider(height: .5, color: Colors.grey.shade400),
            _buildActions(),
          ],
        ),
      ),
    );
  }

  Widget _buildMonthHeader() {
    return Row(
      children: [
        IconButton(
          onPressed: () => _changeMonth(-1),
          icon: const Icon(Icons.chevron_left, size: 30),
          color: Colors.grey.shade500,
        ),
        Expanded(
          child: Text(
            _monthFormatter.format(_visibleMonth),
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: MyColor.darkGrey,
              fontFamily: 'Poppins',
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        IconButton(
          onPressed: () => _changeMonth(1),
          icon: const Icon(Icons.chevron_right, size: 30),
          color: Colors.grey.shade500,
        ),
      ],
    );
  }

  Widget _buildSelectedDateFields() {
    return Row(
      children: [
        Expanded(child: _buildDateField(_startDate)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            '-',
            style: TextStyle(
              color: MyColor.primaryGrey,
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(child: _buildDateField(_endDate)),
      ],
    );
  }

  Widget _buildDateField(DateTime? date) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300, width: 1.3),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        date == null ? '' : _dateFormatter.format(date),
        style: const TextStyle(
          color: MyColor.darkGrey,
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildPresets() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildPresetButton('Last week', _selectLastWeek),
        _buildPresetButton('Last month', _selectLastMonth),
        _buildPresetButton('Last year', _selectLastYear),
      ],
    );
  }

  Widget _buildPresetButton(String label, VoidCallback onTap) {
    return TextButton(
      onPressed: onTap,
      child: Text(
        label,
        style: const TextStyle(
          color: MyColor.primary,
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _buildWeekHeader() {
    const weekdays = ['Mo', 'Tu', 'We', 'Th', 'Fr', 'Sat', 'Su'];
    return Row(
      children: weekdays
          .map(
            (day) => Expanded(
              child: Text(
                day,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: MyColor.darkGrey,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _buildCalendarGrid() {
    final days = _visibleDays();
    return Column(
      children: List.generate(6, (rowIndex) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 3),
          child: Row(
            children: List.generate(7, (columnIndex) {
              final date = days[rowIndex * 7 + columnIndex];
              return Expanded(child: _buildDayCell(date));
            }),
          ),
        );
      }),
    );
  }

  Widget _buildDayCell(DateTime date) {
    final isCurrentMonth = date.month == _visibleMonth.month;
    final isStart = _isSameDay(date, _startDate);
    final isEnd = _isSameDay(date, _endDate);
    final isSelected = isStart || isEnd;
    final isInRange = _isInRange(date);

    return GestureDetector(
      onTap: () => _selectDate(date),
      child: Container(
        // padding: EdgeInsets.symmetric(vertical: 5),
        // height: 45,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color:
              isInRange ? MyColor.primary.withValues(alpha: 0.1) : null,
          // borderRadius: BorderRadius.circular(40),
        ),
        child: Container(
          padding: const EdgeInsets.all(5),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected ? MyColor.primary : Colors.transparent,
            shape: BoxShape.circle,
          ),
          child: Text(
            '${date.day}',
            style: TextStyle(
              color: isSelected
                  ? MyColor.white
                  : isCurrentMonth
                      ? MyColor.darkGrey
                      : MyColor.primaryGrey,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActions() {
    final canApply = _startDate != null;

    return Padding(
      padding: const EdgeInsets.all(18),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () => Navigator.pop(context),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 15),
                side: BorderSide(color: Colors.grey.shade300),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: MyColor.primaryGrey,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: ElevatedButton(
              onPressed: canApply ? _apply : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: MyColor.primary,
                disabledBackgroundColor:
                    MyColor.primary.withValues(alpha: 0.35),
                padding: const EdgeInsets.symmetric(vertical: 15),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Apply',
                style: TextStyle(
                  color: MyColor.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _changeMonth(int offset) {
    setState(() {
      _visibleMonth =
          DateTime(_visibleMonth.year, _visibleMonth.month + offset);
    });
  }

  void _selectDate(DateTime date) {
    final selectedDate = _dateOnly(date);

    setState(() {
      if (_startDate == null || (_startDate != null && _endDate != null)) {
        _startDate = selectedDate;
        _endDate = null;
      } else if (selectedDate.isBefore(_startDate!)) {
        _endDate = _startDate;
        _startDate = selectedDate;
      } else if (_isSameDay(selectedDate, _startDate)) {
        _endDate = null;
      } else {
        _endDate = selectedDate;
      }
    });
  }

  void _selectLastWeek() {
    final today = _dateOnly(DateTime.now());
    final currentWeekStart = today.subtract(Duration(days: today.weekday - 1));
    final lastWeekStart = currentWeekStart.subtract(const Duration(days: 7));
    final lastWeekEnd = lastWeekStart.add(const Duration(days: 6));
    _setPresetRange(lastWeekStart, lastWeekEnd);
  }

  void _selectLastMonth() {
    final today = DateTime.now();
    final lastMonthStart = DateTime(today.year, today.month - 1);
    final lastMonthEnd = DateTime(today.year, today.month, 0);
    _setPresetRange(lastMonthStart, lastMonthEnd);
  }

  void _selectLastYear() {
    final today = DateTime.now();
    final lastYearStart = DateTime(today.year - 1);
    final lastYearEnd = DateTime(today.year - 1, 12, 31);
    _setPresetRange(lastYearStart, lastYearEnd);
  }

  void _setPresetRange(DateTime start, DateTime end) {
    setState(() {
      _startDate = _dateOnly(start);
      _endDate = _dateOnly(end);
      _visibleMonth = DateTime(start.year, start.month);
    });
  }

  void _apply() {
    final startDate = _startDate;
    if (startDate == null) return;

    Navigator.pop(
      context,
      DateTimeRange(start: startDate, end: _endDate ?? startDate),
    );
  }

  List<DateTime> _visibleDays() {
    final firstDay = DateTime(_visibleMonth.year, _visibleMonth.month);
    final firstVisibleDay =
        firstDay.subtract(Duration(days: firstDay.weekday - 1));
    return List.generate(
      42,
      (index) => firstVisibleDay.add(Duration(days: index)),
    );
  }

  bool _isInRange(DateTime date) {
    final startDate = _startDate;
    final endDate = _endDate;

    if (startDate == null || endDate == null) return false;

    return date.isAfter(startDate) && date.isBefore(endDate);
  }

  bool _isSameDay(DateTime date, DateTime? other) {
    if (other == null) return false;
    return date.year == other.year &&
        date.month == other.month &&
        date.day == other.day;
  }

  DateTime _dateOnly(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }
}
