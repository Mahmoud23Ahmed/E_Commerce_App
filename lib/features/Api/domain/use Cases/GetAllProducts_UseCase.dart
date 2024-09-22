import 'package:dartz/dartz.dart';
import 'package:e_commerce_app/core/Constants/failure.dart';
import 'package:e_commerce_app/features/Api/response/ProductDM.dart';
import 'package:injectable/injectable.dart';
import '../repo/homeRepo.dart';

@injectable
class GetAllProductsUseCase {
  HomeRepo repo;

  GetAllProductsUseCase(this.repo);

  Future<Either<Failure, List<ProductDM>>> execute() async {
    print('Executing getProducts');
    return await repo.getProducts();
  }
}