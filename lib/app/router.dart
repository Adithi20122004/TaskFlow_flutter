import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:gig_tasks/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:gig_tasks/features/auth/presentation/bloc/auth_event.dart';
import 'package:gig_tasks/features/auth/presentation/bloc/auth_state.dart';
import 'package:gig_tasks/features/auth/presentation/screens/login_screen.dart';
import 'package:gig_tasks/features/auth/presentation/screens/register_screen.dart';
import 'package:gig_tasks/features/tasks/domain/entities/task_entity.dart';
import 'package:gig_tasks/features/tasks/presentation/bloc/filter_bloc.dart';
import 'package:gig_tasks/features/tasks/presentation/bloc/task_bloc.dart';
import 'package:gig_tasks/features/tasks/presentation/screens/create_edit_task_screen.dart';
import 'package:gig_tasks/features/tasks/presentation/screens/profile_screen.dart';
import 'package:gig_tasks/features/tasks/presentation/screens/task_detail_screen.dart';
import 'package:gig_tasks/features/tasks/presentation/screens/task_list_screen.dart';
import 'package:gig_tasks/injection_container.dart';

// Shared task bloc instance — lives as long as the tasks shell is alive
TaskBloc? _taskBlocInstance;
FilterBloc? _filterBlocInstance;

GoRouter createRouter(AuthBloc authBloc) {
  return GoRouter(
    initialLocation: '/splash',
    refreshListenable: GoRouterAuthNotifier(authBloc),
    redirect: (context, state) {
      final authState = authBloc.state;
      final location = state.uri.toString();

      if (authState is AuthInitial || authState is AuthLoading) {
        return location == '/splash' ? null : '/splash';
      }

      final isAuthenticated = authState is AuthAuthenticated ||
          authState is AuthLoginSuccess ||
          authState is AuthRegisterSuccess;

      final isOnAuth =
          location == '/login' || location == '/register';

      if (!isAuthenticated && !isOnAuth) return '/login';
      if (isAuthenticated && isOnAuth) return '/tasks';
      if (isAuthenticated && location == '/splash') return '/tasks';
      if (!isAuthenticated && location == '/splash') return '/login';

      return null;
    },
    routes: [
      GoRoute(
        path: '/splash',
        builder: (_, __) => const _SplashScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (_, __) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (_, __) => const RegisterScreen(),
      ),

      // Tasks shell — all task routes share the same BLoC instances
      ShellRoute(
        builder: (context, state, child) {
          _taskBlocInstance ??= sl<TaskBloc>();
          _filterBlocInstance ??= sl<FilterBloc>();

          return MultiBlocProvider(
            providers: [
              BlocProvider<TaskBloc>.value(value: _taskBlocInstance!),
              BlocProvider<FilterBloc>.value(value: _filterBlocInstance!),
            ],
            child: child,
          );
        },
        routes: [
          GoRoute(
            path: '/tasks',
            builder: (_, __) => const TaskListScreen(),
          ),
          GoRoute(
            path: '/tasks/create',
            builder: (_, __) => const CreateEditTaskScreen(),
          ),
          GoRoute(
            path: '/tasks/:taskId',
            builder: (_, state) {
              final task = state.extra as TaskEntity;
              return TaskDetailScreen(task: task);
            },
          ),
          GoRoute(
            path: '/tasks/:taskId/edit',
            builder: (_, state) {
              final task = state.extra as TaskEntity;
              return CreateEditTaskScreen(task: task);
            },
          ),
        ],
      ),

      GoRoute(
        path: '/profile',
        builder: (_, __) => const ProfileScreen(),
      ),
    ],
    errorBuilder: (_, state) =>
        _ErrorScreen(error: state.error.toString()),
  );
}

class GoRouterAuthNotifier extends ChangeNotifier {
  final AuthBloc _authBloc;

  GoRouterAuthNotifier(AuthBloc authBloc) : _authBloc = authBloc {
    _authBloc.stream.listen((state) {
      if (state is! AuthInitial && state is! AuthLoading) {
        // Reset task blocs on logout so next login gets fresh instances
        if (state is AuthUnauthenticated || state is AuthLogoutSuccess) {
          _taskBlocInstance?.close();
          _taskBlocInstance = null;
          _filterBlocInstance?.close();
          _filterBlocInstance = null;
        }
        notifyListeners();
      }
    });
  }
}

class _SplashScreen extends StatefulWidget {
  const _SplashScreen();

  @override
  State<_SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<_SplashScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<AuthBloc>().add(const AuthCheckRequested());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF6C63FF),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Icon(
                Icons.check_rounded,
                color: Colors.white,
                size: 44,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'GigTasks',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Get things done.',
              style: TextStyle(
                fontSize: 15,
                color: Colors.white70,
              ),
            ),
            const SizedBox(height: 40),
            const CircularProgressIndicator(
              color: Colors.white,
              strokeWidth: 2.5,
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorScreen extends StatelessWidget {
  final String error;
  const _ErrorScreen({required this.error});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Error')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline_rounded,
                  size: 48, color: Color(0xFFFF5C5C)),
              const SizedBox(height: 16),
              const Text('Something went wrong',
                  style: TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              Text(error, textAlign: TextAlign.center),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => context.go('/tasks'),
                child: const Text('Go Home'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}