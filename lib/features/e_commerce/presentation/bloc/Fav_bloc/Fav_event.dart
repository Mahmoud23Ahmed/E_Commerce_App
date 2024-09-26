part of 'Fav_bloc.dart';

abstract class FavEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadFavItems extends FavEvent {}

class DeleteFavItem extends FavEvent {
  final String itemId;

  DeleteFavItem(this.itemId);

  @override
  List<Object?> get props => [itemId];
}
