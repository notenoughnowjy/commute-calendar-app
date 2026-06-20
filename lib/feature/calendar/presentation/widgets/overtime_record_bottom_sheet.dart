import 'package:commute_calendar/core/services/toast_service.dart';
import 'package:commute_calendar/core/theme/theme_service.dart';
import 'package:commute_calendar/feature/calendar/domain/entities/overtime_record_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class OvertimeRecordBottomSheet extends StatefulWidget {
  const OvertimeRecordBottomSheet({
    super.key,
    required this.selectedDate,
    this.existingRecord,
  });

  final DateTime selectedDate;
  final OvertimeRecordEntity? existingRecord;

  static Future<OvertimeRecordEntity?> show({
    required BuildContext context,
    required DateTime selectedDate,
    OvertimeRecordEntity? existingRecord,
  }) {
    return showModalBottomSheet<OvertimeRecordEntity>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => OvertimeRecordBottomSheet(
        selectedDate: selectedDate,
        existingRecord: existingRecord,
      ),
    );
  }

  @override
  State<OvertimeRecordBottomSheet> createState() =>
      _OvertimeRecordBottomSheetState();
}

class _OvertimeRecordBottomSheetState
    extends State<OvertimeRecordBottomSheet> {
  late OvertimeType _type;
  late int _durationHours;
  late int _durationMinutes;
  late TextEditingController _hoursController;
  late TextEditingController _minutesController;
  late TextEditingController _memoController;

  @override
  void initState() {
    super.initState();
    final existing = widget.existingRecord;
    _type = existing?.type ?? OvertimeType.weekdayOvertime;

    final existingMinutes = existing?.workMinutes ?? 0;
    _durationHours = existingMinutes ~/ 60;
    _durationMinutes = existingMinutes % 60;

    _hoursController = TextEditingController(
      text: _durationHours > 0 ? _durationHours.toString() : '',
    );
    _minutesController = TextEditingController(
      text: _durationMinutes > 0 ? _durationMinutes.toString() : '',
    );
    _memoController = TextEditingController(text: existing?.memo ?? '');
  }

  @override
  void dispose() {
    _hoursController.dispose();
    _minutesController.dispose();
    _memoController.dispose();
    super.dispose();
  }

  bool get _canSave => _durationHours > 0 || _durationMinutes > 0;

  void _save() {
    if (!_canSave) {
      ToastService.show(
        context: context,
        message: '특근 시간을 입력해주세요.',
        isError: true,
      );
      return;
    }

    final id = widget.existingRecord?.id ??
        DateTime.now().millisecondsSinceEpoch.toString();
    final memo = _memoController.text.trim();
    final workMinutes = _durationHours * 60 + _durationMinutes.clamp(0, 59);

    final record = OvertimeRecordEntity(
      id: id,
      date: widget.selectedDate,
      type: _type,
      workMinutes: workMinutes,
      memo: memo.isEmpty ? null : memo,
    );
    Navigator.pop(context, record);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: ThemeService.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildHandle(),
          const SizedBox(height: 20),
          _buildTitle(),
          const SizedBox(height: 8),
          _buildDateLabel(),
          const SizedBox(height: 20),
          _buildTypeSelector(),
          const SizedBox(height: 20),
          _buildDurationInput(),
          const SizedBox(height: 16),
          _buildMemoField(),
          const SizedBox(height: 16),
          _buildSaveButton(),
        ],
      ),
    );
  }

  Widget _buildHandle() {
    return Center(
      child: Container(
        width: 40,
        height: 4,
        decoration: BoxDecoration(
          color: ThemeService.black300,
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Row(
      children: [
        PhosphorIcon(
          PhosphorIcons.clock(),
          color: ThemeService.tertiary,
          size: 22,
        ),
        const SizedBox(width: 8),
        Text('특근 기록', style: ThemeService.subtitle),
      ],
    );
  }

  Widget _buildDateLabel() {
    return Text(
      DateFormat('yyyy년 M월 d일').format(widget.selectedDate),
      style: ThemeService.body1.copyWith(color: ThemeService.black600),
    );
  }

  Widget _buildTypeSelector() {
    return Row(
      children: [
        Expanded(
          child: _TypeChip(
            label: '연장근무',
            isSelected: _type == OvertimeType.weekdayOvertime,
            onTap: () => setState(() => _type = OvertimeType.weekdayOvertime),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _TypeChip(
            label: '휴일근무',
            isSelected: _type == OvertimeType.holidayWork,
            onTap: () => setState(() => _type = OvertimeType.holidayWork),
          ),
        ),
      ],
    );
  }

  Widget _buildDurationInput() {
    return Row(
      children: [
        Expanded(
          child: _buildTimeField(
            label: '시간',
            controller: _hoursController,
            onChanged: (v) =>
                setState(() => _durationHours = int.tryParse(v) ?? 0),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildTimeField(
            label: '분',
            controller: _minutesController,
            onChanged: (v) => setState(
              () => _durationMinutes = (int.tryParse(v) ?? 0).clamp(0, 59),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTimeField({
    required String label,
    required TextEditingController controller,
    required void Function(String) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: ThemeService.caption),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(2),
          ],
          style: ThemeService.body1,
          textAlign: TextAlign.center,
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: '0',
            hintStyle: ThemeService.body1.copyWith(
              color: ThemeService.black400,
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

  Widget _buildMemoField() {
    return TextField(
      controller: _memoController,
      maxLength: 100,
      maxLines: 2,
      style: ThemeService.body2,
      decoration: InputDecoration(
        hintText: '메모를 남겨보세요. (선택)',
        hintStyle: ThemeService.body2.copyWith(color: ThemeService.black400),
        counterStyle: ThemeService.caption,
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
    );
  }

  Widget _buildSaveButton() {
    final isEnabled = _canSave;
    return GestureDetector(
      onTap: isEnabled ? _save : null,
      child: Container(
        height: 52,
        decoration: BoxDecoration(
          color: isEnabled ? ThemeService.tertiary : ThemeService.black300,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(
            '저장',
            style: ThemeService.body1.copyWith(
              color: ThemeService.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}

class _TypeChip extends StatelessWidget {
  const _TypeChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        height: 44,
        decoration: BoxDecoration(
          color: isSelected ? ThemeService.tertiary : ThemeService.black100,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            label,
            style: ThemeService.body2.copyWith(
              color: isSelected ? ThemeService.white : ThemeService.black600,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }
}
