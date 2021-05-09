import 'package:bml_supervisor/app_level/generalised_base_view_model.dart';
import 'package:bml_supervisor/models/get_distributors_response.dart';
import 'package:bml_supervisor/routes/routes_constants.dart';
import 'package:bml_supervisor/screens/addroutes/arrangehubs/arrange_hubs_arguments.dart';

class PickHubsViewModel extends GeneralisedBaseViewModel {
  List<GetDistributorsResponse> _selectedHubsList = [];

  List<GetDistributorsResponse> get selectedHubsList => _selectedHubsList;

  set selectedHubsList(List<GetDistributorsResponse> value) {
    _selectedHubsList = value;
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

  // void takeToAddRoutesPage(List<GetDistributorsResponse> newHubsList) {
  //   // navigationService.navigateTo(addRoutesPageRoute,
  //   //     arguments: AddRoutesArguments(newHubsList: newHubsList));
  //
  //   navigationService.navigateTo(arrangeHubsPageRoute, arguments: newHubsList);
  //   navigationService.navigateTo(addRoutesPageRoute, arguments: newHubsList);
  // }

  void takeToArrangeHubs(
      {List<GetDistributorsResponse> newHubsList,
      String remark,
      String title,
      int srcLocation,
      int dstLocation}) {
    navigationService.navigateTo(arrangeHubsPageRoute,
        arguments: ArrangeHubsArguments(
          newHubsList: newHubsList,
          routeTitle: title,
          remarks: remark,
          dstLocation: dstLocation,
          srcLocation: srcLocation,
        ));
  }
}
