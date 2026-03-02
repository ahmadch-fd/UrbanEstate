import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

void showErrorToast(String message) {
  toastification.show(
    title: const Text('Error'),
    description: Text('Password mismatch'),
    type: ToastificationType.error,
    autoCloseDuration: const Duration(seconds: 3),
  );
}
