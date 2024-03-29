// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:blog_app_clean_architecture/core/error/exceptions.dart';
import 'package:blog_app_clean_architecture/core/network/connection_checker.dart';
import 'package:blog_app_clean_architecture/feature/auth/data/models/user_model.dart';
import 'package:blog_app_clean_architecture/core/common/entities/user.dart';
import 'package:fpdart/src/either.dart';

import 'package:blog_app_clean_architecture/core/error/failures.dart';
import 'package:blog_app_clean_architecture/feature/auth/data/datasources/auth_remote_data_source.dart';
import 'package:blog_app_clean_architecture/feature/auth/domain/repository/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final ConnectionChecker connectionChecker;
  const AuthRepositoryImpl(
    this.remoteDataSource,
    this.connectionChecker,
  );

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
      if (!await (connectionChecker.isConnected)) {
        return left(Failure('No internet connection'));
      }
      final user = await fn();
      return right(user);
    } on ServerException catch (error) {
      return left(Failure(error.message));
    }
  }

  @override
  Future<Either<Failure, User>> currentUser() async {
    try {
      if (!await (connectionChecker.isConnected)) {
        final session = remoteDataSource.currentUserSession;

        if (session == null) {
          return left(Failure('User not logged in'));
        }

        return right(UserModel(
            id: session.user.id, email: session.user.email ?? '', name: ''));
      }
      final user = await remoteDataSource.getCurrentUserData();
      if (user == null) {
        return left(Failure('User not logged in!'));
      }
      return right(user);
    } on ServerException catch (error) {
      return left(Failure(error.message));
    }
  }
}
