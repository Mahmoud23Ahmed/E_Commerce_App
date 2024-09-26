import 'package:e_commerce_app/features/auth/presentation/pages/sign_up_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/app_theme.dart';
import '../../../e_commerce/presentation/pages/controller_page.dart';
import '../../data/model/auth_model.dart';
import '../bloc/auth_bloc/authentication_bloc.dart';
import '../bloc/user_data_bloc/user_data_bloc.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var email = TextEditingController();

  var password = TextEditingController();

  GlobalKey<FormState> keyLogin = GlobalKey();
  bool flag = false;

  @override
  void initState() {
    context.read<AuthBloc>().add(CheckIfAuth());
    super.initState();
  }

  String? userId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (BuildContext context, AuthState state) {
          if (state is UserAuthorizedState) {
            context.read<UserBloc>().add(GetUserEvent());
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => const ControllerPage()));
          }
          if (state is UserErrorState) {
            showToast("An error occurred: ${state.error}");
          }
        },
        builder: (context, state) {
          print(state);
          if (state is UserAuthLoadingState) {
            return const Center(child: CircularProgressIndicator());
          }

          return Center(
            child: Form(
              key: keyLogin,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Center(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: SvgPicture.asset(
                            'assets/images/login.svg',
                            width: 200.0,
                            height: 200.0,
                          ),
                        ),
                        const Text(
                          'Login',
                          style: TextStyle(
                              fontSize: 40.0,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'MyFont'),
                        ),
                        const SizedBox(
                          height: 40.0,
                        ),
                        TextFormField(
                          controller: email,
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                            labelText: 'Email',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(
                              Icons.email,
                            ),
                          ),
                          validator: (text) {
                            if (text!.isEmpty) {
                              return 'field can not be null';
                            }
                            if (text.length < 6 ||
                                !text.contains('@') ||
                                !text.endsWith('.com') ||
                                text.startsWith('@')) {
                              return 'Wrong data ';
                            } else
                              return null;
                          },
                        ),
                        const SizedBox(
                          height: 15.0,
                        ),
                        TextFormField(
                          controller: password,
                          keyboardType: TextInputType.emailAddress,
                          obscureText: !flag,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            border: const OutlineInputBorder(),
                            prefixIcon: const Icon(
                              Icons.lock,
                            ),
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  flag = !flag;
                                });
                              },
                              icon: Icon(
                                flag ? Icons.visibility : Icons.visibility_off,
                              ),
                            ),
                          ),
                          validator: (text) {
                            if (text!.isEmpty) {
                              return 'field can not be null';
                            }
                            if (text.length < 8) {
                              return 'password must be strong';
                            } else {
                              return null;
                            }
                          },
                        ),
                        const SizedBox(
                          height: 35.0,
                        ),
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            gradient: LinearGradient(
                              colors: [primaryColor, secondaryColor],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: MaterialButton(
                            onPressed: () {
                              if (keyLogin.currentState!.validate()) {
                                AuthModel userModel = AuthModel(
                                    password: password.text, email: email.text);
                                context
                                    .read<AuthBloc>()
                                    .add(SignIn(userModel: userModel));
                              }
                            },
                            child: const Text(
                              'Login',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 24),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
                        Center(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  'Don\'t have an account?',
                                  style: TextStyle(
                                      fontSize: 18, fontFamily: 'MyFont'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) => SignUpPage()));
                                  },
                                  child: Text('Register now ',
                                      style: TextStyle(
                                          fontSize: 18,
                                          color: primaryColor,
                                          fontFamily: 'MyFont')),
                                )
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

void showToast(String message) {
  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.CENTER,
    timeInSecForIosWeb: 1,
    backgroundColor: Colors.red,
    textColor: Colors.white,
    fontSize: 16.0,
  );
}
