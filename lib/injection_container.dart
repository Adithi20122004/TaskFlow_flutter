import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:gig_tasks/features/auth/data/repos_impl/auth_repository_impl.dart';
import 'package:gig_tasks/features/auth/data/sources/auth_remote_data_source.dart';
import 'package:gig_tasks/features/auth/data/sources/auth_remote_data_source_impl.dart';
import 'package:gig_tasks/features/auth/domain/repos/auth_repository.dart';
import 'package:gig_tasks/features/auth/domain/usecases/auth_state_changes_usecase.dart';
import 'package:gig_tasks/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:gig_tasks/features/auth/domain/usecases/login_usecase.dart';
import 'package:gig_tasks/features/auth/domain/usecases/logout_usecase.dart';
import 'package:gig_tasks/features/auth/domain/usecases/register_usecase.dart';
import 'package:gig_tasks/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:gig_tasks/features/tasks/data/repos_impl/task_repository_impl.dart';
import 'package:gig_tasks/features/tasks/data/sources/task_remote_data_source.dart';
import 'package:gig_tasks/features/tasks/data/sources/task_remote_data_source_impl.dart';
import 'package:gig_tasks/features/tasks/domain/repos/task_repository.dart';
import 'package:gig_tasks/features/tasks/domain/usecases/create_task_usecase.dart';
import 'package:gig_tasks/features/tasks/domain/usecases/delete_task_usecase.dart';
import 'package:gig_tasks/features/tasks/domain/usecases/get_tasks_usecase.dart';
import 'package:gig_tasks/features/tasks/domain/usecases/toggle_task_complete_usecase.dart';
import 'package:gig_tasks/features/tasks/domain/usecases/update_task_usecase.dart';
import 'package:gig_tasks/features/tasks/domain/usecases/watch_tasks_usecase.dart';
import 'package:gig_tasks/features/tasks/presentation/bloc/filter_bloc.dart';
import 'package:gig_tasks/features/tasks/presentation/bloc/task_bloc.dart';

final GetIt sl = GetIt.instance;

Future<void> initDependencies() async {
  _registerFirebase();
  _registerAuthDataSources();
  _registerAuthRepositories();
  _registerAuthUseCases();
  _registerAuthBloc();
  _registerTaskDataSources();
  _registerTaskRepositories();
  _registerTaskUseCases();
  _registerTaskBlocs();
}

// ─── Firebase ────────────────────────────────────────────────────────────────

void _registerFirebase() {
  sl.registerLazySingleton<FirebaseAuth>(
    () => FirebaseAuth.instance,
  );
  sl.registerLazySingleton<FirebaseFirestore>(
    () => FirebaseFirestore.instance,
  );
}

// ─── Auth: Data Sources ───────────────────────────────────────────────────────

void _registerAuthDataSources() {
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(sl<FirebaseAuth>()),
  );
}

// ─── Auth: Repositories ───────────────────────────────────────────────────────

void _registerAuthRepositories() {
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(sl<AuthRemoteDataSource>()),
  );
}

// ─── Auth: Use Cases ──────────────────────────────────────────────────────────

void _registerAuthUseCases() {
  sl.registerLazySingleton(
    () => LoginUseCase(sl<AuthRepository>()),
  );
  sl.registerLazySingleton(
    () => RegisterUseCase(sl<AuthRepository>()),
  );
  sl.registerLazySingleton(
    () => LogoutUseCase(sl<AuthRepository>()),
  );
  sl.registerLazySingleton(
    () => GetCurrentUserUseCase(sl<AuthRepository>()),
  );
  sl.registerLazySingleton(
    () => AuthStateChangesUseCase(sl<AuthRepository>()),
  );
}

// ─── Auth: BLoC ───────────────────────────────────────────────────────────────

void _registerAuthBloc() {
  // AuthBloc is a singleton so auth state persists across routes.
  sl.registerLazySingleton<AuthBloc>(
    () => AuthBloc(
      loginUseCase: sl<LoginUseCase>(),
      registerUseCase: sl<RegisterUseCase>(),
      logoutUseCase: sl<LogoutUseCase>(),
      getCurrentUserUseCase: sl<GetCurrentUserUseCase>(),
      authStateChangesUseCase: sl<AuthStateChangesUseCase>(),
    ),
  );
}

// ─── Tasks: Data Sources ──────────────────────────────────────────────────────

void _registerTaskDataSources() {
  sl.registerLazySingleton<TaskRemoteDataSource>(
    () => TaskRemoteDataSourceImpl(sl<FirebaseFirestore>()),
  );
}

// ─── Tasks: Repositories ──────────────────────────────────────────────────────

void _registerTaskRepositories() {
  sl.registerLazySingleton<TaskRepository>(
    () => TaskRepositoryImpl(sl<TaskRemoteDataSource>()),
  );
}

// ─── Tasks: Use Cases ─────────────────────────────────────────────────────────

void _registerTaskUseCases() {
  sl.registerLazySingleton(
    () => WatchTasksUseCase(sl<TaskRepository>()),
  );
  sl.registerLazySingleton(
    () => GetTasksUseCase(sl<TaskRepository>()),
  );
  sl.registerLazySingleton(
    () => CreateTaskUseCase(sl<TaskRepository>()),
  );
  sl.registerLazySingleton(
    () => UpdateTaskUseCase(sl<TaskRepository>()),
  );
  sl.registerLazySingleton(
    () => DeleteTaskUseCase(sl<TaskRepository>()),
  );
  sl.registerLazySingleton(
    () => ToggleTaskCompleteUseCase(sl<TaskRepository>()),
  );
}

// ─── Tasks: BLoCs ─────────────────────────────────────────────────────────────

void _registerTaskBlocs() {
  // TaskBloc is a factory — a fresh instance per task list session.
  sl.registerFactory<TaskBloc>(
    () => TaskBloc(
      watchTasksUseCase: sl<WatchTasksUseCase>(),
      createTaskUseCase: sl<CreateTaskUseCase>(),
      updateTaskUseCase: sl<UpdateTaskUseCase>(),
      deleteTaskUseCase: sl<DeleteTaskUseCase>(),
      toggleTaskCompleteUseCase: sl<ToggleTaskCompleteUseCase>(),
    ),
  );

  // FilterBloc is also a factory — one per task list session.
  sl.registerFactory<FilterBloc>(
    () => FilterBloc(),
  );
}