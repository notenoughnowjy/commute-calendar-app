import 'package:commute_calendar/feature/calendar/domain/entities/overtime_record_entity.dart';
import 'package:commute_calendar/feature/calendar/domain/repositories/i_overtime_repository.dart';

class MockOvertimeRepository implements IOvertimeRepository {
  MockOvertimeRepository() {
    _initDummyData();
  }

  final List<OvertimeRecordEntity> _records = [];

  void _initDummyData() {
    final now = DateTime.now();
    final y = now.year;
    final m = now.month;

    _records.addAll([
      // 평일 연장근무 (일반근무 기록이 있는 날과 같은 날 → 목록 표시 검증용)
      OvertimeRecordEntity(
        id: 'ot1',
        date: DateTime(y, m, 2),
        type: OvertimeType.weekdayOvertime,
        workMinutes: 120, // 2h
        memo: '긴급 배포 대응',
      ),
      OvertimeRecordEntity(
        id: 'ot2',
        date: DateTime(y, m, 3),
        type: OvertimeType.weekdayOvertime,
        workMinutes: 90, // 1h 30m
      ),
      // 휴일근무 (주말)
      OvertimeRecordEntity(
        id: 'ot3',
        date: DateTime(y, m, 6),
        type: OvertimeType.holidayWork,
        workMinutes: 240, // 4h
        memo: '프로젝트 마감',
      ),
      OvertimeRecordEntity(
        id: 'ot4',
        date: DateTime(y, m, 7),
        type: OvertimeType.holidayWork,
        workMinutes: 180, // 3h
      ),
      // 연장근무 (일반근무 없이 특근만 있는 날 → 단독 표시 검증용)
      OvertimeRecordEntity(
        id: 'ot5',
        date: DateTime(y, m, 13),
        type: OvertimeType.weekdayOvertime,
        workMinutes: 60, // 1h
      ),
    ]);
  }

  @override
  Future<List<OvertimeRecordEntity>> getOvertimeByMonth(
    int year,
    int month,
  ) async {
    return _records
        .where((r) => r.date.year == year && r.date.month == month)
        .toList();
  }

  @override
  Future<void> addOvertime(OvertimeRecordEntity record) async {
    _records.add(record);
  }

  @override
  Future<void> updateOvertime(OvertimeRecordEntity record) async {
    final index = _records.indexWhere((r) => r.id == record.id);
    if (index != -1) _records[index] = record;
  }

  @override
  Future<void> deleteOvertime(String id) async {
    _records.removeWhere((r) => r.id == id);
  }
}
