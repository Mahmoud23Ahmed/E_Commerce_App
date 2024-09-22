import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:e_commerce_app/core/Constants/end_points.dart';
import 'package:e_commerce_app/core/Constants/failure.dart';
import 'package:e_commerce_app/core/constant.dart';
import 'package:e_commerce_app/features/Api/domain/repo/data_souces/homeDs.dart';
import 'package:e_commerce_app/features/Api/response/CategoriesResponse.dart';
import 'package:e_commerce_app/features/Api/response/ProductDM.dart';
import 'package:e_commerce_app/features/Api/response/ProductResponse.dart';
import 'package:e_commerce_app/features/Api/response/categoryDm.dart';
import 'package:http/http.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: HomeDs)
class DataSourcesImpl extends HomeDs {
  @override
  Future<Either<Failure, List<categoryDM>>> getCategories() async {
    try {
      print("nada");
      Uri url = Uri.https(Endpoints.baseUrl, Endpoints.categories);
      Response serverResponse = await get(url);
      if (serverResponse.statusCode == 200) {
        var myResponse = CategoriesResponse.fromJson(jsonDecode(serverResponse.body));
        if (myResponse.data?.isNotEmpty == true) {
          return Right(myResponse.data!);
        } else {
          return Left(Failure(myResponse.message ?? Constants.noDataFound));
        }
      } else {
        return Left(Failure(serverResponse.reasonPhrase ?? Constants.serverError));
      }
    } catch (error) {
      print("Exception in getCategories: $error");
      return Left(Failure(Constants.serverError));
    }
  }

  Future<Either<Failure, List<ProductDM>>> getProducts() async {
    try {
      Uri url = Uri.https(Endpoints.baseUrl, Endpoints.products);
      Response serverResponse = await get(url);
      print('Server Response: ${serverResponse.body}');
      if (serverResponse.statusCode == 200) {
        var myResponse = ProductResponse.fromJson(jsonDecode(serverResponse.body));
        if (myResponse.data?.isNotEmpty == true) {
          return Right(myResponse.data!);
        } else {
          return Left(Failure(myResponse.message ?? Constants.noDataFound));
        }
      } else {
        return Left(Failure(serverResponse.reasonPhrase ?? Constants.serverError));
      }
    } catch (error) {
      print("Exception in getProducts: $error");
      return Left(Failure(Constants.serverError));
    }
  }
}