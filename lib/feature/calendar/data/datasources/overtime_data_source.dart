import 'package:drift/drift.dart';

import '../../../../core/database/app_database.dart';

class OvertimeDataSource {
  const OvertimeDataSource(this._db);

  final AppDatabase _db;

  Future<List<OvertimeRecord>> getOvertimeByMonth(
    DateTime first,
    DateTime last,
  ) {
    return (_db.select(_db.overtimeRecords)
          ..where((t) => t.date.isBetweenValues(first, last)))
        .get();
  }

  Future<void> addOvertime(OvertimeRecordsCompanion companion) async {
    await _db.into(_db.overtimeRecords).insert(companion);
  }

  Future<void> updateOvertime(OvertimeRecordsCompanion companion) async {
    await _db.update(_db.overtimeRecords).replace(companion);
  }

  Future<void> deleteOvertime(String id) async {
    await (_db.delete(_db.overtimeRecords)..where((t) => t.id.equals(id))).go();
  }
}
