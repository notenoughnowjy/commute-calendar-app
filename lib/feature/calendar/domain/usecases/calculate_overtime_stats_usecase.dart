import 'package:equatable/equatable.dart';

import '../entities/overtime_record_entity.dart';
import '../repositories/i_overtime_repository.dart';

class OvertimeStats extends Equatable {
  const OvertimeStats({
    required this.weekdayOvertimeMinutes,
    required this.holidayWorkMinutes,
  });

  final int weekdayOvertimeMinutes; // 연장근무 합계 (분)
  final int holidayWorkMinutes; // 휴일근무 합계 (분)

  int get totalOvertimeMinutes => weekdayOvertimeMinutes + holidayWorkMinutes;

  /// 수당 계산: 기본 1.5배, 배율은 외부에서 지정 가능
  int calculateAllowance(
    int hourlyWage, {
    double weekdayMultiplier = 1.5,
    double holidayMultiplier = 1.5,
  }) {
    final weekdayAllowance =
        (hourlyWage * weekdayMultiplier * weekdayOvertimeMinutes / 60).round();
    final holidayAllowance =
        (hourlyWage * holidayMultiplier * holidayWorkMinutes / 60).round();
    return weekdayAllowance + holidayAllowance;
  }

  @override
  List<Object?> get props => [weekdayOvertimeMinutes, holidayWorkMinutes];
}

class CalculateOvertimeStatsUseCase {
  const CalculateOvertimeStatsUseCase(this._repository);

  final IOvertimeRepository _repository;

  Future<OvertimeStats> call(int year, int month) async {
    final records = await _repository.getOvertimeByMonth(year, month);

    int weekdayOvertimeMinutes = 0;
    int holidayWorkMinutes = 0;

    for (final record in records) {
      switch (record.type) {
        case OvertimeType.weekdayOvertime:
          weekdayOvertimeMinutes += record.workMinutes;
        case OvertimeType.holidayWork:
          holidayWorkMinutes += record.workMinutes;
      }
    }

    return OvertimeStats(
      weekdayOvertimeMinutes: weekdayOvertimeMinutes,
      holidayWorkMinutes: holidayWorkMinutes,
    );
  }
}
