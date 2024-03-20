import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:robochat/constants.dart';
import 'package:robochat/cubits/loadingCubit/loading_cubit.dart';
import 'package:robochat/cubits/networkConnectivity/network_connectivity_cubit.dart';
import 'package:robochat/firebase_options.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:robochat/screens/chat_screen.dart';
import 'package:robochat/screens/login_screen.dart';
import 'package:robochat/screens/splash_screen.dart';

void main() async {
  await dotenv.load(fileName: "lib/keys.env");
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const AllChat());
}

class AllChat extends StatelessWidget {
  const AllChat({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LoadingCubit>(
          create: (context) => LoadingCubit(),
        ),
        BlocProvider<NetworkConnectivityCubit>(
          create: (context) => NetworkConnectivityCubit(),
        )
      ],
      child: ScreenUtilInit(
        designSize: const Size(392.7, 781.1),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return MaterialApp(
            routes: {
              LoginScreen.id: (context) => const LoginScreen(),
              ChatScreen.id: (context) => const ChatScreen(),
            },
            theme: ThemeData(
                textSelectionTheme: const TextSelectionThemeData(
              cursorColor: Colors.black,
              selectionColor: kPrimaryColor,
              selectionHandleColor: kPrimaryColor,
            )),
            debugShowCheckedModeBanner: false,
            home: const SplashScreen(),
          );
        },
      ),
    );
  }
}
