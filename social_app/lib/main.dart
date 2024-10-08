import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:social_app/firebase_options.dart';
import 'package:social_app/model/user_model_.dart';
import 'package:social_app/provider/auth/auth.dart';
import 'package:social_app/provider/chat_provider.dart';
import 'package:social_app/provider/post_provider.dart';
import 'package:social_app/utils/shared-preferences/shared_preferences.dart';
import 'package:social_app/view_model/login_viewmodel.dart';
import 'package:social_app/view_model/sign_up_viewmodel.dart';
import 'package:social_app/view_model/user_viewmodel.dart';
import 'package:social_app/views/screens/Home/home.dart';
import 'package:social_app/views/screens/auth/login/login_screen.dart';
import 'package:social_app/views/screens/edit_profile_screen/pic_widget.dart';
import 'package:social_app/views/screens/on_boarding_screen/onboarding.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppSharedPreferences.initSharedPreferences();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  bool isShowBoarding =
      AppSharedPreferences.getValue(value: 'isShowenOnboarding') ?? false;
  bool islogin = AppSharedPreferences.getValue(value: 'islogin') ?? false;
  String uid = AppSharedPreferences.getValueString(value: 'uid') ?? "";
  AuthController.mainUser.userUID = uid;
  UserViewModel.userModel = jsonDecode(AppSharedPreferences.getValueString(value: 'userData') ?? "") as UserModel?; 
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => AuthController()),
      ChangeNotifierProvider(create: (_) => PostController()),
      ChangeNotifierProvider(create: (_) => ChatServises()),
      ChangeNotifierProvider(create: (_) => MenuCotroller()),
      ChangeNotifierProvider(create: (_) => LoginPasswordHide()),
      ChangeNotifierProvider(create: (_) => PicWidget()),
      ChangeNotifierProvider(create: (_) => PasswordHideShow()),
    ],
    child: MyApp(isShowBording: isShowBoarding, islogin: islogin),
  ));
}

class MyApp extends StatelessWidget {
  final bool isShowBording;
  final bool islogin;
  const MyApp({super.key, required this.isShowBording, required this.islogin});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      child: MaterialApp(
        theme: ThemeData(
          fontFamily: 'Poppins',
        ),
        debugShowCheckedModeBanner: false,
        home: isShowBording
            ? islogin
                ? const HomeScreen()
                : const LoginScreen()
            : const OnBoardignScreen(),
      ),
    );
  }
}
