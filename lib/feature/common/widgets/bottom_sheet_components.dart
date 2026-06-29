import 'package:commute_calendar/core/theme/theme_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// BottomSheet에서 공통으로 쓰이는 핸들 바
class BottomSheetHandle extends StatelessWidget {
  const BottomSheetHandle({super.key});

  @override
  Widget build(BuildContext context) {
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
}

/// BottomSheet에서 공통으로 쓰이는 저장 버튼
class BottomSheetSaveButton extends StatelessWidget {
  const BottomSheetSaveButton({
    super.key,
    required this.isEnabled,
    required this.color,
    required this.onTap,
  });

  final bool isEnabled;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isEnabled ? onTap : null,
      child: Container(
        height: 52,
        decoration: BoxDecoration(
          color: isEnabled ? color : ThemeService.black300,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(
            '저장',
            style: ThemeService.body1.copyWith(
              color: ThemeService.white,
              fontWeight: ThemeService.semiBold,
            ),
          ),
        ),
      ),
    );
  }
}

/// BottomSheet에서 공통으로 쓰이는 시간/분 입력 필드 (라벨 + TextField)
class BottomSheetTimeField extends StatelessWidget {
  const BottomSheetTimeField({
    super.key,
    required this.label,
    required this.controller,
    required this.onChanged,
  });

  final String label;
  final TextEditingController controller;
  final void Function(String) onChanged;

  @override
  Widget build(BuildContext context) {
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
}

/// BottomSheet에서 공통으로 쓰이는 메모 입력 필드
class BottomSheetMemoField extends StatelessWidget {
  const BottomSheetMemoField({
    super.key,
    required this.controller,
    required this.hintText,
  });

  final TextEditingController controller;
  final String hintText;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLength: 100,
      maxLines: 2,
      style: ThemeService.body2,
      decoration: InputDecoration(
        hintText: hintText,
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
}
