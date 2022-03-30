import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'alert_dialog.dart';
import 'bottom_picker_sheet.dart';
import 'diagnosis_history.dart';


class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final ImagePicker _picker = ImagePicker();
  late File _image;
  bool imageStatus = false;

  _imageFromCamera() async {
    final PickedFile? pickedImage = await _picker.getImage(source: ImageSource.camera, imageQuality: 50);
    if (pickedImage == null) {
      showAlertDialog(
          context: context,
          title: "Error Uploading!",
          content: "No image was selected.");
      return;
    }
    final File fileImage = File(pickedImage.path);

    if (imageConstraint(fileImage)) {
      setState(() {
        _image = fileImage;
        imageStatus = true;
      });
    }
  }

  _imageFromGallery() async {
    final PickedFile? pickedImage = await _picker.getImage(source: ImageSource.gallery, imageQuality: 50);
    if (pickedImage == null) {
      showAlertDialog(
          context: context,
          title: "Error Uploading!",
          content: "No Image was selected.");
      return;
    }
    final File fileImage = File(pickedImage.path);
    if (imageConstraint(fileImage)) {
      setState(() {
        _image = fileImage;
        imageStatus = true;
      });
    }
  }

  bool imageConstraint(File image) {
    if (!['bmp', 'jpg', 'jpeg']
        .contains(image.path.split('.').last.toString())) {
      showAlertDialog(
          context: context,
          title: "Error Uploading!",
          content: "Image format should be jpg/jpeg/bmp.");
      return false;
    }
    if (image.lengthSync() > 10000000) {
      showAlertDialog(
          context: context,
          title: "Error Uploading!",
          content: "Image Size should be less than 10MB.");
      return false;
    }
    return true;
  }

  // TODO: Lam need to split this method into a new class & and crop method for it
  Widget buildPreview(File image){
      return Image(image: FileImage(image));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home screen'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          // Display Progress Indicator if uploadStatus is true
          child: Padding(
            padding: const EdgeInsets.only(top: 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                (imageStatus == true) ? buildPreview(_image): const DiagnosisHistoryView(),
                const SizedBox(
                  height: 20,
                ),
                FloatingActionButton(
                  onPressed: () {
                    bottomPickerSheet(context, _imageFromCamera, _imageFromGallery);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


