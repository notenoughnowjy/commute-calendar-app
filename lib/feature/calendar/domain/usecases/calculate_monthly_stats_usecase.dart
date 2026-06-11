import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../../core/services/holiday_service.dart';
import '../entities/work_record_entity.dart';
import '../repositories/i_calendar_repository.dart';

class MonthlyStats extends Equatable {
  const MonthlyStats({
    required this.totalRequired,
    required this.totalWorked,
    required this.remaining,
  });

  final Duration totalRequired;  // 영업일 × 9h
  final Duration totalWorked;    // 실제 채운 시간
  final Duration remaining;      // max(0, totalRequired - totalWorked)

  @override
  List<Object?> get props => [totalRequired, totalWorked, remaining];
}

class CalculateMonthlyStatsUseCase {
  const CalculateMonthlyStatsUseCase(this._repository);

  final ICalendarRepository _repository;

  // 영업일 계산, 통계 집계 등 비즈니스 로직은 UseCase에 위치한다.
  // Repository는 데이터 접근(CRUD)만 담당하므로, Supabase·로컬 등
  // 구현체가 바뀌어도 이 계산 로직은 영향을 받지 않는다.
  Future<MonthlyStats> call(int year, int month) async {
    final records = await _repository.getRecordsByMonth(year, month);
    final holidays = await HolidayService.getKoreanHolidays(year);

    final recordMap = {
      for (final r in records) _normalize(r.date): r,
    };

    int businessDays = 0;
    final daysInMonth = DateTimeRange(
      start: DateTime(year, month, 1),
      end: DateTime(year, month + 1, 1),
    );

    DateTime cursor = daysInMonth.start;
    while (cursor.isBefore(daysInMonth.end)) {
      final isWeekend = cursor.weekday == DateTime.saturday ||
          cursor.weekday == DateTime.sunday;
      final isApiHoliday = HolidayService.isHoliday(cursor, holidays);
      final record = recordMap[_normalize(cursor)];
      final isUserHoliday = record?.type == WorkType.holiday;
      final isVacation = record?.type == WorkType.vacation;

      if (!isWeekend && !isApiHoliday && !isUserHoliday && !isVacation) {
        businessDays++;
      }

      cursor = cursor.add(const Duration(days: 1));
    }

    final totalRequired = Duration(hours: businessDays * 9);

    Duration totalWorked = Duration.zero;
    for (final record in records) {
      totalWorked += switch (record.type) {
        WorkType.work => record.workedDuration,
        WorkType.vacation => Duration.zero,
        WorkType.holiday => Duration.zero,
      };
    }

    final remaining = totalWorked >= totalRequired
        ? Duration.zero
        : totalRequired - totalWorked;

    return MonthlyStats(
      totalRequired: totalRequired,
      totalWorked: totalWorked,
      remaining: remaining,
    );
  }

  DateTime _normalize(DateTime date) => DateTime(date.year, date.month, date.day);
}
