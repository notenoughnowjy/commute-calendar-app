import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/entities/work_record_entity.dart';
import '../../domain/repositories/i_calendar_repository.dart';
import '../datasources/work_record_data_source.dart';
import '../models/work_record_model.dart';

class CalendarRepositoryImpl implements ICalendarRepository {
  const CalendarRepositoryImpl(this._dataSource, this._supabase);

  final WorkRecordDataSource _dataSource;
  final SupabaseClient _supabase;

  @override
  Future<List<WorkRecordEntity>> getRecordsByMonth(int year, int month) async {
    try {
      final userId = _supabase.auth.currentUser!.id;
      final firstDay = _formatDate(year, month, 1);
      final lastDay = _formatDate(year, month, DateTime(year, month + 1, 0).day);
      final rows = await _dataSource.getRecordsByMonth(userId, firstDay, lastDay);
      return rows.map(WorkRecordModel.fromJson).toList();
    } catch (e) {
      throw Exception('근태 기록을 불러오는 중 오류가 발생했습니다: $e');
    }
  }

  @override
  Future<void> addRecord(WorkRecordEntity record) async {
    try {
      final userId = _supabase.auth.currentUser!.id;
      final payload = WorkRecordModel.fromEntity(record).toJson()
        ..['user_id'] = userId;
      await _dataSource.addRecord(payload);
    } catch (e) {
      throw Exception('근태 기록을 추가하는 중 오류가 발생했습니다: $e');
    }
  }

  @override
  Future<void> updateRecord(WorkRecordEntity record) async {
    try {
      final payload = WorkRecordModel.fromEntity(record).toJson()
        ..['updated_at'] = DateTime.now().toIso8601String();
      await _dataSource.updateRecord(record.id, payload);
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

  String _formatDate(int year, int month, int day) =>
      '${year.toString().padLeft(4, '0')}-'
      '${month.toString().padLeft(2, '0')}-'
      '${day.toString().padLeft(2, '0')}';
}
