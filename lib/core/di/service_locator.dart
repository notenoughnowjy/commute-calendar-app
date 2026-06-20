import 'package:commute_calendar/core/services/supabase_service.dart';
import 'package:commute_calendar/feature/auth/data/datasources/auth_data_source.dart';
import 'package:commute_calendar/feature/auth/data/repositories/auth_repository_impl.dart';
import 'package:commute_calendar/feature/auth/domain/repositories/i_auth_repository.dart';
import 'package:commute_calendar/feature/auth/domain/usecases/get_auth_state_stream_usecase.dart';
import 'package:commute_calendar/feature/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:commute_calendar/feature/auth/domain/usecases/sign_in_usecase.dart';
import 'package:commute_calendar/feature/auth/domain/usecases/sign_out_usecase.dart';
import 'package:commute_calendar/feature/auth/domain/usecases/sign_up_usecase.dart';
import 'package:commute_calendar/feature/auth/presentation/bloc/auth_bloc.dart';
import 'package:commute_calendar/feature/auth/presentation/sign_in/bloc/sign_in_bloc.dart';
import 'package:commute_calendar/feature/auth/presentation/sign_up/bloc/sign_up_bloc.dart';
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
import 'package:supabase_flutter/supabase_flutter.dart';

final getIt = GetIt.instance;

Future<void> setupServiceLocator() async {
  // 1. Services
  getIt.registerSingleton<SupabaseClient>(supabaseService);

  // 2. Auth — DataSource → Repository → UseCases → Bloc
  getIt.registerSingleton<AuthDataSource>(
    AuthDataSource(getIt<SupabaseClient>()),
  );
  getIt.registerSingleton<IAuthRepository>(
    AuthRepositoryImpl(getIt<AuthDataSource>()),
  );
  getIt.registerFactory<SignInUseCase>(
    () => SignInUseCase(getIt<IAuthRepository>()),
  );
  getIt.registerFactory<SignOutUseCase>(
    () => SignOutUseCase(getIt<IAuthRepository>()),
  );
  getIt.registerFactory<GetCurrentUserUseCase>(
    () => GetCurrentUserUseCase(getIt<IAuthRepository>()),
  );
  getIt.registerFactory<GetAuthStateStreamUseCase>(
    () => GetAuthStateStreamUseCase(getIt<IAuthRepository>()),
  );
  getIt.registerSingleton<AuthBloc>(
    AuthBloc(
      getCurrentUser: getIt<GetCurrentUserUseCase>(),
      getAuthStateStream: getIt<GetAuthStateStreamUseCase>(),
      signOut: getIt<SignOutUseCase>(),
    ),
  );
  getIt.registerFactory<SignUpUseCase>(
    () => SignUpUseCase(getIt<IAuthRepository>()),
  );
  getIt.registerFactory<SignUpBloc>(
    () => SignUpBloc(signUp: getIt<SignUpUseCase>()),
  );
  getIt.registerFactory<SignInBloc>(
    () => SignInBloc(signIn: getIt<SignInUseCase>()),
  );

  // 3. Calendar — DataSource → Repository → UseCases → Bloc
  getIt.registerSingleton<WorkRecordDataSource>(
    WorkRecordDataSource(getIt<SupabaseClient>()),
  );
  getIt.registerSingleton<ICalendarRepository>(
    CalendarRepositoryImpl(getIt<WorkRecordDataSource>(), getIt<SupabaseClient>()),
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

  // 4. Overtime — DataSource → Repository → UseCases
  getIt.registerSingleton<OvertimeDataSource>(
    OvertimeDataSource(getIt<SupabaseClient>()),
  );
  getIt.registerSingleton<IOvertimeRepository>(
    OvertimeRepositoryImpl(getIt<OvertimeDataSource>(), getIt<SupabaseClient>()),
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
}
