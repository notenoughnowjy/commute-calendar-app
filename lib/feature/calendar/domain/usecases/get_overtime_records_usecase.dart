import '../entities/overtime_record_entity.dart';
import '../repositories/i_overtime_repository.dart';

class GetOvertimeRecordsUseCase {
  const GetOvertimeRecordsUseCase(this._repository);

  final IOvertimeRepository _repository;

  Future<List<OvertimeRecordEntity>> call(int year, int month) {
    return _repository.getOvertimeByMonth(year, month);
  }
}
