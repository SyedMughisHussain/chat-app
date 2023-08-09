import 'dart:js_interop';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../pickers/image_picker_widget.dart';
import 'dart:io';

class AuthWidget extends StatefulWidget {
  const AuthWidget({super.key});

  @override
  State<AuthWidget> createState() => _AuthWidgetState();
}

class _AuthWidgetState extends State<AuthWidget> {
  final _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  var _emailAddress = '';
  var _userName = '';
  var _password = '';
  bool _isLogin = true;
  bool _isLoading = false;
  File? userImageFile;

  void pickedImage(File image) {
    userImageFile = image;
  }

  loginAndSignUp(
      String email, String username, String password, bool isLogin) async {
    UserCredential userCredential;
    try {
      setState(() {
        _isLoading = true;
      });
      if (isLogin) {
        userCredential = await _auth.signInWithEmailAndPassword(
            email: email, password: password);
      } else {
        userCredential = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
        final ref = FirebaseStorage.instance
            .ref()
            .child('user_image')
            .child("${userCredential.user!.uid}.jpg");
        await ref.putFile(userImageFile!);

        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user!.uid)
            .set({
          'username': username,
          'email': email,
        });
      }
      setState(() {
        _isLoading = false;
      });
    } on FirebaseAuthException catch (error) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(error.message.toString())));
      setState(() {
        _isLoading = false;
      });
    }
  }

  void tryLogin() {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (userImageFile.isNull && !_isLogin) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          backgroundColor: Colors.red, content: Text('Please pick an image.')));
      return;
    }

    if (isValid) {
      _formKey.currentState!.save();
      loginAndSignUp(_emailAddress, _userName, _password, _isLogin);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.pink,
        body: Center(
          child: Card(
            margin: const EdgeInsets.all(15),
            child: Padding(
              padding: const EdgeInsets.all(25),
              child: SingleChildScrollView(
                child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (!_isLogin) ImagePickerWidget(pickedImage),
                        TextFormField(
                          key: const ValueKey('Email address'),
                          validator: (value) {
                            if (value!.isEmpty || !value.contains('@')) {
                              return 'Enter a valid email address.';
                            }
                            return null;
                          },
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                            hintText: 'Email address',
                          ),
                          onSaved: (newValue) {
                            _emailAddress = newValue!;
                          },
                        ),
                        if (!_isLogin)
                          TextFormField(
                            key: const ValueKey('username'),
                            validator: (value) {
                              if (value!.isEmpty || value.length < 4) {
                                return 'Enter a valid user name.';
                              }
                              return null;
                            },
                            keyboardType: TextInputType.name,
                            decoration: const InputDecoration(
                              hintText: 'Username',
                            ),
                            onSaved: (newValue) {
                              _userName = newValue!;
                            },
                          ),
                        TextFormField(
                          key: const ValueKey('password'),
                          validator: (value) {
                            if (value!.isEmpty || value.length < 7) {
                              return 'Enter a valid password.';
                            }
                            return null;
                          },
                          obscureText: true,
                          keyboardType: TextInputType.text,
                          decoration: const InputDecoration(
                            hintText: 'Password',
                          ),
                          onSaved: (newValue) {
                            _password = newValue!;
                          },
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        if (_isLoading) const CircularProgressIndicator(),
                        if (!_isLoading)
                          ElevatedButton(
                              style: const ButtonStyle(
                                  foregroundColor:
                                      MaterialStatePropertyAll(Colors.white),
                                  backgroundColor:
                                      MaterialStatePropertyAll(Colors.pink)),
                              onPressed: () {
                                tryLogin();
                              },
                              child: Text(
                                _isLogin ? 'Login' : 'SignUp',
                              )),
                        const SizedBox(
                          height: 15,
                        ),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _isLogin = !_isLogin;
                            });
                          },
                          style: const ButtonStyle(
                              foregroundColor:
                                  MaterialStatePropertyAll(Colors.pink)),
                          child: Text(_isLogin
                              ? 'Create a new account'
                              : 'Already have an account?'),
                        )
                      ],
                    )),
              ),
            ),
          ),
        ));
  }
}
