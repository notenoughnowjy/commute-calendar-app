import '../entities/overtime_record_entity.dart';
import '../repositories/i_overtime_repository.dart';

class UpdateOvertimeRecordUseCase {
  const UpdateOvertimeRecordUseCase(this._repository);

  final IOvertimeRepository _repository;

  Future<void> call(OvertimeRecordEntity record) {
    return _repository.updateOvertime(record);
  }
}
