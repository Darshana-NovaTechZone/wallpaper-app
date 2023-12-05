import 'package:flutter/material.dart';


class Favorites extends StatefulWidget {
  const Favorites({super.key});

  @override
  State<Favorites> createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {
  @override
  void initState() {
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
