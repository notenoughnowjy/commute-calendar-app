class DurationFormatter {
  DurationFormatter._();

  /// h:mm 형태 — 달력 셀 공간이 좁을 때 사용 (예: 9:30, 10:00)
  static String short(Duration d) {
    final h = d.inHours;
    final m = d.inMinutes.remainder(60);
    return '$h:${m.toString().padLeft(2, '0')}';
  }

  /// Xh Ym 형태 — 통계/타일 등 여유 있는 공간에서 사용 (예: 9시간, 1시간 30분, 30분)
  static String long(Duration d) {
    final h = d.inHours;
    final m = d.inMinutes.remainder(60);
    if (h == 0) return '$m분';
    if (m == 0) return '$h시간';
    return '$h시간 $m분';
  }
}
