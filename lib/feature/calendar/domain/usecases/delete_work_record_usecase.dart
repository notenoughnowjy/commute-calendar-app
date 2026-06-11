import '../repositories/i_calendar_repository.dart';

class DeleteWorkRecordUseCase {
  const DeleteWorkRecordUseCase(this._repository);

  final ICalendarRepository _repository;

  Future<void> call(String id) {
    return _repository.deleteRecord(id);
  }
}
