import 'package:bml_supervisor/app_level/generalised_base_view_model.dart';
import 'package:bml_supervisor/models/consignment_detail_response_new.dart';
import 'package:bml/bml.dart';

class ConsignmentDetailsViewModel extends GeneralisedBaseViewModel {
  ConsignmentDetailResponseNew _consignmentDetailResponse;

  ConsignmentDetailResponseNew get consignmentDetailResponse =>
      _consignmentDetailResponse;

  set consignmentDetailResponse(ConsignmentDetailResponseNew value) {
    _consignmentDetailResponse = value;
    notifyListeners();
  }

  bool _isListViewSelected = true;

  String _consignmentId;

  String get consignmentId => _consignmentId;

  set consignmentId(String value) {
    _consignmentId = value;
    notifyListeners();
  }

  bool get isListViewSelected => _isListViewSelected;

  set isListViewSelected(bool value) {
    _isListViewSelected = value;
    notifyListeners();
  }

  List<int> uniqueHubIds = [];

  List<ItemForCard> newItems;

  void getConsignmentWithId(String consignmentId) async {
    setBusy(true);
    uniqueHubIds.clear();
    ParentApiResponse apiResponse =
        await apiService.getConsignmentWithId(consignmentId: consignmentId);
    if (apiResponse.error == null) {
      if (apiResponse.isNoDataFound()) {
        snackBarService.showSnackbar(message: apiResponse.emptyResult);
      } else {
        consignmentDetailResponse =
            ConsignmentDetailResponseNew.fromJson(apiResponse.response.data);
        consignmentDetailResponse.items.forEach(
          (element) {
            if (!uniqueHubIds.contains(element.hubId)) {
              uniqueHubIds.add(element.hubId);
            }
          },
        );
        //split('-')[0]
        newItems = List(uniqueHubIds.length);
        for (int i = 0; i < uniqueHubIds.length; i++) {
          newItems[i] = ItemForCard();
          consolidateHubCards(i);
        }
      }
    } else {
      snackBarService.showSnackbar(message: apiResponse.getErrorReason());
    }
    notifyListeners();
    setBusy(false);
  }

  void consolidateHubCards(int i) {
    for (int j = 0; j < consignmentDetailResponse.items.length; j++) {
      if (uniqueHubIds[i] == consignmentDetailResponse.items[j].hubId) {
        if (newItems[i].hubId == consignmentDetailResponse.items[j].hubId) {
          if (consignmentDetailResponse.items[j].dropOff >
              int.parse(
                consignmentDetailResponse.reviewedItems.length > 0
                    ? newItems[i].dropOff.split('/')[1]
                    : newItems[i].dropOff,
              )) {
            newItems[i] = newItems[i].copyWith(
              dropOff: consignmentDetailResponse.reviewedItems.length > 0
                  ? consignmentDetailResponse.reviewedItems[j].dropOff
                          .toString() +
                      '/' +
                      consignmentDetailResponse.items[j].dropOff.toString()
                  : consignmentDetailResponse.items[j].dropOff.toString(),
            );
          }
          if (consignmentDetailResponse.items[j].collect >
              int.parse(
                consignmentDetailResponse.reviewedItems.length > 0
                    ? newItems[i].collect.split('/')[1]
                    : newItems[i].collect,
              )) {
            newItems[i] = newItems[i].copyWith(
              collect: consignmentDetailResponse.reviewedItems.length > 0
                  ? consignmentDetailResponse.reviewedItems[j].collect
                          .toString() +
                      '/' +
                      consignmentDetailResponse.items[j].collect.toString()
                  : consignmentDetailResponse.items[j].collect.toString(),
            );
          }
          if (consignmentDetailResponse.items[j].payment >
              double.parse(
                consignmentDetailResponse.reviewedItems.length > 0
                    ? newItems[i].payment.split('/')[1]
                    : newItems[i].payment,
              )) {
            newItems[i] = newItems[i].copyWith(
              payment: consignmentDetailResponse.reviewedItems.length > 0
                  ? consignmentDetailResponse.reviewedItems[j].payment
                          .toString() +
                      '/' +
                      consignmentDetailResponse.items[j].payment.toString()
                  : consignmentDetailResponse.items[j].payment.toString(),
            );
          }
        } else {
          // newItems[i] = consignmentDetailResponse.items[j];
          newItems[i] = newItems[i].copyWith(
            hubId: consignmentDetailResponse.items[j].hubId,
            sequence: consignmentDetailResponse.items[j].sequence,
            hubTitle: consignmentDetailResponse.items[j].hubTitle,
            hubCity: consignmentDetailResponse.items[j].hubCity,
            collect: consignmentDetailResponse.reviewedItems.length > 0
                ? consignmentDetailResponse.reviewedItems[j].collect
                        .toString() +
                    '/' +
                    consignmentDetailResponse.items[j].collect.toString()
                : consignmentDetailResponse.items[j].collect.toString(),
            dropOff: consignmentDetailResponse.reviewedItems.length > 0
                ? consignmentDetailResponse.reviewedItems[j].dropOff
                        .toString() +
                    '/' +
                    consignmentDetailResponse.items[j].dropOff.toString()
                : consignmentDetailResponse.items[j].dropOff.toString(),
            payment: consignmentDetailResponse.reviewedItems.length > 0
                ? consignmentDetailResponse.reviewedItems[j].payment
                        .toString() +
                    '/' +
                    consignmentDetailResponse.items[j].payment.toString()
                : consignmentDetailResponse.items[j].payment.toString(),
          );
        }
      }
    }
  }
  // ConsignmentApis _consignmentApis = locator<ConsignmentApisImpl>();
  // void getConsignmentWithId2(String consignmentId) async {
  //   setBusy(true);
  //   consignmentDetailResponseNew = await _consignmentApis.getConsignmentWithId(
  //       consignmentId: consignmentId);
  //   setBusy(false);
  //   notifyListeners();
  // }
}
