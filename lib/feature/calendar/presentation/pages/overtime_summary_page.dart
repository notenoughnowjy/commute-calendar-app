import 'package:commute_calendar/core/di/service_locator.dart';
import 'package:commute_calendar/core/theme/theme_service.dart';
import 'package:commute_calendar/feature/calendar/domain/entities/overtime_record_entity.dart';
import 'package:commute_calendar/feature/calendar/domain/usecases/calculate_overtime_stats_usecase.dart';
import 'package:commute_calendar/feature/calendar/domain/usecases/get_overtime_records_usecase.dart';
import 'package:commute_calendar/feature/calendar/presentation/widgets/overtime_stats_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OvertimeSummaryPage extends StatefulWidget {
  const OvertimeSummaryPage({super.key, required this.initialMonth});

  final DateTime initialMonth;

  @override
  State<OvertimeSummaryPage> createState() => _OvertimeSummaryPageState();
}

class _OvertimeSummaryPageState extends State<OvertimeSummaryPage> {
  late DateTime _month;
  int? _hourlyWage;
  double _weekdayMultiplier = 1.5;
  double _holidayMultiplier = 1.5;
  OvertimeStats? _stats;
  List<OvertimeRecordEntity> _records = [];
  bool _isLoading = false;
  late final TextEditingController _wageController;

  @override
  void initState() {
    super.initState();
    _month = DateTime(widget.initialMonth.year, widget.initialMonth.month);
    _wageController = TextEditingController();
    _loadPrefs();
    _loadData();
  }

  @override
  void dispose() {
    _wageController.dispose();
    super.dispose();
  }

  Future<void> _loadPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      final wage = prefs.getInt('hourly_wage');
      _hourlyWage = wage;
      if (wage != null) _wageController.text = wage.toString();
      _weekdayMultiplier = prefs.getDouble('weekday_multiplier') ?? 1.5;
      _holidayMultiplier = prefs.getDouble('holiday_multiplier') ?? 1.5;
    });
  }

  Future<void> _saveWage(String value) async {
    final wage = int.tryParse(value);
    final prefs = await SharedPreferences.getInstance();
    if (wage != null && wage > 0) {
      await prefs.setInt('hourly_wage', wage);
      if (mounted) setState(() => _hourlyWage = wage);
    } else {
      await prefs.remove('hourly_wage');
      if (mounted) setState(() => _hourlyWage = null);
    }
  }

  void _setWeekdayMultiplier(double value) {
    setState(() => _weekdayMultiplier = value);
    SharedPreferences.getInstance().then(
      (p) => p.setDouble('weekday_multiplier', value),
    );
  }

  void _setHolidayMultiplier(double value) {
    setState(() => _holidayMultiplier = value);
    SharedPreferences.getInstance().then(
      (p) => p.setDouble('holiday_multiplier', value),
    );
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      final (stats, records) = await (
        getIt<CalculateOvertimeStatsUseCase>()(_month.year, _month.month),
        getIt<GetOvertimeRecordsUseCase>()(_month.year, _month.month),
      ).wait;

      records.sort((a, b) => a.date.compareTo(b.date));

      if (!mounted) return;
      setState(() {
        _stats = stats;
        _records = records;
        _isLoading = false;
      });
    } catch (_) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _prevMonth() {
    setState(() => _month = DateTime(_month.year, _month.month - 1));
    _loadData();
  }

  void _nextMonth() {
    setState(() => _month = DateTime(_month.year, _month.month + 1));
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeService.white,
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildAppBar(),
            _buildMonthNav(),
            Expanded(
              child: _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: ThemeService.tertiary,
                        strokeWidth: 2,
                      ),
                    )
                  : SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 20,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _buildWageInput(),
                          const SizedBox(height: 24),
                          if (_stats != null)
                            OvertimeStatsCard(
                              stats: _stats!,
                              hourlyWage: _hourlyWage,
                              weekdayMultiplier: _weekdayMultiplier,
                              holidayMultiplier: _holidayMultiplier,
                              onWeekdayMultiplierChanged: _setWeekdayMultiplier,
                              onHolidayMultiplierChanged: _setHolidayMultiplier,
                            ),
                          if (_records.isNotEmpty) ...[
                            const SizedBox(height: 28),
                            _buildRecordsList(),
                          ],
                        ],
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      color: ThemeService.white,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 14),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: PhosphorIcon(
                PhosphorIconsBold.caretLeft,
                color: ThemeService.black900,
                size: 20,
              ),
            ),
          ),
          const SizedBox(width: 4),
          Text('특근 현황', style: ThemeService.subtitle),
        ],
      ),
    );
  }

  Widget _buildMonthNav() {
    final label = DateFormat('yyyy년 M월').format(_month);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        children: [
          GestureDetector(
            onTap: _prevMonth,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: PhosphorIcon(
                PhosphorIcons.caretLeft(),
                color: ThemeService.black600,
                size: 18,
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                label,
                style: ThemeService.body2.copyWith(fontWeight: FontWeight.w600),
              ),
            ),
          ),
          GestureDetector(
            onTap: _nextMonth,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: PhosphorIcon(
                PhosphorIcons.caretRight(),
                color: ThemeService.black600,
                size: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWageInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '통상시급',
          style: ThemeService.body2.copyWith(color: ThemeService.black700),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _wageController,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          style: ThemeService.body1,
          onChanged: _saveWage,
          decoration: InputDecoration(
            hintText: '시급을 입력하세요',
            hintStyle: ThemeService.body1.copyWith(
              color: ThemeService.black400,
            ),
            suffixText: '원',
            suffixStyle: ThemeService.body1.copyWith(
              color: ThemeService.black600,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 12,
            ),
            filled: true,
            fillColor: ThemeService.black100,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRecordsList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '특근 기록',
          style: ThemeService.body2.copyWith(
            fontWeight: FontWeight.w600,
            color: ThemeService.black700,
          ),
        ),
        const SizedBox(height: 12),
        for (int i = 0; i < _records.length; i++) ...[
          if (i > 0) const SizedBox(height: 8),
          _buildRecordItem(_records[i]),
        ],
      ],
    );
  }

  Widget _buildRecordItem(OvertimeRecordEntity record) {
    final typeLabel = switch (record.type) {
      OvertimeType.weekdayOvertime => '연장근무',
      OvertimeType.holidayWork => '휴일근무',
    };

    return Container(
      decoration: BoxDecoration(
        color: ThemeService.black100,
        borderRadius: BorderRadius.circular(10),
      ),
      clipBehavior: Clip.antiAlias,
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(width: 4, color: ThemeService.tertiary),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${_formatDate(record.date)}  ·  $typeLabel',
                    style: ThemeService.caption.copyWith(
                      color: ThemeService.black600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _formatDuration(record.workedDuration),
                    style: ThemeService.body2.copyWith(
                      color: ThemeService.tertiary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (record.hasMemo) ...[
                    const SizedBox(height: 2),
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
          ],
        ),
      ),
    );
  }

  String _formatDuration(Duration d) {
    final h = d.inHours;
    final m = d.inMinutes.remainder(60);
    if (h == 0) return '$m분';
    if (m == 0) return '$h시간';
    return '$h시간 $m분';
  }

  String _formatDate(DateTime date) =>
      DateFormat('M월 d일 (E)', 'ko_KR').format(date);
}
