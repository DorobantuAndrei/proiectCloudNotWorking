import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      alignment: Alignment.center,
      child: SizedBox(
        width: 100,
        height: 100,
        child: Lottie.asset('assets/lotties/loading.json'),
      ),
    );
  }
}
