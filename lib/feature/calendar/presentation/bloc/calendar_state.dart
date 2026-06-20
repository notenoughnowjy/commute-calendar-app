import 'package:equatable/equatable.dart';

import '../../domain/entities/overtime_record_entity.dart';
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
    required this.overtimeRecords,
  });

  final DateTime focusedMonth;
  final DateTime selectedDate;

  // 날짜(년월일) → 기록 매핑. 키는 반드시 normalize된 DateTime(y, m, d) 사용
  final Map<DateTime, WorkRecordEntity> records;
  final MonthlyStats stats;

  // 날짜(년월일) → 특근 기록 목록 매핑
  final Map<DateTime, List<OvertimeRecordEntity>> overtimeRecords;

  CalendarLoaded copyWith({
    DateTime? focusedMonth,
    DateTime? selectedDate,
    Map<DateTime, WorkRecordEntity>? records,
    MonthlyStats? stats,
    Map<DateTime, List<OvertimeRecordEntity>>? overtimeRecords,
  }) {
    return CalendarLoaded(
      focusedMonth: focusedMonth ?? this.focusedMonth,
      selectedDate: selectedDate ?? this.selectedDate,
      records: records ?? this.records,
      stats: stats ?? this.stats,
      overtimeRecords: overtimeRecords ?? this.overtimeRecords,
    );
  }

  @override
  List<Object?> get props => [
    focusedMonth,
    selectedDate,
    records,
    stats,
    overtimeRecords,
  ];
}

class CalendarError extends CalendarState {
  const CalendarError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

class CalendarRecordSaved extends CalendarState {
  const CalendarRecordSaved(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

class CalendarRecordRemoved extends CalendarState {
  const CalendarRecordRemoved();
}
