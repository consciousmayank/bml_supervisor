import 'package:bml_supervisor/app_level/generalised_base_view_model.dart';
import 'package:bml_supervisor/models/get_distributors_response.dart';
import 'package:bml_supervisor/routes/routes_constants.dart';
import 'package:bml_supervisor/screens/addroutes/add_routes/add_routes_arguments.dart';
import 'package:bml_supervisor/screens/addroutes/arrangehubs/arrange_hubs_arguments.dart';

class PickHubsViewModel extends GeneralisedBaseViewModel {
  List<GetDistributorsResponse> _newHubsList = [];

  List<GetDistributorsResponse> get newHubsList => _newHubsList;

  set newHubsList(List<GetDistributorsResponse> value) {
    _newHubsList = value;
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
    // navigationService.navigateTo(addRoutesPageRoute,
    //     arguments: AddRoutesArguments(newHubsList: newHubsList));

    navigationService.navigateTo(arrangeHubsPageRoute, arguments: newHubsList);

    navigationService.navigateTo(addRoutesPageRoute, arguments: newHubsList);
  }

  void takeToArrangeHubs(List<GetDistributorsResponse> newHubsList) {
    print('goiing to arrange hubs');
    navigationService.navigateTo(arrangeHubsPageRoute,
        arguments: ArrangeHubsArguments(newHubsList: newHubsList));
  }
}
