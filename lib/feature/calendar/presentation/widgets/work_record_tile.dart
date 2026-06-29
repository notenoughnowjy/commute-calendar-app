import 'package:commute_calendar/core/theme/theme_service.dart';
import 'package:commute_calendar/core/utils/duration_formatter.dart';
import 'package:commute_calendar/feature/calendar/domain/entities/work_record_entity.dart';
import 'package:commute_calendar/feature/calendar/presentation/bloc/calendar_bloc.dart';
import 'package:commute_calendar/feature/calendar/presentation/bloc/calendar_event.dart';
import 'package:commute_calendar/feature/common/widgets/custom_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class WorkRecordTile extends StatelessWidget {
  const WorkRecordTile({super.key, required this.record});

  final WorkRecordEntity record;

  Color get _accentColor => switch (record.type) {
    WorkType.work => ThemeService.primary,
    WorkType.vacation => ThemeService.vacation,
    WorkType.holiday => ThemeService.secondary,
  };

  PhosphorIconData get _icon => switch (record.type) {
    WorkType.work => PhosphorIcons.briefcase(),
    WorkType.vacation => PhosphorIcons.umbrella(),
    WorkType.holiday => PhosphorIcons.calendarX(),
  };

  String get _typeLabel => switch (record.type) {
    WorkType.work => '근무',
    WorkType.vacation => '연차',
    WorkType.holiday => '휴일',
  };

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
            Container(width: 6, color: _accentColor),
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
                    _buildMainContent(),
                    if (record.hasMemo) ...[
                      const SizedBox(height: 4),
                      Text(
                        record.memo!,
                        style: ThemeService.caption.copyWith(
                          color: ThemeService.black500,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                    ],
                  ],
                ),
              ),
            ),
            _DeleteButton(recordId: record.id),
          ],
        ),
      ),
    );
  }

  Widget _buildTypeHeader() {
    return Row(
      children: [
        PhosphorIcon(_icon, color: _accentColor, size: 16),
        const SizedBox(width: 6),
        Text(
          _typeLabel,
          style: ThemeService.body2.copyWith(color: _accentColor),
        ),
      ],
    );
  }

  Widget _buildMainContent() {
    return switch (record.type) {
      WorkType.work => _buildWorkContent(),
      WorkType.vacation => const SizedBox(),
      WorkType.holiday => const SizedBox(),
    };
  }

  Widget _buildWorkContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          DurationFormatter.long(record.workedDuration),
          style: ThemeService.body1.copyWith(
            color: ThemeService.primary,
            fontWeight: ThemeService.semiBold,
          ),
        ),
        if (record.startTime != null && record.endTime != null) ...[
          const SizedBox(height: 4),
          Text(
            '${_formatTime(record.startTime!)}  ~  ${_formatTime(record.endTime!)}',
            style: ThemeService.body2.copyWith(color: ThemeService.black600),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ],
      ],
    );
  }

  /// TODO: TimeUtil로 옮기기
  String _formatTime(TimeOfDay time) {
    final h = time.hour.toString().padLeft(2, '0');
    final m = time.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }
}

class _DeleteButton extends StatelessWidget {
  const _DeleteButton({required this.recordId});

  final String recordId;

  Future<void> _confirmDelete(BuildContext context) async {
    final confirmed = await CustomDialog.show(
      context: context,
      title: '기록 삭제',
      content: '이 날의 근태 기록을 삭제할까요?',
      confirmLabel: '삭제',
      isDestructive: true,
    );

    if (confirmed == true && context.mounted) {
      context.read<CalendarBloc>().add(CalendarRecordDeleted(recordId));
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
