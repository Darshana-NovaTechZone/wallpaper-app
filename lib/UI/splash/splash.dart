import 'package:flutter/material.dart';
import 'package:wall_app/UI/navigation/navigation.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    Future.delayed(Duration(seconds: 2)).then((value) => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => NavigationScreen(),
        )));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Image.asset(
        'assets/w.PNG',
        width: w,
        height: h,
        fit: BoxFit.cover,
      ),
    );
  }
}
