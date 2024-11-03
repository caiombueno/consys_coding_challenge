import 'package:consys_coding_challenge/src/features/home/home.dart';
import 'package:consys_coding_challenge/src/features/tasks/tasks.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

part 'app_router.g.dart';

final goRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    routes: $appRoutes,
    initialLocation: const HomeRoute().location,
  );
});

@TypedGoRoute<HomeRoute>(path: '/', routes: [
  TypedGoRoute<TaskDetailsRoute>(path: 'detais/:taskId'),
])
class HomeRoute extends GoRouteData {
  const HomeRoute();
  @override
  Widget build(BuildContext context, GoRouterState state) => const HomeScreen();
}

class TaskDetailsRoute extends GoRouteData {
  final String taskId;
  const TaskDetailsRoute(this.taskId);
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return TaskDetailsScreen(taskId: taskId);
  }
}
