import '../../domain/entities/overtime_record_entity.dart';

class OvertimeRecordModel extends OvertimeRecordEntity {
  const OvertimeRecordModel({
    required super.id,
    required super.date,
    required super.type,
    required super.workMinutes,
    super.memo,
  });

  factory OvertimeRecordModel.fromJson(Map<String, dynamic> json) {
    return OvertimeRecordModel(
      id: json['id'] as String,
      date: DateTime.parse(json['date'] as String),
      type: OvertimeType.values.byName(json['type'] as String),
      workMinutes: json['work_minutes'] as int,
      memo: json['memo'] as String?,
    );
  }

  factory OvertimeRecordModel.fromEntity(OvertimeRecordEntity entity) {
    return OvertimeRecordModel(
      id: entity.id,
      date: entity.date,
      type: entity.type,
      workMinutes: entity.workMinutes,
      memo: entity.memo,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': '${date.year.toString().padLeft(4, '0')}-'
          '${date.month.toString().padLeft(2, '0')}-'
          '${date.day.toString().padLeft(2, '0')}',
      'type': type.name,
      'work_minutes': workMinutes,
      'memo': memo,
    };
  }
}
