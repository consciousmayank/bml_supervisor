import 'package:bml_supervisor/app_level/generalised_base_view_model.dart';
import 'package:bml_supervisor/models/get_distributors_response.dart';
import 'package:bml_supervisor/utils/widget_utils.dart';
import 'package:dio/dio.dart';

class ArrangeHubsViewModel extends GeneralisedBaseViewModel {
  bool _isReturnList = false;

  bool get isReturnList => _isReturnList;

  set isReturnList(bool value) {
    notifyListeners();
    _isReturnList = value;
  }

  List<GetDistributorsResponse> _selectedSourceHubList;

  List<GetDistributorsResponse> get selectedSourceHubList =>
      _selectedSourceHubList;

  set selectedSourceHubList(List<GetDistributorsResponse> value) {
    _selectedSourceHubList = value;
    notifyListeners();
  }

  List<GetDistributorsResponse> _selectedHubList;

  List<GetDistributorsResponse> get selectedHubList => _selectedHubList;

  set selectedHubList(List<GetDistributorsResponse> value) {
    _selectedHubList = value;
    notifyListeners();
  }

  List<GetDistributorsResponse> _selectedReturningHubsList = [];

  List<GetDistributorsResponse> get selectedReturningHubsList =>
      _selectedReturningHubsList;

  set selectedReturningHubsList(List<GetDistributorsResponse> value) {
    _selectedReturningHubsList = value;
    notifyListeners();
  }

  void createReturningList({List<GetDistributorsResponse> list}) {
    selectedReturningHubsList = copyList(list);

    selectedReturningHubsList = List.from(selectedReturningHubsList.reversed);
    selectedReturningHubsList.removeAt(0);
    selectedHubList.addAll(selectedReturningHubsList);
    // print('create');
    // print('selected hub list length: ${selectedHubList.length}');
    notifyListeners();
  }

  void removeReturningList() {
    // print('source list length: ${selectedSourceHubList.length}');
    selectedReturningHubsList = [];
    // try {
    //   selectedHubList.removeRange(
    //       selectedSourceHubList.length-1, selectedReturningHubsList.length);
    //   print('asdf');
    //   print('remove');
    //   print('selected hub list length: ${selectedHubList.length}');
    // } on Error catch (e) {
    //   // snackBarService.showSnackbar(message: e.message.toString());
    // }

    List<int> temp = [];

    for (int i = selectedHubList.length - 1;
        i > (selectedHubList.length / 2).floor();
        i--) {
      /// if current id exists then remove the current id
      for (int j = 0; j < selectedHubList.length; j++) {
        if (selectedHubList[i].id == selectedHubList[j].id) {
          // selectedHubList.removeAt(i);
          print(i);
          temp.add(i);
          break;
        }
      }
      // selectedHubList.forEach((element) {
      //   if (selectedHubList[i].id == element.id) {
      //     // selectedHubList.removeAt(i);
      //     print(i);
      //     temp.add(i);
      //     break;
      //   }
      // });
    }
    print(temp);

    temp.forEach((element) {
      // print(temp);
      selectedHubList.removeAt(element);
    });

    notifyListeners();

    // selectedHubList.forEach((element) {
    //
    //
    //
    //   if(selectedHubList[i].id == element.id){
    //     selectedHubList.removeAt(i);
    //   }
    // });

    // notifyListeners();
  }
}
