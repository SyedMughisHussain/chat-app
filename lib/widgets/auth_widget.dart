import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

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

  loginAndSignUp(
      String email, String username, String password, bool isLogin) async {
    UserCredential _userCredential;
    try {
      if (isLogin) {
        _userCredential = await _auth.signInWithEmailAndPassword(
            email: email, password: password);
      } else {
        _userCredential = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
      }
    } catch (err) {
      if (kDebugMode) {
        print(err);
      }
    }
  }

  void tryLogin() {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();

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
