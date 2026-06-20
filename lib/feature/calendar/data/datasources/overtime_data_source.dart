import 'package:supabase_flutter/supabase_flutter.dart';

class OvertimeDataSource {
  const OvertimeDataSource(this._supabase);

  final SupabaseClient _supabase;

  Future<List<Map<String, dynamic>>> getOvertimeByMonth(
    String userId,
    String firstDay,
    String lastDay,
  ) async {
    return await _supabase
        .from('overtime_records')
        .select()
        .eq('user_id', userId)
        .gte('date', firstDay)
        .lte('date', lastDay);
  }

  Future<void> addOvertime(Map<String, dynamic> payload) async {
    await _supabase.from('overtime_records').insert(payload);
  }

  Future<void> updateOvertime(String id, Map<String, dynamic> payload) async {
    await _supabase.from('overtime_records').update(payload).eq('id', id);
  }

  Future<void> deleteOvertime(String id) async {
    await _supabase.from('overtime_records').delete().eq('id', id);
  }
}
