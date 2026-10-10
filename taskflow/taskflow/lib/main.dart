import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'firebase_options.dart';
import 'routes/app_pages.dart';
import 'routes/app_routes.dart';
import 'services/auth_service.dart';
import 'utils/app_theme.dart';
import 'viewmodels/auth_viewmodel.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final authService = Get.put(AuthService());
  Get.put(AuthViewModel(), permanent: true);

  runApp(
    GetMaterialApp(
      title: 'TaskFlow',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: authService.currentUser != null
          ? AppRoutes.tasks
          : AppRoutes.onboarding,
      getPages: AppPages.pages,
    ),
  );
}
