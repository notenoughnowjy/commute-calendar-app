import 'package:drift/drift.dart';

import '../../../../core/database/app_database.dart';
import '../../domain/entities/overtime_record_entity.dart';
import '../../domain/repositories/i_overtime_repository.dart';
import '../datasources/overtime_data_source.dart';

class OvertimeRepositoryImpl implements IOvertimeRepository {
  const OvertimeRepositoryImpl(this._dataSource);

  final OvertimeDataSource _dataSource;

  @override
  Future<List<OvertimeRecordEntity>> getOvertimeByMonth(
    int year,
    int month,
  ) async {
    try {
      final first = DateTime(year, month, 1);
      final lastDay = DateTime(year, month + 1, 0).day;
      final last = DateTime(year, month, lastDay, 23, 59, 59);
      final rows = await _dataSource.getOvertimeByMonth(first, last);
      return rows.map(_toEntity).toList();
    } catch (e) {
      throw Exception('특근 기록을 불러오는 중 오류가 발생했습니다: $e');
    }
  }

  @override
  Future<void> addOvertime(OvertimeRecordEntity record) async {
    try {
      await _dataSource.addOvertime(_toCompanion(record));
    } catch (e) {
      throw Exception('특근 기록을 추가하는 중 오류가 발생했습니다: $e');
    }
  }

  @override
  Future<void> updateOvertime(OvertimeRecordEntity record) async {
    try {
      await _dataSource.updateOvertime(_toCompanion(record));
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

  OvertimeRecordEntity _toEntity(OvertimeRecord row) {
    return OvertimeRecordEntity(
      id: row.id,
      date: row.date,
      type: row.type,
      workMinutes: row.workMinutes,
      memo: row.memo,
    );
  }

  OvertimeRecordsCompanion _toCompanion(OvertimeRecordEntity record) {
    return OvertimeRecordsCompanion(
      id: Value(record.id),
      date: Value(DateTime(record.date.year, record.date.month, record.date.day)),
      type: Value(record.type),
      workMinutes: Value(record.workMinutes),
      memo: Value(record.memo),
    );
  }
}
