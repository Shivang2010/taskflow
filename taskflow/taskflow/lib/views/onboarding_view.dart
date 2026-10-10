import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../routes/app_routes.dart';
import '../utils/app_colors.dart';
import 'widgets/app_logo.dart';

class OnboardingView extends StatelessWidget {
  const OnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final screenWidth = MediaQuery.sizeOf(context).width;

    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: -screenWidth * 0.35,
            right: -screenWidth * 0.35,
            child: Container(
              width: screenWidth * 1.1,
              height: screenWidth * 1.1,
              decoration: BoxDecoration(
                color: AppColors.primaryLight.withValues(alpha: 0.35),
                shape: BoxShape.circle,
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Spacer(flex: 2),
                  const AppLogo(size: 72),
                  const SizedBox(height: 32),
                  Text('Get things done.', style: textTheme.headlineMedium),
                  const SizedBox(height: 12),
                  Text(
                    'Just a click away from planning your tasks.',
                    style: textTheme.bodyLarge?.copyWith(
                      color: AppColors.textGrey,
                    ),
                  ),
                  const Spacer(flex: 3),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: FloatingActionButton(
                      onPressed: () => Get.toNamed(AppRoutes.signup),
                      child: const Icon(Icons.arrow_forward),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
