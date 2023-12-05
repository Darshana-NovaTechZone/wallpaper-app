import 'dart:io';
import 'dart:math';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';

import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wall_app/Color/color.dart';
import 'package:wall_app/UI/navigation/navigation.dart';
import 'package:http/http.dart' as http;

import '../../../font/font.dart';

class SingleImage extends StatefulWidget {
  const SingleImage({super.key, required this.img, required this.index});
  final List img;
  final int index;

  @override
  State<SingleImage> createState() => _SingleImageState();
}

class _SingleImageState extends State<SingleImage> {
  final String imageUrl =
      "https://ss0.baidu.com/94o3dSag_xI4khGko9WTAnF6hhy/image/h%3D300/sign=a62e824376d98d1069d40a31113eb807/838ba61ea8d3fd1fc9c7b6853a4e251f94ca5f46.jpg";
  final String folderName = 'MyImages';
  bool isDownloading = false;
  static const _url =
      "https://ss0.baidu.com/94o3dSag_xI4khGko9WTAnF6hhy/image/h%3D300/sign=a62e824376d98d1069d40a31113eb807/838ba61ea8d3fd1fc9c7b6853a4e251f94ca5f46.jpg";
  var random = Random();
  List img = [];
  int selectedImg = 0;
  @override
  void initState() {
    print(widget.index);
    setState(() {
      img = widget.img;
      selectedImg = widget.index;
    });
    super.initState();
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
                    autoPlay: false,
                    viewportFraction: 1,
                    initialPage: selectedImg,
                    height: h,
                  ),
                  itemBuilder: (context, index, realIdx) {
                    return Stack(
                      children: [
                        Image.asset(img[index], fit: BoxFit.cover, height: h, width: w),
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
                      onPressed: () {},
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
                          info();
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
                          saveImage();
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
                          try {
                            Uint8List imageBytes = await downloadImage(imageUrl);
                            String imageName = 'my_image.jpg'; // You can change the name as needed
                            await saveImageToGallery(imageBytes, folderName, imageName);
                            // Add any additional logic or UI updates after saving the image
                          } catch (e) {
                            print('Error: $e');
                          }
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
                          _saveImage(context);
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Container(
                              height: h / 14,
                              width: w / 4,
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.favorite_border,
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
                              "Saving Design...",
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

  Future<void> downloadAndSaveImagee() async {
    late http.Client client;
    late String imageUrl;
    client = http.Client();
    // Replace the URL with the actual image URL you want to download and save
    imageUrl =
        "https://ss0.baidu.com/94o3dSag_xI4khGko9WTAnF6hhy/image/h%3D300/sign=a62e824376d98d1069d40a31113eb807/838ba61ea8d3fd1fc9c7b6853a4e251f94ca5f46.jpg";
    ;
    try {
      final response = await client.get(Uri.parse(imageUrl));

      if (response.statusCode == 200) {
        final Uint8List bytes = response.bodyBytes;
        final appDocDir = await getApplicationDocumentsDirectory();
        final String appDocPath = appDocDir.path;
        final String imagePath = '$appDocPath/imagefolder';

        // Create the image folder if it doesn't exist
        await Directory(imagePath).create(recursive: true);

        // Save the image to the image folder
        final File imageFile = File('$imagePath/image.jpg');
        await imageFile.writeAsBytes(bytes);

        print('Image downloaded and saved to $imagePath');
      } else {
        print('Failed to download image: ${response.statusCode}');
      }
    } catch (e) {
      print('Error downloading image: $e');
    } finally {
      client.close();
    }
  }

  Future<void> saveImageToGallery(Uint8List imageBytes, String folderName, String imageName) async {
    final directory = await getApplicationDocumentsDirectory();
    final folderPath = '${directory!.path}/hello';

    await Directory(folderPath).create(recursive: true);

    final imagePath = '$folderPath/$imageName';
    await File(imagePath).writeAsBytes(imageBytes);

    await ImageGallerySaver.saveFile(imagePath);
    print(imagePath);
  }

  Future<Uint8List> downloadImage(String imageUrl) async {
    final response = await http.get(Uri.parse(imageUrl));

    if (response.statusCode == 200) {
      print(response.bodyBytes);
      return response.bodyBytes;
    } else {
      throw Exception('Failed to load image');
    }
  }

  saveImage() async {
    var url =
        "https://ss0.baidu.com/94o3dSag_xI4khGko9WTAnF6hhy/image/h%3D300/sign=a62e824376d98d1069d40a31113eb807/838ba61ea8d3fd1fc9c7b6853a4e251f94ca5f46.jpg";
    var response = await Dio().get(url, options: Options(responseType: ResponseType.bytes));
    final result = await ImageGallerySaver.saveImage(Uint8List.fromList(response.data), quality: 100, name: DateTime.now().microsecond.toString());
    print(result);
  }

  Future<void> downloadAndSaveImage() async {
    var ur =
        "https://ss0.baidu.com/94o3dSag_xI4khGko9WTAnF6hhy/image/h%3D300/sign=a62e824376d98d1069d40a31113eb807/838ba61ea8d3fd1fc9c7b6853a4e251f94ca5f46.jpg";
    final response = await http.get(Uri.parse(ur));

    var tempDir = await getTemporaryDirectory();
    var tempDirPath = tempDir.path;
    final myAppPath = '$tempDirPath/my_app';
    final res = await Directory(myAppPath).create(recursive: true);

    if (response.statusCode == 200) {
      final fileName = DateTime.now().microsecond;
      final filePath = '${res.path}/$fileName';

      final File file = File(filePath);
      await file.writeAsBytes(Uint8List.fromList(response.bodyBytes));

      print('Image downloaded and saved to: $filePath');
    } else {
      print('Failed to download image. Status code: ${response.statusCode}');
    }
  }

  _saveNetworkImage() async {
    final directory = await getExternalStorageDirectory();
    final myimagepath = '${directory!.path}/myimages';
    final myimgdir = await new Directory(myimagepath).create();
  }

  info() {
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

  Future<void> _saveImage(BuildContext context) async {
    setState(() {
      isDownloading = true;
    });
    final directory = await getExternalStorageDirectory();
    final myImagePath = '${directory!.path}/Relaxing Wallpaper HD';
    final myImgDir = await new Directory(myImagePath).create(recursive: true);
    print(myImgDir);
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    late String message;

    try {
      // Download image
      final http.Response response = await http.get(Uri.parse(_url));

      // Get temporary directory
      final dir = await getTemporaryDirectory();

      // Create an image name
      var filename = '${myImgDir.path}/Relaxing Wallpaper${random.nextInt(100)}.png';
      print(filename);
      // Save to filesystem
      final file = File(filename);
      await file.writeAsBytes(response.bodyBytes);

      // Ask the user to save it
      final params = SaveFileDialogParams(sourceFilePath: file.path);
      final finalPath = await FlutterFileDialog.saveFile(params: params);

      if (finalPath != null) {
        message = 'Image saved ';
      }
    } catch (e) {
      message = e.toString();
      scaffoldMessenger.showSnackBar(SnackBar(
        content: Text(
          message,
          style: TextStyle(
            fontSize: 12,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: menuD,
      ));
    }

    if (message != null) {
      scaffoldMessenger.showSnackBar(SnackBar(
        content: Text(
          message,
          style: TextStyle(
            fontSize: 12,
            color: Color.fromARGB(255, 218, 210, 210),
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: menuD,
      ));
    }
    setState(() {
      isDownloading = false;
    });
  }
}
