import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/features/auth/domain/entities/user.dart';
import 'package:chat_app/features/auth/domain/repositories/auth_repo.dart';
import 'package:equatable/equatable.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {

  final AuthRepo repository;
  late User user;

  AuthCubit(this.repository) : super(AuthInitial());

  // checkCachedUser
  Future<void> checkCachedUser() async {
    emit(AuthLoading());
    final failureOrUser = await repository.getCachedUser();
    failureOrUser.fold(
      (failure) => emit(AuthError(message: failure.message)),
      (user) {
        this.user = user;
        emit(AuthLoaded(user: user));
      }
    );
  }

  // signInWithEmailAndPassword
  Future<void> signInWithEmailAndPassword(String email, String password) async {
    emit(AuthLoading());
    final failureOrUser = await repository.signInWithEmailAndPassword(email, password);
    failureOrUser.fold(
      (failure) => emit(AuthError(message: failure.message)),
      (user) {
        this.user = user;
        emit(AuthLoaded(user: user));
      }
    );
  }

  Future<void> signInWithUsernameAndPassword(String email, String password) async {
    emit(AuthLoading());
    final failureOrUser = await repository.signInWithUsernameAndPassword(email, password);
    failureOrUser.fold(
            (failure) => emit(AuthError(message: failure.message)),
            (user) {
          this.user = user;
          emit(AuthLoaded(user: user));
        }
    );
  }

  // signup
  Future<void> signup(String name, String email, String username, String password) async {
    emit(AuthLoading());
    final failureOrUser = await repository.signup(name, email, username, password);
    failureOrUser.fold(
      (failure) => emit(AuthError(message: failure.message)),
      (user) {
        this.user = user;
        emit(AuthLoaded(user: user));
      }
    );
  }

  // logout
  Future<void> logout() async {
    emit(AuthLoading());
    final failureOrUnit = await repository.logout();
    failureOrUnit.fold(
      (failure) => emit(AuthError(message: failure.message)),
      (unit) {
        emit(AuthInitial());
      }
    );
  }


  // clear auth state
  Future<void> clearAuthState() async {
    emit(AuthInitial());
  }

  // update user avatar
  Future<void> updateUserAvatar(File image) async {
    emit(AuthLoading());
    final failureOrUser = await repository.updateUserAvatar(image);
    failureOrUser.fold(
      (failure) => emit(AuthError(message: failure.message)),
      (user) {
        this.user = user;
        emit(AuthLoaded(user: user));
      }
    );
  }

  // update user profile
  Future<void> updateUserProfile(String name, String username, String email) async {
    emit(AuthLoading());
    final failureOrUser = await repository.updateUserProfile(name, username, email);
    failureOrUser.fold(
      (failure) => emit(AuthError(message: failure.message)),
      (user) {
        this.user = user;
        emit(AuthLoaded(user: user));
      }
    );
  }


}