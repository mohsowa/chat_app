import 'dart:io';
import 'package:chat_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:chat_app/features/auth/auth_di.dart' as auth_di;
import './services/http_client.dart';
import 'config/router/app_router.dart' as router;

Future<void> main() async {
  // Load .env file
  await dotenv.load(fileName: ".env");

  // Set up http client
  HttpOverrides.global = MyHttpOverrides();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => auth_di.sl<AuthCubit>(),
      child: MaterialApp(
        title: 'Chat App',
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: router.routes,
        builder: (context, child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
            child: child!,
          );
        }
      )
    );
  }
}
