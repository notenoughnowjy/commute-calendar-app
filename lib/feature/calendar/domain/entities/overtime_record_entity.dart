import 'package:equatable/equatable.dart';

enum OvertimeType {
  weekdayOvertime, // 연장근무 (평일 시간 외)
  holidayWork, // 휴일근무 (주말/공휴일)
}

class OvertimeRecordEntity extends Equatable {
  const OvertimeRecordEntity({
    required this.id,
    required this.date,
    required this.type,
    required this.workMinutes,
    this.memo,
  });

  final String id;
  final DateTime date;
  final OvertimeType type;
  final int workMinutes; // 특근 시간 (분 단위)
  final String? memo;

  Duration get workedDuration => Duration(minutes: workMinutes);

  bool get hasMemo => memo != null && memo!.isNotEmpty;

  OvertimeRecordEntity copyWith({
    String? id,
    DateTime? date,
    OvertimeType? type,
    int? workMinutes,
    String? memo,
  }) {
    return OvertimeRecordEntity(
      id: id ?? this.id,
      date: date ?? this.date,
      type: type ?? this.type,
      workMinutes: workMinutes ?? this.workMinutes,
      memo: memo ?? this.memo,
    );
  }

  @override
  List<Object?> get props => [id, date, type, workMinutes, memo];
}
