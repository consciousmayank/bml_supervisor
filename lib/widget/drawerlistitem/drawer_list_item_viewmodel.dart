import 'package:stacked/stacked.dart';

class DrawerListItemViewModel extends IndexTrackingViewModel {
  bool _showItems = false;

  bool get showItems => _showItems;

  set showItems(bool value) {
    _showItems = value;
    notifyListeners();
  }
}
