import 'dart:io';
import 'dart:math';

import 'package:admob_flutter/admob_flutter.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:flutter_wallpaper_manager/flutter_wallpaper_manager.dart';
import 'package:gallery_saver_plus/gallery_saver.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path/path.dart';

import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:wall_app/Color/color.dart';
import 'package:wall_app/UI/navigation/navigation.dart';
import 'package:http/http.dart' as http;

import '../../../db/sqldb.dart';
import '../../../font/font.dart';

class SingleImage extends StatefulWidget {
  const SingleImage({super.key, required this.img, required this.index, required this.singleImg});
  final List img;
  final int index;
  final String singleImg;

  @override
  State<SingleImage> createState() => _SingleImageState();
}

class _SingleImageState extends State<SingleImage> {
  GlobalKey<ScaffoldState> scaffoldState = GlobalKey();
  late AdmobInterstitial interstitialAd;
  late AdmobReward rewardAd;
  final String imageUrl =
      "https://ss0.baidu.com/94o3dSag_xI4khGko9WTAnF6hhy/image/h%3D300/sign=a62e824376d98d1069d40a31113eb807/838ba61ea8d3fd1fc9c7b6853a4e251f94ca5f46.jpg";
  final String folderName = 'MyImages';
  bool isDownloading = false;
  bool processing = false;
  bool share = false;
  static const _url =
      "https://ss0.baidu.com/94o3dSag_xI4khGko9WTAnF6hhy/image/h%3D300/sign=a62e824376d98d1069d40a31113eb807/838ba61ea8d3fd1fc9c7b6853a4e251f94ca5f46.jpg";
  var random = Random();
  List img = [];
  int selectedImg = 0;
  String singleImg = '';
  SqlDb sqlDb = SqlDb();
  List localImg = [];
  @override
  void initState() {
    setState(() {
      img = widget.img;
      selectedImg = widget.index;
      singleImg = widget.singleImg;
    });
    super.initState();
    interstitialAd = AdmobInterstitial(
      adUnitId: getInterstitialAdUnitId()!,
      listener: (AdmobAdEvent event, Map<String, dynamic>? args) {
        if (event == AdmobAdEvent.closed) interstitialAd.load();
        // handleEvent(event, args, 'Interstitial');
      },
    );
    rewardAd = AdmobReward(
      adUnitId: getRewardBasedVideoAdUnitId()!,
      listener: (AdmobAdEvent event, Map<String, dynamic>? args) {
        if (event == AdmobAdEvent.closed) rewardAd.load();
        // handleEvent(event, args, 'Reward');
      },
    );

    interstitialAd.load();
    rewardAd.load();
    localData();
  }

