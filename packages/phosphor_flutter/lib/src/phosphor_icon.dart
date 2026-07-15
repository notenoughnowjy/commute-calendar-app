library phosphor_flutter;

import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

/// Flutter 3.43+ 에서 [IconData] 가 final class 가 되어 [PhosphorIconData] 가
/// 더 이상 [IconData] 를 상속하지 않는다. 그래서 [PhosphorIcon] 도 [Icon] 을
/// 상속하는 대신 [StatelessWidget] 으로 두고, 빌드 시점에 [Icon] 을 생성한다.
class PhosphorIcon extends StatelessWidget {
  const PhosphorIcon(
    this.icon, {
    super.key,
    this.size,
    this.fill,
    this.weight,
    this.grade,
    this.opticalSize,
    this.color,
    this.shadows,
    this.semanticLabel,
    this.textDirection,
    this.duotoneSecondaryOpacity = 0.20,
    this.duotoneSecondaryColor,
  });

  final PhosphorIconData icon;
  final double? size;
  final double? fill;
  final double? weight;
  final double? grade;
  final double? opticalSize;
  final Color? color;
  final List<Shadow>? shadows;
  final String? semanticLabel;
  final TextDirection? textDirection;
  final double duotoneSecondaryOpacity;
  final Color? duotoneSecondaryColor;

  @override
  Widget build(BuildContext context) {
    final primary = Icon(
      icon.toIconData(),
      size: size,
      fill: fill,
      weight: weight,
      grade: grade,
      opticalSize: opticalSize,
      color: color,
      shadows: shadows,
      semanticLabel: semanticLabel,
      textDirection: textDirection,
    );

    final localIcon = icon;
    if (localIcon is PhosphorDuotoneIconData) {
      return Stack(
        alignment: Alignment.center,
        children: [
          Opacity(
            opacity: duotoneSecondaryOpacity,
            child: Icon(
              localIcon.secondary.toIconData(),
              size: size,
              fill: fill,
              weight: weight,
              grade: grade,
              opticalSize: opticalSize,
              color: duotoneSecondaryColor ?? color,
              shadows: shadows,
              semanticLabel: semanticLabel,
              textDirection: textDirection,
            ),
          ),
          primary,
        ],
      );
    }
    return primary;
  }
}
