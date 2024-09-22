import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_app/core/networks/network_info.dart';
import 'package:e_commerce_app/features/auth/data/datasorce/authentication_remote_ds/authentication.dart';
import 'package:e_commerce_app/features/auth/data/model/user_model.dart';
import 'package:e_commerce_app/features/auth/presentation/bloc/auth_bloc/authentication_bloc.dart';
import 'package:e_commerce_app/features/auth/presentation/pages/login_page.dart';
import 'package:e_commerce_app/features/e_commerce/presentation/pages/reset_password_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:e_commerce_app/core/app_theme.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ContactPage extends StatefulWidget {
  const ContactPage({super.key});

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  bool editable = false;
  Icon editIcon = const Icon(Icons.edit);
  String editToolTip = "Edit Info";

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final globalKeyForm = GlobalKey<FormState>();

    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            "Contact Information",
            style: appTheme.textTheme.displayLarge,
          ),
        ),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'Logout') {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Logout'),
                      content: const Text('Are you sure you want to log out?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () async {
                            Navigator.pop(context);
                            await AuthenticationRemoteDsImpl(
                                    networkInfo: NetworkInfoImpl(
                                        connectionChecker:
                                            InternetConnectionChecker()))
                                .signOut();
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const LoginPage()),
                            );
                          },
                          child: const Text('Logout'),
                        ),
                      ],
                    );
                  },
                );
              } else if (value == 'Reset Password') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ResetPasswordPage()),
                );
              }
            },
            itemBuilder: (BuildContext context) {
              return {'Reset Password', 'Logout'}.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          future: FirebaseFirestore.instance
              .collection('users')
              .doc(user!.uid)
              .get(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (!snapshot.hasData || !snapshot.data!.exists) {
              return const Text("No User Data Found");
            }
            final userModel = UserModel.fromDocumentSnapshot(snapshot.data!);
            final nameController = TextEditingController(text: userModel.name);
            final emailController =
                TextEditingController(text: userModel.email);
            final phoneController =
                TextEditingController(text: userModel.phone);
            final addressController =
                TextEditingController(text: userModel.address);
            final ageController =
                TextEditingController(text: userModel.age?.toString());

            return SingleChildScrollView(
              child: Container(
                width: MediaQuery.of(context).size.width, // Responsive width
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text("Welcome,\n ${userModel.name}",
                            style: const TextStyle(
                                fontSize: 22, fontWeight: FontWeight.bold)),
                        const Spacer(),
                        IconButton(
                          icon: editIcon,
                          onPressed: () {
                            setState(() {
                              editable = !editable;
                              editIcon = editable
                                  ? const Icon(Icons.cancel_outlined)
                                  : const Icon(Icons.edit);
                              editToolTip = editable ? "Cancel" : "Edit Info";
                            });
                          },
                          tooltip: editToolTip,
                        ),
                      ],
                    ),
                    const SizedBox(height: 25.0),
                    Center(
                      child: Lottie.asset(
                          'assets/images/Animation - 1725374754294.json',
                          width: 200,
                          height: 200,
                          fit: BoxFit.fill),
                    ),
                    Form(
                      key: globalKeyForm,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          buildTextField(nameController, "Full Name",
                              enabled: editable),
                          const SizedBox(height: 25.0),
                          buildTextField(emailController, "Email",
                              enabled: false),
                          const SizedBox(height: 25.0),
                          Row(
                            children: [
                              Expanded(
                                flex: 3,
                                child: buildTextField(ageController, "Age",
                                    enabled: editable,
                                    keyboardType: TextInputType.number),
                              ),
                              const SizedBox(width: 10.0),
                              Expanded(
                                flex: 7,
                                child: buildTextField(
                                    phoneController, "Phone Number",
                                    enabled: editable,
                                    keyboardType: TextInputType.phone,
                                    validator: (text) {
                                  if (text!.isNotEmpty && text.length != 11) {
                                    return 'Phone number must be 11 digits';
                                  }
                                  return null;
                                }),
                              ),
                            ],
                          ),
                          const SizedBox(height: 25.0),
                          buildTextField(addressController, "Address",
                              enabled: editable),
                          const SizedBox(height: 25.0),
                          Visibility(
                            visible: editable,
                            child: Column(
                              children: [
                                Center(
                                  child: Container(
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
                                      onPressed: () async {
                                        if (globalKeyForm.currentState!
                                            .validate()) {
                                          UserModel updatedUser =
                                              userModel.copyWith(
                                            name: nameController.text,
                                            phone:
                                                phoneController.text.isNotEmpty
                                                    ? phoneController.text
                                                    : null,
                                            address: addressController
                                                    .text.isNotEmpty
                                                ? addressController.text
                                                : null,
                                            age: ageController.text.isNotEmpty
                                                ? int.parse(ageController.text)
                                                : null,
                                          );

                                          // Update user data in Firestore
                                          await FirebaseFirestore.instance
                                              .collection('users')
                                              .doc(updatedUser.userId)
                                              .update(updatedUser.toMap());

                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                  'Changes Saved Successfully'),
                                              duration: Duration(seconds: 2),
                                            ),
                                          );

                                          setState(() {
                                            editable = false;
                                            editIcon = const Icon(Icons.edit);
                                            editToolTip = "Edit Info";
                                          });
                                        }
                                      },
                                      child: const Text(
                                        'Save',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 24),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 25),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

Widget buildTextField(TextEditingController controller, String label,
    {bool enabled = true,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
    Widget? suffixIcon}) {
  return TextFormField(
    controller: controller,
    enabled: enabled,
    obscureText: obscureText,
    keyboardType: keyboardType,
    decoration: InputDecoration(
      suffixIcon: suffixIcon,
      label: Text(label, style: appTheme.textTheme.bodyMedium),
      floatingLabelStyle: TextStyle(color: primaryColor),
      iconColor: secondaryColor,
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: secondaryColor),
        borderRadius: BorderRadius.circular(8),
      ),
      border: OutlineInputBorder(
        borderSide: BorderSide(color: primaryColor),
        borderRadius: BorderRadius.circular(8),
      ),
    ),
    validator: validator,
  );
}
