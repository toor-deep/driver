import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as storage;
import 'package:rickshaw_driver_app/features/current_user/presentation/bloc/user_state.dart';
import '../../../../shared/toast_alert.dart';
import '../../../auth/domain/entities/auth_user.dart';
import '../../domain/usecase/create_user.usecase.dart';
import '../../domain/usecase/delete_user.usecase.dart';
import '../../domain/usecase/get_user_info.usecase.dart';
import '../../domain/usecase/update_user.usecase.dart';

class UserCubit extends Cubit<UserState> {
  final GetUserUseCase getUserUseCase;
  final CreateUserUseCase createUserUseCase;
  final UpdateUserUseCase updateUserUseCase;
  final DeleteUserUseCase deleteUserUseCase;

  UserCubit({
    required this.getUserUseCase,
    required this.createUserUseCase,
    required this.updateUserUseCase,
    required this.deleteUserUseCase,
  }) : super(UserState());

  User? currentUser = FirebaseAuth.instance.currentUser;

  Future<void> fetchUser() async {
    emit(state.copyWith(isLoading: true));
    try {
      final user = await getUserUseCase.call(currentUser?.email??"");
      if (user != null) {
        emit(state.copyWith(isLoading: false, authUser: user));
      } else {
        emit(state.copyWith(isLoading: false));
      }
    } catch (e) {
      emit(state.copyWith(isLoading: false));
    }
  }

  Future<void> addUser(AuthUser authUser) async {
    emit(state.copyWith(isLoading: true));
    try {
      await createUserUseCase.call(authUser);
      emit(state.copyWith(isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false));
    }
  }

  Future<void> updateUser(AuthUser authUser) async {
    emit(state.copyWith(isLoading: true));
    try {
      await updateUserUseCase.call(authUser);
      emit(state.copyWith(
          isLoading: false,
          authUser: AuthUser(
              id: '',
              email: authUser.email,
              photoURL: authUser.photoURL,
              phone: authUser.phone,
              name: authUser.name)));
      showSnackbar('Successfully Updated', Colors.green);
    } catch (e) {
      emit(state.copyWith(isLoading: false));
      showSnackbar(e.toString(), Colors.red);
    }
  }

  Future<void> deleteUser(String userId) async {
    emit(state.copyWith(isLoading: true));
    try {
      await deleteUserUseCase.call(userId);
      emit(state.copyWith(isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false));
    }
  }

  Future<void> saveImageToFirebase(File imageFile) async {
    try {
      emit(state.copyWith(isLoading: true));
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final userEmail = user.email!;
        final storageRef = storage.FirebaseStorage.instance
            .ref()
            .child('users')
            .child(userEmail)
            .child('profileImage.jpg');

        print("Uploading image...");

        UploadTask uploadTask = storageRef.putFile(imageFile);
        TaskSnapshot snapshot = await uploadTask;

        final imageUrl = await snapshot.ref.getDownloadURL();

        // Query Firestore by email to find the document
        final querySnapshot = await FirebaseFirestore.instance
            .collection('users')
            .where('email', isEqualTo: userEmail)
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          // Assuming that email is unique and we only expect one document
          final docRef = querySnapshot.docs.first.reference;

          await docRef.update({'photoURL': imageUrl});
          AuthUser updatedUser = AuthUser(
            id: user.uid,
            email: userEmail,
            photoURL: imageUrl,
            name: user.displayName,
            phone: user.phoneNumber,
          );
          emit(state.copyWith(authUser: updatedUser, isLoading: false));
          showSnackbar('Image Uploaded Successfully', Colors.green);
        } else {
          showSnackbar('User not found in Firestore', Colors.red);
        }
      } else {
        emit(state.copyWith(isLoading: false));
        showSnackbar('Upload Failed', Colors.red);
      }
    } catch (e) {
      print('Error during upload: $e');
      emit(state.copyWith(isLoading: false));
      showSnackbar('Error in uploading image: $e', Colors.red);
    }
  }
}
