import 'package:bml_supervisor/app_level/generalised_base_view_model.dart';
import 'package:bml_supervisor/app_level/setup_bottomsheet_ui.dart';
import 'package:bml_supervisor/enums/snackbar_types.dart';
import 'package:bml_supervisor/utils/dimens.dart';
import 'package:bml_supervisor/utils/form_validators.dart';
import 'package:bml_supervisor/utils/stringutils.dart';
import 'package:bml_supervisor/utils/widget_utils.dart';
import 'package:bml_supervisor/widget/app_button.dart';
import 'package:bml_supervisor/widget/app_dropdown.dart';
import 'package:bml_supervisor/widget/app_textfield.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class SeachForHubsBottomSheet extends StatefulWidget {
  final SheetRequest request;
  final Function(SheetResponse) completer;

  const SeachForHubsBottomSheet({
    Key key,
    @required this.request,
    @required this.completer,
  }) : super(key: key);

  @override
  _SeachForHubsBottomSheetState createState() =>
      _SeachForHubsBottomSheetState();
}

class _SeachForHubsBottomSheetState extends State<SeachForHubsBottomSheet> {
  TextEditingController itemsCollectController = TextEditingController();
  FocusNode itemsCollectFocusNode = FocusNode();
  TextEditingController itemsDropController = TextEditingController();
  FocusNode itemsDropFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SearchForHubsBottomSheetViewModel>.reactive(
      builder: (context, model, child) {
        SearchForHubsBottomSheetInputArgument args = widget.request.customData;
        return BaseBottomSheet(
          bottomSheetTitle: args.bottomSheetTitle,
          request: widget.request,
          completer: widget.completer,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                AppDropDown(
                  showUnderLine: true,
                  selectedValue: model.itemUnit != null ? model.itemUnit : null,
                  hint: "Item Unit",
                  onOptionSelect: (selectedValue) {
                    model.itemUnit = selectedValue;
                    model.notifyListeners();
                    itemsDropFocusNode.requestFocus();
                  },
                  optionList: selectItemUnit,
                ),
                Row(
                  children: [
                    Expanded(
                      child: dropInput(viewModel: model),
                      flex: 1,
                    ),
                    wSizedBox(5),
                    Expanded(
                      child: collectInput(viewModel: model),
                      flex: 1,
                    ),
                  ],
                ),
                hSizedBox(8),
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: buttonHeight,
                        child: AppButton.normal(
                          buttonText: 'Cancel',
                          onTap: () {
                            widget.completer(
                              SheetResponse(
                                  confirmed: false, responseData: null),
                            );
                          },
                        ),
                      ),
                      flex: 1,
                    ),
                    wSizedBox(10),
                    Expanded(
                      child: SizedBox(
                        height: buttonHeight,
                        child: AppButton.normal(
                          onTap: () {
                            if (model.itemUnit == null ||
                                model.itemUnit.length == 0) {
                              model.makeSnackbarMessage(
                                  message: 'Please select Item Unit',
                                  onOkButtonclicked: null);
                            } else if (itemsDropController.text.trim().length ==
                                    0 &&
                                itemsCollectController.text.trim().length ==
                                    0) {
                              model.makeSnackbarMessage(
                                  message:
                                      'Please enter values for either drop or collect',
                                  onOkButtonclicked: () {
                                    itemsDropFocusNode.requestFocus();
                                  });
                            } else {
                              widget.completer(
                                SheetResponse(
                                  confirmed: true,
                                  responseData:
                                      SearchForHubsBottomSheetOutputArguments(
                                    collect: itemsCollectController.text
                                                .trim()
                                                .length ==
                                            0
                                        ? 0
                                        : double.parse(
                                            itemsCollectController.text.trim(),
                                          ),
                                    drop: itemsDropController.text
                                                .trim()
                                                .length ==
                                            0
                                        ? 0
                                        : double.parse(
                                            itemsDropController.text.trim(),
                                          ),
                                    itemUnit: model.itemUnit,
                                  ),
                                ),
                              );
                            }
                          },
                          buttonText: 'Continue',
                        ),
                      ),
                      flex: 1,
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
      viewModelBuilder: () => SearchForHubsBottomSheetViewModel(),
    );
  }

  Widget dropInput({@required SearchForHubsBottomSheetViewModel viewModel}) {
    return appTextFormField(
      hintText: "${viewModel.itemUnit ?? 'Items'} Drop",
      enabled: true,
      controller: itemsDropController,
      focusNode: itemsDropFocusNode,
      onFieldSubmitted: (_) {
        fieldFocusChange(
          context,
          itemsDropFocusNode,
          itemsCollectFocusNode,
        );
      },
      keyboardType: TextInputType.number,
      validator: FormValidators().normalValidator,
    );
  }

  Widget collectInput({@required SearchForHubsBottomSheetViewModel viewModel}) {
    return appTextFormField(
      hintText: "${viewModel.itemUnit ?? 'Items'} Collect",
      enabled: true,
      controller: itemsCollectController,
      focusNode: itemsCollectFocusNode,
      onFieldSubmitted: (_) {
        itemsCollectFocusNode.unfocus();
      },
      keyboardType: TextInputType.number,
      validator: FormValidators().normalValidator,
    );
  }
}

class SearchForHubsBottomSheetInputArgument {
  final String bottomSheetTitle;

  SearchForHubsBottomSheetInputArgument({
    @required this.bottomSheetTitle,
  });
}

class SearchForHubsBottomSheetOutputArguments {
  final String itemUnit;
  final double drop, collect;

  SearchForHubsBottomSheetOutputArguments({
    @required this.itemUnit,
    @required this.drop,
    @required this.collect,
  });
}

class SearchForHubsBottomSheetViewModel extends GeneralisedBaseViewModel {
  String itemUnit;

  makeSnackbarMessage({
    @required String message,
    @required Function onOkButtonclicked,
  }) {
    snackBarService.showCustomSnackBar(
      variant: SnackbarType.ERROR,
      duration: Duration(seconds: 2),
      message: message,
      mainButtonTitle: onOkButtonclicked != null ? 'Ok' : null,
      onMainButtonTapped: onOkButtonclicked != null
          ? () {
              onOkButtonclicked.call();
            }
          : null,
    );
  }
}
