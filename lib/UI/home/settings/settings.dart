// import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:open_settings_plus/android/open_settings_plus_android.dart';
import 'package:provider/provider.dart';
import 'package:simple_app_cache_manager/simple_app_cache_manager.dart';

import '../../../Color/color.dart';
import '../../../db/sqldb.dart';
import '../../../font/font.dart';
import '../../../provider/all_provider.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> with CacheMixin {
  final settingsAndroid = OpenSettingsPlusAndroid();
  bool isLite = true;
  List modeData = [];
  SqlDb sqlDb = SqlDb();
  bool isDownloading = false;
  int? columnindex = 3;
  @override
  void initState() {
    data();
    super.initState();
  }

  data() async {
    modeData = await SqlDb().readData('select * from mood');
    setState(() {
      columnindex = modeData[0]['colum'];
      modeData;
      print(modeData);
    });
    if (modeData.isEmpty) {
      await SqlDb().insertData('insert into mood ("status","colum") values(0,3)');
      modeData = await SqlDb().readData('select * from mood');
      setState(() {
        columnindex = modeData[0]['colum'];
        isLite = true;
      });
    } else {
      if (modeData[0]['status'] == 0) {
        setState(() {
          isLite = true;
        });
      } else {
        setState(() {
          isLite = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    return Consumer<ProviderS>(
      builder: (context, color, child) => Scaffold(
        backgroundColor: color.pbackground,
        appBar: AppBar(
          iconTheme: IconThemeData(color: fontColor),
          backgroundColor: color.appbarColor,

          // Note the controller here
          title: Text(
            "Settings",
            style: TextStyle(
              color: white,
              fontFamily: font,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Stack(
            children: [
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                SizedBox(
                  height: 20,
                ),
                Container(
                  padding: const EdgeInsets.all(12.0),
                  width: w,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Dark theme",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: color.pfont,
                              fontFamily: font,
                            ),
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Text(
                            "Better for eyesight & battery life",
                            style: TextStyle(
                              fontSize: 14,
                              color: color.pfont2,
                              fontFamily: font,
                            ),
                          ),
                        ],
                      ),
                      Switch(
                        value: isLite,
                        onChanged: (value) async {
                          setState(() {
                            isLite = value;
                          });

                          if (isLite == true) {
                            Provider.of<ProviderS>(context, listen: false).pbackground = background;
                            Provider.of<ProviderS>(context, listen: false).pfont = white1;
                            Provider.of<ProviderS>(context, listen: false).pfont2 = white3;
                            Provider.of<ProviderS>(context, listen: false).appbarColor = black1;
                            Provider.of<ProviderS>(context, listen: false).pnaveColor = navColor;

                            Provider.of<ProviderS>(context, listen: false).pMenuColor = menuD;
                            await SqlDb().updateData('update mood set status ="0"');
                          } else {
                            await SqlDb().updateData('update mood set status ="1"');

                            Provider.of<ProviderS>(context, listen: false).pbackground = white1;
                            Provider.of<ProviderS>(context, listen: false).pfont = black;
                            Provider.of<ProviderS>(context, listen: false).pfont2 = black2;
                            Provider.of<ProviderS>(context, listen: false).appbarColor = appbarColor;
                            Provider.of<ProviderS>(context, listen: false).pnaveColor = white;
                            Provider.of<ProviderS>(context, listen: false).pMenuColor = white;
                          }
                          data();
                        },
                      )
                    ],
                  ),
                ),
                InkWell(
                  onTap: () {
                    changeColum();
                  },
                  child: Container(
                    padding: const EdgeInsets.all(12.0),
                    width: w,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Display Design",
                          style: TextStyle(fontSize: 18, color: color.pfont, fontFamily: font, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        Text(
                          "$columnindex Columns",
                          style: TextStyle(
                            fontSize: 14,
                            color: color.pfont2,
                            fontFamily: font,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    settingsAndroid.notification();
                    // AppSettings.openAppSettings(type: AppSettingsType.location);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(12.0),
                    width: w,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Notification",
                          style: TextStyle(fontSize: 18, color: color.pfont, fontFamily: font, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        Text(
                          "Subscribe to receive Designs update",
                          style: TextStyle(
                            fontSize: 14,
                            color: color.pfont2,
                            fontFamily: font,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    cacheClear();
                  },
                  child: Container(
                    padding: const EdgeInsets.all(12.0),
                    width: w,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Clear Cache",
                              style: TextStyle(fontSize: 18, color: color.pfont, fontFamily: font, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 4,
                            ),
                            ValueListenableBuilder(
                              valueListenable: cacheSizeNotifier,
                              builder: (context, cacheSize, child) => Text(
                                cacheSize == '0 B' ? "Free up  0 Bytes of space" : "Free up  $cacheSize of space",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: color.pfont2,
                                  fontFamily: font,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Icon(
                          Icons.delete,
                          color: white3,
                        )
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {},
                  child: Container(
                    padding: const EdgeInsets.all(12.0),
                    width: w,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Design Save TO",
                          style: TextStyle(fontSize: 18, color: color.pfont, fontFamily: font, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        Text(
                          "/Storage/emulated/0/Pictures/wallpaper",
                          style: TextStyle(
                            fontSize: 14,
                            color: color.pfont2,
                            fontFamily: font,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {},
                  child: Container(
                    padding: const EdgeInsets.all(12.0),
                    width: w,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Copyright information",
                          style: TextStyle(fontSize: 18, color: color.pfont, fontFamily: font, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        Text(
                          "All Designs that are available in the App are free and it's credit goes to their respective owners. These Designs are licensed under the Creative Commons Zero (CCO) license. Please contact us if you find any Design that violates any rules and we will remove the Design.",
                          style: TextStyle(
                            fontSize: 14,
                            color: color.pfont2,
                            fontFamily: font,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {},
                  child: Container(
                    padding: const EdgeInsets.all(12.0),
                    width: w,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Privacy Policy",
                          style: TextStyle(fontSize: 18, color: color.pfont, fontFamily: font, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        Text(
                          "App Terms & Policies",
                          style: TextStyle(
                            fontSize: 14,
                            color: color.pfont2,
                            fontFamily: font,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {},
                  child: Container(
                    padding: const EdgeInsets.all(12.0),
                    width: w,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "About",
                          style: TextStyle(fontSize: 18, color: color.pfont, fontFamily: font, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        Text(
                          "App info & build version",
                          style: TextStyle(
                            fontSize: 14,
                            color: color.pfont2,
                            fontFamily: font,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ]),
              isDownloading
                  ? Container(
                      height: h,
                      width: w,
                      color: black.withOpacity(0.3),
                    )
                  : Container(),
              isDownloading
                  ? Positioned(
                      top: h / 4,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(30.0),
                          child: Container(
                            padding: const EdgeInsets.all(8.0),
                            decoration: BoxDecoration(color: color.pMenuColor, borderRadius: BorderRadius.circular(10)),
                            // height: h / 6,
                            width: w,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Text(
                                    "Clearing Cache.",
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: color.pfont,
                                      fontFamily: font,
                                    ),
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Spacer(),
                                    CircularProgressIndicator(color: navSelect, strokeWidth: 5),
                                    Spacer(
                                      flex: 2,
                                    ),
                                    Text(
                                      "Please waite...",
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: color.pfont,
                                        fontFamily: font,
                                      ),
                                    ),
                                    Spacer(
                                      flex: 5,
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 20,
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
                  : SizedBox()
            ],
          ),
        ),
      ),
    );
  }

  cachestatus() async {
    setState(() {
      isDownloading = true;
    });
    cacheManager.clearCache();

    await Future.delayed(Duration(seconds: 1)).then((value) {
      updateCacheSize();
      setState(() {
        isDownloading = false;
      });
    });
  }

  cacheClear() {
    showDialog(
      context: context,
      builder: (context) => Consumer<ProviderS>(
          builder: (context, color, child) => StatefulBuilder(builder: (context, setState) {
                return AlertDialog(
                  backgroundColor: color.pMenuColor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
                  actionsPadding: EdgeInsets.all(0),
                  actions: [
                    TextButton(
                        onPressed: () async {
                          Navigator.pop(context);
                        },
                        child: Text("CANCEL", style: TextStyle(color: color.pfont, fontSize: 13))),
                    TextButton(
                        onPressed: () async {
                          setState(() {
                            isDownloading = true;
                          });
                          cachestatus();
                          Navigator.pop(context);
                        },
                        child: Text("YES", style: TextStyle(color: color.pfont, fontSize: 13)))
                  ],
                  content: Column(mainAxisSize: MainAxisSize.min, children: [
                    SizedBox(
                      height: 15,
                    ),
                    Text("Are you sure want to clear cache ?", style: TextStyle(color: color.pfont, fontSize: 18))
                  ]),
                );
              })),
    );
  }

  changeColum() {
    content:
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return Consumer<ProviderS>(
            builder: (context, color, child) => AlertDialog(
              insetPadding: EdgeInsets.all(25),
              contentPadding: EdgeInsets.all(12),
              backgroundColor: color.pMenuColor, actionsPadding: EdgeInsets.all(8),
              actions: [
                TextButton(
                    onPressed: () async {
                      Navigator.pop(context);
                    },
                    child: Text("OK", style: TextStyle(color: color.pfont, fontSize: 13)))
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
                      child: Text("Display Design", style: TextStyle(color: color.pfont, fontSize: 20)),
                    ),
                    ListTile(
                      contentPadding: EdgeInsets.symmetric(horizontal: 12),
                      title: Text('2 Columns', style: TextStyle(color: color.pfont, fontSize: 18)),
                      leading: Radio<int>(
                        value: 2,
                        groupValue: columnindex,
                        onChanged: (int? value) async {
                          setState(() {
                            columnindex = value;
                            print("Selected Option: $columnindex");
                          });
                          await SqlDb().updateData('update mood set colum ="2"');
                          Provider.of<ProviderS>(context, listen: false).columnIndex = 2;
                          data();
                        },
                      ),
                    ),
                    ListTile(
                      contentPadding: EdgeInsets.symmetric(horizontal: 12),
                      title: Text(
                        '3 Columns',
                        style: TextStyle(color: color.pfont, fontSize: 18),
                      ),
                      leading: Radio<int>(
                        value: 3,
                        groupValue: columnindex,
                        onChanged: (int? value) async {
                          await SqlDb().updateData('update mood set colum ="3"');
                          Provider.of<ProviderS>(context, listen: false).columnIndex = 3;
                          data();
                          setState(() {
                            columnindex = value;
                            print("Selected Option: $columnindex");
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),

              // Set the default value here
            ),
          );
        });
      },
    );
  }
}

mixin CacheMixin on State<Settings> {
  late final SimpleAppCacheManager cacheManager;
  late ValueNotifier<String> cacheSizeNotifier = ValueNotifier<String>('');

  @override
  void initState() {
    super.initState();
    cacheManager = SimpleAppCacheManager();
    updateCacheSize();
  }

  void updateCacheSize() async {
    final cacheSize = await cacheManager.getTotalCacheSize();
    cacheSizeNotifier.value = cacheSize;
  }
}
