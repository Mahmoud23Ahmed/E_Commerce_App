import 'package:dartz/dartz.dart';
import 'package:e_commerce_app/core/Constants/failure.dart';
import 'package:e_commerce_app/features/Api/response/categoryDm.dart';
import 'package:injectable/injectable.dart';
import '../repo/homeRepo.dart';

@injectable
class GetAllCategoriesUseCase {
  HomeRepo repo;

  GetAllCategoriesUseCase(this.repo);

  Future<Either<Failure, List<categoryDM>>> execute() async {
    print('Executing getCategories');
    return await repo.getCategories();
  }
}


