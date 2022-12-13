import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:until/shared_preference.dart';

import 'MainPage.dart';
import 'ProgressPage.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        body: LoginForm()
    );
  }
}

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  bool showSpinner = false;
  final _authentication = FirebaseAuth.instance;
  final _spfManager = SharedPrefManager();
  final _loginKey = GlobalKey<FormState>();
  String email = '';
  String password = '';
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _loginKey,
            child: ListView(
              children: [
                const SizedBox(height: 100,),
                const Text(
                  "UNTIL",
                  style: TextStyle(fontSize: 32),
                ),
                const SizedBox(height: 80,),
                TextFormField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Email',
                    helperText: '',
                  ),
                  onSaved: (value) {
                    email = value!;
                  },
                  validator: (value) {
                    if (value == null) {
                      return "Please enter an email.";
                    } else if (value.isEmpty) {
                      return "Please enter an email";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12,),
                TextFormField(
                  obscureText: true,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                    helperText: '',
                  ),
                  onSaved: (value) {
                    password = value!;
                  },
                  validator: (value) {
                    if (value == null) {
                      return "Please enter a password.";
                    } else if (value.length < 6) {
                      return "Please enter at least 6 characters.";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 50,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 110,
                      height: 40,
                      child: ElevatedButton(
                        onPressed: () async {
                          try {
                            if(_loginKey.currentState!.validate()) {
                              _loginKey.currentState!.save();
                              setState(() {
                                showSpinner = true;
                              });
                              final currentUser = await _authentication.signInWithEmailAndPassword(email: email, password: password);
                              if (currentUser.user != null) {
                                _loginKey.currentState!.reset();
                                if (!mounted) return;
                                setState(() {
                                  showSpinner = false;
                                });
                                _spfManager.setUserId(currentUser.user!.uid);
                                Navigator.push(context, MaterialPageRoute(builder: (context) => const ProgressPage()));
                              }
                            }
                          } on FirebaseAuthException catch (e) {
                            _loginKey.currentState!.reset();
                            if (!mounted) return;
                            setState(() {
                              showSpinner = false;
                            });
                            if (e.code == 'user-not-found') {
                              showToast("No user found for that email.");
                            } else if (e.code == 'wrong-password') {
                              showToast("Wrong password provided for that user.");
                            } else {
                              showToast("Error: ${e.code}");
                            }
                          }
                        },
                        child: const Text('Enter')),
                    ),
                  ]
                ),
              ],
            )
          ),
        ),
      )
    );
  }

  void showToast(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
    ));
  }
}