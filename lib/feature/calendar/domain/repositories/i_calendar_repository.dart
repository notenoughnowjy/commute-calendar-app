import '../entities/work_record_entity.dart';

abstract interface class ICalendarRepository {
  Future<List<WorkRecordEntity>> getRecordsByMonth(int year, int month);
  Future<void> addRecord(WorkRecordEntity record);
  Future<void> updateRecord(WorkRecordEntity record);
  Future<void> deleteRecord(String id);
}
