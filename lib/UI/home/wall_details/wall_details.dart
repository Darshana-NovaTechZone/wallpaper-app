import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/material.dart';



import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:scroll_app_bar_2_0_0_custom_fix/scroll_app_bar.dart';
import 'package:wall_app/Color/color.dart';
import 'package:wall_app/UI/home/wall_details/single_img.dart';

import '../../../font/font.dart';
import '../../../provider/all_provider.dart';
import '../add/ad.dart';

class WallDetails extends StatefulWidget {
  const WallDetails({super.key});

  @override
  State<WallDetails> createState() => _WallDetailsState();
}

class _WallDetailsState extends State<WallDetails> {
  final controller = ScrollController();
  GlobalKey<ScaffoldState> scaffoldState = GlobalKey();
  late AdmobInterstitial interstitialAd;
  late AdmobReward rewardAd;
  AdmobBannerSize? bannerSize;
  List<Map<String, String>> firstItems = [];
  List<Map<String, String>> secondItems = [];
  // NativeAd? nativeAd;
  bool _nativeAdIsLoaded = false;

  // TODO: replace this test ad unit with your own ad unit.
  final String _adUnitId = 'ca-app-pub-3940256099942544/2247696110';

  /// Loads a native ad.
  // void loadAd() {
  //   nativeAd = NativeAd(
  //       adUnitId: _adUnitId,
  //       listener: NativeAdListener(
  //         onAdLoaded: (ad) {
  //           debugPrint('$NativeAd loaded.');
  //           setState(() {
  //             _nativeAdIsLoaded = true;
  //           });
  //         },
  //         onAdFailedToLoad: (ad, error) {
  //           // Dispose the ad here to free resources.
  //           debugPrint('$NativeAd failed to load: $error');
  //           ad.dispose();
  //         },
  //       ),
  //       request: const AdRequest(),
  //       // Styling
  //       nativeTemplateStyle: NativeTemplateStyle(
  //           // Required: Choose a template.
  //           templateType: TemplateType.medium,
  //           // Optional: Customize the ad's style.
  //           mainBackgroundColor: Colors.purple,
  //           cornerRadius: 10.0,
  //           callToActionTextStyle:
  //               NativeTemplateTextStyle(textColor: Colors.cyan, backgroundColor: Colors.red, style: NativeTemplateFontStyle.monospace, size: 16.0),
  //           primaryTextStyle:
  //               NativeTemplateTextStyle(textColor: Colors.red, backgroundColor: Colors.cyan, style: NativeTemplateFontStyle.italic, size: 16.0),
  //           secondaryTextStyle:
  //               NativeTemplateTextStyle(textColor: Colors.green, backgroundColor: Colors.black, style: NativeTemplateFontStyle.bold, size: 16.0),
  //           tertiaryTextStyle:
  //               NativeTemplateTextStyle(textColor: Colors.brown, backgroundColor: Colors.amber, style: NativeTemplateFontStyle.normal, size: 16.0)))
  //     ..load();
  // }

  @override
  void initState() {
    main();
    // loadAd();
    bannerSize = AdmobBannerSize.LARGE_BANNER;
    super.initState();
  }

  void main() {
    List<Map<String, String>> img = [
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
      {"name": "assets/1.PNG"},
      {"name": "assets/2.PNG"},
      {"name": "assets/3.PNG"},
      {"name": "assets/5.PNG"},
      {"name": "assets/5.PNG"},
      {"name": "assets/8.PNG"},
      {"name": "assets/9.PNG"},
    ];

    List<Map<String, String>> firstFourItems = img.sublist(0, 9);
    List<Map<String, String>> remainingItems = img.sublist(9);

    setState(() {
      firstItems = firstFourItems;
      secondItems = remainingItems;
    });
  }

  ScrollController _controller = ScrollController();
  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    return Consumer<ProviderS>(
      builder: (context, color, child) => Scaffold(
        key: scaffoldState,
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
          controller: _controller,
          child: Column(
            children: [
              // ConstrainedBox(
              //   constraints: const BoxConstraints(
              //     minWidth: 320, // minimum recommended width
              //     minHeight: 320, // minimum recommended height
              //     maxWidth: 400,
              //     maxHeight: 400,
              //   ),
              //   child: AdWidget(ad: nativeAd!),
              // ),
              ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: 4,
                itemBuilder: (context, index) {
                  print(index);
                  return index == 0
                      ? Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: GridView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: firstItems.length,
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: color.columnIndex, mainAxisExtent: h / 4, crossAxisSpacing: 8, mainAxisSpacing: 8),
                            itemBuilder: (context, index) {
                              // Check if it's time to show a full-width container

                              return InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    PageTransition(
                                        type: PageTransitionType.rightToLeft,
                                        child: SingleImage(singleImg: firstItems[index]['name'].toString(), img: firstItems, index: index),
                                        inheritTheme: true,
                                        ctx: context),
                                  );
                                },
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: Image.asset(
                                    firstItems[index]['name'].toString(),
                                    width: w,
                                    height: h,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              );
                            },
                          ),
                        )
                      : index == 1
                          ? Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              child: Card(
                                color: Color.fromARGB(255, 45, 45, 45),
                                child: Container(
                                  padding: EdgeInsets.all(8),
                                  alignment: Alignment.center,
                                  width: w,
                                  margin: EdgeInsets.only(bottom: 20.0),
                                  child: AdmobBanner(
                                    adUnitId: getBannerAdUnitId()!,
                                    adSize: bannerSize!,
                                    listener: (AdmobAdEvent event, Map<String, dynamic>? args) {},
                                    onBannerCreated: (AdmobBannerController controller) {},
                                  ),
                                ),
                              ),
                            )
                          : Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: GridView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: secondItems.length,
                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: color.columnIndex, mainAxisExtent: h / 4, crossAxisSpacing: 8, mainAxisSpacing: 8),
                                itemBuilder: (context, index) {
                                  // Check if it's time to show a full-width container

                                  return InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        PageTransition(
                                            type: PageTransitionType.rightToLeft,
                                            child: SingleImage(singleImg: secondItems[index]['name'].toString(), img: secondItems, index: index),
                                            inheritTheme: true,
                                            ctx: context),
                                      );
                                    },
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(15),
                                      child: Image.asset(
                                        secondItems[index]['name'].toString(),
                                        width: w,
                                        height: h,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
