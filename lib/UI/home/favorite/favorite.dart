import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:scroll_app_bar_2_0_0_custom_fix/scroll_app_bar.dart';
import 'package:wall_app/Color/color.dart';

import '../../../db/sqldb.dart';
import '../../../font/font.dart';
import '../../../provider/all_provider.dart';
import '../../widget/menu_button.dart';
import '../wall_details/single_img.dart';

class Favorites extends StatefulWidget {
  const Favorites({super.key});

  @override
  State<Favorites> createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {
  final controller = ScrollController();
  List img = [];
  SqlDb sqlDb = SqlDb();
  @override
  void initState() {
    localData();
    super.initState();
  }

  localData() async {
    List res = await SqlDb().readData('select * from favorites');
    setState(() {
      img = res;
      print(res);
    });
  }

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
            "Favorites",
            style: TextStyle(
              color: fontColor,
              fontFamily: font,
            ),
          ),
          actions: [MenuButton()],
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
                          print(img[index]['name']);
                          print(img);
                          print(img[index]['img']);
                          Navigator.push(
                            context,
                            PageTransition(
                                type: PageTransitionType.rightToLeft,
                                child: SingleImage(singleImg: img[index]['name'].toString(), img: img, index: img[index]['img']),
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
