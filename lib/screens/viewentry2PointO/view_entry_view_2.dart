import 'package:bml_supervisor/screens/viewentry2PointO/view_entry_viewmodel_2.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:bml_supervisor/utils/widget_utils.dart';
import 'package:bml_supervisor/widget/app_textfield.dart';
import 'package:bml_supervisor/widget/app_dropdown.dart';
import 'package:bml_supervisor/widget/app_suffix_icon_button.dart';
import 'package:bml_supervisor/utils/stringutils.dart';
import 'package:bml_supervisor/utils/dimens.dart';

class ViewEntryView2PointO extends StatefulWidget {
  @override
  _ViewEntryView2PointOState createState() => _ViewEntryView2PointOState();
}

class _ViewEntryView2PointOState extends State<ViewEntryView2PointO> {
  final TextEditingController selectedRegNoController = TextEditingController();
  final FocusNode selectedRegNoFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ViewEntryViewModel2PointO>.reactive(
      builder: (context, viewModel, child) => Scaffold(
        appBar: AppBar(
          title: Text('View Entry 2.0'),
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
                  selectDuration(viewModel: viewModel),
                ],
              ),
              searchEntryButton(viewModel: viewModel),
            ],
          ),
        ),
        // Column(
        //   crossAxisAlignment: CrossAxisAlignment.start,
        //   children: [
        //     // dateSelector(context: context, viewModel: viewModel),
        //     selectDuration(viewModel: viewModel),
        //     registrationSelector(context: context, viewModel: viewModel),
        //   ],
        // ),
      ),
      viewModelBuilder: () => ViewEntryViewModel2PointO(),
    );
  }

  Widget searchEntryButton({ViewEntryViewModel2PointO viewModel}) {
    return SizedBox(
      height: buttonHeight,
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 4.0),
        child: RaisedButton(
          child: Text("Search Entry"),
          onPressed: () {
            if (selectedRegNoController.text.length == 0 ||
                viewModel.selectedDuration.length == 0) {
              viewModel.snackBarService
                  .showSnackbar(message: 'Please fill all the fields');
            } else {
              viewModel.vehicleEntrySearch(
                  selectedRegNoController.text.toUpperCase(),
                  viewModel.selectedDuration);

              // viewModel.search(selectedRegNoController.text.toUpperCase(),
              //     viewModel.selectedDuration);
            }
            // vehicleEntrySearch(
            //   context,
            //   viewModel,
            //   viewModel.selectedDuration,
            // );
          },
        ),
      ),
    );
  }

  Widget selectDuration({ViewEntryViewModel2PointO viewModel}) {
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

  registrationSelector(
      {BuildContext context, ViewEntryViewModel2PointO viewModel}) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        Padding(
          padding: const EdgeInsets.all(2.0),
          child: registrationNumberTextField(viewModel),
        ),
        // selectRegButton(context, viewModel),
      ],
    );
  }

  registrationNumberTextField(ViewEntryViewModel2PointO viewModel) {
    // viewModel.selectedVehicle != null
    //     ? selectedRegNoController.text =
    //         viewModel.selectedVehicle.registrationNumber
    //     : selectedRegNoController.text = "";
    return appTextFormField(
      enabled: true,
      controller: selectedRegNoController,
      // focusNode: selectedRegNoFocusNode,
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

  // selectRegButton(BuildContext context, ViewEntryViewModel2PointO viewModel) {
  //   return Padding(
  //     padding: const EdgeInsets.only(bottom: 5.0, right: 4),

  //     child: appSuffixIconButton(

  //       icon: Icon(Icons.search),
  //       onPressed: () {
  //         if (selectedRegNoController.text.length == 0) {
  //           viewModel.snackBarService
  //               .showSnackbar(message: 'Please fill all the fields');
  //         } else {
  //           viewModel.search(selectedRegNoController.text.toUpperCase());
  //         }
  //       },
  //     ),
  //   );
  // }
}
