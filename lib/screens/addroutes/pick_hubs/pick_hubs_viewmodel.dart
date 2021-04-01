import 'package:bml_supervisor/app_level/generalised_base_view_model.dart';
import 'package:bml_supervisor/models/get_distributors_response.dart';
import 'package:bml_supervisor/utils/widget_utils.dart';
import 'package:flutter/material.dart';

class PickHubsViewModel extends GeneralisedBaseViewModel {
  int _currentStep = 0;

  List<GetDistributorsResponse> _selectedHubsList = [];
  List<GetDistributorsResponse> _completeHubsList = [];
  List<TextEditingController> kilometerController = [];

  List<GetDistributorsResponse> get selectedHubsList => _selectedHubsList;

  set selectedHubsList(List<GetDistributorsResponse> value) {
    _selectedHubsList = value;
    notifyListeners();
  }

  List<GetDistributorsResponse> get completeHubsList => _completeHubsList;

  set completeHubsList(List<GetDistributorsResponse> value) {
    _completeHubsList = value;
  }

  int get currentStep => _currentStep;

  set currentStep(int value) {
    _currentStep = value;
    notifyListeners();
  }

  List<String> getHubNameForAutoComplete(
      List<GetDistributorsResponse> hubsList) {
    List<String> hubNames = [];
    hubsList.forEach((element) {
      hubNames.add(element.title);
    });
    return hubNames;
  }

  void takeToAddRoutesPage(List<GetDistributorsResponse> newHubsList) {
    navigationService.back(result: newHubsList);
  }

  setCompleteHubList(List<GetDistributorsResponse> hubsList) {
    completeHubsList = copyList(hubsList);
  }
}
