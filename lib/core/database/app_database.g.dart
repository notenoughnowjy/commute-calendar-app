// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $WorkRecordsTable extends WorkRecords
    with TableInfo<$WorkRecordsTable, WorkRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WorkRecordsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<WorkType, String> type =
      GeneratedColumn<String>(
        'type',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<WorkType>($WorkRecordsTable.$convertertype);
  static const VerificationMeta _workMinutesMeta = const VerificationMeta(
    'workMinutes',
  );
  @override
  late final GeneratedColumn<int> workMinutes = GeneratedColumn<int>(
    'work_minutes',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _startTimeMeta = const VerificationMeta(
    'startTime',
  );
  @override
  late final GeneratedColumn<String> startTime = GeneratedColumn<String>(
    'start_time',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _endTimeMeta = const VerificationMeta(
    'endTime',
  );
  @override
  late final GeneratedColumn<String> endTime = GeneratedColumn<String>(
    'end_time',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _memoMeta = const VerificationMeta('memo');
  @override
  late final GeneratedColumn<String> memo = GeneratedColumn<String>(
    'memo',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    date,
    type,
    workMinutes,
    startTime,
    endTime,
    memo,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'work_records';
  @override
  VerificationContext validateIntegrity(
    Insertable<WorkRecord> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('work_minutes')) {
      context.handle(
        _workMinutesMeta,
        workMinutes.isAcceptableOrUnknown(
          data['work_minutes']!,
          _workMinutesMeta,
        ),
      );
    }
    if (data.containsKey('start_time')) {
      context.handle(
        _startTimeMeta,
        startTime.isAcceptableOrUnknown(data['start_time']!, _startTimeMeta),
      );
    }
    if (data.containsKey('end_time')) {
      context.handle(
        _endTimeMeta,
        endTime.isAcceptableOrUnknown(data['end_time']!, _endTimeMeta),
      );
    }
    if (data.containsKey('memo')) {
      context.handle(
        _memoMeta,
        memo.isAcceptableOrUnknown(data['memo']!, _memoMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WorkRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WorkRecord(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      type: $WorkRecordsTable.$convertertype.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}type'],
        )!,
      ),
      workMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}work_minutes'],
      ),
      startTime: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}start_time'],
      ),
      endTime: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}end_time'],
      ),
      memo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}memo'],
      ),
    );
  }

  @override
  $WorkRecordsTable createAlias(String alias) {
    return $WorkRecordsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<WorkType, String, String> $convertertype =
      const EnumNameConverter<WorkType>(WorkType.values);
}

