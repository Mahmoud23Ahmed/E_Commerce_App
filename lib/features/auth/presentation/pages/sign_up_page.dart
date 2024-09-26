import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../../../core/app_theme.dart';
import '../../../e_commerce/presentation/pages/controller_page.dart';
import '../../data/model/auth_model.dart';
import '../../data/model/user_model.dart';
import '../bloc/auth_bloc/authentication_bloc.dart';
import 'login_page.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  var email = TextEditingController();

  var name = TextEditingController();

  var password = TextEditingController();

  var GlobalKeyForm = GlobalKey<FormState>();

  String? userId;

  bool flag = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is UserErrorState) {
            showToast(state.error);
          }
          if (state is UserAuthorizedState) {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (_) => ControllerPage()));
          }
        },
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: GlobalKeyForm,
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
                        'Sign up',
                        style: TextStyle(
                            fontSize: 40.0,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'MyFont'),
                      ),
                      const SizedBox(
                        height: 40.0,
                      ),
                      TextFormField(
                        controller: name,
                        decoration: const InputDecoration(
                          hintText: 'Name',
                          border: OutlineInputBorder(),
                          prefixIcon: const Icon(
                            Icons.person,
                          ),
                        ),
                        validator: (text) {
                          if (text!.isEmpty) {
                            return 'field can not be null';
                          } else {
                            return null;
                          }
                        },
                      ),
                      const SizedBox(
                        height: 15.0,
                      ),
                      TextFormField(
                        controller: email,
                        decoration: const InputDecoration(
                          hintText: 'Email',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(
                            Icons.email,
                          ),
                        ),
                        validator: (text) {
                          if (text == null || text.isEmpty) {
                            return 'Email field cannot be empty';
                          }
                          // Regular expression for validating an email
                          final emailRegex = RegExp(
                              r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
                          if (!emailRegex.hasMatch(text)) {
                            return 'Please enter a valid email address';
                          }
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
                            if (GlobalKeyForm.currentState!.validate()) {
                              String sanitizedEmail = email.text.trim();
                              String sanitizedName = name.text.trim();
                              String sanitizedPassword = password.text.trim();

                              AuthModel authModel = AuthModel(
                                password: sanitizedPassword,
                                email: sanitizedEmail,
                              );

                              UserModel userModel = UserModel(
                                  name: sanitizedName,
                                  userId: '',
                                  email: sanitizedEmail);

                              context.read<AuthBloc>().add(SignUp(
                                  authModel: authModel, userModel: userModel));
                            }
                          },
                          child: const Text(
                            'Sign up',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontFamily: 'MyFont',
                            ),
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
                                'Already have an account ? ',
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) => const LoginPage()));
                                },
                                child: Text('Login now ',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: primaryColor,
                                    )),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
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
