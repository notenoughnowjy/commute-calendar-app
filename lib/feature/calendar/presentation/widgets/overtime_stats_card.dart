import 'package:commute_calendar/core/theme/theme_service.dart';
import 'package:commute_calendar/feature/calendar/domain/usecases/calculate_overtime_stats_usecase.dart';
import 'package:commute_calendar/feature/common/widgets/multiplier_control.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class OvertimeStatsCard extends StatelessWidget {
  const OvertimeStatsCard({
    super.key,
    required this.stats,
    required this.hourlyWage,
    required this.weekdayMultiplier,
    required this.holidayMultiplier,
    required this.onWeekdayMultiplierChanged,
    required this.onHolidayMultiplierChanged,
  });

  final OvertimeStats stats;
  final int? hourlyWage;
  final double weekdayMultiplier;
  final double holidayMultiplier;
  final ValueChanged<double> onWeekdayMultiplierChanged;
  final ValueChanged<double> onHolidayMultiplierChanged;

  int? _allowance(double multiplier, int minutes) {
    if (hourlyWage == null) return null;
    return (hourlyWage! * multiplier * minutes / 60).round();
  }

  @override
  Widget build(BuildContext context) {
    final weekdayAllowance =
        _allowance(weekdayMultiplier, stats.weekdayOvertimeMinutes);
    final holidayAllowance =
        _allowance(holidayMultiplier, stats.holidayWorkMinutes);
    final totalAllowance =
        weekdayAllowance != null && holidayAllowance != null
            ? weekdayAllowance + holidayAllowance
            : null;

    return Container(
      decoration: BoxDecoration(
        color: ThemeService.black100,
        borderRadius: BorderRadius.circular(14),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      child: Column(
        children: [
          _StatRow(
            label: '연장근무',
            duration: Duration(minutes: stats.weekdayOvertimeMinutes),
            allowance: weekdayAllowance,
            multiplier: weekdayMultiplier,
            onMultiplierChanged: onWeekdayMultiplierChanged,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 14),
            child: Divider(height: 1, color: ThemeService.black200),
          ),
          _StatRow(
            label: '휴일근무',
            duration: Duration(minutes: stats.holidayWorkMinutes),
            allowance: holidayAllowance,
            multiplier: holidayMultiplier,
            onMultiplierChanged: onHolidayMultiplierChanged,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 14),
            child: Divider(height: 1, color: ThemeService.black200),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '합계 수당',
                style: ThemeService.body2.copyWith(fontWeight: FontWeight.w600),
              ),
              Text(
                _formatAmount(totalAllowance),
                style: ThemeService.body1.copyWith(
                  color: ThemeService.tertiary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  static String _formatAmount(int? amount) {
    if (amount == null) return '- 원';
    return '${NumberFormat('#,###').format(amount)}원';
  }
}

class _StatRow extends StatelessWidget {
  const _StatRow({
    required this.label,
    required this.duration,
    required this.allowance,
    required this.multiplier,
    required this.onMultiplierChanged,
  });

  final String label;
  final Duration duration;
  final int? allowance;
  final double multiplier;
  final ValueChanged<double> onMultiplierChanged;

  String _formatDuration(Duration d) {
    final h = d.inHours;
    final m = d.inMinutes.remainder(60);
    if (h == 0) return '$m분';
    if (m == 0) return '$h시간';
    return '$h시간 $m분';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style:
                  ThemeService.caption.copyWith(color: ThemeService.black600),
            ),
            MultiplierControl(
              value: multiplier,
              onChanged: onMultiplierChanged,
            ),
          ],
        ),
        const SizedBox(height: 6),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(_formatDuration(duration), style: ThemeService.body2),
            Text(
              OvertimeStatsCard._formatAmount(allowance),
              style: ThemeService.body2.copyWith(color: ThemeService.black700),
            ),
          ],
        ),
      ],
    );
  }
}
