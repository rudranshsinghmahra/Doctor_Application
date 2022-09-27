import 'dart:async';
import 'package:doctors_app/screens/register_screen.dart';
import 'package:doctors_app/services/log_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../blocs/auth_bloc.dart';
import '../widgets/loading.dart';
import 'main_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  StreamSubscription<User?>? loginStateSubscription;
  bool loading = false;

  @override
  void initState() {
    var authBloc = Provider.of<AuthBloc>(context, listen: false);
    loginStateSubscription = authBloc.currentUser.listen((fbUser) {
      if (fbUser != null) {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const MainScreen()));
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
            backgroundColor: Colors.white,
            body: SingleChildScrollView(
              reverse: true,
              child: Column(
                children: [
                  Container(
                    height: 400,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                          image:
                              AssetImage("assets/images/background_green.png"),
                          fit: BoxFit.fill),
                    ),
                    child: Stack(
                      children: [
                        Positioned(
                          width: 150,
                          height: 200,
                          child: Container(
                            decoration: const BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage("assets/images/light-1.png"),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          width: 350,
                          height: 150,
                          child: Container(
                            decoration: const BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage("assets/images/light-2.png"),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 40,
                          right: 40,
                          width: 80,
                          height: 150,
                          child: Container(
                            decoration: const BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage("assets/images/clock.png"),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          child: Container(
                            margin: const EdgeInsets.only(top: 50),
                            child: const Center(
                              child: Text(
                                "Login",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 40,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(30),
                    child: Column(
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
                            children: [
                              SizedBox(
                                width: double.infinity,
                                height:
                                    MediaQuery.of(context).size.height * 0.06,
                                child: ElevatedButton(
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        Colors.redAccent),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      loading = true;
                                    });
                                    authBloc.loginGoogle();
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      Icon(FontAwesomeIcons.google),
                                      SizedBox(
                                        width: 15,
                                      ),
                                      Text(
                                        "Login With Google",
                                        style: TextStyle(fontSize: 18),
                                      ),
                                    ],
                                  ),
                                ),
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
                                  "Login",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                    builder: (context) => RegisterPage()),
                                (Route<dynamic> route) => false);
                          },
                          child: const Text(
                            "Don't have an account? SignUp",
                            style: TextStyle(
                                color: Color.fromRGBO(70, 212, 153, 1),
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
