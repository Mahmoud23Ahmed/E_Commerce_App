import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

part 'cart_event.dart';
part 'cart_state.dart';

// Cart Bloc
class CartBloc extends Bloc<CartEvent, CartState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? _userId;

  CartBloc() : super(CartLoading()) {
    on<LoadCartItems>(_onLoadCartItems);
    on<DeleteCartItem>(_onDeleteCartItem);
    _getCurrentUserId();
  }

  void _getCurrentUserId() async {
    final User? user = _auth.currentUser;
    if (user != null) {
      _userId = user.uid;
      add(LoadCartItems());
    }
  }

  Future<void> _onLoadCartItems(
      LoadCartItems event, Emitter<CartState> emit) async {
    if (_userId != null) {
      try {
        final snapshot = await _firestore
            .collection('users')
            .doc(_userId)
            .collection('cartItems')
            .get();
        num totalPrice = 0.0;
        snapshot.docs.forEach((item) {
          totalPrice += item['price'];
        });
        emit(CartLoaded(snapshot.docs, totalPrice));
      } catch (e) {
        emit(CartError('Failed to load cart items.'));
      }
    } else {
      emit(CartError('User not authenticated.'));
    }
  }

  Future<void> _onDeleteCartItem(
      DeleteCartItem event, Emitter<CartState> emit) async {
    if (_userId != null) {
      try {
        await _firestore
            .collection('users')
            .doc(_userId)
            .collection('cartItems')
            .doc(event.itemId)
            .delete();
        add(LoadCartItems()); // Reload cart after deleting
      } catch (e) {
        emit(CartError('Failed to delete item.'));
      }
    } else {
      emit(CartError('User not authenticated.'));
    }
  }
}
