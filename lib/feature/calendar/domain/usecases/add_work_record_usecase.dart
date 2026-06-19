import '../entities/work_record_entity.dart';
import '../repositories/i_calendar_repository.dart';

class AddWorkRecordUseCase {
  const AddWorkRecordUseCase(this._repository);

  final ICalendarRepository _repository;

  Future<void> call(WorkRecordEntity record) {
    return _repository.addRecord(record);
  }
}
