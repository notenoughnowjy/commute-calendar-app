import 'package:commute_calendar/core/di/service_locator.dart';
import 'package:commute_calendar/core/services/toast_service.dart';
import 'package:commute_calendar/core/theme/theme_service.dart';
import 'package:commute_calendar/core/utils/date_formatter.dart';
import 'package:commute_calendar/feature/auth/presentation/bloc/auth_bloc.dart';
import 'package:commute_calendar/feature/auth/presentation/bloc/auth_state.dart';
import 'package:commute_calendar/feature/calendar/presentation/bloc/calendar_bloc.dart';
import 'package:commute_calendar/feature/calendar/presentation/bloc/calendar_event.dart';
import 'package:commute_calendar/feature/calendar/presentation/bloc/calendar_state.dart';
import 'package:commute_calendar/feature/calendar/presentation/widgets/calendar_widget.dart';
import 'package:commute_calendar/feature/calendar/presentation/widgets/day_info_widget.dart';
import 'package:commute_calendar/feature/calendar/presentation/widgets/monthly_summary_widget.dart';
import 'package:commute_calendar/feature/calendar/presentation/pages/overtime_summary_page.dart';
import 'package:commute_calendar/feature/common/widgets/expandable_fab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class CalendarPage extends StatelessWidget {
  const CalendarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CalendarBloc>(
      create: (_) =>
          getIt<CalendarBloc>()..add(CalendarMonthChanged(DateTime.now())),
      child: const _CalendarView(),
    );
  }
}

class _CalendarView extends StatelessWidget {
  const _CalendarView();

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthAuthenticated && state.isAutoLogin) {
              ToastService.show(context: context, message: '환영합니다!');
            } else if (state is AuthUnauthenticated) {
              ToastService.show(context: context, message: '로그아웃 되었습니다.');
            }
          },
        ),
        BlocListener<CalendarBloc, CalendarState>(
          listener: (context, state) {
            if (state is CalendarRecordSaved) {
              ToastService.show(context: context, message: state.message);
            } else if (state is CalendarRecordRemoved) {
              ToastService.show(context: context, message: '기록이 삭제됐습니다.');
            } else if (state is CalendarError) {
              ToastService.show(
                context: context,
                message: state.message,
                isError: true,
              );
            }
          },
        ),
      ],
      child: Scaffold(
        backgroundColor: ThemeService.white,
        body: SafeArea(
          bottom: false,
          child: Stack(
            children: [
              Column(
                children: [
                  const _PrimaryAppBar(),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          const _MonthHeader(),
                          const _CalendarLegend(),
                          BlocBuilder<CalendarBloc, CalendarState>(
                            buildWhen: (prev, curr) => curr is CalendarLoaded,
                            builder: (context, state) {
                              if (state is! CalendarLoaded) {
                                return const SizedBox(
                                  height: 480,
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      color: ThemeService.primary,
                                      strokeWidth: 2,
                                    ),
                                  ),
                                );
                              }
                              return CalendarWidget(
                                focusedMonth: state.focusedMonth,
                                selectedDate: state.selectedDate,
                                records: state.records,
                                overtimeRecords: state.overtimeRecords,
                                onMonthChanged: (month) => context
                                    .read<CalendarBloc>()
                                    .add(CalendarMonthChanged(month)),
                                onDateSelected: (date) => context
                                    .read<CalendarBloc>()
                                    .add(CalendarDateSelected(date)),
                              );
                            },
                          ),
                          const _SectionDivider(),
                          const MonthlySummaryWidget(),
                          const _SectionDivider(),
                          const DayInfoWidget(),
                          const SizedBox(height: 96),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Positioned.fill(child: ExpandableFab()),
            ],
          ),
        ),
      ),
    );
  }
}

class _CalendarLegend extends StatelessWidget {
  const _CalendarLegend();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, top: 10, bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _LegendItem(color: ThemeService.primary, label: '근무일'),
          const SizedBox(width: 20),
          _LegendItem(color: ThemeService.secondary, label: '휴일'),
          const SizedBox(width: 20),
          _LegendItem(color: ThemeService.vacation, label: '휴가'),
          const SizedBox(width: 20),
          _LegendItem(color: ThemeService.tertiary, label: '특근'),
        ],
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  const _LegendItem({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 7,
          height: 7,
          decoration: BoxDecoration(shape: BoxShape.circle, color: color),
        ),
        const SizedBox(width: 5),
        Text(
          label,
          style: ThemeService.caption.copyWith(color: ThemeService.black600),
        ),
      ],
    );
  }
}

class _SectionDivider extends StatelessWidget {
  const _SectionDivider();

  @override
  Widget build(BuildContext context) {
    return Container(height: 10, color: ThemeService.black100);
  }
}

class _PrimaryAppBar extends StatelessWidget {
  const _PrimaryAppBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ThemeService.white,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('근태 달력', style: ThemeService.subtitle),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              final state = context.read<CalendarBloc>().state;
              final month = state is CalendarLoaded
                  ? state.focusedMonth
                  : DateTime.now();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => OvertimeSummaryPage(initialMonth: month),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: PhosphorIcon(
                PhosphorIcons.clock(),
                color: ThemeService.tertiary,
                size: 24,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MonthHeader extends StatelessWidget {
  const _MonthHeader();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CalendarBloc, CalendarState>(
      buildWhen: (prev, curr) => curr is CalendarLoaded,
      builder: (context, state) {
        final month = state is CalendarLoaded
            ? state.focusedMonth
            : DateTime.now();
        final label = DateFormatter.monthLabel(month);

        return Container(
          padding: const EdgeInsets.all(4),
          child: Row(
            children: [
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  final prev = DateTime(month.year, month.month - 1);
                  context.read<CalendarBloc>().add(CalendarMonthChanged(prev));
                },
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: PhosphorIcon(
                    PhosphorIconsBold.caretLeft,
                    color: ThemeService.black900,
                    size: 20,
                  ),
                ),
              ),
              Expanded(
                child: Center(
                  child: Text(
                    label,
                    style: ThemeService.subtitle.copyWith(fontSize: 18),
                  ),
                ),
              ),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  final next = DateTime(month.year, month.month + 1);
                  context.read<CalendarBloc>().add(CalendarMonthChanged(next));
                },
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: PhosphorIcon(
                    PhosphorIconsBold.caretRight,
                    color: ThemeService.black900,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
