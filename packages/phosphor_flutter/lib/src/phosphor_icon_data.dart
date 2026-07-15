library phosphor_flutter;

import 'package:flutter/widgets.dart';

/// Flutter 3.43+ 에서 [IconData] 가 final class 로 변경되어 더 이상 상속할 수 없다.
/// 따라서 [PhosphorIconData] 는 [IconData] 를 상속하지 않는 독립 값 객체로 두고,
/// 실제 렌더링 시 [toIconData] 로 [IconData] 인스턴스를 생성한다.
@immutable
class PhosphorIconData {
  const PhosphorIconData(this.codePoint, this.style);

  final int codePoint;
  final String style;

  /// 렌더링용 [IconData] 로 변환한다.
  IconData toIconData() => IconData(
        codePoint,
        fontFamily: 'Phosphor$style',
        fontPackage: 'phosphor_flutter',
        matchTextDirection: true,
      );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PhosphorIconData &&
        other.codePoint == codePoint &&
        other.style == style;
  }

  @override
  int get hashCode => Object.hash(codePoint, style);
}

class PhosphorFlatIconData extends PhosphorIconData {
  const PhosphorFlatIconData(int codePoint, String style)
      : super(codePoint, style);
}

class PhosphorDuotoneIconData extends PhosphorIconData {
  const PhosphorDuotoneIconData(int codePoint, this.secondary)
      : super(codePoint, 'Duotone');

  final PhosphorIconData secondary;
}
