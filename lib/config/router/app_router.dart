import 'package:chat_app/features/auth/presentation/pages/login.dart';
import 'package:chat_app/features/home/presentation/pages/home.dart';
import 'package:chat_app/features/profile/presentation/pages/profile.dart';
import 'package:chat_app/features/splashScreen/splash_screen.dart';
import 'package:flutter/material.dart';

import '../../features/auth/presentation/pages/signup.dart';


Map<String, Widget Function(BuildContext)> routes = {
  '/': (context) => SplashScreen(),
  '/home': (context) =>  const HomePage(),
  '/login': (context) =>  const LoginPage(),
  '/Register': (context) =>  const SignUpPage(),
  '/profile': (context) =>  const ProfilePage(),
};
