import 'package:chat_app/features/auth/presentation/pages/login.dart';
import 'package:chat_app/features/home/presentation/pages/home.dart';
import 'package:chat_app/features/splashScreen/splash_screen.dart';
import 'package:flutter/material.dart';

import '../../features/auth/presentation/pages/signup.dart';


Map<String, Widget Function(BuildContext)> routes = {
  '/': (context) => SplashScreen(),
  '/home': (context) =>  HomePage(),
  '/login': (context) =>  LoginPage(),
  '/Register': (context) =>  SignUpPage(),
};
