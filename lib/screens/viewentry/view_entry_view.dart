// Added by Vikas
// Module subject to change

import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:bml_supervisor/screens/viewentry/view_entry_viewmodel.dart';
import 'package:bml_supervisor/utils/widget_utils.dart';
import 'package:bml_supervisor/widget/app_textfield.dart';
import 'package:bml_supervisor/widget/app_dropdown.dart';
import 'package:bml_supervisor/widget/app_suffix_icon_button.dart';
import 'package:bml_supervisor/utils/stringutils.dart';
import 'package:bml_supervisor/utils/dimens.dart';

class ViewEntryView extends StatefulWidget {
  @override
  _ViewEntryViewState createState() => _ViewEntryViewState();
}

class _ViewEntryViewState extends State<ViewEntryView> {
  // final _formKey = GlobalKey<FormState>();
  final TextEditingController selectedRegNoController = TextEditingController();
  final FocusNode selectedRegNoFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ViewEntryViewModel>.reactive(
      builder: (context, viewModel, child) => Scaffold(
        appBar: AppBar(
          title: Text('View Entry'),
        ),
        body: Padding(
          padding: getSidePadding(context: context),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                // crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  registrationSelector(context: context, viewModel: viewModel),
                  viewModel.selectedSearchVehicle == null
                      ? Container()
                      : selectDuration(
                          viewModel: viewModel,
                        ),
                  hSizedBox(20),
                ],
              ),
              viewModel.selectedSearchVehicle == null
                  ? Container()
                  : searchButton(
                      viewModel: viewModel,
                    ),
            ],
          ),
        ),
      ),
      viewModelBuilder: () => ViewEntryViewModel(),
    );
  }

  Widget registrationSelector(
      {BuildContext context, ViewEntryViewModel viewModel}) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        Padding(
          padding: const EdgeInsets.all(2.0),
          child: registrationNumberTextField(viewModel),
        ),
        Container(
            child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            selectRegButton(context, viewModel),
          ],
        ))
      ],
    );
  }

  Widget registrationNumberTextField(ViewEntryViewModel viewModel) {
    viewModel.selectedSearchVehicle != null
        ? selectedRegNoController.text =
            viewModel.selectedSearchVehicle.registrationNumber
        : selectedRegNoController.text = "";
    return appTextFormField(
      enabled: false,
      controller: selectedRegNoController,
      focusNode: selectedRegNoFocusNode,
      hintText: drRegNoHint,
      keyboardType: TextInputType.text,
      validator: (value) {
        if (value.isEmpty) {
          return textRequired;
        } else {
          return null;
        }
      },
    );
  }

  Widget selectRegButton(BuildContext context, ViewEntryViewModel viewModel) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5.0, right: 4),
      child: appSuffixIconButton(
        icon: Icon(Icons.search),
        onPressed: () {
          viewModel.takeToSearch();
        },
      ),
    );
  }

  Widget selectDuration({ViewEntryViewModel viewModel}) {
    return AppDropDown(
      optionList: selectDurationList,
      hint: "Select Duration",
      onOptionSelect: (selectedValue) {
        viewModel.selectedDuration = selectedValue;
        print(viewModel.selectedDuration);
      },
      selectedValue: viewModel.selectedDuration.isEmpty
          ? null
          : viewModel.selectedDuration,
    );
  }

  Widget searchButton({ViewEntryViewModel viewModel}) {
    return SizedBox(
      height: buttonHeight,
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 4.0),
        child: RaisedButton(
          child: Text("Find"),
          onPressed: () {
            vehicleEntrySearch(
              context,
              viewModel,
              viewModel.selectedDuration,
            );
          },
        ),
      ),
    );
  }

  void vehicleEntrySearch(
    BuildContext context,
    ViewEntryViewModel viewModel,
    String selectedDuration,
  ) {
    viewModel.vehicleEntrySearch(
      viewModel.selectedSearchVehicle.registrationNumber,
      selectedDuration,
    );
  }
}
