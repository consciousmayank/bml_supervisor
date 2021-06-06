import 'package:bml_supervisor/services/api_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import 'locator.dart';

class GeneralisedIndexTrackingViewModel extends IndexTrackingViewModel {
  ApiService apiService = locator<ApiService>();
  SnackbarService snackBarService = locator<SnackbarService>();
  NavigationService navigationService = locator<NavigationService>();
}
