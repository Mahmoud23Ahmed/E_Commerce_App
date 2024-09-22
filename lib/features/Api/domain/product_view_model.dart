import 'package:e_commerce_app/core/Constants/product_state.dart';
import 'package:e_commerce_app/features/Api/domain/use%20Cases/GetAllProducts_UseCase.dart';
import 'package:e_commerce_app/features/Api/response/ProductDM.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class ProductViewModel extends Cubit {

  GetAllProductsUseCase getAllProductsUseCase;

  ProductViewModel(this.getAllProductsUseCase)
      : super(InitialProductState());


  Future<void> LoadProducts() async {
    print('Loading products');
    var result = await getAllProductsUseCase.execute();
    result.fold(
            (failure) {
          print('Error loading products: ${failure.errorMessage}');
          emit(ProductErrorState(failure.errorMessage));
        },
            (products) {
          if (products.isNotEmpty) {
            emit(ProductSuccessState<List<ProductDM>>(data: products));
          } else {
            emit(ProductErrorState('No products found'));
          }
        }
    );
  }
}