import 'package:chat_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/features/auth/auth_di.dart' as di;
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';




class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  int _selectedIndex = 0; // 0 for Email, 1 for Username, 2 for Phone

  final _emailController = TextEditingController();
  final _emailPasswordController = TextEditingController();
  final _usernameController = TextEditingController();
  final _usernamePasswordController = TextEditingController();

  // map to valid fields in the form
  final Map<String, bool> _validFieldsEmail = {
    'email': false,
    'password': false,
  };

  final Map<String, bool> _validFieldsUsername = {
    'username': false,
    'password': false,
  };

  final cubit = AuthCubit(di.sl.get());
  

  _loginViaEmail() {
    cubit.signInWithEmailAndPassword(
      _emailController.text,
      _emailPasswordController.text,
    );
  }

  _loginViaUsername() {
    cubit.signInWithUsernameAndPassword(
      _usernameController.text,
      _usernamePasswordController.text,
    );
  }


  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      bloc: cubit,
      builder: (context, state) {
        // states handler
        if (state is AuthLoading) {
          // Show the loading widget on top of your main widget.
          return Stack(
            children: [
              _loginWidget(context), // Your main content widget
              Positioned.fill(
                child: Center(
                  child: _loginWidget(context),
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
          cubit.clearAuthState();
        }
        if (state is AuthLoaded) {
          SchedulerBinding.instance.addPostFrameCallback((_) {
            Navigator.of(context).pushNamedAndRemoveUntil(
                '/MainPages', (Route<dynamic> route) => false);
          });
        }

        return _loginWidget(context);
      },
    );
  }

  Scaffold _loginWidget(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
          child: Material(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Logo Part
                  Container(
                    padding: const EdgeInsets.fromLTRB(0, 100, 0, 0),
                    child: Column(
                      children: <Widget>[
                        Image.asset(
                          'assets/images/login_image.png',
                          height: 120,
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Login',
                          style: TextStyle(
                            fontSize: 18,
                            color: Color.fromRGBO(10, 44, 64, 1),
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.none,
                          ),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'We’re happy to see you back again!',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color.fromRGBO(10, 44, 64, 1),
                            decoration: TextDecoration.none,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Login Method Part
                  Container(
                    padding: const EdgeInsets.fromLTRB(0, 50, 0, 0),
                    child: Column(
                      children: <Widget>[
                        // 3 Login Methods Buttons
                        Row(
                          children: [
                            // Email Button
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      color: (_selectedIndex == 0)
                                          ? const Color.fromRGBO(
                                          64, 194, 210, 1)
                                          : Colors.grey,
                                      width: 3,
                                      style: BorderStyle.solid,
                                    ),
                                  ),
                                ),
                                child: TextButton(
                                  onPressed: () {
                                    setState(() {
                                      _selectedIndex = 0;
                                    });
                                  },
                                  child: const Text(
                                    'Email',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Color.fromRGBO(10, 44, 64, 1),
                                      fontWeight: FontWeight.bold,
                                      decoration: TextDecoration.none,
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            // Username Button
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      color: (_selectedIndex == 1)
                                          ? const Color.fromRGBO(
                                          64, 194, 210, 1)
                                          : Colors.grey,
                                      width: 3,
                                      style: BorderStyle.solid,
                                    ),
                                  ),
                                ),
                                child: TextButton(
                                  onPressed: () {
                                    setState(() {
                                      _selectedIndex = 1;
                                    });
                                  },
                                  child: const Text(
                                    'Username',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Color.fromRGBO(10, 44, 64, 1),
                                      fontWeight: FontWeight.bold,
                                      decoration: TextDecoration.none,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),

                  if (_selectedIndex == 0) // Email Login
                    Column(
                      children: [
                        Form(
                          key: GlobalKey<FormState>(),
                          child: TextFormField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            autovalidateMode:
                            AutovalidateMode.onUserInteraction,
                            validator: (value) {
                              if (value!.isEmpty) {
                                _validFieldsEmail['email'] = false;
                                return 'Please enter your email';
                              } else if (!RegExp(
                                  r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$')
                                  .hasMatch(value)) {
                                _validFieldsEmail['email'] = false;
                                return 'Please enter a valid email address';
                              }
                              _validFieldsEmail['email'] = true;
                              return null;
                            },
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                  color: Color.fromRGBO(64, 194, 210, 1),
                                ),
                              ),
                              prefixIcon: const Icon(Icons.email,
                                  color: Color.fromRGBO(64, 194, 210, 1)),
                              hintText: 'Email',
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                  color: Color.fromRGBO(64, 194, 210, 1),
                                ),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                  color: Colors.red,
                                ),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                  color: Colors.red,
                                ),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 20),
                            ),
                            style: const TextStyle(
                              fontSize: 16,
                              color: Color.fromRGBO(10, 44, 64, 1),
                              fontWeight: FontWeight.w300,
                              decoration: TextDecoration.none,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          controller: _emailPasswordController,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          obscureText: true,
                          validator: (value) {
                            if (value!.isEmpty) {
                              _validFieldsEmail['password'] = false;
                              return 'Please enter your password';
                            }
                            _validFieldsEmail['password'] = true;

                            return null;
                          },
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                color: Color.fromRGBO(64, 194, 210, 1),
                              ),
                            ),
                            prefixIcon: const Icon(Icons.lock,
                                color: Color.fromRGBO(64, 194, 210, 1)),
                            hintText: 'Password',
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                color: Color.fromRGBO(64, 194, 210, 1),
                              ),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                color: Colors.red,
                              ),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                color: Colors.red,
                              ),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 15, horizontal: 20),
                          ),
                          style: const TextStyle(
                            fontSize: 16,
                            color: Color.fromRGBO(10, 44, 64, 1),
                            fontWeight: FontWeight.w300,
                            decoration: TextDecoration.none,
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          child: GestureDetector(
                            onTap: () {},
                            child: const Text(
                              'Forgot your password?',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                color: Color.fromRGBO(10, 44, 64, 1),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
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
                            if (_validFieldsEmail['email']! &&
                                _validFieldsEmail['password']!) {
                              _loginViaEmail();
                            }
                          },
                          child: const Text('Login'),
                        ),
                      ],
                    )
                  else if (_selectedIndex == 1) // Username Login
                    Column(
                      children: [
                        TextFormField(
                          controller: _usernameController,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value!.isEmpty) {
                              _validFieldsUsername['username'] = false;
                              return 'Please enter your username';
                            } else {
                              _validFieldsUsername['username'] = true;
                              return null;
                            }
                          },
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                color: Color.fromRGBO(64, 194, 210, 1),
                              ),
                            ),
                            prefixIcon: const Icon(Icons.person,
                                color: Color.fromRGBO(64, 194, 210, 1)),
                            hintText: 'Username',
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                color: Color.fromRGBO(64, 194, 210, 1),
                              ),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                color: Colors.red,
                              ),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                color: Colors.red,
                              ),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 15, horizontal: 20),
                          ),
                          style: const TextStyle(
                            fontSize: 16,
                            color: Color.fromRGBO(10, 44, 64, 1),
                            fontWeight: FontWeight.w300,
                            decoration: TextDecoration.none,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          controller: _usernamePasswordController,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          obscureText: true,
                          validator: (value) {
                            if (value!.isEmpty) {
                              _validFieldsUsername['password'] = false;

                              return 'Please enter your password';
                            }
                            _validFieldsUsername['password'] = true;

                            return null;
                          },
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                color: Color.fromRGBO(64, 194, 210, 1),
                              ),
                            ),
                            prefixIcon: const Icon(Icons.lock,
                                color: Color.fromRGBO(64, 194, 210, 1)),
                            hintText: 'Password',
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                color: Color.fromRGBO(64, 194, 210, 1),
                              ),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                color: Colors.red,
                              ),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                color: Colors.red,
                              ),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 15, horizontal: 20),
                          ),
                          style: const TextStyle(
                            fontSize: 16,
                            color: Color.fromRGBO(10, 44, 64, 1),
                            fontWeight: FontWeight.w300,
                            decoration: TextDecoration.none,
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          child: GestureDetector(
                            onTap: () {},
                            child: const Text(
                              'Forgot your password?',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                color: Color.fromRGBO(10, 44, 64, 1),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
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
                            if (_validFieldsUsername['username']! &&
                                _validFieldsUsername['password']!) {
                              _loginViaUsername();
                            }
                          },
                          child: const Text('Login'),
                        ),
                      ],
                    ),


                  // do not have an account? Sign up
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    alignment: Alignment.bottomCenter,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Don\'t have an account? ',
                          style: TextStyle(
                            color: Color.fromRGBO(10, 44, 64, 1),
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushReplacementNamed(
                                context, '/Register');
                          },
                          child: const Text(
                            'Sign up',
                            style: TextStyle(
                              color: Color.fromRGBO(64, 194, 210, 1),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    alignment: Alignment.bottomCenter,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Skip and go to The Home ',
                          style: TextStyle(
                            color: Color.fromRGBO(10, 44, 64, 1),
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushReplacementNamed(
                                context, '/home');
                          },
                          child: const Text(
                            'Skip',
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
