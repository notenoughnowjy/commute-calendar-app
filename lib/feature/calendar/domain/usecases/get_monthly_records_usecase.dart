import '../entities/work_record_entity.dart';
import '../repositories/i_calendar_repository.dart';

class GetMonthlyRecordsUseCase {
  const GetMonthlyRecordsUseCase(this._repository);

  final ICalendarRepository _repository;

  Future<List<WorkRecord>> call(int year, int month) {
    return _repository.getRecordsByMonth(year, month);
  }
}
