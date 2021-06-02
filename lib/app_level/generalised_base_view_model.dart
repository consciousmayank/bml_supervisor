import 'package:bml_supervisor/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import 'locator.dart';

class GeneralisedBaseViewModel extends BaseViewModel {
  bool isFloatingActionButtonVisible = true;
  ApiService apiService = locator<ApiService>();
  SnackbarService snackBarService = locator<SnackbarService>();
  NavigationService navigationService = locator<NavigationService>();
  BottomSheetService bottomSheetService = locator<BottomSheetService>();

  void hideFloatingActionButton() {
    isFloatingActionButtonVisible = false;
    notifyListeners();
  }

  void showFloatingActionButton() {
    isFloatingActionButtonVisible = true;
    notifyListeners();
  }
}
