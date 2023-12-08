import 'dart:io';
import 'package:chat_app/config/themes/app_style.dart';
import 'package:chat_app/core/widgets/image_viewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chat_app/features/auth/auth_di.dart' as auth_di;
import 'package:chat_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ProfilePage extends StatefulWidget {
  static const String routeName = '/profile';

  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  File? _image;
  final _formKey = GlobalKey<FormState>();
  final _avatarFormKey = GlobalKey<FormState>();

  final authCubit = auth_di.sl.get<AuthCubit>();
  final user = auth_di.getUser();

  final String _baseImageUrl = dotenv.env['IMAGE_URL'] ?? 'https://chat.mohsowa.com/api/image';


  @override
  void initState() {
    super.initState();

  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      authCubit.updateUserAvatar(_image!);
      authCubit.checkCachedUser();
    }
  }

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _userNameController = TextEditingController();

  // _saveInfod
  void _saveInfo() {
    if (_formKey.currentState!.validate()) {
      authCubit.updateUserProfile(
        _nameController.text,
        _userNameController.text,
        _emailController.text,
      );
      authCubit.checkCachedUser();
    }
  }

  void showImageEditor() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          surfaceTintColor: white,
          title: const Text("Edit Image"),
          content: SizedBox(
            // You can customize the size of the image viewer here
            width: double.maxFinite,
            height: 350,
            child: Form(
              key: _avatarFormKey,
              child: ImageViewer.file(
                imageFile: _image,
                editableCallback: (newImage) {
                  setState(() {
                    _image = newImage;
                  });
                },
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Close"),
            ),
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: themeBlue,
              ),
              onPressed: () {
                _submitForm();
                Navigator.of(context).pop();
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }

  Widget buildCircle({
    required Widget child,
    required double all,
    required Color color,
  }) =>
      ClipOval(
        child: Container(
          padding: EdgeInsets.all(all),
          color: color,
          child: child,
        ),
      );

  Widget buildEditIcon() => buildCircle(
        color: themeDarkBlue,
        all: 3,
        child: buildCircle(
          color: themeDarkBlue,
          all: 8,
          child: Icon(
            Icons.edit,
            color: themeBlue,
            size: 20,
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: _buildAuthState(),
    );
  }

  BlocBuilder<AuthCubit, AuthState> _buildAuthState() {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {

        if (state is AuthLoading) {

          return Center(
            child: CircularProgressIndicator(
              color: themeBlue,
              backgroundColor: themePink,
            ),
          );
        }

        else if (state is AuthLoaded) {
          _nameController.text = state.user.name;
          _emailController.text = state.user.email;
          _userNameController.text = state.user.username;
          String avatar = _baseImageUrl + state.user.avatar;
          print(avatar);
          return Column(
            children: [
              Center(
                child: Stack(
                  children: [
                    buildCircle(
                      color: Colors.transparent,
                      all: 2,
                      child: ClipOval(
                        child: Material(
                          color: Colors.transparent,
                          child: ImageViewer.network(
                          placeholderImagePath: 'assets/images/user.png',
                          imageURL: avatar,
                          width: 110,
                          height: 110,
                        ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 4,
                      child: GestureDetector(
                        onTap: () {
                          showImageEditor();
                        },
                        child: buildEditIcon(),
                      ),
                    ),
                  ],
                ),
              ),
              Form(
                key: _formKey,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const SizedBox(height: 10),
                      // User Info Form with initial values
                      Text(
                        'Full Name',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14.0,
                          color: themeBlue,
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                        padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                        decoration: primaryDecoration,
                        child: TextField(
                          controller: _nameController,
                          cursorColor: themeBlue,
                          decoration: const InputDecoration(
                            prefixIcon: Padding(
                              padding: EdgeInsets.fromLTRB(0, 0, 0, 8),
                              child: Icon(
                                Icons.person,
                                color: Colors.black38,
                              ),
                            ),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),

                      Text(
                        'Username',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14.0,
                          color: themeBlue,
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                        padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                        decoration: primaryDecoration,
                        child: TextField(
                          controller: _userNameController,
                          cursorColor: themeBlue,
                          decoration: InputDecoration(
                            prefixText: '@ ',
                            prefixStyle: TextStyle(
                              color: themeGrey,
                              fontWeight: FontWeight.bold,
                            ),
                            prefixIcon: const Padding(
                              padding: EdgeInsets.fromLTRB(0, 0, 0, 8),
                              child: Icon(
                                Icons.person_pin,
                                color: Colors.black38,
                              ),
                            ),
                            border: InputBorder.none,
                          ),
                        ),
                      ),

                      const SizedBox(
                        height: 15,
                      ),

                      Text(
                        'Email',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14.0,
                          color: themeBlue,
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                        padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                        decoration: primaryDecoration,
                        child: TextField(
                          controller: _emailController,
                          cursorColor: themeBlue,
                          decoration: const InputDecoration(
                            prefixIcon: Padding(
                              padding: EdgeInsets.fromLTRB(0, 0, 0, 8),
                              child: Icon(
                                Icons.email,
                                color: Colors.black38,
                              ),
                            ),
                            border: InputBorder.none,
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),
                      Center(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: themeBlue,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 50, vertical: 13),
                              // Button padding
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    8), // Button border radius
                              ),
                              textStyle: const TextStyle(
                                fontWeight: FontWeight.bold,
                              )),
                          onPressed: _saveInfo,
                          child: const Text(
                            'Save Info',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        } else {
          return Container();
        }
      },
    );
  }
}
