import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import '../../feature/calendar/domain/entities/overtime_record_entity.dart';
import '../../feature/calendar/domain/entities/work_record_entity.dart';

part 'app_database.g.dart';

/// 일반 근태 기록 테이블 (근무/연차/휴일)
class WorkRecords extends Table {
  TextColumn get id => text()();
  DateTimeColumn get date => dateTime()();
  TextColumn get type => textEnum<WorkType>()();
  IntColumn get workMinutes => integer().nullable()();
  TextColumn get startTime => text().nullable()(); // 'HH:mm'
  TextColumn get endTime => text().nullable()(); // 'HH:mm'
  TextColumn get memo => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

/// 특근 기록 테이블 (연장근무/휴일근무)
class OvertimeRecords extends Table {
  TextColumn get id => text()();
  DateTimeColumn get date => dateTime()();
  TextColumn get type => textEnum<OvertimeType>()();
  IntColumn get workMinutes => integer()();
  TextColumn get memo => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

@DriftDatabase(tables: [WorkRecords, OvertimeRecords])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  static QueryExecutor _openConnection() {
    return driftDatabase(name: 'commute_calendar');
  }
}
