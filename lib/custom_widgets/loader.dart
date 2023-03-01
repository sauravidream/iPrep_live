import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class FullPageLoader extends StatelessWidget {
  const FullPageLoader(
      {Key? key,
      this.opacity = 0.5,
      this.dismissibles = false,
      this.color = Colors.black,
      this.loadingTxt = 'Loading...'})
      : super(key: key);

  final double opacity;
  final bool dismissibles;
  final Color color;
  final String loadingTxt;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Opacity(
          opacity: opacity,
          child: const ModalBarrier(dismissible: false, color: Colors.black),
        ),
        Center(
          child: Container(
            // width: 30,
            height: 50,
            alignment: Alignment.center,
            padding: const EdgeInsets.only(top: 10),
            // decoration: new BoxDecoration(
            //   image: new DecorationImage(
            //     image: new AssetImage("assets/custom_loader.json"),
            //   ),
            // ),
            child: Lottie.asset("assets/json/custom_loader.json"),
          ),
        ),
      ],
    );
  }
}

class Loader extends StatelessWidget {
  const Loader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Lottie.asset("assets/json/custom_loader.json");
  }
}
