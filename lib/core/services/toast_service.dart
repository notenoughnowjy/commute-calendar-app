import 'package:commute_calendar/core/theme/theme_service.dart';
import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

class ToastService {
  ToastService._();

  static void show({
    required BuildContext context,
    required String message,
    bool isError = false,
  }) {
    toastification.show(
      context: context,
      type: isError ? ToastificationType.error : ToastificationType.success,
      style: ToastificationStyle.flat,
      title: Text(
        message,
        style: ThemeService.body2.copyWith(color: ThemeService.black900),
      ),
      alignment: Alignment.topCenter,
      autoCloseDuration: const Duration(seconds: 3),
      showProgressBar: false,
      primaryColor: isError ? ThemeService.secondary : ThemeService.primary,
    );
  }
}
