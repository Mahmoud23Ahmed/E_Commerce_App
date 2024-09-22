import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dartz/dartz.dart';
import 'package:e_commerce_app/core/Constants/failure.dart';
import 'package:e_commerce_app/features/Api/domain/repo/data_souces/homeDs.dart';
import 'package:e_commerce_app/features/Api/domain/repo/homeRepo.dart';
import 'package:e_commerce_app/features/Api/response/ProductDM.dart';
import 'package:e_commerce_app/features/Api/response/categoryDm.dart';
import 'package:injectable/injectable.dart';


@Injectable(as: HomeRepo)
class HomeRepoImpl extends HomeRepo {
  final Connectivity connectivity;
  final HomeDs ds;
  HomeRepoImpl(this.connectivity, this.ds);

  @override
  Future<Either<Failure, List<categoryDM>>> getCategories() async {
    print('Fetching categories from repository');
    return ds.getCategories();  // Directly return since it's already a Future<Either>

  }

  @override
  Future<Either<Failure, List<ProductDM>>> getProducts() async {
    print('Fetching products from repository');
    return ds.getProducts();

  }
}