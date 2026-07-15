import 'package:drift/drift.dart';
import 'package:flutter/material.dart';

import '../../../../core/database/app_database.dart';
import '../../domain/entities/work_record_entity.dart';
import '../../domain/repositories/i_calendar_repository.dart';
import '../datasources/work_record_data_source.dart';

class CalendarRepositoryImpl implements ICalendarRepository {
  const CalendarRepositoryImpl(this._dataSource);

  final WorkRecordDataSource _dataSource;

  @override
  Future<List<WorkRecordEntity>> getRecordsByMonth(int year, int month) async {
    try {
      final first = DateTime(year, month, 1);
      final lastDay = DateTime(year, month + 1, 0).day;
      final last = DateTime(year, month, lastDay, 23, 59, 59);
      final rows = await _dataSource.getRecordsByMonth(first, last);
      return rows.map(_toEntity).toList();
    } catch (e) {
      throw Exception('근태 기록을 불러오는 중 오류가 발생했습니다: $e');
    }
  }

  @override
  Future<void> addRecord(WorkRecordEntity record) async {
    try {
      await _dataSource.addRecord(_toCompanion(record));
    } catch (e) {
      throw Exception('근태 기록을 추가하는 중 오류가 발생했습니다: $e');
    }
  }

  @override
  Future<void> updateRecord(WorkRecordEntity record) async {
    try {
      await _dataSource.updateRecord(_toCompanion(record));
    } catch (e) {
      throw Exception('근태 기록을 수정하는 중 오류가 발생했습니다: $e');
    }
  }

  @override
  Future<void> deleteRecord(String id) async {
    try {
      await _dataSource.deleteRecord(id);
    } catch (e) {
      throw Exception('근태 기록을 삭제하는 중 오류가 발생했습니다: $e');
    }
  }

  WorkRecordEntity _toEntity(WorkRecord row) {
    return WorkRecordEntity(
      id: row.id,
      date: row.date,
      type: row.type,
      workMinutes: row.workMinutes,
      startTime: _parseTime(row.startTime),
      endTime: _parseTime(row.endTime),
      memo: row.memo,
    );
  }

  WorkRecordsCompanion _toCompanion(WorkRecordEntity record) {
    return WorkRecordsCompanion(
      id: Value(record.id),
      date: Value(DateTime(record.date.year, record.date.month, record.date.day)),
      type: Value(record.type),
      workMinutes: Value(record.workMinutes),
      startTime: Value(_formatTime(record.startTime)),
      endTime: Value(_formatTime(record.endTime)),
      memo: Value(record.memo),
    );
  }

  static TimeOfDay? _parseTime(String? value) {
    if (value == null) return null;
    final parts = value.split(':');
    if (parts.length != 2) return null;
    final hour = int.tryParse(parts[0]);
    final minute = int.tryParse(parts[1]);
    if (hour == null || minute == null) return null;
    return TimeOfDay(hour: hour, minute: minute);
  }

  static String? _formatTime(TimeOfDay? time) {
    if (time == null) return null;
    final h = time.hour.toString().padLeft(2, '0');
    final m = time.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }
}
