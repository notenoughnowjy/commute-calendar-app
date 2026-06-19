import 'package:commute_calendar/feature/auth/domain/usecases/sign_up_usecase.dart';
import 'package:commute_calendar/feature/auth/presentation/sign_up/bloc/sign_up_event.dart';
import 'package:commute_calendar/feature/auth/presentation/sign_up/bloc/sign_up_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  SignUpBloc({required SignUpUseCase signUp})
    : _signUp = signUp,
      super(const SignUpInitial()) {
    on<SignUpSubmitted>(_onSignUpSubmitted);
  }

  final SignUpUseCase _signUp;

  Future<void> _onSignUpSubmitted(
    SignUpSubmitted event,
    Emitter<SignUpState> emit,
  ) async {
    emit(const SignUpLoading());
    try {
      await _signUp(event.email, event.password, event.name, event.department);
      emit(const SignUpSuccess());
    } catch (e) {
      emit(SignUpFailure(e.toString().replaceAll('Exception: ', '')));
    }
  }
}
