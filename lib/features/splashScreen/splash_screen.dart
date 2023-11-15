import 'package:chat_app/features/auth/auth_di.dart' as di;
import 'package:chat_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:flutter/material.dart';


class SplashScreen extends StatefulWidget {
  String? nextRoute = 'auth';
  String? message = 'Loading...';

  SplashScreen({super.key, this.nextRoute, this.message});

  @override
  _SplashScreenState createState() => _SplashScreenState();


}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {

  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..addListener(() { });

    _controller.repeat(reverse: true);

    _loadAppDependencies();
  }


  Future<void> _loadAppDependencies() async {
    await _checkAuth();
  }


  Future<void> _checkAuth() async {
    await di.AuthInit();
    final authCubit = di.sl<AuthCubit>();
    await authCubit.checkCachedUser();
    if (authCubit.state is AuthLoaded) {
      print('Authed');
      Navigator.of(context).pushNamedAndRemoveUntil('/home', (Route<dynamic> route) => false);
    } else {
      print('Not Authed');
      Navigator.of(context).pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);
    }
  }


@override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),

    );
  }
}