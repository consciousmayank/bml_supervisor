import 'package:bml_supervisor/app_level/BaseApi.dart';
import 'package:bml_supervisor/app_level/configuration.dart';
import 'package:bml_supervisor/main/app_configs.dart';
import 'package:bml_supervisor/models/app_versioning_request.dart';
import 'package:bml_supervisor/models/app_versioning_response.dart';
import 'package:bml_supervisor/models/parent_api_response.dart';

abstract class AppStartApis {
  Future<AppVersioningResponse> getAppVersions();
}

class AppStartApiImpl extends BaseApi implements AppStartApis {
  @override
  Future<AppVersioningResponse> getAppVersions() async {
    AppVersioningResponse _response;
    ParentApiResponse _apiresonse = await apiService.getAppVersions(
      request: AppVersioningRequest(appName: AppConfigs.APP_NAME),
    );

    if (filterResponse(_apiresonse) != null) {
      _response = AppVersioningResponse.fromMap(_apiresonse.response.data);
    }
    return _response;
  }
}
