import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/entities/work_record_entity.dart';
import '../models/work_record_model.dart';

class WorkRecordDataSource {
  const WorkRecordDataSource(this._supabase);

  final SupabaseClient _supabase;

  Future<List<WorkRecordModel>> getRecordsByMonth(int year, int month) async {
    final userId = _supabase.auth.currentUser!.id;
    final firstDay =
        '${year.toString().padLeft(4, '0')}-${month.toString().padLeft(2, '0')}-01';
    final lastDayNum = DateTime(year, month + 1, 0).day;
    final lastDay =
        '${year.toString().padLeft(4, '0')}-${month.toString().padLeft(2, '0')}-${lastDayNum.toString().padLeft(2, '0')}';

    final rows = await _supabase
        .from('work_records')
        .select()
        .eq('user_id', userId)
        .gte('date', firstDay)
        .lte('date', lastDay);

    return rows.map((row) => WorkRecordModel.fromJson(row)).toList();
  }

  Future<void> addRecord(WorkRecord record) async {
    final userId = _supabase.auth.currentUser!.id;
    final payload = WorkRecordModel.fromEntity(record).toJson()
      ..['user_id'] = userId;

    await _supabase.from('work_records').insert(payload);
  }

  Future<void> updateRecord(WorkRecord record) async {
    final payload = WorkRecordModel.fromEntity(record).toJson()
      ..['updated_at'] = DateTime.now().toIso8601String();

    await _supabase
        .from('work_records')
        .update(payload)
        .eq('id', record.id);
  }

  Future<void> deleteRecord(String id) async {
    await _supabase.from('work_records').delete().eq('id', id);
  }
}
