import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../routes/app_routes.dart';
import '../services/auth_service.dart';
import '../utils/validators.dart';

class AuthViewModel extends GetxController {
  final AuthService _authService = Get.find<AuthService>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final isLoading = false.obs;
  final isPasswordHidden = true.obs;
  final errorMessage = ''.obs;

  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  Future<void> login() async {
    final email = emailController.text.trim();
    final password = passwordController.text;
    final error =
        Validators.validateEmail(email) ??
        Validators.validatePassword(password);
    if (error != null) {
      errorMessage.value = error;
      return;
    }
    await _runAuthAction(() => _authService.login(email, password));
  }

  Future<void> signUp() async {
    final email = emailController.text.trim();
    final password = passwordController.text;
    final error =
        Validators.validateEmail(email) ??
        Validators.validatePassword(password) ??
        Validators.validateConfirmPassword(
          password,
          confirmPasswordController.text,
        );
    if (error != null) {
      errorMessage.value = error;
      return;
    }
    await _runAuthAction(() => _authService.signUp(email, password));
  }

  void logout() {
    Get.defaultDialog(
      title: 'Log out',
      middleText: 'Are you sure you want to log out?',
      textCancel: 'Cancel',
      textConfirm: 'Log out',
      confirmTextColor: Colors.white,
      onConfirm: () async {
        await _authService.logout();
        clearForm();
        Get.offAllNamed(AppRoutes.login);
      },
    );
  }

  void goToLogin() {
    clearForm();
    Get.offNamed(AppRoutes.login);
  }

  void goToSignUp() {
    clearForm();
    Get.offNamed(AppRoutes.signup);
  }

  void clearForm() {
    emailController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
    errorMessage.value = '';
    isPasswordHidden.value = true;
  }

  Future<void> _runAuthAction(Future<void> Function() action) async {
    errorMessage.value = '';
    isLoading.value = true;
    try {
      await action();
      clearForm();
      Get.offAllNamed(AppRoutes.tasks);
    } on FirebaseAuthException catch (e) {
      errorMessage.value = _messageForCode(e.code);
    } catch (_) {
      errorMessage.value = 'Something went wrong. Please try again.';
    } finally {
      isLoading.value = false;
    }
  }

  String _messageForCode(String code) {
    switch (code) {
      case 'invalid-email':
        return 'That email address is not valid.';
      case 'user-not-found':
      case 'wrong-password':
      case 'invalid-credential':
        return 'Incorrect email or password.';
      case 'email-already-in-use':
        return 'An account already exists for this email.';
      case 'weak-password':
        return 'Password is too weak.';
      case 'too-many-requests':
        return 'Too many attempts. Try again later.';
      case 'network-request-failed':
        return 'No internet connection.';
      default:
        return 'Something went wrong. Please try again.';
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
