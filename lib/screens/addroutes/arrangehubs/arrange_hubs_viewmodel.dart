import 'package:bml_supervisor/app_level/generalised_base_view_model.dart';
import 'package:bml_supervisor/app_level/locator.dart';
import 'package:bml_supervisor/app_level/shared_prefs.dart';
import 'package:bml_supervisor/models/ApiResponse.dart';
import 'package:bml_supervisor/models/create_route_request.dart';
import 'package:bml_supervisor/models/get_distributors_response.dart';
import 'package:bml_supervisor/screens/addroutes/add_routes_apis.dart';
import 'package:bml_supervisor/screens/addroutes/arrangehubs/arrange_hubs_arguments.dart';
import 'package:bml_supervisor/utils/stringutils.dart';
import 'package:bml_supervisor/utils/widget_utils.dart';
import 'package:dio/dio.dart';

class ArrangeHubsViewModel extends GeneralisedBaseViewModel {
  AddRoutesApis _routesApis = locator<AddRouteApisImpl>();
  final int sourceListLength;
  List<int> returnListIndexes = [];

  // final int srcDestinationHubId;

  ArrangeHubsViewModel({
    this.sourceListLength,
    this.selectedSourceHubList,
    // this.srcDestinationHubId,
  });

  bool _isReturnList = false;

  bool get isReturnList => _isReturnList;

  set isReturnList(bool value) {
    notifyListeners();
    _isReturnList = value;
  }

  final List<GetDistributorsResponse> selectedSourceHubList;

  // List<GetDistributorsResponse> get selectedSourceHubList =>
  //     _selectedSourceHubList;

  // set selectedSourceHubList(List<GetDistributorsResponse> value) {
  //   _selectedSourceHubList = value;
  //   notifyListeners();
  // }

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

  void createRoute(
      {String title, String remarks, int srcLocation, int dstLocation}) async{
    CreateRouteRequest request = CreateRouteRequest(
      title: title,
      remarks: remarks,
      srcLocation: srcLocation,
      dstLocation: dstLocation,
      clientId: MyPreferences().getSelectedClient().clientId,
      hubs: getHubsList(),
    );

    print('source hub list length: ${selectedSourceHubList.length}');
    print('source hub list length int: $sourceListLength');
    print('return hub list length: ${selectedReturningHubsList.length}');

    print('Request is ${request.toJson()}');
    ApiResponse _apiResponse =
        await _routesApis.addRoute(request: request);
    dialogService
        .showConfirmationDialog(
        title: _apiResponse.isSuccessful()
            ? addRouteSuccessful
            : addRouteUnSuccessful,
        description: _apiResponse.message,
        barrierDismissible: false)
        .then((value) {
      if (value.confirmed) {
        if (_apiResponse.isSuccessful()) {
          navigationService.back();
        }
      }
    });
  }

  List<Hub> getHubsList() {
    List<Hub> listOfHubsToBeAdded = [];
    listOfHubsToBeAdded.addAll(buildHubList(hubsList: selectedHubList));
    return listOfHubsToBeAdded;
  }

  List<Hub> buildHubList({List<GetDistributorsResponse> hubsList}) {
    List<Hub> listOfHubsToBeAdded = [];
    int count = 1;

    for (var singleSelectedHub in hubsList) {
      listOfHubsToBeAdded.add(
        Hub(
          hub: singleSelectedHub.id,
          kms: double.parse(singleSelectedHub.kiloMeters.toString()),
          flag: getProperFlag(
              hubsList.indexOf(singleSelectedHub), listOfHubsToBeAdded),
          sequence: count,
        ),
      );
      ++count;
    }

    return listOfHubsToBeAdded;
  }

  String getProperFlag(int index, List<Hub> listOfHubsToBeAdded) {
    bool isDestinationAdded = false;

    listOfHubsToBeAdded.forEach((element) {
      if (element.flag == 'D') {
        isDestinationAdded = true;
      }
    });

    if (isDestinationAdded) {
      return 'R';
    } else {
      if (index == sourceListLength - 1) {
        return 'D';
      } else {
        return 'S';
      }
    }
  }

  void removeReturningList() {
    selectedReturningHubsList = [];

    List<int> temp = [];

    for (int i = selectedHubList.length - 1;
        i > (selectedHubList.length / 2).floor();
        i--) {
      for (int j = 0; j < selectedHubList.length; j++) {
        if (selectedHubList[i].id == selectedHubList[j].id) {
          // selectedHubList.removeAt(i);
          // print(i);
          temp.add(i);
          break;
        }
      }
    }
    // print(temp);

    temp.forEach((element) {
      // print(temp);
      selectedHubList.removeAt(element);
    });

    notifyListeners();
  }


}
