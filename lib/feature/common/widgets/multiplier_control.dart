import 'package:commute_calendar/core/theme/theme_service.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class MultiplierControl extends StatelessWidget {
  const MultiplierControl({
    super.key,
    required this.value,
    required this.onChanged,
    this.min = 1.0,
    this.max = 3.0,
    this.step = 0.5,
  });

  final double value;
  final ValueChanged<double> onChanged;
  final double min;
  final double max;
  final double step;

  bool get _canDecrement => value > min + 0.001;
  bool get _canIncrement => value < max - 0.001;

  void _decrement() => onChanged((value - step).clamp(min, max));
  void _increment() => onChanged((value + step).clamp(min, max));

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _StepButton(
          icon: PhosphorIcons.minus(),
          enabled: _canDecrement,
          onTap: _canDecrement ? _decrement : null,
        ),
        SizedBox(
          width: 48,
          child: Text(
            '${value.toStringAsFixed(1)}x',
            textAlign: TextAlign.center,
            style: ThemeService.body2.copyWith(
              color: ThemeService.black800,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        _StepButton(
          icon: PhosphorIcons.plus(),
          enabled: _canIncrement,
          onTap: _canIncrement ? _increment : null,
        ),
      ],
    );
  }
}

class _StepButton extends StatelessWidget {
  const _StepButton({
    required this.icon,
    required this.enabled,
    required this.onTap,
  });

  final PhosphorIconData icon;
  final bool enabled;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: enabled ? ThemeService.black200 : ThemeService.black100,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Center(
          child: PhosphorIcon(
            icon,
            size: 14,
            color: enabled ? ThemeService.black700 : ThemeService.black400,
          ),
        ),
      ),
    );
  }
}
