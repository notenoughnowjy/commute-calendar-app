import 'package:drift/drift.dart';

import '../../../../core/database/app_database.dart';

class WorkRecordDataSource {
  const WorkRecordDataSource(this._db);

  final AppDatabase _db;

  Future<List<WorkRecord>> getRecordsByMonth(
    DateTime first,
    DateTime last,
  ) {
    return (_db.select(_db.workRecords)
          ..where((t) => t.date.isBetweenValues(first, last)))
        .get();
  }

  Future<void> addRecord(WorkRecordsCompanion companion) async {
    await _db.into(_db.workRecords).insert(companion);
  }

  Future<void> updateRecord(WorkRecordsCompanion companion) async {
    await _db.update(_db.workRecords).replace(companion);
  }

  Future<void> deleteRecord(String id) async {
    await (_db.delete(_db.workRecords)..where((t) => t.id.equals(id))).go();
  }
}
