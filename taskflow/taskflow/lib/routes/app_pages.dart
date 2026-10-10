import 'package:get/get.dart';

import '../viewmodels/task_viewmodel.dart';
import '../views/login_view.dart';
import '../views/onboarding_view.dart';
import '../views/signup_view.dart';
import '../views/task_form_view.dart';
import '../views/task_list_view.dart';
import 'app_routes.dart';

class AppPages {
  static final List<GetPage> pages = [
    GetPage(name: AppRoutes.onboarding, page: () => const OnboardingView()),
    GetPage(name: AppRoutes.login, page: () => const LoginView()),
    GetPage(name: AppRoutes.signup, page: () => const SignupView()),
    GetPage(
      name: AppRoutes.tasks,
      page: () => const TaskListView(),
      binding: BindingsBuilder(() => Get.lazyPut(() => TaskViewModel())),
    ),
    GetPage(name: AppRoutes.taskForm, page: () => const TaskFormView()),
  ];
}
