part of 'Fav_bloc.dart';

abstract class FavState extends Equatable {
  @override
  List<Object?> get props => [];
}

class FavLoading extends FavState {}

class FavLoaded extends FavState {
  final List<QueryDocumentSnapshot> FavItems;
  final num totalPrice;

  FavLoaded(this.FavItems, this.totalPrice);

  @override
  List<Object?> get props => [FavItems, totalPrice];
}

class FavError extends FavState {
  final String message;

  FavError(this.message);

  @override
  List<Object?> get props => [message];
}
