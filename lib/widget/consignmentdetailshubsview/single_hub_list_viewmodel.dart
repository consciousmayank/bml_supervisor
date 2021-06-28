import 'package:bml_supervisor/app_level/generalised_base_view_model.dart';
import 'package:bml_supervisor/models/hub_data_response.dart';

class SingleHubListViewModel extends GeneralisedBaseViewModel {
  HubResponse _hubDetails;

  HubResponse get hubDetails => _hubDetails;

  set hubDetails(HubResponse value) {
    _hubDetails = value;
    notifyListeners();
  }

// getHubDate(int hubId) async{
//   var response = await apiService.getHubData(hubId);
//
//   if(response is String){
//     snackBarService.showSnackbar(message: response);
//   }else{
//
//     Response apiResponse = response;
//     hubDetails = HubResponse.fromMap(apiResponse.data);
//   }
// }
}
