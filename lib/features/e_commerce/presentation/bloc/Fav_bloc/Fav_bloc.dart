import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

part 'Fav_event.dart';
part 'Fav_state.dart';

// Fav Bloc
class FavBloc extends Bloc<FavEvent, FavState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? _userId;

  FavBloc() : super(FavLoading()) {
    on<LoadFavItems>(_onLoadFavItems);
    on<DeleteFavItem>(_onDeleteFavItem);
    _getCurrentUserId();
  }

  void _getCurrentUserId() async {
    final User? user = _auth.currentUser;
    if (user != null) {
      _userId = user.uid;
      add(LoadFavItems());
    }
  }

  Future<void> _onLoadFavItems(
      LoadFavItems event, Emitter<FavState> emit) async {
    if (_userId != null) {
      try {
        final snapshot = await _firestore
            .collection('users')
            .doc(_userId)
            .collection('FavItems')
            .get();
        num totalPrice = 0.0;
        snapshot.docs.forEach((item) {
          totalPrice += item['price'];
        });
        emit(FavLoaded(snapshot.docs, totalPrice));
      } catch (e) {
        emit(FavError('Failed to load Fav items.'));
      }
    } else {
      emit(FavError('User not authenticated.'));
    }
  }

  Future<void> _onDeleteFavItem(
      DeleteFavItem event, Emitter<FavState> emit) async {
    if (_userId != null) {
      try {
        await _firestore
            .collection('users')
            .doc(_userId)
            .collection('FavItems')
            .doc(event.itemId)
            .delete();
        add(LoadFavItems()); // Reload Fav after deleting
      } catch (e) {
        emit(FavError('Failed to delete item.'));
      }
    } else {
      emit(FavError('User not authenticated.'));
    }
  }
}
