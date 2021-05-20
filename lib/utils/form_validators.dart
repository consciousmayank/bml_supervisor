import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:form_field_validator/form_field_validator.dart';

class FormValidators {
  final emailValidator = MultiValidator([
    RequiredValidator(errorText: 'Email is required'),
    // MinLengthValidator(8, errorText: 'password must be at least 8 digits long'),
    EmailValidator(errorText: 'Invalid Email')
  ]);

  final mobileNumberValidator = MultiValidator([
    RequiredValidator(errorText: 'Phone Number is required'),
    MinLengthValidator(10, errorText: 'Phone Number must be 10 digits long'),
    // PatternValidator(RegularExpressions().mobileNumberRegEx,
    //     errorText: 'Invalid Phone Number')
  ]);

  final mobileNumberNotRequiredValidator = MultiValidator([
    MinLengthValidator(10, errorText: 'Phone Number must be 10 digits long'),
    MaxLengthValidator(10, errorText: '')
    // PatternValidator(RegularExpressions().mobileNumberRegEx,
    //     errorText: 'Invalid Phone Number')
  ]);

  final panNumberValidator = MultiValidator([
    RequiredValidator(errorText: 'PAN is required'),
    MinLengthValidator(10, errorText: 'PAN must be 10 digits long'),
    // PatternValidator(RegularExpressions().panCardRegEx,
    // errorText: 'Invalid PAN')
  ]);

  final aadhaarCardNumberValidator = MultiValidator([
    RequiredValidator(errorText: 'Aadhar Card is required'),
    MinLengthValidator(12, errorText: 'Aadhar Card must be 12 digits long'),
    // PatternValidator(RegularExpressions().aadhaarCardRegEx,
    // errorText: 'Invalid Aadhar Card Number')
  ]);

  final normalValidator = MultiValidator([
    RequiredValidator(errorText: 'required'),
  ]);
}

class RegularExpressions {
  ///
  ///^ represents the starting of the string.
  ///[2-9]{1} represents the first digit should be any from 2-9.
  ///[0-9]{3} represents the next 3 digits after the first digit should be any digit from 0-9. \\s represents white space.
  ///[0-9]{4} represents the next 4 digits should be any from 0-9.\\s represents white space.
  ///[0-9]{4} represents the next 4 digits should be any from 0-9.$ represents the ending of the string.
  ///
  // RegExp aadhaarCardRegEx = RegExp(r"^[2-9]{1}[0-9]{3}\\s[0-9]{4}\\s[0-9]{4}$");
  // RegExp mobileNumberRegEx = RegExp(r'(0/91)?[7-9][0-9]{9}');
  // RegExp panCardRegEx = RegExp(r'[A-Z]{5}[0-9]{4}[A-Z]{1}');

  ///helpful for vehicle Numbers
  RegExp alphaNumericWithSpaceRegEx = RegExp(r'[a-zA-Z0-9 -]');
  RegExp alphaNumericWithSpaceSlashHyphenUnderScoreRegEx =
      RegExp(r'[a-zA-Z0-9 -/_]');
  RegExp alphabeticSpaceRegEx = RegExp(r'[a-zA-Z ]');
  RegExp numericRegEx = RegExp(r'[0-9]');
}

class TextFieldInputFormatter {
  final TextInputFormatter alphaNumericFormatter =
      FilteringTextInputFormatter.allow(
          RegularExpressions().alphaNumericWithSpaceRegEx);
  final TextInputFormatter alphaNumericWithSpaceSlashHyphenUnderScoreFormatter =
      FilteringTextInputFormatter.allow(
          RegularExpressions().alphaNumericWithSpaceSlashHyphenUnderScoreRegEx);
  final TextInputFormatter alphabeticFormatter =
      FilteringTextInputFormatter.allow(
          RegularExpressions().alphabeticSpaceRegEx);
  final TextInputFormatter numericFormatter =
      FilteringTextInputFormatter.allow(RegularExpressions().numericRegEx);

  TextInputFormatter maxLengthFormatter({@required int maxLength}) {
    return LengthLimitingTextInputFormatter(maxLength);
  }
}
