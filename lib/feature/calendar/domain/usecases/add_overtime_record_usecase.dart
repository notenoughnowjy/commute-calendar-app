import '../entities/overtime_record_entity.dart';
import '../repositories/i_overtime_repository.dart';

class AddOvertimeRecordUseCase {
  const AddOvertimeRecordUseCase(this._repository);

  final IOvertimeRepository _repository;

  Future<void> call(OvertimeRecordEntity record) {
    return _repository.addOvertime(record);
  }
}
