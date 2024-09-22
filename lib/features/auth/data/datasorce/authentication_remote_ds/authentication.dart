import 'dart:convert';

import 'package:e_commerce_app/core/errors/failures.dart';
import 'package:e_commerce_app/core/networks/network_info.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../model/auth_model.dart';


abstract class AuthenticationRemoteDs {
  Future<void> signIn(AuthModel userModel);
  Future<void> signUp(AuthModel userModel);
  Future<void> signOut();
  bool checkIfAuth();
  String getUserId();
  bool checkUserSignInStatus();
}

class AuthenticationRemoteDsImpl extends AuthenticationRemoteDs {
  final NetworkInfo networkInfo ;

  AuthenticationRemoteDsImpl({required this.networkInfo});
  @override
  Future<UserCredential?> signIn(AuthModel userModel) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: userModel.email,
        password: userModel.password,
      );
      print('User signed in successfully: ${userCredential.user?.uid}');
      return userCredential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
        throw(UserNotFoundFailure());
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
        throw(WrongPasswordFailure());
      } else if (e.code == 'invalid-email') {
        print('The email address is badly formatted.');
        throw(WrongEmailFailure());
      } else {
        bool isConnected = await networkInfo.isConnected;
        if(!isConnected){
          throw(OfflineFailure());
        }
        print('Error during sign-in: ${e.message}');
        throw(FailureWhileSignIn());

      }
      return null;
    } catch (e) {
      print('Unexpected error: $e');
      return null;
    }
  }

  @override
  Future<void> signUp(AuthModel userModel) async {
    try {
      final UserCredential credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: userModel.email,
        password: userModel.password,
      );
      print('User signed up successfully with ID: ${credential.user?.uid}');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
        throw(EmailAlreadyExistFailer());
      } else if (e.code == 'invalid-email') {
        print('The email address is badly formatted.');
      } else {
        bool isConnected = await networkInfo.isConnected;
        if(!isConnected){
          throw(OfflineFailure());
        }
        print('Error during sign-up: ${e.message}');
      }
    } catch (e) {
      print('Unexpected error: $e');
    }
  }


  @override
  bool checkIfAuth() => FirebaseAuth.instance.currentUser != null;

  @override
  Future<void> signOut() async {
    print('signout');
    await FirebaseAuth.instance.signOut();
    print('after signout');
  }
  @override
  String getUserId() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return user.uid;
    }
    return throw Exception('the user did\'t sign in');
  }


  @override
  bool checkUserSignInStatus() {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;

    if (user != null) {
      print("User is signed in!");
      return user.isAnonymous;
    } else {
      print("User is signed out.");
      return false;
    }
  }
}