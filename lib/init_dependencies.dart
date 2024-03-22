import 'package:blog_app_clean_architecture/core/secrets/app_secrets.dart';
import 'package:blog_app_clean_architecture/feature/auth/data/datasources/auth_remote_data_source.dart';
import 'package:blog_app_clean_architecture/feature/auth/data/repositories/auth_repositories_impl.dart';
import 'package:blog_app_clean_architecture/feature/auth/domain/repository/auth_repository.dart';
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
}

void _initAuth() {
  serviceLocator.registerFactory<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(serviceLocator()),
  );

  serviceLocator.registerFactory<AuthRepository>(
    () => AuthRepositoryImpl(serviceLocator()),
  );

  serviceLocator.registerFactory(
    () => UserSignUp(
      serviceLocator(),
    ),
  );

  serviceLocator.registerFactory(
    () => UserLogin(
      serviceLocator(),
    ),
  );

  serviceLocator.registerLazySingleton(
    () => AuthBloc(
      userSignUp: serviceLocator(),
      userLogin: serviceLocator(),
    ),
  );
}
