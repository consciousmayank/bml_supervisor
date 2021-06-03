import 'package:bml_supervisor/app_level/generalised_base_view_model.dart';
import 'package:bml_supervisor/app_level/locator.dart';
import 'package:bml_supervisor/app_level/setup_bottomsheet_ui.dart';
import 'package:bml_supervisor/enums/bottomsheet_type.dart';
import 'package:bml_supervisor/models/ApiResponse.dart';
import 'package:bml_supervisor/models/save_payment_request.dart';
import 'package:bml_supervisor/routes/routes_constants.dart';
import 'package:bml_supervisor/screens/payments/payments_apis.dart';
import 'package:bml_supervisor/utils/stringutils.dart';

class AddPaymentViewModel extends GeneralisedBaseViewModel {
  PaymentsApis _paymentsApis = locator<PaymentsApisImpl>();
  DateTime _entryDate;

  DateTime get entryDate => _entryDate;

  set entryDate(DateTime registrationDate) {
    _entryDate = registrationDate;
    notifyListeners();
  }

  Future addNewPayment(SavePaymentRequest savePaymentRequest) async {
    setBusy(true);
    ApiResponse _apiResponse = await _paymentsApis.addNewPayment(
        savePaymentRequest: savePaymentRequest);
    // snackBarService.showSnackbar(message: _apiResponse.message);
    bottomSheetService
        .showCustomSheet(
      customData: ConfirmationBottomSheetInputArgs(
          title: _apiResponse.isSuccessful()
              ? addPaymentSuccessful
              : addPaymentUnSuccessful,
          description: _apiResponse?.message ?? null),
      barrierDismissible: false,
      isScrollControlled: true,
      variant: BottomSheetType.CONFIRMATION_BOTTOM_SHEET,
    )
        .then((value) {
      if (_apiResponse.isSuccessful()) {
        navigationService.replaceWith(addPaymentPageRoute);
      }
    });
    setBusy(false);
  }
}
