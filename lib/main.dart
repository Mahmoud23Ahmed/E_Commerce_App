import 'package:e_commerce_app/core/networks/network_info.dart';
import 'package:e_commerce_app/features/auth/presentation/pages/login_page.dart';
import 'package:e_commerce_app/features/auth/presentation/pages/splash_page.dart';
import 'package:e_commerce_app/features/e_commerce/presentation/pages/home_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'features/auth/data/datasorce/authentication_remote_ds/authentication.dart';
import 'features/auth/data/datasorce/user_remote_ds/user_remote_ds.dart';
import 'features/auth/presentation/bloc/auth_bloc/authentication_bloc.dart';
import 'features/auth/presentation/bloc/user_data_bloc/user_data_bloc.dart';
import 'firebase_options.dart';
import 'package:e_commerce_app/features/Api/domain/getIt.dart';

void main() async {
  await setLocator();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await AuthenticationRemoteDsImpl(
          networkInfo:
              NetworkInfoImpl(connectionChecker: InternetConnectionChecker()))
      .signOut();
  // await AuthenticationImp().signIn("nada@gmail.com", "123456789");
  runApp(MultiBlocProvider(
    providers: [
      BlocProvider(
          create: (_) => AuthBloc(
              usersDBModel: UsersRemoteDsImp(),
              authenticationRemoteDs: AuthenticationRemoteDsImpl(
                  networkInfo: NetworkInfoImpl(
                      connectionChecker: InternetConnectionChecker())),
              networkInfo: NetworkInfoImpl(
                  connectionChecker: InternetConnectionChecker()))),
      BlocProvider(
          create: (_) => UserBloc(
              usersDBModel: UsersRemoteDsImp(),
              authinticationRemoteDs: AuthenticationRemoteDsImpl(
                  networkInfo: NetworkInfoImpl(
                      connectionChecker: InternetConnectionChecker())))),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        debugShowCheckedModeBanner: false,
        home: const SplashScreen());
  }
}
