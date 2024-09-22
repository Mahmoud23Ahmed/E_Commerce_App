import 'package:dartz/dartz.dart';
import 'package:e_commerce_app/core/Constants/failure.dart';
import 'package:e_commerce_app/features/Api/response/ProductDM.dart';
import 'package:e_commerce_app/features/Api/response/categoryDm.dart';

abstract class HomeDs{

  Future<Either<Failure, List<categoryDM>>> getCategories();

  Future<Either<Failure,List<ProductDM>>> getProducts();

}