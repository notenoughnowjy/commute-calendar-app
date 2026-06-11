import 'package:commute_calendar/core/services/supabase_service.dart';
import 'package:commute_calendar/feature/calendar/presentation/bloc/calendar_bloc.dart';
import 'package:commute_calendar/feature/calendar/data/repositories/mock_calendar_repository.dart';
import 'package:commute_calendar/feature/calendar/domain/repositories/i_calendar_repository.dart';
import 'package:commute_calendar/feature/calendar/domain/usecases/add_work_record_usecase.dart';
import 'package:commute_calendar/feature/calendar/domain/usecases/calculate_monthly_stats_usecase.dart';
import 'package:commute_calendar/feature/calendar/domain/usecases/delete_work_record_usecase.dart';
import 'package:commute_calendar/feature/calendar/domain/usecases/get_monthly_records_usecase.dart';
import 'package:commute_calendar/feature/calendar/domain/usecases/update_work_record_usecase.dart';
import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final getIt = GetIt.instance;

Future<void> setupServiceLocator() async {
  // 1. Services
  getIt.registerSingleton<SupabaseClient>(supabaseService);

  // 2. Repository (MockData — 추후 SupabaseCalendarRepository로 교체)
  getIt.registerSingleton<ICalendarRepository>(MockCalendarRepository());

  // 3. UseCases
  getIt.registerFactory<GetMonthlyRecordsUseCase>(
    () => GetMonthlyRecordsUseCase(getIt<ICalendarRepository>()),
  );
  getIt.registerFactory<AddWorkRecordUseCase>(
    () => AddWorkRecordUseCase(getIt<ICalendarRepository>()),
  );
  getIt.registerFactory<UpdateWorkRecordUseCase>(
    () => UpdateWorkRecordUseCase(getIt<ICalendarRepository>()),
  );
  getIt.registerFactory<DeleteWorkRecordUseCase>(
    () => DeleteWorkRecordUseCase(getIt<ICalendarRepository>()),
  );
  getIt.registerFactory<CalculateMonthlyStatsUseCase>(
    () => CalculateMonthlyStatsUseCase(getIt<ICalendarRepository>()),
  );

  // 4. BLoC
  getIt.registerFactory<CalendarBloc>(
    () => CalendarBloc(
      getMonthlyRecords: getIt<GetMonthlyRecordsUseCase>(),
      addWorkRecord: getIt<AddWorkRecordUseCase>(),
      updateWorkRecord: getIt<UpdateWorkRecordUseCase>(),
      deleteWorkRecord: getIt<DeleteWorkRecordUseCase>(),
      calculateMonthlyStats: getIt<CalculateMonthlyStatsUseCase>(),
    ),
  );
}
