import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wall_app/UI/navigation/navigation.dart';

import '../../Color/color.dart';
import '../../db/sqldb.dart';
import '../../provider/all_provider.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  SqlDb sqlDb = SqlDb();
  @override
  void initState() {
    localData();
    Future.delayed(Duration(seconds: 2)).then((value) => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => NavigationScreen(),
        )));

    super.initState();
  }

  localData() async {
    List modeData = await SqlDb().readData('select * from mood');
    if (modeData.isNotEmpty) {
      Provider.of<ProviderS>(context, listen: false).columnIndex = modeData[0]['colum'];
      if (modeData[0]['status'] == 1) {
        Provider.of<ProviderS>(context, listen: false).pbackground = white;
        Provider.of<ProviderS>(context, listen: false).pfont = black;
        Provider.of<ProviderS>(context, listen: false).pfont2 = black2;
        Provider.of<ProviderS>(context, listen: false).appbarColor = appbarColor;
        Provider.of<ProviderS>(context, listen: false).pnaveColor = white;
        Provider.of<ProviderS>(context, listen: false).pMenuColor = white;
      } else {
        Provider.of<ProviderS>(context, listen: false).columnIndex = 3;
        Provider.of<ProviderS>(context, listen: false).pbackground = background;
        Provider.of<ProviderS>(context, listen: false).pfont = white1;
        Provider.of<ProviderS>(context, listen: false).pfont2 = white3;
        Provider.of<ProviderS>(context, listen: false).appbarColor = black1;
        Provider.of<ProviderS>(context, listen: false).pnaveColor = navColor;

        Provider.of<ProviderS>(context, listen: false).pMenuColor = menuD;
      }
    }
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