  localData() async {
    List res = await SqlDb().readData('select * from favorites');

    setState(() {
      localImg = res;
      print(res);
    });

    Future.delayed(Duration(seconds: 3)).then((value) async {
      print('dddddddddddddddddddddddd');
      final isLoaded = await interstitialAd.isLoaded;
      interstitialAd.show();
    });
  }

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: background,
      body: SizedBox(
        height: h,
        width: w,
        child: Stack(
          children: [
            Container(
                height: h,
                width: w,
                child: CarouselSlider.builder(
                  itemCount: img.length,
                  options: CarouselOptions(
                    onPageChanged: (index, reason) {
                      setState(() {
                        selectedImg = index;
                        singleImg = img[index]['name'];
                        print(selectedImg);
                      });
                    },
                    autoPlay: false,
                    viewportFraction: 1,
                    initialPage: selectedImg,
                    height: h,
                  ),
                  itemBuilder: (context, index, realIdx) {
                    return Stack(
                      children: [
                        Image.asset(img[index]['name'], fit: BoxFit.cover, height: h, width: w),
                        Container(
                          height: h,
                          width: w,
                          color: Colors.black.withOpacity(0.4),
                        )
                      ],
                    );
                  },
                )),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Icons.arrow_back,
                        color: fontColor,
                      )),
                  IconButton(
                      onPressed: () async {
                        final isLoaded = await interstitialAd.isLoaded;
                        if (isLoaded ?? false) {
                          interstitialAd.show();
                        } else {
                          // showSnackBar('Interstitial ad is still loading...');
                        }
                        // setState(() {
                        //   share = true;
                        //   isDownloading = true;
                        // });
                        // final directory = await getExternalStorageDirectory();

                        // final url = Uri.parse(imageUrl);
                        // final response = await http.get(url);
                        // var ss = await File('${directory!.path}myItem.png').writeAsBytes(response.bodyBytes);
                        // print(ss);
                        // setState(() {
                        //   isDownloading = false;
                        //   share = false;
                        // });
                        // await FlutterShare.shareFile(title: 'Compartilhar comprovante', filePath: ss.path, fileType: 'image/png');
                      },
                      icon: Icon(
                        Icons.reply_all_rounded,
                        color: fontColor,
                      )),
                ],
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              left: 0,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        splashColor: Colors.white24,
                        onTap: () {
                          info(context);
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Container(
                            height: h / 14,
                            width: w / 4,
                            child: Column(
                              children: [
                                Icon(
                                  Icons.info_outline,
                                  color: fontColor,
                                ),
                                SizedBox(
                                  height: 4,
                                ),
                                Text(
                                  "Info",
                                  style: TextStyle(
                                    color: fontColor,
                                    fontFamily: font,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        splashColor: Colors.white24,
                        onTap: () {
                          // _saveImage(context);
                          imageSave(context);
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Container(
                              height: h / 14,
                              width: w / 4,
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.download,
                                    color: fontColor,
                                  ),
                                  SizedBox(
                                    height: 4,
                                  ),
                                  Text(
                                    "Save",
                                    style: TextStyle(
                                      color: fontColor,
                                      fontFamily: font,
                                    ),
                                  ),
                                ],
                              )),
                        ),
                      ),
                    ),
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        splashColor: Colors.white24,
                        onTap: () async {
                          apply(context);
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Container(
                              height: h / 14,
                              width: w / 4,
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.biotech_sharp,
                                    color: fontColor,
                                  ),
                                  SizedBox(
                                    height: 4,
                                  ),
                                  Text(
                                    "Apply",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white70,
                                      fontFamily: font,
                                    ),
                                  ),
                                ],
                              )),
                        ),
                      ),
                    ),
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        splashColor: Colors.white24,
                        onTap: () async {
                          if (localImg.any((element) => element['img'] == selectedImg)) {
                            await SqlDb().deleteData('DELETE FROM favorites where img ="$selectedImg" ');
                          } else {
                            await SqlDb().insertData('insert into favorites ("img","name") values("$selectedImg","$singleImg")');
                          }

                          localData();
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Container(
                              height: h / 14,
                              width: w / 4,
                              child: Column(
                                children: [
                                  Icon(
                                    localImg.any((element) => element['img'] == selectedImg) ? Icons.favorite : Icons.favorite_border,
                                    color: fontColor,
                                  ),
                                  SizedBox(
                                    height: 4,
                                  ),
                                  Text(
                                    "Favorite",
                                    style: TextStyle(
                                      color: fontColor,
                                      fontFamily: font,
                                    ),
                                  ),
                                ],
                              )),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            isDownloading
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Container(
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(color: menuD, borderRadius: BorderRadius.circular(10)),
                        height: h / 6,
                        width: w,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Spacer(),
                            CircularProgressIndicator(color: navSelect, strokeWidth: 5),
                            Spacer(
                              flex: 2,
                            ),
                            Text(
                              share ? "preparing Design..." : "Saving Design...",
                              style: TextStyle(
                                fontSize: 18,
                                color: fontColor,
                                fontFamily: font,
                              ),
                            ),
                            Spacer(
                              flex: 5,
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                : SizedBox()
          ],
        ),
      ),
    );
  }

  Future<void> setWallpaper(int? selectedOption, BuildContext context) async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    setState(() {
      share = true;
      isDownloading = true;
    });
    final directory = await getExternalStorageDirectory();

    final url = Uri.parse(imageUrl);
    final response = await http.get(url);
    var path = await File('${directory!.path}${DateTime.now().millisecondsSinceEpoch}').writeAsBytes(response.bodyBytes);
    print(path);

    if (selectedOption == 1) {
      int location = await WallpaperManager.HOME_SCREEN;
      print(location); //can be Home/Lock Screen
      bool result = await WallpaperManager.setWallpaperFromFile(path.path, location);
    } else if (selectedOption == 2) {
      // await WallpaperManager.clearWallpaper();
      int location = await WallpaperManager.LOCK_SCREEN;
      print(location); //can be Home/Lock Screen
      bool result = await WallpaperManager.setWallpaperFromFile(path.path, location);
    } else if (selectedOption == 3) {
      // await WallpaperManager.clearWallpaper();
      int location = await WallpaperManager.BOTH_SCREEN;
      print(location); //can be Home/Lock Screen
      bool result = await WallpaperManager.setWallpaperFromFile(path.path, location);
    } else if (selectedOption == 4) {}
    setState(() {
      share = false;
      isDownloading = false;
    });
    scaffoldMessenger.showSnackBar(SnackBar(
      content: Text(
        'wallpaper successfully added',
        style: TextStyle(
          fontSize: 12,
          color: Color.fromARGB(255, 218, 210, 210),
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: menuD,
    ));
  }

  apply(BuildContext context) {
    content:
    int? selectedOption = 1;
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            insetPadding: EdgeInsets.all(25),
            contentPadding: EdgeInsets.all(12),
            backgroundColor: menuD, actionsPadding: EdgeInsets.all(8),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("CANCEL", style: TextStyle(color: white3, fontSize: 12))),
              TextButton(
                  onPressed: () async {
                    await setWallpaper(selectedOption, context);

                    Navigator.pop(context);
                  },
                  child: Text("OK", style: TextStyle(color: white2, fontSize: 12)))
            ],
            content: Container(
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: 12,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 25),
                    child: Text("Set As:", style: TextStyle(color: white2, fontSize: 20)),
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.symmetric(horizontal: 12),
                    title: Text('Home Screen', style: TextStyle(color: white2, fontSize: 18)),
                    leading: Radio<int>(
                      value: 1,
                      groupValue: selectedOption,
                      onChanged: (int? value) {
                        setState(() {
                          selectedOption = value;
                          print("Selected Option: $selectedOption");
                        });
                      },
                    ),
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.symmetric(horizontal: 12),
                    title: Text('Lock Screen', style: TextStyle(color: white2, fontSize: 18)),
                    leading: Radio<int>(
                      value: 2,
                      groupValue: selectedOption,
                      onChanged: (int? value) {
                        setState(() {
                          selectedOption = value;
                          print("Selected Option: $selectedOption");
                        });
                      },
                    ),
                  ),
                  Stack(
                    children: [
                      ListTile(
                        contentPadding: EdgeInsets.symmetric(horizontal: 12),
                        title: Text('Home & Lock Screens', style: TextStyle(color: white2, fontSize: 18)),
                        leading: Radio<int>(
                          value: 3,
                          groupValue: selectedOption,
                          onChanged: (int? value) {
                            setState(() {
                              selectedOption = value;
                              print("Selected Option: $selectedOption");
                            });
                          },
                        ),
                      ),
                      processing ? Center(child: CircularProgressIndicator()) : SizedBox()
                    ],
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.symmetric(horizontal: 12),
                    title: Text('Crop', style: TextStyle(color: white2, fontSize: 18)),
                    leading: Radio<int>(
                      value: 4,
                      groupValue: selectedOption,
                      onChanged: (int? value) {
                        setState(() {
                          selectedOption = value;
                          print("Selected Option: $selectedOption");
                        });
                      },
                    ),
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.symmetric(horizontal: 12),
                    title: Text(
                      'Set with...',
                      style: TextStyle(color: white2, fontSize: 18),
                    ),
                    leading: Radio<int>(
                      value: 5,
                      groupValue: selectedOption,
                      onChanged: (int? value) {
                        setState(() {
                          selectedOption = value;
                          print("Selected Option: $selectedOption");
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),

            // Set the default value here
          );
        });
      },
    );
  }

  info(BuildContext context) {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
        backgroundColor: menuD,
        context: context,
        builder: (context) {
          var h = MediaQuery.of(context).size.height;
          var w = MediaQuery.of(context).size.width;
          return Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(
                  child: Text(
                    "Info",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: fontColor2,
                      fontFamily: font,
                    ),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  children: [
                    SizedBox(
                      width: w / 3,
                      child: Text(
                        "Resolution",
                        style: TextStyle(
                          fontSize: 18,
                          color: fontColor,
                          fontFamily: font,
                        ),
                      ),
                    ),
                    Text(
                      "720*1600",
                      style: TextStyle(
                        fontSize: 18,
                        color: fontColor,
                        fontFamily: font,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  children: [
                    SizedBox(
                      width: w / 3,
                      child: Text(
                        "Size",
                        style: TextStyle(
                          fontSize: 18,
                          color: fontColor,
                          fontFamily: font,
                        ),
                      ),
                    ),
                    Text(
                      "0.8668 MB",
                      style: TextStyle(
                        fontSize: 18,
                        color: fontColor,
                        fontFamily: font,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  children: [
                    SizedBox(
                      width: w / 3,
                      child: Text(
                        "Views",
                        style: TextStyle(
                          fontSize: 18,
                          color: fontColor,
                          fontFamily: font,
                        ),
                      ),
                    ),
                    Text(
                      "24.4k",
                      style: TextStyle(
                        fontSize: 18,
                        color: fontColor,
                        fontFamily: font,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  children: [
                    SizedBox(
                      width: w / 3,
                      child: Text(
                        "Download",
                        style: TextStyle(
                          fontSize: 18,
                          color: fontColor,
                          fontFamily: font,
                        ),
                      ),
                    ),
                    Text(
                      "1.9k",
                      style: TextStyle(
                        fontSize: 18,
                        color: fontColor,
                        fontFamily: font,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        });
  }

  imageSave(BuildContext context) async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    late String message;
    setState(() {
      isDownloading = true;
    });
    final tempDir = await getTemporaryDirectory();
    final path = '${tempDir.path}/${DateTime.now()}.jpg';
    await Dio().download(_url, path);
    await GallerySaver.saveImage(path, albumName: 'wallpaper');
    setState(() {
      isDownloading = false;
    });
    message = e.toString();
    scaffoldMessenger.showSnackBar(SnackBar(
      content: Text(
        'Image successfully saved',
        style: TextStyle(
          fontSize: 12,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: menuD,
    ));
  }

  String? getInterstitialAdUnitId() {
    if (Platform.isIOS) {
      return 'ca-app-pub-3940256099942544/4411468910';
    } else if (Platform.isAndroid) {
      return 'ca-app-pub-3940256099942544/1033173712';
    }
    return null;
  }

  String? getRewardBasedVideoAdUnitId() {
    if (Platform.isIOS) {
      return 'ca-app-pub-3940256099942544/1712485313';
    } else if (Platform.isAndroid) {
      return 'ca-app-pub-3940256099942544/5224354917';
    }
    return null;
  }

  @override
  void dispose() {
    interstitialAd.dispose();
    rewardAd.dispose();
    super.dispose();
  }
}
