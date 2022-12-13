import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:until/service/local_notification.dart';
import 'package:until/shared_preference.dart';
import 'package:until/view/screen/LoginPage.dart';
import 'package:until/view/screen/MainPage.dart';

class SignupPage extends StatelessWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        body: SignupForm()
    );
  }
}

class SignupForm extends StatefulWidget {
  const SignupForm({Key? key}) : super(key: key);

  @override
  State<SignupForm> createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  bool showSpinner = false;
  final _authentication = FirebaseAuth.instance;
  final _spfManager = SharedPrefManager();
  final _loginKey = GlobalKey<FormState>();
  String email = '';
  String password = '';
  String userName = '';

  @override
  void initState() {
    LocalNotification.requestPermission();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: ModalProgressHUD(
          inAsyncCall: showSpinner,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
                key: _loginKey,
                child: ScrollConfiguration(
                  behavior: const ScrollBehavior().copyWith(overscroll: false),
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
                      const SizedBox(height: 12,),
                      TextFormField(
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Name',
                          helperText: '',
                        ),
                        onSaved: (value) {
                          userName = value!;
                        },
                        validator: (value) {
                          if (value == null) {
                            return "Please enter an email.";
                          } else if (value.isEmpty) {
                            return "Please enter your name";
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
                                        final newUser =
                                        await _authentication.createUserWithEmailAndPassword(email: email, password: password);
                                        await FirebaseFirestore.instance
                                            .collection('user')
                                            .doc(newUser.user!.uid)
                                            .set({'userName': userName, 'email': email,});
                                        if (newUser.user != null) {
                                          _loginKey.currentState!.reset();
                                          if (!mounted) return;
                                          setState(() {
                                            showSpinner = false;
                                          });
                                          _spfManager.setUserId(newUser.user!.uid);
                                          Navigator.push(context, MaterialPageRoute(builder: (context) => const MainPage()));
                                        }
                                      }
                                    } catch (e) {
                                      print(e);
                                    }
                                  },
                                  child: const Text('Enter')),
                            ),
                          ]
                      ),
                      const SizedBox(height: 30,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Already have account?",
                            style: TextStyle(fontSize: 12),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginPage()));
                            },
                            child: const Text(
                              "Sign In",
                              style: TextStyle(fontSize: 12),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                )
            ),
          ),
        )
    );
  }
}