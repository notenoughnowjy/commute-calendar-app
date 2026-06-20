import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/overtime_record_entity.dart';
import '../../domain/usecases/add_overtime_record_usecase.dart';
import '../../domain/usecases/add_work_record_usecase.dart';
import '../../domain/usecases/calculate_monthly_stats_usecase.dart';
import '../../domain/usecases/delete_overtime_record_usecase.dart';
import '../../domain/usecases/delete_work_record_usecase.dart';
import '../../domain/usecases/get_monthly_records_usecase.dart';
import '../../domain/usecases/get_overtime_records_usecase.dart';
import '../../domain/usecases/update_overtime_record_usecase.dart';
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
    required GetOvertimeRecordsUseCase getOvertimeRecords,
    required AddOvertimeRecordUseCase addOvertimeRecord,
    required UpdateOvertimeRecordUseCase updateOvertimeRecord,
    required DeleteOvertimeRecordUseCase deleteOvertimeRecord,
  }) : _getMonthlyRecords = getMonthlyRecords,
       _addWorkRecord = addWorkRecord,
       _updateWorkRecord = updateWorkRecord,
       _deleteWorkRecord = deleteWorkRecord,
       _calculateMonthlyStats = calculateMonthlyStats,
       _getOvertimeRecords = getOvertimeRecords,
       _addOvertimeRecord = addOvertimeRecord,
       _updateOvertimeRecord = updateOvertimeRecord,
       _deleteOvertimeRecord = deleteOvertimeRecord,
       super(const CalendarInitial()) {
    on<CalendarMonthChanged>(_onMonthChanged);
    on<CalendarDateSelected>(_onDateSelected);
    on<CalendarRecordAdded>(_onRecordAdded);
    on<CalendarRecordUpdated>(_onRecordUpdated);
    on<CalendarRecordDeleted>(_onRecordDeleted);
    on<CalendarOvertimeAdded>(_onOvertimeAdded);
    on<CalendarOvertimeUpdated>(_onOvertimeUpdated);
    on<CalendarOvertimeDeleted>(_onOvertimeDeleted);
  }

  final GetMonthlyRecordsUseCase _getMonthlyRecords;
  final AddWorkRecordUseCase _addWorkRecord;
  final UpdateWorkRecordUseCase _updateWorkRecord;
  final DeleteWorkRecordUseCase _deleteWorkRecord;
  final CalculateMonthlyStatsUseCase _calculateMonthlyStats;
  final GetOvertimeRecordsUseCase _getOvertimeRecords;
  final AddOvertimeRecordUseCase _addOvertimeRecord;
  final UpdateOvertimeRecordUseCase _updateOvertimeRecord;
  final DeleteOvertimeRecordUseCase _deleteOvertimeRecord;

  // ── 달력 ──────────────────────────────────────────────────────────────────

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

  // ── 일반 근태 기록 ─────────────────────────────────────────────────────────

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

  // ── 특근 기록 ──────────────────────────────────────────────────────────────

  Future<void> _onOvertimeAdded(
    CalendarOvertimeAdded event,
    Emitter<CalendarState> emit,
  ) async {
    if (state is! CalendarLoaded) return;
    final loaded = state as CalendarLoaded;
    try {
      await _addOvertimeRecord(event.record);
      emit(const CalendarRecordSaved('특근 기록이 추가됐습니다.'));
      await _loadMonth(loaded.focusedMonth, emit);
    } catch (e) {
      emit(CalendarError('특근 기록 추가 중 오류가 발생했습니다.'));
    }
  }

  Future<void> _onOvertimeUpdated(
    CalendarOvertimeUpdated event,
    Emitter<CalendarState> emit,
  ) async {
    if (state is! CalendarLoaded) return;
    final loaded = state as CalendarLoaded;
    try {
      await _updateOvertimeRecord(event.record);
      emit(const CalendarRecordSaved('특근 기록이 수정됐습니다.'));
      await _loadMonth(loaded.focusedMonth, emit);
    } catch (e) {
      emit(CalendarError('특근 기록 수정 중 오류가 발생했습니다.'));
    }
  }

  Future<void> _onOvertimeDeleted(
    CalendarOvertimeDeleted event,
    Emitter<CalendarState> emit,
  ) async {
    if (state is! CalendarLoaded) return;
    final loaded = state as CalendarLoaded;
    try {
      await _deleteOvertimeRecord(event.id);
      emit(const CalendarRecordRemoved());
      await _loadMonth(loaded.focusedMonth, emit);
    } catch (e) {
      emit(CalendarError('특근 기록 삭제 중 오류가 발생했습니다.'));
    }
  }

  // ── 공통 로드 ──────────────────────────────────────────────────────────────

  Future<void> _loadMonth(DateTime month, Emitter<CalendarState> emit) async {
    try {
      final (records, stats, overtimeList) = await (
        _getMonthlyRecords(month.year, month.month),
        _calculateMonthlyStats(month.year, month.month),
        _getOvertimeRecords(month.year, month.month),
      ).wait;

      final recordMap = {for (final r in records) _normalize(r.date): r};

      final overtimeMap = <DateTime, List<OvertimeRecordEntity>>{};
      for (final r in overtimeList) {
        overtimeMap.putIfAbsent(_normalize(r.date), () => []).add(r);
      }

      final currentSelected = state is CalendarLoaded
          ? (state as CalendarLoaded).selectedDate
          : DateTime.now();

      emit(
        CalendarLoaded(
          focusedMonth: month,
          selectedDate: currentSelected,
          records: recordMap,
          stats: stats,
          overtimeRecords: overtimeMap,
        ),
      );
    } catch (e) {
      emit(CalendarError('데이터를 불러오는 중 오류가 발생했습니다.'));
    }
  }

  DateTime _normalize(DateTime date) =>
      DateTime(date.year, date.month, date.day);
}
