import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import 'package:flutter_svg/svg.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

enum ImageSourceType { gallery, camera }

class ImagePickerWidgets extends StatefulWidget {
  late Function(File) onImageSelected;
  final bool? camera;
  final bool? gallery;
  final bool? pdf;

  ImagePickerWidgets({super.key,  required this.onImageSelected, this.camera = true,this.gallery = true,this.pdf = false});

  @override
  State<ImagePickerWidgets> createState() => _ImagePickerWidgetsState();
}

class _ImagePickerWidgetsState extends State<ImagePickerWidgets> {
  var imagePicker;

  Future<void> _handleURLButtonPress(BuildContext context, var type) async {
    var source = (type == ImageSourceType.camera) ? ImageSource.camera : ImageSource.gallery;

    XFile image = await imagePicker.pickImage(source: source, imageQuality: 50, preferredCameraDevice: CameraDevice.front);
    if (image != null) {
      CroppedFile? croppedFile = await ImageCropper().cropImage(
        sourcePath: image.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9
        ],
        uiSettings: [
          AndroidUiSettings(
              toolbarTitle: 'Cropper',
              toolbarColor: Colors.deepOrange,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false),
          IOSUiSettings(
            title: 'Cropper',
          ),
          WebUiSettings(
            context: context,
          ),
        ],
      );

      if (croppedFile != null) {
        // Handle the cropped image file (convert CroppedFile to File if needed)
        File? croppedImageFile = croppedFileToFile(croppedFile);
        if (croppedImageFile != null) {
          // Use the cropped image file (e.g., display or upload)
          print('Cropped image path: ${croppedImageFile.path}');
          //  Navigator.of(context).pop(croppedImageFile);
          widget.onImageSelected(croppedImageFile);
        }
      } else {
        // Crop operation was canceled
        print('Crop operation canceled');
      }
    }

  }




  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(40),
      child: Container(
        height: 100,
        width: double.infinity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Spacer(),
            widget.camera!?
            Container(
              child: GestureDetector(
                onTap: () async {
                  Navigator.pop(context);
                  print("click Camera");

                  var status = await Permission.camera.status;
                  if (status.isPermanentlyDenied) {
                    openAppSettings();
                  }else {
                    _handleURLButtonPress(context, ImageSourceType.camera);
                  }

                },
                child: Column(
                  children: [
                    SvgPicture.asset(
                      'assets/icons/ic_camera.svg',
                      width: 50,
                      height: 50,
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Camera",
                      style: TextStyle(color: Colors.black),
                    )
                  ],
                ),
              ),
            ):Container(),
            widget.camera!?Spacer(): Container(),
            widget.gallery!?
            Container(
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                  print("Click Gallery");
                  _handleURLButtonPress(context, ImageSourceType.gallery);
                },
                child: Column(
                  children: [
                    SvgPicture.asset(
                      'assets/icons/ic_gallery.svg',
                      width: 50,
                      height: 50,
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Gallery",
                      style: TextStyle(color: Colors.black),
                    )
                  ],
                ),
              ),
            ):Container(),
            widget.gallery!?Spacer(): Container(),
            widget.pdf!?
            Container(
              child: GestureDetector(
                onTap: () async {
                  Navigator.pop(context);
                  print("File");
                  FilePickerResult? result = await FilePicker.platform.pickFiles();
                  if (result != null) {
                    File file = File(result.files.single.path!);
                    print("filePath-${file.path}");
                    widget.onImageSelected(file);
                  } else {
                    // User canceled the picker
                  }
                },
                child: Column(
                  children: [
                    SvgPicture.asset(
                      'assets/icons/ic_file.svg',
                      width: 50,
                      height: 50,
                    ),
                    SizedBox(height: 10),
                    Text(
                      "File",
                      style: TextStyle(color: Colors.black),
                    )
                  ],
                ),
              ),
            ):Container(),
            widget.pdf!?Spacer(): Container(),
          ],
        ),
      ),
    );


  }



  @override
  void initState() {
    super.initState();
    imagePicker = ImagePicker();
  }
  File? croppedFileToFile(CroppedFile? croppedFile) {
    if (croppedFile == null) {
      return null;
    }
    return File(croppedFile.path);
  }

}
