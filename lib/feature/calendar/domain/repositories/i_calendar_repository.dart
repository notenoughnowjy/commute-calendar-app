import '../entities/work_record_entity.dart';

abstract interface class ICalendarRepository {
  Future<List<WorkRecord>> getRecordsByMonth(int year, int month);
  Future<void> addRecord(WorkRecord record);
  Future<void> updateRecord(WorkRecord record);
  Future<void> deleteRecord(String id);
}
