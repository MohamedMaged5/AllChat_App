// ignore_for_file: use_build_context_synchronously, unused_local_variable

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:robochat/cubits/loadingCubit/loading_cubit.dart';
import 'package:robochat/global/global.dart';
import 'package:robochat/helpers/snackbar.dart';
import 'package:robochat/helpers/updateloginstatus.dart';
import 'package:robochat/screens/chat_screen.dart';
import 'package:robochat/screens/register_screen.dart';
import 'package:robochat/widgets/account_sentence.dart';
import 'package:robochat/widgets/custom_button.dart';
import 'package:robochat/widgets/custom_textformfield.dart';
import 'package:robochat/widgets/topcontainer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  static String id = 'loginScreen';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String? password;
  GlobalKey<FormState> formKey = GlobalKey();
  bool isLoggedIn = false;
  @override
  void initState() {
    checkLoginStatus();
    super.initState();
  }

  Future<void> checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getBool("isLoggedIn") == true) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
        return ChatScreen(
          email: prefs.getString("email")!,
        );
      }));
    }
  }

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
                      "Login",
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
                    validator: (data) {
                      return validateEmail(data);
                    },
                    onChanged: (input) {
                      emailLogin = input;
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
                    validator: (data) {
                      return validatePassword(data);
                    },
                    onChanged: (input) {
                      password = input;
                    },
                    hintText: "Password",
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
                    haveaccount: "Don't have an account?",
                    action: "Register",
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return const RegisterScreen();
                          },
                        ),
                      );
                    },
                  ),
                  SizedBox(
                    height: 40.h,
                  ),
                  CustomButton(
                    text: "Login",
                    onPressed: () async {
                      await loginOnPressed(context);
                    },
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Future<void> loginOnPressed(BuildContext context) async {
    final networkConnection = await (Connectivity().checkConnectivity());
    if (networkConnection == ConnectivityResult.mobile ||
        networkConnection == ConnectivityResult.wifi ||
        networkConnection == ConnectivityResult.ethernet) {
      if (formKey.currentState!.validate()) {
        isloading = !isloading;
        context.read<LoadingCubit>().loading();
        try {
          await userLogin();
          Navigator.pushReplacement(context, MaterialPageRoute(
            builder: (context) {
              return ChatScreen(
                email: emailLogin!,
              );
            },
          ));
          updateLoginStatus(true);
        } on FirebaseAuthException catch (e) {
          if (e.code == 'user-not-found') {
            snackBar(context, 'No user found for that email.');
          } else if (e.code == 'wrong-password') {
            snackBar(context, 'Wrong password provided for that user.');
          } else if (e.code == 'invalid-email') {
            snackBar(context, "The email is badly formatted.");
          } else if (e.code == 'user-disabled') {
            snackBar(context, "The account has been banned.");
          }
        } catch (e) {
          snackBar(context, "error");
        }
        isloading = !isloading;
        context.read<LoadingCubit>().loading();
      } else {}
    } else {
      snackBar(context, "Check Your Network Connection!");
    }
  }

  String? validatePassword(String? data) {
    if (data!.isEmpty) {
      return "Password is required";
    } else if (data.contains(" ")) {
      return "Password can't contain spaces";
    }
    return null;
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

  Future<void> userLogin() async {
    UserCredential user = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: emailLogin!, password: password!);
  }
}
