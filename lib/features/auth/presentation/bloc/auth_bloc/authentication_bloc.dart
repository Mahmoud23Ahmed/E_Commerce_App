import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:e_commerce_app/core/networks/network_info.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:meta/meta.dart';
import '../../../data/datasorce/authentication_remote_ds/authentication.dart';
import '../../../data/datasorce/user_remote_ds/user_remote_ds.dart';
import '../../../data/model/auth_model.dart';
import '../../../data/model/user_model.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthenticationRemoteDs authenticationRemoteDs;
  final UsersRemoteDs usersDBModel;
  final NetworkInfo networkInfo ;

  AuthBloc({required this.usersDBModel, required this.authenticationRemoteDs , required this.networkInfo,})
      : super(UserUnauthorized()) {
    on<AuthEvent>((event, emit) async {
      print(event); // Debugging: Print the event
      try {
          try{
            if (event is SignUp) {
              emit(UserAuthLoadingState());
              await authenticationRemoteDs.signUp(event.authModel);

              // Ensure the user ID is fetched correctly
              final String userId = authenticationRemoteDs.getUserId();
              print('User signed up with ID: $userId');

              // Create a new UserModel with the correct user ID
              UserModel updatedUserModel = event.userModel.copyWith(userId: userId);

              // Add user to Firestore with the correct user ID
              await usersDBModel.addUser(updatedUserModel);

              print('User added to Firestore successfully');
              emit(UserAuthorizedState());
            }
          }
          catch(e){
            print("netwooooooork");
            emit(UserErrorState(error: e.toString()));
          }
          try{
            if (event is SignIn) {
              emit(UserAuthLoadingState());
              await authenticationRemoteDs.signIn(event.userModel);

              if (authenticationRemoteDs.checkIfAuth()) {
                emit(UserAuthorizedState());
              } else {
                emit(UserUnauthorized());
              }
            }
          } catch(e){
            print(e.toString());
            emit(UserErrorState(error: e.toString()));
          }
          if (event is CheckIfAuth) {
            emit(UserAuthLoadingState());
            final bool isSignedIn = authenticationRemoteDs.checkIfAuth();
            final bool isAnonymous = authenticationRemoteDs.checkUserSignInStatus();

            if (isSignedIn && isAnonymous) {
              emit(UserAnonymousState());
            } else if (isSignedIn) {
              emit(UserAuthorizedState());
            } else {
              emit(UserUnauthorized());
            }
          } else if (event is SignOut) {
            emit(UserAuthLoadingState());
            await authenticationRemoteDs.signOut();
            emit(UserUnauthorized());
          }



      }catch (e) {
        print('Error in AuthBloc: $e'); // Debugging: Print the error
        if (e is TypeError) {
          print('Type Error details: ${e.toString()}'); // Additional debugging for type errors
        }
        emit(UserErrorState(
            error: 'Please enter your credentials correctly or sign up.'));
      }


    });
  }
}
void showToast(String message) {
  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.CENTER,
    timeInSecForIosWeb: 1,
    backgroundColor: Colors.red,
    textColor: Colors.white,
    fontSize: 16.0,
  );
}