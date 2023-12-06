import 'package:flutter/material.dart';
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

  void choiceAction(String choice, BuildContext context) {
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
      print('I Third Item');
    } else if (choice == Constants.fifthItem) {
      print('I Third Item');
    }
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
