import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/add_work_record_usecase.dart';
import '../../domain/usecases/calculate_monthly_stats_usecase.dart';
import '../../domain/usecases/delete_work_record_usecase.dart';
import '../../domain/usecases/get_monthly_records_usecase.dart';
import '../../domain/usecases/update_work_record_usecase.dart';
import 'calendar_event.dart';
import 'calendar_state.dart';

class CalendarBloc extends Bloc<CalendarEvent, CalendarState> {
  CalendarBloc({
    required GetMonthlyRecordsUseCase getMonthlyRecords,
    required AddWorkRecordUseCase addWorkRecord,
    required UpdateWorkRecordUseCase updateWorkRecord,
    required DeleteWorkRecordUseCase deleteWorkRecord,
    required CalculateMonthlyStatsUseCase calculateMonthlyStats,
  }) : _getMonthlyRecords = getMonthlyRecords,
       _addWorkRecord = addWorkRecord,
       _updateWorkRecord = updateWorkRecord,
       _deleteWorkRecord = deleteWorkRecord,
       _calculateMonthlyStats = calculateMonthlyStats,
       super(const CalendarInitial()) {
    on<CalendarMonthChanged>(_onMonthChanged);
    on<CalendarDateSelected>(_onDateSelected);
    on<CalendarRecordAdded>(_onRecordAdded);
    on<CalendarRecordUpdated>(_onRecordUpdated);
    on<CalendarRecordDeleted>(_onRecordDeleted);
  }

  final GetMonthlyRecordsUseCase _getMonthlyRecords;
  final AddWorkRecordUseCase _addWorkRecord;
  final UpdateWorkRecordUseCase _updateWorkRecord;
  final DeleteWorkRecordUseCase _deleteWorkRecord;
  final CalculateMonthlyStatsUseCase _calculateMonthlyStats;

  // ------ 달력 관련 --------------------------------------------------
  Future<void> _onMonthChanged(
    CalendarMonthChanged event,
    Emitter<CalendarState> emit,
  ) async {
    await _loadMonth(event.month, emit);
  }

  Future<void> _onDateSelected(
    CalendarDateSelected event,
    Emitter<CalendarState> emit,
  ) async {
    if (state is CalendarLoaded) {
      emit((state as CalendarLoaded).copyWith(selectedDate: event.date));
    }
  }

  // ------ 근태 기록 관련 --------------------------------------------------
  Future<void> _onRecordAdded(
    CalendarRecordAdded event,
    Emitter<CalendarState> emit,
  ) async {
    if (state is! CalendarLoaded) return;
    final loaded = state as CalendarLoaded;
    try {
      await _addWorkRecord(event.record);
      emit(const CalendarRecordSaved('기록이 추가됐습니다.'));
      await _loadMonth(loaded.focusedMonth, emit);
    } catch (e) {
      emit(CalendarError('기록 추가 중 오류가 발생했습니다.'));
    }
  }

  Future<void> _onRecordUpdated(
    CalendarRecordUpdated event,
    Emitter<CalendarState> emit,
  ) async {
    if (state is! CalendarLoaded) return;
    final loaded = state as CalendarLoaded;
    try {
      await _updateWorkRecord(event.record);
      emit(const CalendarRecordSaved('기록이 수정됐습니다.'));
      await _loadMonth(loaded.focusedMonth, emit);
    } catch (e) {
      emit(CalendarError('기록 수정 중 오류가 발생했습니다.'));
    }
  }

  Future<void> _onRecordDeleted(
    CalendarRecordDeleted event,
    Emitter<CalendarState> emit,
  ) async {
    if (state is! CalendarLoaded) return;
    final loaded = state as CalendarLoaded;
    try {
      await _deleteWorkRecord(event.id);
      emit(const CalendarRecordRemoved());
      await _loadMonth(loaded.focusedMonth, emit);
    } catch (e) {
      emit(CalendarError('기록 삭제 중 오류가 발생했습니다.'));
    }
  }

  Future<void> _loadMonth(DateTime month, Emitter<CalendarState> emit) async {
    try {
      final records = await _getMonthlyRecords(month.year, month.month);
      final stats = await _calculateMonthlyStats(month.year, month.month);

      final recordMap = {for (final r in records) _normalize(r.date): r};

      final currentSelected = state is CalendarLoaded
          ? (state as CalendarLoaded).selectedDate
          : DateTime.now();

      emit(
        CalendarLoaded(
          focusedMonth: month,
          selectedDate: currentSelected,
          records: recordMap,
          stats: stats,
        ),
      );
    } catch (e) {
      emit(CalendarError('데이터를 불러오는 중 오류가 발생했습니다.'));
    }
  }

  DateTime _normalize(DateTime date) =>
      DateTime(date.year, date.month, date.day);
}
