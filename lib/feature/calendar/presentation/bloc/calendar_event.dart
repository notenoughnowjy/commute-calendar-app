import 'package:equatable/equatable.dart';

import '../../domain/entities/work_record_entity.dart';

abstract class CalendarEvent extends Equatable {
  const CalendarEvent();

  @override
  List<Object?> get props => [];
}

class CalendarMonthChanged extends CalendarEvent {
  const CalendarMonthChanged(this.month);

  final DateTime month;

  @override
  List<Object?> get props => [month];
}

class CalendarDateSelected extends CalendarEvent {
  const CalendarDateSelected(this.date);

  final DateTime date;

  @override
  List<Object?> get props => [date];
}

class CalendarRecordAdded extends CalendarEvent {
  const CalendarRecordAdded(this.record);

  final WorkRecordEntity record;

  @override
  List<Object?> get props => [record];
}

class CalendarRecordUpdated extends CalendarEvent {
  const CalendarRecordUpdated(this.record);

  final WorkRecordEntity record;

  @override
  List<Object?> get props => [record];
}

class CalendarRecordDeleted extends CalendarEvent {
  const CalendarRecordDeleted(this.id);

  final String id;

  @override
  List<Object?> get props => [id];
}
