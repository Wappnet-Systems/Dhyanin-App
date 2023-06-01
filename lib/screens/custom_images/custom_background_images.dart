import 'dart:io';

import 'package:dhyanin_app/services/providers/colors_theme_provider.dart';
import 'package:dhyanin_app/utils/styles.dart';
import 'package:dhyanin_app/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/images.dart';
import '../../widgets/custom_snackbar.dart';
import '../../widgets/list_drawer.dart';

class CustomBackgroundImages extends StatefulWidget {
  const CustomBackgroundImages({super.key});

  @override
  State<CustomBackgroundImages> createState() => _CustomBackgroundImagesState();
}

class _CustomBackgroundImagesState extends State<CustomBackgroundImages> {
  late String lottiePath;

  @override
  void initState() {
    ColorsThemeNotifier model =
        Provider.of<ColorsThemeNotifier>(context, listen: false);
    if (model.primaryColor == Color(0xffDE0CA3)) {
      lottiePath = emptyHistoryListPink;
    } else if (model.primaryColor == Color(0xFFF44336)) {
      lottiePath = emptyHistoryListRed;
    } else if (model.primaryColor == Color(0xFF4CAF50)) {
      lottiePath = emptyHistoryListGreen;
    } else if (model.primaryColor == Color(0xFF2196F3)) {
      lottiePath = emptyHistoryListBlue;
    } else {
      lottiePath = emptyHistoryListPurple;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ColorsThemeNotifier model =
        Provider.of<ColorsThemeNotifier>(context, listen: true);
    return Container(
      decoration: topLeftToBottomRightGradient(model),
      child: Scaffold(
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(right: 8.0, bottom: 8.0),
          child: FloatingActionButton(
            backgroundColor: model.secondaryColor2,
            child: Icon(Icons.add),
            onPressed: () {
              _selectImage(context);
            },
          ),
        ),
        appBar: CustomAppBar(title: "Custom Images"),
        body: savedImagePaths.length == 0
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Lottie.asset(lottiePath, width: 250),
                    Text(
                      'No Images Added yet!',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
              )
            : GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                ),
                shrinkWrap: true,
                itemCount: savedImagePaths.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 5.0),
                    child: Stack(children: [
                      Center(child: Image.file(File(savedImagePaths[index]))),
                      Positioned(
                        top: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text('Delete Image'),
                                    content: Text(
                                        'Are you sure you want to delete this image?'),
                                    actions: [
                                      MaterialButton(
                                        onPressed: () async {
                                          deleteImage(index);
                                          Navigator.of(context).pop();
                                        },
                                        child: Text("Yes"),
                                      ),
                                      MaterialButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text("No"),
                                      ),
                                    ],
                                    actionsAlignment: MainAxisAlignment.end,
                                  );
                                });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.red.shade700,
                            ),
                            padding: EdgeInsets.all(4.0),
                            child: Icon(
                              Icons.close,
                              color: Colors.white,
                              size: 16.0,
                            ),
                          ),
                        ),
                      ),
                    ]),
                  );
                },
              ),
      ),
    );
  }

  void deleteImage(int index) async {
    final imagePath = savedImagePaths[index];
    final imageFile = File(imagePath);
    if (await imageFile.exists()) {
      await imageFile.delete();
      setState(() {
        savedImagePaths.removeAt(index);
      });
      await saveImagePaths(savedImagePaths);
    }
  }

  void _selectImage(context) async {
    final imageFile = await pickImage();
    if (imageFile != null) {
      final localPath = await getLocalPath();
      final fileName = DateTime.now().millisecondsSinceEpoch.toString();
      final savedImagePath = '$localPath/$fileName.png';
      // setState(() {
      savedImagePaths.add(savedImagePath);
      // });
      await saveImagePaths(savedImagePaths);
      final savedImage = await imageFile.copy(savedImagePath);
      CustomSnackbar.functionSnackbar(context, "Added Image Successfully!");
    }
    if (mounted) {
      setState(() {});
    }
  }

  Future<String> getLocalPath() async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File?> pickImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      return File(pickedImage.path);
    }
    return null;
  }

  Future<void> saveImagePaths(List<String> imagePaths) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('savedImagePaths', imagePaths);
  }
}
