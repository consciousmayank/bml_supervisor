import 'package:bml_supervisor/app_level/locator.dart';
import 'package:bml_supervisor/services/api_service.dart';
import 'package:stacked_services/stacked_services.dart';

class BaseApi {
  SnackbarService snackBarService = locator<SnackbarService>();
  ApiService apiService = locator<ApiService>();
}
