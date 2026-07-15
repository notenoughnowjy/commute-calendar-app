import 'package:commute_calendar/core/database/app_database.dart';
import 'package:commute_calendar/feature/calendar/data/datasources/overtime_data_source.dart';
import 'package:commute_calendar/feature/calendar/data/datasources/work_record_data_source.dart';
import 'package:commute_calendar/feature/calendar/data/repositories/calendar_repository_impl.dart';
import 'package:commute_calendar/feature/calendar/data/repositories/overtime_repository_impl.dart';
import 'package:commute_calendar/feature/calendar/domain/repositories/i_calendar_repository.dart';
import 'package:commute_calendar/feature/calendar/domain/repositories/i_overtime_repository.dart';
import 'package:commute_calendar/feature/calendar/domain/usecases/add_overtime_record_usecase.dart';
import 'package:commute_calendar/feature/calendar/domain/usecases/calculate_overtime_stats_usecase.dart';
import 'package:commute_calendar/feature/calendar/domain/usecases/delete_overtime_record_usecase.dart';
import 'package:commute_calendar/feature/calendar/domain/usecases/get_overtime_records_usecase.dart';
import 'package:commute_calendar/feature/calendar/domain/usecases/update_overtime_record_usecase.dart';
import 'package:commute_calendar/feature/calendar/domain/usecases/add_work_record_usecase.dart';
import 'package:commute_calendar/feature/calendar/domain/usecases/calculate_monthly_stats_usecase.dart';
import 'package:commute_calendar/feature/calendar/domain/usecases/delete_work_record_usecase.dart';
import 'package:commute_calendar/feature/calendar/domain/usecases/get_monthly_records_usecase.dart';
import 'package:commute_calendar/feature/calendar/domain/usecases/update_work_record_usecase.dart';
import 'package:commute_calendar/feature/calendar/presentation/bloc/calendar_bloc.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

Future<void> setupServiceLocator() async {
  // 1. Database
  getIt.registerSingleton<AppDatabase>(AppDatabase());

  // 2. Calendar — DataSource → Repository → UseCases → Bloc
  getIt.registerSingleton<WorkRecordDataSource>(
    WorkRecordDataSource(getIt<AppDatabase>()),
  );
  getIt.registerSingleton<ICalendarRepository>(
    CalendarRepositoryImpl(getIt<WorkRecordDataSource>()),
  );
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

  // 3. Overtime — DataSource → Repository → UseCases
  getIt.registerSingleton<OvertimeDataSource>(
    OvertimeDataSource(getIt<AppDatabase>()),
  );
  getIt.registerSingleton<IOvertimeRepository>(
    OvertimeRepositoryImpl(getIt<OvertimeDataSource>()),
  );
  getIt.registerFactory<GetOvertimeRecordsUseCase>(
    () => GetOvertimeRecordsUseCase(getIt<IOvertimeRepository>()),
  );
  getIt.registerFactory<AddOvertimeRecordUseCase>(
    () => AddOvertimeRecordUseCase(getIt<IOvertimeRepository>()),
  );
  getIt.registerFactory<UpdateOvertimeRecordUseCase>(
    () => UpdateOvertimeRecordUseCase(getIt<IOvertimeRepository>()),
  );
  getIt.registerFactory<DeleteOvertimeRecordUseCase>(
    () => DeleteOvertimeRecordUseCase(getIt<IOvertimeRepository>()),
  );
  getIt.registerFactory<CalculateOvertimeStatsUseCase>(
    () => CalculateOvertimeStatsUseCase(getIt<IOvertimeRepository>()),
  );

  // 4. Calendar Bloc (특근 UseCase 의존 → 마지막에 등록)
  getIt.registerFactory<CalendarBloc>(
    () => CalendarBloc(
      getMonthlyRecords: getIt<GetMonthlyRecordsUseCase>(),
      addWorkRecord: getIt<AddWorkRecordUseCase>(),
      updateWorkRecord: getIt<UpdateWorkRecordUseCase>(),
      deleteWorkRecord: getIt<DeleteWorkRecordUseCase>(),
      calculateMonthlyStats: getIt<CalculateMonthlyStatsUseCase>(),
      getOvertimeRecords: getIt<GetOvertimeRecordsUseCase>(),
      addOvertimeRecord: getIt<AddOvertimeRecordUseCase>(),
      updateOvertimeRecord: getIt<UpdateOvertimeRecordUseCase>(),
      deleteOvertimeRecord: getIt<DeleteOvertimeRecordUseCase>(),
    ),
  );
}
