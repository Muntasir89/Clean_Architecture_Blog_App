// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:blog_app_clean_architecture/core/error/exceptions.dart';
import 'package:blog_app_clean_architecture/feature/auth/data/models/user_model.dart';
import 'package:blog_app_clean_architecture/feature/auth/domain/entities/user.dart';
import 'package:fpdart/src/either.dart';

import 'package:blog_app_clean_architecture/core/error/failures.dart';
import 'package:blog_app_clean_architecture/feature/auth/data/datasources/auth_remote_data_source.dart';
import 'package:blog_app_clean_architecture/feature/auth/domain/repository/auth_repository.dart';
import 'package:supabase/supabase.dart' as sb;

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  const AuthRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, User>> loginWithEmailPassword(
      {required String email, required String password}) async {
    return _getUser(() async => await remoteDataSource.loginWithEmailPassword(
          email: email,
          password: password,
        ));
  }

  @override
  Future<Either<Failure, User>> signUpWithEmailPassword(
      {required String name,
      required String email,
      required String password}) async {
    return _getUser(
      () async => await remoteDataSource.signUpWithEmailPassword(
        name: name,
        email: email,
        password: password,
      ),
    );
  }

  Future<Either<Failure, User>> _getUser(Future<User> Function() fn) async {
    try {
      final user = await fn();
      return right(user);
    } on sb.AuthException catch (error) {
      return left(Failure(error.message));
    } on ServerException catch (error) {
      return left(Failure(error.message));
    }
  }
}
