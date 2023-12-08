import 'dart:io';
import 'package:chat_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:chat_app/features/auth/auth_di.dart' as auth_di;
import './services/http_client.dart';
import 'config/router/app_router.dart' as router;
import 'config/themes/app_style.dart';
import 'config/themes/sh_preferences.dart';
import 'features/home/presentation/cubits/themecubit.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  HttpOverrides.global = MyHttpOverrides();

  // Create an instance of ThemeCubit
  final themeCubit = ThemeCubit();

  // Load the saved theme mode and update ThemeCubit
  // Load the saved theme mode and update ThemeCubit
  bool savedThemeMode = await ThemePreferences().isDarkMode();
  themeCubit.emit(savedThemeMode);

  print("Saved Theme Mode: $savedThemeMode");
  await themeCubit.init(); // Ensure this is called before runApp()

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => auth_di.sl<AuthCubit>()),
        BlocProvider(create: (context) => themeCubit),
      ],
      child: const MyApp(),
    ),
  );
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, bool>(
      builder: (context, themeState) {
        return MaterialApp(
          navigatorKey: navigatorKey,
          title: 'Chat App',
          debugShowCheckedModeBanner: false,
          initialRoute: '/',
          routes: router.routes,
          theme: themeState ? AppThemes.darkTheme : AppThemes.lightTheme,
          builder: (context, child) {
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(textScaler: const TextScaler.linear(1.0)),
              child: child!,
            );
          },
        );
      },
    );
  }
}
