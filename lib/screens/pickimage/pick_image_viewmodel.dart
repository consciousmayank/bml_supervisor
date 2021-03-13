import 'dart:convert';
import 'dart:io';
import 'dart:io' as Io;

import 'package:bml_supervisor/app_level/generalised_base_view_model.dart';

class PickImageViewModel extends GeneralisedBaseViewModel {
  String _imagePath = '', base64ImageString = '';
  File _selectedImageFile;

  File get selectedImageFile => _selectedImageFile;

  set selectedImageFile(File value) {
    _selectedImageFile = value;
  }

  String get imagePath => _imagePath;

  set imagePath(String value) {
    _imagePath = value;
    selectedImageFile = File(_imagePath);
    convert();
    notifyListeners();
  }

  void convert() {
    Io.File(imagePath).readAsBytes().then((value) {
      base64ImageString = base64Encode(value);
    });
    notifyListeners();
  }
}

String base64Encode(List<int> bytes) => base64.encode(bytes);
