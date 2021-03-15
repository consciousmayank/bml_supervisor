import 'dart:convert';
import 'dart:io';

import 'package:bml_supervisor/app_level/generalised_base_view_model.dart';
import 'package:flutter_native_image/flutter_native_image.dart';

class PickImageViewModel extends GeneralisedBaseViewModel {
  String _imagePath = '', base64ImageString = '';
  File _selectedImageFile;
  Function onImageSelected;

  File get selectedImageFile => _selectedImageFile;

  set selectedImageFile(File value) {
    _selectedImageFile = value;
  }

  String get imagePath => _imagePath;

  set imagePath(String value) {
    _imagePath = value;
    if (value.length > 0) {
      selectedImageFile = File(_imagePath);
      convert();
    }
  }

  void convert() async {
    File compressedFile = await FlutterNativeImage.compressImage(
      selectedImageFile.path,
      targetHeight: 300,
      targetWidth: 400,
      quality: 50,
      percentage: 20,
    );

    compressedFile.readAsBytes().then((value) {
      base64ImageString = base64Encode(value);
      onImageSelected('data:image/jpeg;base64, $base64ImageString');
    });
    notifyListeners();
  }

  void clearImage() {
    imagePath = '';
    notifyListeners();
  }

  setFunction(Function onImageSelected) {
    this.onImageSelected = onImageSelected;
  }
}

String base64Encode(List<int> bytes) => base64.encode(bytes);
