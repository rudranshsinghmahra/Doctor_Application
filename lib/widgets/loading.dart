import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color.fromRGBO(108, 230, 179, 1),
      body: Center(
        child: SpinKitPumpingHeart(
          color: Colors.green,
          size: 50,
        ),
      ),
    );
  }
}
