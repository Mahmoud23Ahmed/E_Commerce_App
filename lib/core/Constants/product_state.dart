class InitialProductState{}

class ProductLoadingState{}

class ProductErrorState{
  String errorMessage;
  ProductErrorState(this.errorMessage);
}

class ProductSuccessState<Type>{
  Type data;
  ProductSuccessState({required this.data});
}
