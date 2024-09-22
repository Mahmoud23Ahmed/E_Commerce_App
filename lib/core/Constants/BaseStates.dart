class BaseInitialState{}

class BaseLoadingState{}

class BaseErrorState{
  String errorMessage;
  BaseErrorState(this.errorMessage);
}

class BaseSuccessState<Type>{
  Type data;
  BaseSuccessState({required this.data});
}
