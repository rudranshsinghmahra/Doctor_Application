import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../blocs/auth_bloc.dart';
import '../widgets/loading.dart';
import 'login_screen.dart';
import 'main_screen.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  StreamSubscription<User?>? loginStateSubscription;
  bool loading = false;

  @override
  void initState() {
    var authBloc = Provider.of<AuthBloc>(context, listen: false);
    loginStateSubscription = authBloc.currentUser.listen((fbUser) {
      if (fbUser != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const MainScreen(),
          ),
        );
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    loginStateSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authBloc = Provider.of<AuthBloc>(context);
    return loading
        ? const Loading()
        : Scaffold(
            body: SingleChildScrollView(
              reverse: true,
              child: Padding(
                padding: const EdgeInsets.all(30),
                child: Column(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.28,
                    ),
                    Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: const [
                              BoxShadow(
                                color: Color.fromRGBO(70, 212, 153, 0.8),
                                blurRadius: 20,
                                offset: Offset(0, 10),
                              )
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: double.infinity,
                                height:
                                    MediaQuery.of(context).size.height * 0.06,
                                child: ElevatedButton(
                                    style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                Colors.redAccent)),
                                    onPressed: () {
                                      setState(() {
                                        loading = true;
                                      });
                                      authBloc.loginGoogle();
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: const [
                                        Icon(FontAwesomeIcons.google),
                                        SizedBox(
                                          width: 15,
                                        ),
                                        Text(
                                          "SignUp With Google",
                                          style: TextStyle(fontSize: 18),
                                        ),
                                      ],
                                    )),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        Container(
                          height: 40,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            gradient: const LinearGradient(
                              colors: [
                                Color.fromRGBO(70, 212, 153, 1),
                                Color.fromRGBO(70, 212, 153, 0.6),
                              ],
                            ),
                          ),
                          child: Center(
                              child: SizedBox(
                            height: 40,
                            width: double.infinity,
                            child: TextButton(
                                onPressed: () {},
                                child: const Text(
                                  "Register Now",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                )),
                          )),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                    builder: (context) => const LoginScreen()),
                                (Route<dynamic> route) => false);
                          },
                          child: const Text(
                            "Already have account? Login",
                            style: TextStyle(
                                color: Color.fromRGBO(70, 212, 153, 1),
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