class WorkRecord extends DataClass implements Insertable<WorkRecord> {
  final String id;
  final DateTime date;
  final WorkType type;
  final int? workMinutes;
  final String? startTime;
  final String? endTime;
  final String? memo;
  const WorkRecord({
    required this.id,
    required this.date,
    required this.type,
    this.workMinutes,
    this.startTime,
    this.endTime,
    this.memo,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['date'] = Variable<DateTime>(date);
    {
      map['type'] = Variable<String>(
        $WorkRecordsTable.$convertertype.toSql(type),
      );
    }
    if (!nullToAbsent || workMinutes != null) {
      map['work_minutes'] = Variable<int>(workMinutes);
    }
    if (!nullToAbsent || startTime != null) {
      map['start_time'] = Variable<String>(startTime);
    }
    if (!nullToAbsent || endTime != null) {
      map['end_time'] = Variable<String>(endTime);
    }
    if (!nullToAbsent || memo != null) {
      map['memo'] = Variable<String>(memo);
    }
    return map;
  }

  WorkRecordsCompanion toCompanion(bool nullToAbsent) {
    return WorkRecordsCompanion(
      id: Value(id),
      date: Value(date),
      type: Value(type),
      workMinutes: workMinutes == null && nullToAbsent
          ? const Value.absent()
          : Value(workMinutes),
      startTime: startTime == null && nullToAbsent
          ? const Value.absent()
          : Value(startTime),
      endTime: endTime == null && nullToAbsent
          ? const Value.absent()
          : Value(endTime),
      memo: memo == null && nullToAbsent ? const Value.absent() : Value(memo),
    );
  }

  factory WorkRecord.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WorkRecord(
      id: serializer.fromJson<String>(json['id']),
      date: serializer.fromJson<DateTime>(json['date']),
      type: $WorkRecordsTable.$convertertype.fromJson(
        serializer.fromJson<String>(json['type']),
      ),
      workMinutes: serializer.fromJson<int?>(json['workMinutes']),
      startTime: serializer.fromJson<String?>(json['startTime']),
      endTime: serializer.fromJson<String?>(json['endTime']),
      memo: serializer.fromJson<String?>(json['memo']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'date': serializer.toJson<DateTime>(date),
      'type': serializer.toJson<String>(
        $WorkRecordsTable.$convertertype.toJson(type),
      ),
      'workMinutes': serializer.toJson<int?>(workMinutes),
      'startTime': serializer.toJson<String?>(startTime),
      'endTime': serializer.toJson<String?>(endTime),
      'memo': serializer.toJson<String?>(memo),
    };
  }

  WorkRecord copyWith({
    String? id,
    DateTime? date,
    WorkType? type,
    Value<int?> workMinutes = const Value.absent(),
    Value<String?> startTime = const Value.absent(),
    Value<String?> endTime = const Value.absent(),
    Value<String?> memo = const Value.absent(),
  }) => WorkRecord(
    id: id ?? this.id,
    date: date ?? this.date,
    type: type ?? this.type,
    workMinutes: workMinutes.present ? workMinutes.value : this.workMinutes,
    startTime: startTime.present ? startTime.value : this.startTime,
    endTime: endTime.present ? endTime.value : this.endTime,
    memo: memo.present ? memo.value : this.memo,
  );
  WorkRecord copyWithCompanion(WorkRecordsCompanion data) {
    return WorkRecord(
      id: data.id.present ? data.id.value : this.id,
      date: data.date.present ? data.date.value : this.date,
      type: data.type.present ? data.type.value : this.type,
      workMinutes: data.workMinutes.present
          ? data.workMinutes.value
          : this.workMinutes,
      startTime: data.startTime.present ? data.startTime.value : this.startTime,
      endTime: data.endTime.present ? data.endTime.value : this.endTime,
      memo: data.memo.present ? data.memo.value : this.memo,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WorkRecord(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('type: $type, ')
          ..write('workMinutes: $workMinutes, ')
          ..write('startTime: $startTime, ')
          ..write('endTime: $endTime, ')
          ..write('memo: $memo')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, date, type, workMinutes, startTime, endTime, memo);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WorkRecord &&
          other.id == this.id &&
          other.date == this.date &&
          other.type == this.type &&
          other.workMinutes == this.workMinutes &&
          other.startTime == this.startTime &&
          other.endTime == this.endTime &&
          other.memo == this.memo);
}

class WorkRecordsCompanion extends UpdateCompanion<WorkRecord> {
  final Value<String> id;
  final Value<DateTime> date;
  final Value<WorkType> type;
  final Value<int?> workMinutes;
  final Value<String?> startTime;
  final Value<String?> endTime;
  final Value<String?> memo;
  final Value<int> rowid;
  const WorkRecordsCompanion({
    this.id = const Value.absent(),
    this.date = const Value.absent(),
    this.type = const Value.absent(),
    this.workMinutes = const Value.absent(),
    this.startTime = const Value.absent(),
    this.endTime = const Value.absent(),
    this.memo = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  WorkRecordsCompanion.insert({
    required String id,
    required DateTime date,
    required WorkType type,
    this.workMinutes = const Value.absent(),
    this.startTime = const Value.absent(),
    this.endTime = const Value.absent(),
    this.memo = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       date = Value(date),
       type = Value(type);
  static Insertable<WorkRecord> custom({
    Expression<String>? id,
    Expression<DateTime>? date,
    Expression<String>? type,
    Expression<int>? workMinutes,
    Expression<String>? startTime,
    Expression<String>? endTime,
    Expression<String>? memo,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (date != null) 'date': date,
      if (type != null) 'type': type,
      if (workMinutes != null) 'work_minutes': workMinutes,
      if (startTime != null) 'start_time': startTime,
      if (endTime != null) 'end_time': endTime,
      if (memo != null) 'memo': memo,
      if (rowid != null) 'rowid': rowid,
    });
  }

  WorkRecordsCompanion copyWith({
    Value<String>? id,
    Value<DateTime>? date,
    Value<WorkType>? type,
    Value<int?>? workMinutes,
    Value<String?>? startTime,
    Value<String?>? endTime,
    Value<String?>? memo,
    Value<int>? rowid,
  }) {
    return WorkRecordsCompanion(
      id: id ?? this.id,
      date: date ?? this.date,
      type: type ?? this.type,
      workMinutes: workMinutes ?? this.workMinutes,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      memo: memo ?? this.memo,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(
        $WorkRecordsTable.$convertertype.toSql(type.value),
      );
    }
    if (workMinutes.present) {
      map['work_minutes'] = Variable<int>(workMinutes.value);
    }
    if (startTime.present) {
      map['start_time'] = Variable<String>(startTime.value);
    }
    if (endTime.present) {
      map['end_time'] = Variable<String>(endTime.value);
    }
    if (memo.present) {
      map['memo'] = Variable<String>(memo.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WorkRecordsCompanion(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('type: $type, ')
          ..write('workMinutes: $workMinutes, ')
          ..write('startTime: $startTime, ')
          ..write('endTime: $endTime, ')
          ..write('memo: $memo, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $OvertimeRecordsTable extends OvertimeRecords
    with TableInfo<$OvertimeRecordsTable, OvertimeRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OvertimeRecordsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<OvertimeType, String> type =
      GeneratedColumn<String>(
        'type',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<OvertimeType>($OvertimeRecordsTable.$convertertype);
  static const VerificationMeta _workMinutesMeta = const VerificationMeta(
    'workMinutes',
  );
  @override
  late final GeneratedColumn<int> workMinutes = GeneratedColumn<int>(
    'work_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _memoMeta = const VerificationMeta('memo');
  @override
  late final GeneratedColumn<String> memo = GeneratedColumn<String>(
    'memo',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [id, date, type, workMinutes, memo];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'overtime_records';
  @override
  VerificationContext validateIntegrity(
    Insertable<OvertimeRecord> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('work_minutes')) {
      context.handle(
        _workMinutesMeta,
        workMinutes.isAcceptableOrUnknown(
          data['work_minutes']!,
          _workMinutesMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_workMinutesMeta);
    }
    if (data.containsKey('memo')) {
      context.handle(
        _memoMeta,
        memo.isAcceptableOrUnknown(data['memo']!, _memoMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  OvertimeRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return OvertimeRecord(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      type: $OvertimeRecordsTable.$convertertype.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}type'],
        )!,
      ),
      workMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}work_minutes'],
      )!,
      memo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}memo'],
      ),
    );
  }

  @override
  $OvertimeRecordsTable createAlias(String alias) {
    return $OvertimeRecordsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<OvertimeType, String, String> $convertertype =
      const EnumNameConverter<OvertimeType>(OvertimeType.values);
}

class OvertimeRecord extends DataClass implements Insertable<OvertimeRecord> {
  final String id;
  final DateTime date;
  final OvertimeType type;
  final int workMinutes;
  final String? memo;
  const OvertimeRecord({
    required this.id,
    required this.date,
    required this.type,
    required this.workMinutes,
    this.memo,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['date'] = Variable<DateTime>(date);
    {
      map['type'] = Variable<String>(
        $OvertimeRecordsTable.$convertertype.toSql(type),
      );
    }
    map['work_minutes'] = Variable<int>(workMinutes);
    if (!nullToAbsent || memo != null) {
      map['memo'] = Variable<String>(memo);
    }
    return map;
  }

  OvertimeRecordsCompanion toCompanion(bool nullToAbsent) {
    return OvertimeRecordsCompanion(
      id: Value(id),
      date: Value(date),
      type: Value(type),
      workMinutes: Value(workMinutes),
      memo: memo == null && nullToAbsent ? const Value.absent() : Value(memo),
    );
  }

  factory OvertimeRecord.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return OvertimeRecord(
      id: serializer.fromJson<String>(json['id']),
      date: serializer.fromJson<DateTime>(json['date']),
      type: $OvertimeRecordsTable.$convertertype.fromJson(
        serializer.fromJson<String>(json['type']),
      ),
      workMinutes: serializer.fromJson<int>(json['workMinutes']),
      memo: serializer.fromJson<String?>(json['memo']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'date': serializer.toJson<DateTime>(date),
      'type': serializer.toJson<String>(
        $OvertimeRecordsTable.$convertertype.toJson(type),
      ),
      'workMinutes': serializer.toJson<int>(workMinutes),
      'memo': serializer.toJson<String?>(memo),
    };
  }

  OvertimeRecord copyWith({
    String? id,
    DateTime? date,
    OvertimeType? type,
    int? workMinutes,
    Value<String?> memo = const Value.absent(),
  }) => OvertimeRecord(
    id: id ?? this.id,
    date: date ?? this.date,
    type: type ?? this.type,
    workMinutes: workMinutes ?? this.workMinutes,
    memo: memo.present ? memo.value : this.memo,
  );
  OvertimeRecord copyWithCompanion(OvertimeRecordsCompanion data) {
    return OvertimeRecord(
      id: data.id.present ? data.id.value : this.id,
      date: data.date.present ? data.date.value : this.date,
      type: data.type.present ? data.type.value : this.type,
      workMinutes: data.workMinutes.present
          ? data.workMinutes.value
          : this.workMinutes,
      memo: data.memo.present ? data.memo.value : this.memo,
    );
  }

  @override
  String toString() {
    return (StringBuffer('OvertimeRecord(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('type: $type, ')
          ..write('workMinutes: $workMinutes, ')
          ..write('memo: $memo')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, date, type, workMinutes, memo);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is OvertimeRecord &&
          other.id == this.id &&
          other.date == this.date &&
          other.type == this.type &&
          other.workMinutes == this.workMinutes &&
          other.memo == this.memo);
}

class OvertimeRecordsCompanion extends UpdateCompanion<OvertimeRecord> {
  final Value<String> id;
  final Value<DateTime> date;
  final Value<OvertimeType> type;
  final Value<int> workMinutes;
  final Value<String?> memo;
  final Value<int> rowid;
  const OvertimeRecordsCompanion({
    this.id = const Value.absent(),
    this.date = const Value.absent(),
    this.type = const Value.absent(),
    this.workMinutes = const Value.absent(),
    this.memo = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  OvertimeRecordsCompanion.insert({
    required String id,
    required DateTime date,
    required OvertimeType type,
    required int workMinutes,
    this.memo = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       date = Value(date),
       type = Value(type),
       workMinutes = Value(workMinutes);
  static Insertable<OvertimeRecord> custom({
    Expression<String>? id,
    Expression<DateTime>? date,
    Expression<String>? type,
    Expression<int>? workMinutes,
    Expression<String>? memo,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (date != null) 'date': date,
      if (type != null) 'type': type,
      if (workMinutes != null) 'work_minutes': workMinutes,
      if (memo != null) 'memo': memo,
      if (rowid != null) 'rowid': rowid,
    });
  }

  OvertimeRecordsCompanion copyWith({
    Value<String>? id,
    Value<DateTime>? date,
    Value<OvertimeType>? type,
    Value<int>? workMinutes,
    Value<String?>? memo,
    Value<int>? rowid,
  }) {
    return OvertimeRecordsCompanion(
      id: id ?? this.id,
      date: date ?? this.date,
      type: type ?? this.type,
      workMinutes: workMinutes ?? this.workMinutes,
      memo: memo ?? this.memo,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(
        $OvertimeRecordsTable.$convertertype.toSql(type.value),
      );
    }
    if (workMinutes.present) {
      map['work_minutes'] = Variable<int>(workMinutes.value);
    }
    if (memo.present) {
      map['memo'] = Variable<String>(memo.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OvertimeRecordsCompanion(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('type: $type, ')
          ..write('workMinutes: $workMinutes, ')
          ..write('memo: $memo, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $WorkRecordsTable workRecords = $WorkRecordsTable(this);
  late final $OvertimeRecordsTable overtimeRecords = $OvertimeRecordsTable(
    this,
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    workRecords,
    overtimeRecords,
  ];
}

typedef $$WorkRecordsTableCreateCompanionBuilder =
    WorkRecordsCompanion Function({
      required String id,
      required DateTime date,
      required WorkType type,
      Value<int?> workMinutes,
      Value<String?> startTime,
      Value<String?> endTime,
      Value<String?> memo,
      Value<int> rowid,
    });
typedef $$WorkRecordsTableUpdateCompanionBuilder =
    WorkRecordsCompanion Function({
      Value<String> id,
      Value<DateTime> date,
      Value<WorkType> type,
      Value<int?> workMinutes,
      Value<String?> startTime,
      Value<String?> endTime,
      Value<String?> memo,
      Value<int> rowid,
    });

class $$WorkRecordsTableFilterComposer
    extends Composer<_$AppDatabase, $WorkRecordsTable> {
  $$WorkRecordsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<WorkType, WorkType, String> get type =>
      $composableBuilder(
        column: $table.type,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<int> get workMinutes => $composableBuilder(
    column: $table.workMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get startTime => $composableBuilder(
    column: $table.startTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get endTime => $composableBuilder(
    column: $table.endTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get memo => $composableBuilder(
    column: $table.memo,
    builder: (column) => ColumnFilters(column),
  );
}

class $$WorkRecordsTableOrderingComposer
    extends Composer<_$AppDatabase, $WorkRecordsTable> {
  $$WorkRecordsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get workMinutes => $composableBuilder(
    column: $table.workMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get startTime => $composableBuilder(
    column: $table.startTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get endTime => $composableBuilder(
    column: $table.endTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get memo => $composableBuilder(
    column: $table.memo,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$WorkRecordsTableAnnotationComposer
    extends Composer<_$AppDatabase, $WorkRecordsTable> {
  $$WorkRecordsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumnWithTypeConverter<WorkType, String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<int> get workMinutes => $composableBuilder(
    column: $table.workMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<String> get startTime =>
      $composableBuilder(column: $table.startTime, builder: (column) => column);

  GeneratedColumn<String> get endTime =>
      $composableBuilder(column: $table.endTime, builder: (column) => column);

  GeneratedColumn<String> get memo =>
      $composableBuilder(column: $table.memo, builder: (column) => column);
}

class $$WorkRecordsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WorkRecordsTable,
          WorkRecord,
          $$WorkRecordsTableFilterComposer,
          $$WorkRecordsTableOrderingComposer,
          $$WorkRecordsTableAnnotationComposer,
          $$WorkRecordsTableCreateCompanionBuilder,
          $$WorkRecordsTableUpdateCompanionBuilder,
          (
            WorkRecord,
            BaseReferences<_$AppDatabase, $WorkRecordsTable, WorkRecord>,
          ),
          WorkRecord,
          PrefetchHooks Function()
        > {
  $$WorkRecordsTableTableManager(_$AppDatabase db, $WorkRecordsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WorkRecordsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WorkRecordsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WorkRecordsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<WorkType> type = const Value.absent(),
                Value<int?> workMinutes = const Value.absent(),
                Value<String?> startTime = const Value.absent(),
                Value<String?> endTime = const Value.absent(),
                Value<String?> memo = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WorkRecordsCompanion(
                id: id,
                date: date,
                type: type,
                workMinutes: workMinutes,
                startTime: startTime,
                endTime: endTime,
                memo: memo,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required DateTime date,
                required WorkType type,
                Value<int?> workMinutes = const Value.absent(),
                Value<String?> startTime = const Value.absent(),
                Value<String?> endTime = const Value.absent(),
                Value<String?> memo = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WorkRecordsCompanion.insert(
                id: id,
                date: date,
                type: type,
                workMinutes: workMinutes,
                startTime: startTime,
                endTime: endTime,
                memo: memo,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$WorkRecordsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WorkRecordsTable,
      WorkRecord,
      $$WorkRecordsTableFilterComposer,
      $$WorkRecordsTableOrderingComposer,
      $$WorkRecordsTableAnnotationComposer,
      $$WorkRecordsTableCreateCompanionBuilder,
      $$WorkRecordsTableUpdateCompanionBuilder,
      (
        WorkRecord,
        BaseReferences<_$AppDatabase, $WorkRecordsTable, WorkRecord>,
      ),
      WorkRecord,
      PrefetchHooks Function()
    >;
typedef $$OvertimeRecordsTableCreateCompanionBuilder =
    OvertimeRecordsCompanion Function({
      required String id,
      required DateTime date,
      required OvertimeType type,
      required int workMinutes,
      Value<String?> memo,
      Value<int> rowid,
    });
typedef $$OvertimeRecordsTableUpdateCompanionBuilder =
    OvertimeRecordsCompanion Function({
      Value<String> id,
      Value<DateTime> date,
      Value<OvertimeType> type,
      Value<int> workMinutes,
      Value<String?> memo,
      Value<int> rowid,
    });

class $$OvertimeRecordsTableFilterComposer
    extends Composer<_$AppDatabase, $OvertimeRecordsTable> {
  $$OvertimeRecordsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<OvertimeType, OvertimeType, String> get type =>
      $composableBuilder(
        column: $table.type,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<int> get workMinutes => $composableBuilder(
    column: $table.workMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get memo => $composableBuilder(
    column: $table.memo,
    builder: (column) => ColumnFilters(column),
  );
}

class $$OvertimeRecordsTableOrderingComposer
    extends Composer<_$AppDatabase, $OvertimeRecordsTable> {
  $$OvertimeRecordsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get workMinutes => $composableBuilder(
    column: $table.workMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get memo => $composableBuilder(
    column: $table.memo,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$OvertimeRecordsTableAnnotationComposer
    extends Composer<_$AppDatabase, $OvertimeRecordsTable> {
  $$OvertimeRecordsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumnWithTypeConverter<OvertimeType, String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<int> get workMinutes => $composableBuilder(
    column: $table.workMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<String> get memo =>
      $composableBuilder(column: $table.memo, builder: (column) => column);
}

class $$OvertimeRecordsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $OvertimeRecordsTable,
          OvertimeRecord,
          $$OvertimeRecordsTableFilterComposer,
          $$OvertimeRecordsTableOrderingComposer,
          $$OvertimeRecordsTableAnnotationComposer,
          $$OvertimeRecordsTableCreateCompanionBuilder,
          $$OvertimeRecordsTableUpdateCompanionBuilder,
          (
            OvertimeRecord,
            BaseReferences<
              _$AppDatabase,
              $OvertimeRecordsTable,
              OvertimeRecord
            >,
          ),
          OvertimeRecord,
          PrefetchHooks Function()
        > {
  $$OvertimeRecordsTableTableManager(
    _$AppDatabase db,
    $OvertimeRecordsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$OvertimeRecordsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$OvertimeRecordsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$OvertimeRecordsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<OvertimeType> type = const Value.absent(),
                Value<int> workMinutes = const Value.absent(),
                Value<String?> memo = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => OvertimeRecordsCompanion(
                id: id,
                date: date,
                type: type,
                workMinutes: workMinutes,
                memo: memo,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required DateTime date,
                required OvertimeType type,
                required int workMinutes,
                Value<String?> memo = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => OvertimeRecordsCompanion.insert(
                id: id,
                date: date,
                type: type,
                workMinutes: workMinutes,
                memo: memo,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$OvertimeRecordsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $OvertimeRecordsTable,
      OvertimeRecord,
      $$OvertimeRecordsTableFilterComposer,
      $$OvertimeRecordsTableOrderingComposer,
      $$OvertimeRecordsTableAnnotationComposer,
      $$OvertimeRecordsTableCreateCompanionBuilder,
      $$OvertimeRecordsTableUpdateCompanionBuilder,
      (
        OvertimeRecord,
        BaseReferences<_$AppDatabase, $OvertimeRecordsTable, OvertimeRecord>,
      ),
      OvertimeRecord,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$WorkRecordsTableTableManager get workRecords =>
      $$WorkRecordsTableTableManager(_db, _db.workRecords);
  $$OvertimeRecordsTableTableManager get overtimeRecords =>
      $$OvertimeRecordsTableTableManager(_db, _db.overtimeRecords);
}
