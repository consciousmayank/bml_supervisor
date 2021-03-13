import 'package:bml_supervisor/app_level/generalised_base_view_model.dart';

class AddDriverViewModel extends GeneralisedBaseViewModel {
  DateTime _dateOfBirth = DateTime.now();

  String _selectedGender = '';

  String get selectedGender => _selectedGender;

  set selectedGender(String value) {
    _selectedGender = value;
  }

  set dateOfBirth(DateTime value) {
    _dateOfBirth = value;
  }

  DateTime get dateOfBirth => _dateOfBirth;
}
