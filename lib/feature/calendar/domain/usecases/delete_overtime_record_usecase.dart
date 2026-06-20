import '../repositories/i_overtime_repository.dart';

class DeleteOvertimeRecordUseCase {
  const DeleteOvertimeRecordUseCase(this._repository);

  final IOvertimeRepository _repository;

  Future<void> call(String id) {
    return _repository.deleteOvertime(id);
  }
}
