import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class ErrorScreen extends StatelessWidget {
  const ErrorScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      alignment: Alignment.center,
      child: SizedBox(
        width: 50,
        height: 50,
        child: Lottie.asset('assets/lotties/loading.json'),
      ),
    );
  }
}
