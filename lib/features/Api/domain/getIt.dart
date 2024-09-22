import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:e_commerce_app/features/Api/domain/HomeViewModel.dart';
import 'package:e_commerce_app/features/Api/domain/product_view_model.dart';
import 'package:e_commerce_app/features/Api/domain/repo/data_souces/homeDs.dart';
import 'package:e_commerce_app/features/Api/domain/repo/homeRepo.dart';
import 'package:e_commerce_app/features/Api/domain/use%20Cases/GetAllCategories_UseCase.dart';
import 'package:e_commerce_app/features/Api/domain/use%20Cases/GetAllProducts_UseCase.dart';
import 'package:e_commerce_app/features/Api/homeRepo/data_souces_impl/dataSourcesImplDs.dart';
import 'package:e_commerce_app/features/Api/homeRepo/homeRepo_impl.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart';

final GetIt locator=GetIt.instance;

Future<void> setLocator() async {
  locator.registerLazySingleton<Connectivity>(() => Connectivity()); // assuming Connectivity has a default constructor
  locator.registerLazySingleton<Client>(() => Client()); // register the http client
  locator.registerLazySingleton<HomeDs>(() => DataSourcesImpl()); // register DataSourcesImpl
  locator.registerLazySingleton<HomeRepo>(() => HomeRepoImpl(locator<Connectivity>(), locator<HomeDs>()));
  locator.registerLazySingleton<GetAllCategoriesUseCase>(() => GetAllCategoriesUseCase(locator<HomeRepo>()));
  locator.registerLazySingleton<GetAllProductsUseCase>(() => GetAllProductsUseCase(locator<HomeRepo>()));
  locator.registerLazySingleton<HomeViewModel>(() => HomeViewModel(locator<GetAllCategoriesUseCase>(), locator<GetAllProductsUseCase>()));
  locator.registerLazySingleton<ProductViewModel>(() => ProductViewModel(locator<GetAllProductsUseCase>()));
}