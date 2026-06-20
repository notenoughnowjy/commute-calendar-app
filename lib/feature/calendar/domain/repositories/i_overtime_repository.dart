import '../entities/overtime_record_entity.dart';

abstract interface class IOvertimeRepository {
  Future<List<OvertimeRecordEntity>> getOvertimeByMonth(int year, int month);
  Future<void> addOvertime(OvertimeRecordEntity record);
  Future<void> updateOvertime(OvertimeRecordEntity record);
  Future<void> deleteOvertime(String id);
}
