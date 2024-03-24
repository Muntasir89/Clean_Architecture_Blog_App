import 'package:bloc/bloc.dart';
import 'package:blog_app_clean_architecture/core/common/entities/user.dart';
import 'package:flutter/material.dart';

part 'app_user_state.dart';

class AppUserCubit extends Cubit<AppUserState> {
  AppUserCubit() : super(AppUserInitial());

  void updateUser(User? user) {
    if (user == null) {
      emit(AppUserInitial());
    } else {
      emit(AppUserLoggedIn(user));
    }
  }
}
