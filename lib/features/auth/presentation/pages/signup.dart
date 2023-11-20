
import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

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
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
          child: Material(
            child: SingleChildScrollView(
              child: Column(
                  children: [
                    SizedBox(height: 20),
                    Image.asset(
                      'assets/images/signup_image.png',
                      height: 120,
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Sign Up',
                      style: TextStyle(
                        fontSize: 18,
                        color: Color.fromRGBO(10, 44, 64, 1),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
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

