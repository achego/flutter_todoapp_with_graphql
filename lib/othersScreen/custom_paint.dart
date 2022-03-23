import 'package:flutter/material.dart';

class CustomPaintScreen extends StatelessWidget {
  static String routeName = '/other-screen';

  const CustomPaintScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
      title: const Text('Other Screens'),
    ));
  }
}
