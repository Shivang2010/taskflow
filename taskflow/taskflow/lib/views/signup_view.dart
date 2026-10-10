import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../viewmodels/auth_viewmodel.dart';
import 'widgets/app_logo.dart';
import 'widgets/app_text_field.dart';
import 'widgets/auth_footer.dart';
import 'widgets/error_text.dart';
import 'widgets/primary_button.dart';

class SignupView extends StatelessWidget {
  const SignupView({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Get.find<AuthViewModel>();

    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const AppLogo(),
              const SizedBox(height: 24),
              Text(
                "Let's get started!",
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 32),
              AppTextField(
                label: 'Email',
                hint: 'you@example.com',
                controller: viewModel.emailController,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              Obx(
                () => AppTextField(
                  label: 'Password',
                  hint: 'At least 6 characters',
                  controller: viewModel.passwordController,
                  obscureText: viewModel.isPasswordHidden.value,
                  suffixIcon: IconButton(
                    onPressed: viewModel.togglePasswordVisibility,
                    icon: Icon(
                      viewModel.isPasswordHidden.value
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Obx(
                () => AppTextField(
                  label: 'Confirm password',
                  hint: 'Re-enter your password',
                  controller: viewModel.confirmPasswordController,
                  obscureText: viewModel.isPasswordHidden.value,
                ),
              ),
              const SizedBox(height: 24),
              Obx(() => ErrorText(message: viewModel.errorMessage.value)),
              Obx(
                () => PrimaryButton(
                  text: 'Sign up',
                  isLoading: viewModel.isLoading.value,
                  onPressed: viewModel.signUp,
                ),
              ),
              const SizedBox(height: 16),
              AuthFooter(
                question: 'Already have an account?',
                actionText: 'Log in',
                onTap: viewModel.goToLogin,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
