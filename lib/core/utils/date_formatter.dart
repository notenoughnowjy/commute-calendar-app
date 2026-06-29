import 'package:intl/intl.dart';

class DateFormatter {
  DateFormatter._();

  /// yyyy년 M월 (예: 2025년 6월)
  static String monthLabel(DateTime date) =>
      DateFormat('yyyy년 M월').format(date);

  /// yyyy년 M월 d일 (예: 2025년 6월 21일)
  static String fullDate(DateTime date) =>
      DateFormat('yyyy년 M월 d일').format(date);

  /// M월 d일 EEEE — 한국어 요일 포함 (예: 6월 21일 토요일)
  static String dayWithWeekday(DateTime date) =>
      DateFormat('M월 d일 EEEE', 'ko_KR').format(date);

  /// M월 d일 (E) — 특근 기록 목록에서 사용 (예: 6월 21일 (토))
  static String dayWithShortWeekday(DateTime date) =>
      DateFormat('M월 d일 (E)', 'ko_KR').format(date);
}
