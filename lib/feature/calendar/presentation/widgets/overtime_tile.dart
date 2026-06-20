import 'package:commute_calendar/core/theme/theme_service.dart';
import 'package:commute_calendar/feature/calendar/domain/entities/overtime_record_entity.dart';
import 'package:commute_calendar/feature/calendar/presentation/bloc/calendar_bloc.dart';
import 'package:commute_calendar/feature/calendar/presentation/bloc/calendar_event.dart';
import 'package:commute_calendar/feature/common/widgets/custom_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class OvertimeTile extends StatelessWidget {
  const OvertimeTile({super.key, required this.record});

  final OvertimeRecordEntity record;

  String get _typeLabel => switch (record.type) {
    OvertimeType.weekdayOvertime => '연장근무',
    OvertimeType.holidayWork => '휴일근무',
  };

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    if (minutes == 0) return '$hours시간';
    return '$hours시간 $minutes분';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: ThemeService.black100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(width: 4, color: ThemeService.tertiary),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTypeHeader(),
                    const SizedBox(height: 4),
                    Text(
                      _formatDuration(record.workedDuration),
                      style: ThemeService.body1.copyWith(
                        color: ThemeService.tertiary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (record.hasMemo) ...[
                      const SizedBox(height: 4),
                      Text(
                        record.memo!,
                        style: ThemeService.caption.copyWith(
                          color: ThemeService.black500,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            _OvertimeDeleteButton(recordId: record.id),
          ],
        ),
      ),
    );
  }

  Widget _buildTypeHeader() {
    return Row(
      children: [
        PhosphorIcon(
          PhosphorIcons.clock(),
          color: ThemeService.tertiary,
          size: 16,
        ),
        const SizedBox(width: 6),
        Text(
          _typeLabel,
          style: ThemeService.body2.copyWith(color: ThemeService.tertiary),
        ),
      ],
    );
  }
}

class _OvertimeDeleteButton extends StatelessWidget {
  const _OvertimeDeleteButton({required this.recordId});

  final String recordId;

  Future<void> _confirmDelete(BuildContext context) async {
    final confirmed = await CustomDialog.show(
      context: context,
      title: '특근 기록 삭제',
      content: '이 특근 기록을 삭제할까요?',
      confirmLabel: '삭제',
      isDestructive: true,
    );

    if (confirmed == true && context.mounted) {
      context.read<CalendarBloc>().add(CalendarOvertimeDeleted(recordId));
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _confirmDelete(context),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        child: PhosphorIcon(
          PhosphorIcons.trash(),
          color: ThemeService.secondary,
          size: 20,
        ),
      ),
    );
  }
}
