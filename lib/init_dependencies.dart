import 'package:blog_app_clean_architecture/core/common/cubit/app_user/app_user_cubit.dart';
import 'package:blog_app_clean_architecture/core/secrets/app_secrets.dart';
import 'package:blog_app_clean_architecture/feature/auth/data/datasources/auth_remote_data_source.dart';
import 'package:blog_app_clean_architecture/feature/auth/data/repositories/auth_repositories_impl.dart';
import 'package:blog_app_clean_architecture/feature/auth/domain/repository/auth_repository.dart';
import 'package:blog_app_clean_architecture/feature/auth/domain/usecases/current_user.dart';
import 'package:blog_app_clean_architecture/feature/auth/domain/usecases/user_login.dart';
import 'package:blog_app_clean_architecture/feature/auth/domain/usecases/user_sign_up.dart';
import 'package:blog_app_clean_architecture/feature/auth/presentation/bloc/auth_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final serviceLocator = GetIt.instance;

Future<void> init_dependencies() async {
  _initAuth();
  final supabase = await Supabase.initialize(
    url: AppSecrets.supabaseUrl,
    anonKey: AppSecrets.supabaseAnonKey,
  );

  serviceLocator.registerLazySingleton(() => supabase.client);
  // core
  serviceLocator.registerLazySingleton(() => AppUserCubit());
}

void _initAuth() {
  // DataSource
  serviceLocator
    ..registerFactory<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(serviceLocator()),
    )
    // Repository
    ..registerFactory<AuthRepository>(
      () => AuthRepositoryImpl(serviceLocator()),
    )
    // UserCases
    ..registerFactory(
      () => UserSignUp(
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => UserLogin(
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => CurrentUser(
        serviceLocator(),
      ),
    )
// Bloc
    ..registerLazySingleton(
      () => AuthBloc(
        userSignUp: serviceLocator(),
        userLogin: serviceLocator(),
        currentUser: serviceLocator(),
        appUserCubit: serviceLocator(),
      ),
    );
}
