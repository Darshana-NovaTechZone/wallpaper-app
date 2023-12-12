import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

import 'package:scroll_app_bar_2_0_0_custom_fix/scroll_app_bar.dart';
import 'package:wall_app/UI/home/wall_details/wall_details.dart';

import '../../Color/color.dart';
import '../../font/font.dart';
import '../../provider/all_provider.dart';
import '../widget/menu_button.dart';
import 'add/ad.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final controller = ScrollController();
  @override
  void initState() {
    super.initState();
  }

  List home = [
    {'img': 'assets/a.PNG', 'n': 'Mode'},
    {'img': 'assets/a1.PNG', 'n': 'Line'},
    {'img': 'assets/a2.PNG', 'n': 'Lofi'},
    {'img': 'assets/a3.PNG', 'n': 'Sparkles'},
    {'img': 'assets/a4.PNG', 'n': 'Cute'},
    {'img': 'assets/a5.PNG', 'n': 'Morning Aesthetic Wallpaper'},
    {'img': 'assets/a6.PNG', 'n': 'Kawaii'},
    {'img': 'assets/a7.PNG', 'n': 'Anime'},
  ];
  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    return Consumer<ProviderS>(
      builder: (context, color, child) => Scaffold(
        appBar: ScrollAppBar(
          iconTheme: IconThemeData(color: fontColor),
          backgroundColor: color.appbarColor,
          automaticallyImplyLeading: false,
          controller: controller, // Note the controller here
          title: Text(
            "Relaxing Wallpaper HD",
            style: TextStyle(
              color: fontColor,
              fontFamily: font,
            ),
          ),
          actions: [MenuButton()],
        ),
        backgroundColor: color.pbackground,
        body: ListView.builder(
          controller: controller,
          padding: EdgeInsets.only(bottom: 80),
          itemCount: home.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    PageTransition(type: PageTransitionType.rightToLeft, child: WallDetails(), inheritTheme: true, ctx: context),
                  );
                },
                child: Stack(
                  children: [
                    SizedBox(
                      height: h / 4,
                      width: w,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Image.asset(
                          home[index]['img'],
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(color: black.withOpacity(0.4), borderRadius: BorderRadius.circular(15)),
                      height: h / 4,
                      width: w,
                    ),
                    Positioned(
                      bottom: 12,
                      left: 12,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          home[index]['n'],
                          style: TextStyle(color: fontColor, fontSize: 18, fontFamily: font, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  menu() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
          contentPadding: EdgeInsets.all(0),
          content: Container(height: 200, width: 200, color: Colors.amber),
          alignment: Alignment.topRight,
          insetPadding: EdgeInsets.only(right: 0, top: 0, left: 200)),
    );
  }
}
