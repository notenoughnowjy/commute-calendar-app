import '../entities/work_record_entity.dart';
import '../repositories/i_calendar_repository.dart';

class UpdateWorkRecordUseCase {
  const UpdateWorkRecordUseCase(this._repository);

  final ICalendarRepository _repository;

  Future<void> call(WorkRecordEntity record) {
    return _repository.updateRecord(record);
  }
}
