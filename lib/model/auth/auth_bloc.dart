import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? currentUser;
  Map<String, dynamic>? userData;

  Future<String> uploadProfilePicture(String uid, File file) async {
    try {
      final ref = FirebaseStorage.instance.ref().child('profile_pictures/$uid.jpg');
      await ref.putFile(file);
      return await ref.getDownloadURL();
    } catch (e) {
      throw Exception("Gagal Mengunggah Foto Profil: $e");
    }
  }


  AuthBloc() : super(AuthInitial()) {
    on<SignInEvent>((event, emit) async {
      emit(AuthLoading());
      try {
        // Create a new account
        UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
          email: event.email,
          password: event.password,
        );
        currentUser = userCredential.user;

        if (userCredential.user != null) {
          // Check if data exists
          final docSnapshot = await _firestore.collection('users').doc(userCredential.user!.uid).get();
          if (!docSnapshot.exists) {
            emit(AuthSignedIn()); // Navigate to the Form Page
          } else {
            emit(AuthError("Email telah terdaftar, harap log in."));
          }
        }
      } catch (e) {
        emit(AuthError(e.toString()));
      }
    });

    on<LogInEvent>((event, emit) async {
      emit(AuthLoading());
      try {
        // Log in the user
        UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: event.email,
          password: event.password,
        );
        currentUser = userCredential.user;

        if (userCredential.user != null) {
          // Check if data exists
          final docSnapshot = await _firestore.collection('users').doc(userCredential.user!.uid).get();
          if (docSnapshot.exists) {
            userData = docSnapshot.data();
            emit(AuthAuthenticated()); // Navigate to Main App
          } else {
            emit(AuthError("Email belum terdaftar, harap registrasi."));
          }
        }
      } catch (e) {
        emit(AuthError(e.toString()));
      }
    });

    on<SubmitFormEvent>((event, emit) async {
      emit(AuthFormSubmission());
      try {
        if (currentUser != null) {
          final downloadUrl = await uploadProfilePicture(currentUser!.uid, File(event.formData['profile_picture']));

          userData = {
            'name': event.formData['name'],
            'age': event.formData['age'],
            'domisili': event.formData['domisili'],
            'profile_picture_url': downloadUrl,
            'wa': event.formData['wa']
          };

          await FirebaseFirestore.instance.collection('users').doc(currentUser!.uid).set(userData!);

          emit(AuthAuthenticated());
        } else {
          emit(AuthError("No authenticated user found."));
        }
      } catch (e) {
        emit(AuthError(e.toString()));
      }
    });

    on<ForgotPasswordEvent>((event, emit) async {
      emit(ForgotPasswordLoading());
      try {
        await _auth.sendPasswordResetEmail(email: event.email);
        emit(ForgotPasswordSuccess("Request reset password telah dikirim, harak cek inbox email Anda."));
      } catch (e) {
        emit(ForgotPasswordError("Failed to send password reset email. ${e.toString()}"));
      }
    });

    on<EditProfileEvent>((event, emit) async {
      emit(AuthLoading());
      try {
        if (currentUser != null) {
          // Update profile picture if a new file is provided
          String? profilePictureUrl = userData?['profile_picture_url'];
          if (event.updatedData.containsKey('profile_picture') && event.updatedData['profile_picture'] != null) {
            profilePictureUrl = await uploadProfilePicture(currentUser!.uid, File(event.updatedData['profile_picture']));
          }

          // Update Firestore data
          Map<String, dynamic> updatedUserData = {
            'name': event.updatedData['name'] ?? userData?['name'],
            'age': event.updatedData['age'] ?? userData?['age'],
            'domisili': event.updatedData['domisili'] ?? userData?['domisili'],
            'profile_picture_url': profilePictureUrl,
            'wa': event.updatedData['wa'] ?? userData?['wa'],
          };

          await _firestore.collection('users').doc(currentUser!.uid).update(updatedUserData);

          // Update local state
          userData = updatedUserData;
          emit(AuthAuthenticated());
        } else {
          emit(AuthError("No authenticated user found."));
        }
      } catch (e) {
        emit(AuthError("Failed to update profile: ${e.toString()}"));
      }
    });

  }
}
