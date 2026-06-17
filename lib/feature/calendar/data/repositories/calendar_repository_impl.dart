import '../../domain/entities/work_record_entity.dart';
import '../../domain/repositories/i_calendar_repository.dart';
import '../datasources/work_record_data_source.dart';

class CalendarRepositoryImpl implements ICalendarRepository {
  const CalendarRepositoryImpl(this._dataSource);

  final WorkRecordDataSource _dataSource;

  @override
  Future<List<WorkRecord>> getRecordsByMonth(int year, int month) async {
    try {
      return await _dataSource.getRecordsByMonth(year, month);
    } catch (e) {
      throw Exception('근태 기록을 불러오는 중 오류가 발생했습니다: $e');
    }
  }

  @override
  Future<void> addRecord(WorkRecord record) async {
    try {
      await _dataSource.addRecord(record);
    } catch (e) {
      throw Exception('근태 기록을 추가하는 중 오류가 발생했습니다: $e');
    }
  }

  @override
  Future<void> updateRecord(WorkRecord record) async {
    try {
      await _dataSource.updateRecord(record);
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
}
