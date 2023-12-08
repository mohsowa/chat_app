import 'package:chat_app/features/auth/auth_di.dart' as di;
import 'package:chat_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _usernameController = TextEditingController();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  final authCubit = di.sl.get<AuthCubit>();

  void _signUp() {
    final username = _usernameController.text;
    final fullName = _fullNameController.text;
    final email = _emailController.text;
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    if(password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Passwords do not match'),
        ),
      );
      return;
    }

    authCubit.signup(fullName, email, username, password);
  }


  // Add any additional controllers or validation logic as needed
  final InputDecoration textFieldDecoration = InputDecoration(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(
        color: Color.fromRGBO(64, 194, 210, 1),
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(
        color: Color.fromRGBO(64, 194, 210, 1),
      ),
    ),
    contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
  );


  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      bloc: authCubit,
      builder: (context, state) {
        // states handler
        if (state is AuthLoading) {
          // Show the loading widget on top of your main widget.
          return Stack(
            children: [
              _registerWidget(context), // Your main content widget
              Positioned.fill(
                child: Center(
                  child: _registerWidget(context),
                ),
              ),
            ],
          );
        }

        if (state is AuthError) {
          SchedulerBinding.instance.addPostFrameCallback((_) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
              ),
            );
          });
        }


        if (state is AuthLoaded) {
          SchedulerBinding.instance.addPostFrameCallback((_) {
            Navigator.of(context).pushNamedAndRemoveUntil(
                '/home', (Route<dynamic> route) => false);
          });
        }

        return _registerWidget(context);
      },
    );
  }



  Scaffold _registerWidget(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
          child: Material(
            child: SingleChildScrollView(
              child: Column(
                  children: [
                    const SizedBox(height: 20),
                    Image.asset(
                      'assets/images/signup_image.png',
                      height: 120,
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Sign Up',
                      style: TextStyle(
                        fontSize: 18,
                        color: Color.fromRGBO(10, 44, 64, 1),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Create an account to continue!',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color.fromRGBO(10, 44, 64, 1),
                        fontWeight: FontWeight.w300,
                      ),
                    ),
              // Sign Up Form
              Container(
              padding: const EdgeInsets.fromLTRB(0, 50, 0, 0),
              child: Column(

                children: <Widget>[

                  //user name
                  TextFormField(
                    controller: _fullNameController,
                    keyboardType: TextInputType.name,
                    decoration: textFieldDecoration.copyWith(
                      prefixIcon: const Icon(Icons.person_rounded,
                          color: Color.fromRGBO(64, 194, 210, 1)),
                      hintText: 'Full Name',
                    ),
                    style: const TextStyle(
                      fontSize: 16,
                      color: Color.fromRGBO(10, 44, 64, 1),
                      fontWeight: FontWeight.w300,
                      decoration: TextDecoration.none,
                    ),
                    // Add validation logic
                  ),
                  const SizedBox(height: 10),
                  //user name
                  TextFormField(
                    controller: _usernameController,
                    keyboardType: TextInputType.name,
                    decoration: textFieldDecoration.copyWith(
                      prefixIcon: const Icon(Icons.alternate_email,
                          color: Color.fromRGBO(64, 194, 210, 1)),
                      hintText: 'UserName',
                    ),
                    style: const TextStyle(
                      fontSize: 16,
                      color: Color.fromRGBO(10, 44, 64, 1),
                      fontWeight: FontWeight.w300,
                      decoration: TextDecoration.none,
                    ),
                    // Add validation logic
                  ),
                  const SizedBox(height: 10),

                  // Email Input
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: textFieldDecoration.copyWith(
                      prefixIcon: const Icon(Icons.email,
                          color: Color.fromRGBO(64, 194, 210, 1)),
                      hintText: 'Email',
                    ),
                    style: const TextStyle(
                      fontSize: 16,
                      color: Color.fromRGBO(10, 44, 64, 1),
                      fontWeight: FontWeight.w300,
                      decoration: TextDecoration.none,
                    ),
                    // Add validation logic
                  ),
                  const SizedBox(height: 10),

                  // Password Input
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: textFieldDecoration.copyWith(
                      prefixIcon: const Icon(Icons.lock,
                          color: Color.fromRGBO(64, 194, 210, 1)),
                      hintText: 'Password',
                    ),
                    style: const TextStyle(
                      fontSize: 16,
                      color: Color.fromRGBO(10, 44, 64, 1),
                      fontWeight: FontWeight.w300,
                      decoration: TextDecoration.none,
                    ),
                    // Add validation logic
                  ),
                  const SizedBox(height: 10),

                  // Confirm Password Input
                  TextFormField(
                    controller: _confirmPasswordController,
                    obscureText: true,
                    decoration: textFieldDecoration.copyWith(
                      prefixIcon: const Icon(Icons.lock,
                          color: Color.fromRGBO(64, 194, 210, 1)),
                      hintText: 'Confirm Password',
                    ),
                    style: const TextStyle(
                      fontSize: 16,
                      color: Color.fromRGBO(10, 44, 64, 1),
                      fontWeight: FontWeight.w300,
                      decoration: TextDecoration.none,
                    ),
                    // Add validation logic
                  ),
                  const SizedBox(height: 20),

                  // Sign Up Button
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                      backgroundColor:
                      const Color.fromRGBO(64, 194, 210, 1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      _signUp();
                    },
                    child: const Text('Sign up',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        )),
                  ),
                ],
              ),
              ),

                    // Already have an account? Login
                    const SizedBox(height: 20),
                    Container(
                      alignment: Alignment.bottomCenter,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Already have an account? ',
                            style: TextStyle(
                              color: Color.fromRGBO(10, 44, 64, 1),
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushReplacementNamed(context, '/login');
                            },
                            child: const Text(
                              'Login',
                              style: TextStyle(
                                color: Color.fromRGBO(64, 194, 210, 1),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
            ),
          ),
        ),
      ),
    ),
    );
  }
}

