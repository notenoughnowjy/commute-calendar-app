import 'package:supabase_flutter/supabase_flutter.dart';

class WorkRecordDataSource {
  const WorkRecordDataSource(this._supabase);

  final SupabaseClient _supabase;

  Future<List<Map<String, dynamic>>> getRecordsByMonth(
    String userId,
    String firstDay,
    String lastDay,
  ) async {
    return await _supabase
        .from('work_records')
        .select()
        .eq('user_id', userId)
        .gte('date', firstDay)
        .lte('date', lastDay);
  }

  Future<void> addRecord(Map<String, dynamic> payload) async {
    await _supabase.from('work_records').insert(payload);
  }

  Future<void> updateRecord(String id, Map<String, dynamic> payload) async {
    await _supabase.from('work_records').update(payload).eq('id', id);
  }

  Future<void> deleteRecord(String id) async {
    await _supabase.from('work_records').delete().eq('id', id);
  }
}
