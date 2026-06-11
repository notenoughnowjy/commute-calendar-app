import 'package:equatable/equatable.dart';

import '../../domain/entities/work_record_entity.dart';
import '../../domain/usecases/calculate_monthly_stats_usecase.dart';

abstract class CalendarState extends Equatable {
  const CalendarState();

  @override
  List<Object?> get props => [];
}

class CalendarInitial extends CalendarState {
  const CalendarInitial();
}

class CalendarLoading extends CalendarState {
  const CalendarLoading();
}

class CalendarLoaded extends CalendarState {
  const CalendarLoaded({
    required this.focusedMonth,
    required this.selectedDate,
    required this.records,
    required this.stats,
  });

  final DateTime focusedMonth;
  final DateTime selectedDate;

  // 날짜(년월일) → 기록 매핑. 키는 반드시 normalize된 DateTime(y, m, d) 사용
  final Map<DateTime, WorkRecord> records;
  final MonthlyStats stats;

  CalendarLoaded copyWith({
    DateTime? focusedMonth,
    DateTime? selectedDate,
    Map<DateTime, WorkRecord>? records,
    MonthlyStats? stats,
  }) {
    return CalendarLoaded(
      focusedMonth: focusedMonth ?? this.focusedMonth,
      selectedDate: selectedDate ?? this.selectedDate,
      records: records ?? this.records,
      stats: stats ?? this.stats,
    );
  }

  @override
  List<Object?> get props => [focusedMonth, selectedDate, records, stats];
}

class CalendarError extends CalendarState {
  const CalendarError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
