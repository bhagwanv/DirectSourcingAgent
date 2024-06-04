import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import '../../utils/constant.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({Key? key, required this.cameras}) : super(key: key);

  final List<CameraDescription>? cameras;

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  late CameraController _cameraController;
  bool _isRearCameraSelected = false;
  File? _imageFile;

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    initCamera(widget.cameras![1]);
  }

  Future<void> _pickImage(File pickedImage) async {

  }



  Future takePicture() async {
    if (!_cameraController.value.isInitialized) {
      return null;
    }
    if (_cameraController.value.isTakingPicture) {
      return null;
    }
    try {
      await _cameraController.setFlashMode(FlashMode.off);
      XFile picture = await _cameraController.takePicture();
     //  File file = File(picture!.path);
     // // Navigator.of(context).pop(picture);
     //
     //  _pickImage(file);

      CroppedFile? croppedFile = await ImageCropper().cropImage(
        sourcePath: picture.path,
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
          Navigator.of(context).pop(croppedImageFile);
        }
      } else {
        // Crop operation was canceled
        print('Crop operation canceled');
      }
      // if(croppedFile!=null){
      //   Navigator.of(context).pop(croppedFile);
      // }

    } on CameraException catch (e) {
      debugPrint('Error occured while taking picture: $e');
      return null;
    }


  }

  Future initCamera(CameraDescription cameraDescription) async {
    _cameraController =
        CameraController(cameraDescription, ResolutionPreset.high);
    try {
      await _cameraController.initialize().then((_) {
        if (!mounted) return;
        setState(() {});
      });
    } on CameraException catch (e) {
      debugPrint("camera error $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: textFiledBackgroundColour,
        body: SafeArea(
      child: Stack(children: [
        (_cameraController.value.isInitialized)
            ? Center(
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.black87,
                      shape: BoxShape.rectangle,
                      border: Border.all(color: kPrimaryColor, width: 2),
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                          bottomLeft: Radius.circular(10))),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ClipOval(
                        child: Align(
                            heightFactor: 0.6,
                            widthFactor: 0.7,
                            child: CameraPreview(_cameraController))),
                  ),
                ),
              )
            : Container(
                color: Colors.black,
                child: const Center(child: CircularProgressIndicator())),
        Align(
            alignment: Alignment.bottomCenter,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 50),
                  child: Column(
                    children: [
                      Text(
                        'Take a Selfie !',
                        textAlign: TextAlign.start,
                        style: TextStyle(fontSize: 18, color: Colors.black,fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Please point the camera on your Face',
                        textAlign: TextAlign.start,
                        style: TextStyle(fontSize: 15, color: Colors.black),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 50),
                  child: SizedBox(
                    width: double.infinity,
                    child: IconButton(
                      onPressed: takePicture,
                      iconSize: 50,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      icon: SvgPicture.asset('assets/images/camera_click.svg'),
                    ),
                  ),
                ),
              ],
            ),),
      ]),
    ));
  }
  File? croppedFileToFile(CroppedFile? croppedFile) {
    if (croppedFile == null) {
      return null;
    }
    return File(croppedFile.path!);
}
}