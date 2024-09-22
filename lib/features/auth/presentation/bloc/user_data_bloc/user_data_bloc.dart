import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

import '../../../data/datasorce/authentication_remote_ds/authentication.dart';
import '../../../data/datasorce/user_remote_ds/user_remote_ds.dart';
import '../../../data/model/user_model.dart';


part 'user_data_event.dart';
part 'user_data_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UsersRemoteDs usersDBModel;
  final AuthenticationRemoteDs authinticationRemoteDs;
  UserBloc({required this.usersDBModel, required this.authinticationRemoteDs})
      : super(UserDataInitial()) {
    on<UserEvent>((event, emit) async {
      if (event is SetUserEvent) {
        emit(UserLoadingState());
        add(GetUserEvent());
      } else if (event is GetUserEvent) {
        emit(UserLoadingState());
        User? user = FirebaseAuth.instance.currentUser;
        String userId = user != null ? user.uid : '';

        UserModel userModel = await usersDBModel.getUserByAuthId(userId) ??
            UserModel(
              name: 'name',
              userId: userId, email: 'email',
            );
        emit(UserLoadedState(usersModel: userModel));
      }
    });
  }
}
