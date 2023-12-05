import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:scroll_app_bar_2_0_0_custom_fix/scroll_app_bar.dart';
import 'package:wall_app/Color/color.dart';
import 'package:wall_app/UI/home/wall_details/single_img.dart';

import '../../../font/font.dart';

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
    'assets/1.PNG',
    'assets/2.PNG',
    'assets/3.PNG',
    'assets/5.PNG',
    'assets/6.PNG',
    'assets/7.PNG',
    'assets/8.PNG',
    'assets/9.PNG',
    'assets/10.PNG',
    'assets/11.PNG'
  ];
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
      ),
      backgroundColor: background,
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
                  gridDelegate:
                      SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, mainAxisExtent: h / 4, crossAxisSpacing: 8, mainAxisSpacing: 8),
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          PageTransition(
                              type: PageTransitionType.rightToLeft, child: SingleImage(img: img, index: index), inheritTheme: true, ctx: context),
                        );
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Image.asset(
                          img[index],
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
    );
  }
}
