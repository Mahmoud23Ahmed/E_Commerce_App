part of 'cart_bloc.dart';

abstract class CartEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadCartItems extends CartEvent {}

class DeleteCartItem extends CartEvent {
  final String itemId;

  DeleteCartItem(this.itemId);

  @override
  List<Object?> get props => [itemId];
}

class DeleteAllCartItems extends CartEvent {
  DeleteAllCartItems();
  @override
  List<Object?> get props => [];
}
