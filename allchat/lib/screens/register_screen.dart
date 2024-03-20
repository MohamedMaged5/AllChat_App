// ignore_for_file: unused_local_variable, use_build_context_synchronously

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:robochat/cubits/loadingCubit/loading_cubit.dart';
import 'package:robochat/global/global.dart';
import 'package:robochat/helpers/snackbar.dart';
import 'package:robochat/screens/login_screen.dart';
import 'package:robochat/widgets/account_sentence.dart';
import 'package:robochat/widgets/custom_button.dart';
import 'package:robochat/widgets/custom_textformfield.dart';
import 'package:robochat/widgets/topcontainer.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  String? emailRegister;
  String? confirmPassword;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: AlignmentDirectional.bottomEnd,
        children: [
          const TopContainer(),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 15.w),
            width: 1.sw,
            height: (6 / 9).sh,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(50).r,
                  topRight: const Radius.circular(50).r,
                ),
                color: Colors.white),
            child: Form(
              key: formKey,
              child: ListView(
                children: [
                  SizedBox(
                    height: 10.h,
                  ),
                  Center(
                    child: Text(
                      "Register",
                      style: GoogleFonts.nunito(
                        fontSize: 35.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 25.h,
                  ),
                  CustomTextFormField(
                    fillColor: Colors.grey[350],
                    controller: emailController,
                    validator: (data) {
                      return validateEmail(data);
                    },
                    onChanged: (input) {
                      emailRegister = input;
                    },
                    hintText: "Email",
                    prefixIcon: const Icon(
                      Icons.email,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(
                    height: 15.h,
                  ),
                  CustomTextFormField(
                    fillColor: Colors.grey[350],
                    controller: passwordController,
                    validator: (data) {
                      return validatePassword(data);
                    },
                    hintText: "Password",
                    prefixIcon: const Icon(
                      Icons.lock,
                      color: Colors.black,
                    ),
                    obscureText: true,
                  ),
                  SizedBox(
                    height: 15.h,
                  ),
                  CustomTextFormField(
                    fillColor: Colors.grey[350],
                    controller: confirmPasswordController,
                    validator: (data) {
                      return validateConfirmPassword(data);
                    },
                    onChanged: (input) {
                      confirmPassword = input;
                    },
                    hintText: "Confirm Password",
                    prefixIcon: const Icon(
                      Icons.lock,
                      color: Colors.black,
                    ),
                    obscureText: true,
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                  AccountSentence(
                    haveaccount: "Already have an account?",
                    action: "Login",
                    onTap: () {
                      Navigator.pushReplacement(context, MaterialPageRoute(
                        builder: (context) {
                          return const LoginScreen();
                        },
                      ));
                    },
                  ),
                  SizedBox(
                    height: 40.h,
                  ),
                  CustomButton(
                    text: "Register",
                    onPressed: () async {
                      await registerOnPressed(context);
                    },
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Future<void> registerOnPressed(BuildContext context) async {
    final connectivity = await (Connectivity().checkConnectivity());
    if (connectivity == ConnectivityResult.mobile ||
        connectivity == ConnectivityResult.wifi ||
        connectivity == ConnectivityResult.ethernet) {
      if (formKey.currentState!.validate()) {
        isloading = !isloading;
        context.read<LoadingCubit>().loading();
        try {
          await userRegister();
          Navigator.pushReplacement(context, MaterialPageRoute(
            builder: (context) {
              return const LoginScreen();
            },
          ));
          snackBar(context,
              "Account Created Successfully! Please Login to Continue.");
        } on FirebaseAuthException catch (e) {
          if (e.code == 'weak-password') {
            snackBar(context, 'The password provided is too weak.');
          } else if (e.code == 'email-already-in-use') {
            snackBar(context, "The account already exists for that email.");
          } else if (e.code == 'invalid-email') {
            snackBar(context, "The email is badly formatted.");
          }
        } catch (e) {
          snackBar(context, "Something went wrong");
        }
        isloading = !isloading;
        context.read<LoadingCubit>().loading();
      } else {}
    } else {
      snackBar(context, "Check Your Network Connection!");
    }
  }

  String? validateEmail(String? data) {
    if (data!.isEmpty) {
      return "Email is required";
    } else if (!data.contains("@")) {
      return "must contain @";
    } else if (!data.contains(".")) {
      return "must contain .";
    } else if (data.contains(" ")) {
      return "Email can't contain spaces";
    }
    return null;
  }

  String? validatePassword(String? data) {
    if (data!.isEmpty) {
      return "Password is required";
    } else if (data.length < 6) {
      return "Password must be at least 6 characters";
    } else if (data.contains(" ")) {
      return "Password can't contain spaces";
    }
    return null;
  }

  String? validateConfirmPassword(String? data) {
    if (data!.isEmpty) {
      return "Confirm Password is required";
    } else if (data != passwordController.text) {
      return "Confirm Password does not match Password";
    }
    return null;
  }

  Future<void> userRegister() async {
    UserCredential user = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(
            email: emailRegister!, password: confirmPassword!);
  }
}
