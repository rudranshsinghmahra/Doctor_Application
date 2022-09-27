import 'package:doctors_app/screens/register_screen.dart';
import 'package:flutter/material.dart';
import 'login_screen.dart';

class LoginRegisterScreen extends StatefulWidget {
  const LoginRegisterScreen({Key? key}) : super(key: key);

  @override
  State<LoginRegisterScreen> createState() => _LoginRegisterScreenState();
}

class _LoginRegisterScreenState extends State<LoginRegisterScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: const Color.fromRGBO(70, 212, 153, 0.8),
        child: Column(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.2,
            ),
            const Image(image: AssetImage("assets/images/health.png")),
            Padding(
              padding: const EdgeInsets.only(left: 22.0, right: 22),
              child: SizedBox(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.06,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: const StadiumBorder()),
                  child: const Text(
                    "Login",
                    style: TextStyle(
                        color: Color.fromRGBO(70, 212, 153, 0.8),
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 22.0, right: 22),
              child: SizedBox(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.06,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const RegisterPage(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    shape: const StadiumBorder(),
                    side: const BorderSide(color: Colors.white),
                  ),
                  child: const Text(
                    "Register Now",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
