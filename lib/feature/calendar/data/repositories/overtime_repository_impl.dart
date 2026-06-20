import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/entities/overtime_record_entity.dart';
import '../../domain/repositories/i_overtime_repository.dart';
import '../datasources/overtime_data_source.dart';
import '../models/overtime_record_model.dart';

class OvertimeRepositoryImpl implements IOvertimeRepository {
  const OvertimeRepositoryImpl(this._dataSource, this._supabase);

  final OvertimeDataSource _dataSource;
  final SupabaseClient _supabase;

  @override
  Future<List<OvertimeRecordEntity>> getOvertimeByMonth(
    int year,
    int month,
  ) async {
    try {
      final userId = _supabase.auth.currentUser!.id;
      final firstDay = _formatDate(year, month, 1);
      final lastDay = _formatDate(year, month, DateTime(year, month + 1, 0).day);
      final rows = await _dataSource.getOvertimeByMonth(userId, firstDay, lastDay);
      return rows.map(OvertimeRecordModel.fromJson).toList();
    } catch (e) {
      throw Exception('특근 기록을 불러오는 중 오류가 발생했습니다: $e');
    }
  }

  @override
  Future<void> addOvertime(OvertimeRecordEntity record) async {
    try {
      final userId = _supabase.auth.currentUser!.id;
      final payload = OvertimeRecordModel.fromEntity(record).toJson()
        ..['user_id'] = userId;
      await _dataSource.addOvertime(payload);
    } catch (e) {
      throw Exception('특근 기록을 추가하는 중 오류가 발생했습니다: $e');
    }
  }

  @override
  Future<void> updateOvertime(OvertimeRecordEntity record) async {
    try {
      final payload = OvertimeRecordModel.fromEntity(record).toJson()
        ..['updated_at'] = DateTime.now().toIso8601String();
      await _dataSource.updateOvertime(record.id, payload);
    } catch (e) {
      throw Exception('특근 기록을 수정하는 중 오류가 발생했습니다: $e');
    }
  }

  @override
  Future<void> deleteOvertime(String id) async {
    try {
      await _dataSource.deleteOvertime(id);
    } catch (e) {
      throw Exception('특근 기록을 삭제하는 중 오류가 발생했습니다: $e');
    }
  }

  String _formatDate(int year, int month, int day) =>
      '${year.toString().padLeft(4, '0')}-'
      '${month.toString().padLeft(2, '0')}-'
      '${day.toString().padLeft(2, '0')}';
}
