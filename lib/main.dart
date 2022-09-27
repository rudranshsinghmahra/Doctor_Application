import 'package:doctors_app/screens/login_screen.dart';
import 'package:doctors_app/services/log_in.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'blocs/auth_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (context) => AuthBloc(),
      child: const MaterialApp(
        home: LogIn(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
