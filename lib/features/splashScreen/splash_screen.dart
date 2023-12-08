import 'package:chat_app/features/auth/auth_di.dart' as di;
import 'package:chat_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/config/themes/app_style.dart';

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
    final authCubit = di.sl.get<AuthCubit>();
    await authCubit.checkCachedUser();
    if (authCubit.state is AuthLoaded) {
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      Navigator.pushReplacementNamed(context, '/login');
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
      color: Theme.of(context).primaryColor,

      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.chat, size: 100, color: themeBlue,),
          const SizedBox(height: 20,),
          CircularProgressIndicator(
            valueColor: _controller.drive(ColorTween(
              begin: themeBlue,
              end: themePink,
            )),
            backgroundColor: themePink,
          ),
        ],
      ),
    );
  }
}