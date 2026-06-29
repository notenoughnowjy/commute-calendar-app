import 'package:commute_calendar/core/services/holiday_service.dart';
import 'package:commute_calendar/core/theme/theme_service.dart';
import 'package:commute_calendar/core/utils/date_formatter.dart';
import 'package:commute_calendar/feature/calendar/domain/entities/overtime_record_entity.dart';
import 'package:commute_calendar/feature/calendar/domain/entities/work_record_entity.dart';
import 'package:commute_calendar/feature/calendar/presentation/bloc/calendar_bloc.dart';
import 'package:commute_calendar/feature/calendar/presentation/bloc/calendar_state.dart';
import 'package:commute_calendar/feature/calendar/presentation/widgets/overtime_tile.dart';
import 'package:commute_calendar/feature/calendar/presentation/widgets/work_record_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DayInfoWidget extends StatefulWidget {
  const DayInfoWidget({super.key});

  @override
  State<DayInfoWidget> createState() => _DayInfoWidgetState();
}

class _DayInfoWidgetState extends State<DayInfoWidget> {
  Map<DateTime, String> _holidays = {};
  int _loadedYear = 0;

  @override
  void initState() {
    super.initState();
    _loadHolidays(DateTime.now().year);
  }

  // 연도가 바뀌면 해당 연도의 공휴일 데이터 재로드
  Future<void> _loadHolidays(int year) async {
    if (_loadedYear == year) return;
    final holidays = await HolidayService.getKoreanHolidays(year);
    if (mounted) {
      setState(() {
        _holidays = holidays;
        _loadedYear = year;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CalendarBloc, CalendarState>(
      buildWhen: (prev, curr) => curr is CalendarLoaded,
      builder: (context, state) {
        if (state is! CalendarLoaded) return const SizedBox.shrink();

        // focusedMonth 연도가 바뀌면 공휴일 재로드
        final year = state.focusedMonth.year;
        if (_loadedYear != year) {
          _loadHolidays(year);
        }

        return _DayInfoContent(
          selectedDate: state.selectedDate,
          records: state.records,
          overtimeRecords: state.overtimeRecords,
          holidays: _holidays,
        );
      },
    );
  }
}

class _DayInfoContent extends StatelessWidget {
  const _DayInfoContent({
    required this.selectedDate,
    required this.records,
    required this.overtimeRecords,
    required this.holidays,
  });

  final DateTime selectedDate;
  final Map<DateTime, WorkRecordEntity> records;
  final Map<DateTime, List<OvertimeRecordEntity>> overtimeRecords;
  final Map<DateTime, String> holidays;

  @override
  Widget build(BuildContext context) {
    final normalizedDate = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
    );
    final record = records[normalizedDate];
    final overtimeList = overtimeRecords[normalizedDate] ?? [];
    final isWeekend = _isWeekend(normalizedDate);

    // 표시할 타일 목록 구성
    final tiles = <Widget>[
      if (record != null) WorkRecordTile(record: record),
      ...overtimeList.map((ot) => OvertimeTile(record: ot)),
    ];

    return Container(
      color: ThemeService.white,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _DateHeader(
            date: normalizedDate,
            holidays: holidays,
            isWeekend: isWeekend,
            hasHolidayRecord: record?.type == WorkType.holiday,
          ),
          const SizedBox(height: 12),
          if (tiles.isNotEmpty)
            for (int i = 0; i < tiles.length; i++) ...[
              if (i > 0) const SizedBox(height: 8),
              tiles[i],
            ]
          else
            _EmptyRecordText(
              holidayName: HolidayService.getHolidayName(
                normalizedDate,
                holidays,
              ),
              date: normalizedDate,
              isWeekend: isWeekend,
            ),
        ],
      ),
    );
  }

  bool _isWeekend(DateTime date) {
    return date.weekday == DateTime.saturday || date.weekday == DateTime.sunday;
  }
}

class _DateHeader extends StatelessWidget {
  const _DateHeader({
    required this.date,
    required this.holidays,
    required this.isWeekend,
    required this.hasHolidayRecord,
  });

  final DateTime date;
  final Map<DateTime, String> holidays;
  final bool isWeekend;
  final bool hasHolidayRecord;

  @override
  Widget build(BuildContext context) {
    final holidayName = HolidayService.getHolidayName(date, holidays);
    // 공휴일 기록이 있거나, API 공휴일이거나, 주말이면 secondary 색상 적용
    final isSpecialDay = hasHolidayRecord || holidayName != null || isWeekend;
    final dateColor = isSpecialDay
        ? ThemeService.secondary
        : ThemeService.black900;

    final label = DateFormatter.dayWithWeekday(date);

    return Text(
      label,
      textAlign: TextAlign.center,
      style: ThemeService.body2.copyWith(color: dateColor),
    );
  }
}

class _EmptyRecordText extends StatelessWidget {
  const _EmptyRecordText({
    required this.holidayName,
    required this.date,
    required this.isWeekend,
  });

  final String? holidayName;
  final DateTime date;
  final bool isWeekend;

  String get _text {
    if (holidayName != null) return holidayName!;
    if (isWeekend) return _weekdayText;
    return '근태 기록이 없어요!';
  }

  String get _weekdayText {
    const names = ['월요일', '화요일', '수요일', '목요일', '금요일', '토요일', '일요일'];
    return '${names[date.weekday - 1]}이에요';
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      _text,
      style: ThemeService.subtitle.copyWith(color: ThemeService.black300),
      textAlign: TextAlign.center,
    );
  }
}
