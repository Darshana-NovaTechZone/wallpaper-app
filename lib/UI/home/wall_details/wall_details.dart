import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:scroll_app_bar_2_0_0_custom_fix/scroll_app_bar.dart';
import 'package:wall_app/Color/color.dart';
import 'package:wall_app/UI/home/wall_details/single_img.dart';

import '../../../font/font.dart';
import '../../../provider/all_provider.dart';

class WallDetails extends StatefulWidget {
  const WallDetails({super.key});

  @override
  State<WallDetails> createState() => _WallDetailsState();
}

class _WallDetailsState extends State<WallDetails> {
  final controller = ScrollController();
  @override
  void initState() {
    super.initState();
  }

  List img = [
    {"name": "assets/1.PNG"},
    {"name": "assets/2.PNG"},
    {"name": "assets/3.PNG"},
    {"name": "assets/5.PNG"},
    {"name": "assets/6.PNG"},
    {"name": "assets/7.PNG"},
    {"name": "assets/8.PNG"},
    {"name": "assets/9.PNG"},
    {"name": "assets/10.PNG"},
    {"name": "assets/11.PNG"},
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

          controller: controller, // Note the controller here
          title: Text(
            "Relaxing Wallpaper HD",
            style: TextStyle(
              color: fontColor,
              fontFamily: font,
            ),
          ),
        ),
        backgroundColor: color.pbackground,
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                width: w,
                height: h,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: GridView.builder(
                    itemCount: img.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: color.columnIndex, mainAxisExtent: h / 4, crossAxisSpacing: 8, mainAxisSpacing: 8),
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            PageTransition(
                                type: PageTransitionType.rightToLeft,
                                child: SingleImage(singleImg: img[index]['name'], img: img, index: index),
                                inheritTheme: true,
                                ctx: context),
                          );
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Image.asset(
                            img[index]['name'],
                            width: w,
                            height: h,
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
