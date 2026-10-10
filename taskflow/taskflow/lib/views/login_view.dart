import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../viewmodels/auth_viewmodel.dart';
import 'widgets/app_logo.dart';
import 'widgets/app_text_field.dart';
import 'widgets/auth_footer.dart';
import 'widgets/error_text.dart';
import 'widgets/primary_button.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Get.find<AuthViewModel>();

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 40),
              const AppLogo(),
              const SizedBox(height: 24),
              Text(
                'Welcome back!',
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
                  hint: 'Enter your password',
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
              const SizedBox(height: 24),
              Obx(() => ErrorText(message: viewModel.errorMessage.value)),
              Obx(
                () => PrimaryButton(
                  text: 'Log in',
                  isLoading: viewModel.isLoading.value,
                  onPressed: viewModel.login,
                ),
              ),
              const SizedBox(height: 16),
              AuthFooter(
                question: "Don't have an account?",
                actionText: 'Get started!',
                onTap: viewModel.goToSignUp,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
