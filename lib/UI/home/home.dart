import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

import 'package:scroll_app_bar_2_0_0_custom_fix/scroll_app_bar.dart';
import 'package:wall_app/UI/home/wall_details/wall_details.dart';

import '../../Color/color.dart';
import '../../font/font.dart';

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

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: ScrollAppBar(
        iconTheme: IconThemeData(color: fontColor),
        backgroundColor: black1,
        automaticallyImplyLeading: false,
        controller: controller, // Note the controller here
        title: Text(
          "Relaxing Wallpaper HD",
          style: TextStyle(
            color: fontColor,
            fontFamily: font,
          ),
        ),
        actions: [
          PopupMenuButton<String>(
            icon: Icon(
              Icons.more_vert,
              color: fontColor,
            ),
            // elevation: 100,
            color: menuD,
            surfaceTintColor: black1,
            shadowColor: black1,
            onSelected: choiceAction,
            itemBuilder: (BuildContext context) {
              return Constants.choices.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(
                    choice,
                    style: TextStyle(fontSize: 18, color: fontColor2),
                  ),
                );
              }).toList();
            },
          ),
        ],
      ),
      backgroundColor: background,
      body: ListView.builder(
        controller: controller,
        padding: EdgeInsets.only(bottom: 80),
        itemCount: 10,
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
                        'assets/w.PNG',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 12,
                    left: 12,
                    child: Text(
                      "Wall",
                      style: TextStyle(color: fontColor, fontSize: 18, fontFamily: font, fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
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

  void choiceAction(String choice) {
    if (choice == Constants.FirstItem) {
      print('I First Item');
    } else if (choice == Constants.SecondItem) {
      print('I Second Item');
    } else if (choice == Constants.ThirdItem) {
      print('I Third Item');
    } else if (choice == Constants.fourthItem) {
      print('I Third Item');
    } else if (choice == Constants.fifthItem) {
      print('I Third Item');
    }
  }
}

class Constants {
  static const String FirstItem = 'Setting';
  static const String SecondItem = 'Rate us';
  static const String ThirdItem = 'More apps(AD)';
  static const String fourthItem = 'Share';
  static const String fifthItem = 'About';

  static const List<String> choices = <String>[
    FirstItem,
    SecondItem,
    ThirdItem,
    fourthItem,
    fifthItem,
  ];
}
