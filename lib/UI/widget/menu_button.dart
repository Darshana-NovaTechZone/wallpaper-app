import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

import '../../Color/color.dart';
import '../../provider/all_provider.dart';
import '../home/settings/settings.dart';

class MenuButton extends StatefulWidget {
  const MenuButton({super.key});

  @override
  State<MenuButton> createState() => _MenuButtonState();
}

class _MenuButtonState extends State<MenuButton> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ProviderS>(
      builder: (context, color, child) => PopupMenuButton<String>(
        icon: Icon(
          Icons.more_vert,
          color: fontColor,
        ),
        // elevation: 100,
        color: color.pMenuColor,
        surfaceTintColor: black1,
        shadowColor: black1,
        onSelected: (value) {
          choiceAction(value, context);
        },
        itemBuilder: (BuildContext context) {
          return Constants.choices.map((String choice) {
            return PopupMenuItem<String>(
              value: choice,
              child: Text(
                choice,
                style: TextStyle(fontSize: 18, color: color.pfont),
              ),
            );
          }).toList();
        },
      ),
    );
  }

  void choiceAction(String choice, BuildContext context) async {
    if (choice == Constants.FirstItem) {
      Navigator.push(
        context,
        PageTransition(type: PageTransitionType.rightToLeft, child: Settings(), inheritTheme: true, ctx: context),
      );
    } else if (choice == Constants.SecondItem) {
      print('I Second Item');
    } else if (choice == Constants.ThirdItem) {
      print('I Third Item');
    } else if (choice == Constants.fourthItem) {
      await FlutterShare.share(
          title:
              'Relaxing Wallpaper HD\nI Would like to share this with you. Here You Can Download This Application from PlayStore\nhttps://play.google.com/store/apps/details?id=relaxing.wallpaperhd.backgrounds ');
    } else if (choice == Constants.fifthItem) {
      about();
    }
  }

  about() {
    showDialog(
      context: context,
      builder: (context) => Consumer<ProviderS>(
          builder: (context, color, child) => StatefulBuilder(builder: (context, setState) {
                var h = MediaQuery.of(context).size.height;
                var w = MediaQuery.of(context).size.width;
                return AlertDialog(
                  insetPadding: EdgeInsets.all(25),
                  backgroundColor: color.pMenuColor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  actionsPadding: EdgeInsets.all(0),
                  actions: [
                    TextButton(
                        onPressed: () async {
                          Navigator.pop(context);
                        },
                        child: Text("OK", style: TextStyle(color: color.pfont, fontSize: 13))),
                  ],
                  content: Container(
                    width: w,
                    child: Column(mainAxisSize: MainAxisSize.min, children: [
                      SizedBox(
                        height: 15,
                      ),
                      SizedBox(
                          width: 100,
                          height: 100,
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: Image.asset(
                                'assets/1.PNG',
                                fit: BoxFit.cover,
                              ))),
                      SizedBox(
                        height: 10,
                      ),
                      Text("Relaxing Wallpaper HD", style: TextStyle(color: color.pfont, fontSize: 20, fontWeight: FontWeight.bold)),
                      SizedBox(
                        height: 10,
                      ),
                      Text("Version 22",
                          style: TextStyle(
                            color: color.pfont2,
                            fontSize: 14,
                          )),
                      SizedBox(
                        height: 20,
                      ),
                      Text("Copyright @ novatechzone Developer \n All right reserved",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: color.pfont2,
                            fontSize: 14,
                          )),
                    ]),
                  ),
                );
              })),
    );
  }
}

class Constants {
  static const String FirstItem = 'Settings';
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
