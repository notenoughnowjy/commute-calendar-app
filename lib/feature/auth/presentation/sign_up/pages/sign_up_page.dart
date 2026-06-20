import 'package:commute_calendar/core/di/service_locator.dart';
import 'package:commute_calendar/core/services/toast_service.dart';
import 'package:commute_calendar/core/theme/theme_service.dart';
import 'package:commute_calendar/feature/auth/presentation/sign_up/bloc/sign_up_bloc.dart';
import 'package:commute_calendar/feature/auth/presentation/sign_up/bloc/sign_up_event.dart';
import 'package:commute_calendar/feature/auth/presentation/sign_up/bloc/sign_up_state.dart';
import 'package:commute_calendar/feature/auth/presentation/widgets/auth_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<SignUpBloc>(),
      child: const _SignUpView(),
    );
  }
}

class _SignUpView extends StatefulWidget {
  const _SignUpView();

  @override
  State<_SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<_SignUpView> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _departmentController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _departmentController.dispose();
    super.dispose();
  }

  void _onSubmit() {
    context.read<SignUpBloc>().add(
      SignUpSubmitted(
        email: _emailController.text.trim(),
        password: _passwordController.text,
        name: _nameController.text.trim(),
        department: _departmentController.text.trim().isEmpty
            ? null
            : _departmentController.text.trim(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeService.white,
      body: BlocListener<SignUpBloc, SignUpState>(
        listener: (context, state) {
          if (state is SignUpFailure) {
            ToastService.show(
              context: context,
              message: state.message,
              isError: true,
            );
          } else if (state is SignUpSuccess) {
            ToastService.show(
              context: context,
              message: '회원가입이 완료됐습니다.',
            );
          }
        },
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 80),
                  const Text('회원가입', style: ThemeService.headline),
                  const SizedBox(height: 4),
                  Text(
                    '정보를 입력해주세요.',
                    style: ThemeService.body1.copyWith(color: ThemeService.black500),
                  ),
                  const SizedBox(height: 48),
                  AuthTextField(
                    controller: _nameController,
                    label: '이름',
                  ),
                  const SizedBox(height: 16),
                  AuthTextField(
                    controller: _emailController,
                    label: '이메일',
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 16),
                  AuthTextField(
                    controller: _passwordController,
                    label: '비밀번호',
                    obscureText: true,
                  ),
                  const SizedBox(height: 16),
                  AuthTextField(
                    controller: _departmentController,
                    label: '부서 (선택)',
                  ),
                  const SizedBox(height: 32),
                  BlocBuilder<SignUpBloc, SignUpState>(
                    builder: (context, state) {
                      final isLoading = state is SignUpLoading;
                      return _SignUpButton(
                        onPressed: isLoading ? null : _onSubmit,
                        isLoading: isLoading,
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: TextButton(
                      onPressed: () => context.go('/sign-in'),
                      child: Text(
                        '이미 계정이 있으신가요? 로그인',
                        style: ThemeService.caption.copyWith(color: ThemeService.black600),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SignUpButton extends StatelessWidget {
  const _SignUpButton({required this.onPressed, required this.isLoading});

  final VoidCallback? onPressed;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          backgroundColor: ThemeService.primary,
          disabledBackgroundColor: ThemeService.black300,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        child: isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: ThemeService.white,
                ),
              )
            : Text(
                '회원가입',
                style: ThemeService.body2.copyWith(
                  color: ThemeService.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
      ),
    );
  }
}
