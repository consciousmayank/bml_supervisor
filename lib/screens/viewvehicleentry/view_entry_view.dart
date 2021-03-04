import 'package:bml_supervisor/models/secured_get_clients_response.dart';
import 'package:bml_supervisor/screens/viewvehicleentry/view_entry_viewmodel.dart';
import 'package:bml_supervisor/utils/app_text_styles.dart';
import 'package:bml_supervisor/utils/dimens.dart';
import 'package:bml_supervisor/utils/stringutils.dart';
import 'package:bml_supervisor/utils/widget_utils.dart';
import 'package:bml_supervisor/widget/app_dropdown.dart';
import 'package:bml_supervisor/widget/app_textfield.dart';
import 'package:bml_supervisor/widget/client_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class ViewVehicleEntryView extends StatefulWidget {
  @override
  _ViewVehicleEntryViewState createState() => _ViewVehicleEntryViewState();
}

class _ViewVehicleEntryViewState extends State<ViewVehicleEntryView> {
  final TextEditingController selectedRegNoController = TextEditingController();
  final FocusNode selectedRegNoFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ViewVehicleEntryViewModel>.reactive(
      onModelReady: (viewModel) => viewModel.getClients(),
      builder: (context, viewModel, child) => Scaffold(
        appBar: AppBar(
          title:
              Text('View Daily Entry', style: AppTextStyles.appBarTitleStyle),
        ),
        body: Padding(
          padding: getSidePadding(context: context),
          child: ListView(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              selectClient(viewModel: viewModel),
              registrationSelector(context: context, viewModel: viewModel),
              selectDuration(viewModel: viewModel),
              hSizedBox(15),
              searchEntryButton(viewModel: viewModel),
            ],
          ),
        ),
      ),
      viewModelBuilder: () => ViewVehicleEntryViewModel(),
    );
  }

  Widget selectClient({ViewVehicleEntryViewModel viewModel}) {
    return ClientsDropDown(
      optionList: viewModel.clientsList,
      hint: "Select Client",
      onOptionSelect: (GetClientsResponse selectedValue) =>
          viewModel.selectedClient = selectedValue,
      selectedClient:
          viewModel.selectedClient == null ? null : viewModel.selectedClient,
    );
  }

  Widget searchEntryButton({ViewVehicleEntryViewModel viewModel}) {
    return SizedBox(
      height: buttonHeight,
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 4.0),
        child: RaisedButton(
          child: Text("View Entry"),
          onPressed: () {
            if (viewModel.selectedDuration.length != 0) {
              viewModel.vehicleEntrySearch(
                regNum: selectedRegNoController.text.trim().toUpperCase(),
                selectedDuration: viewModel.selectedDuration,
                clientId: viewModel.selectedClient != null
                    ? viewModel.selectedClient.clientId
                    : '',
              );
            } else {
              viewModel.snackBarService
                  .showSnackbar(message: 'Please select Duration');
            }
          },
        ),
      ),
    );
  }

  Widget selectDuration({ViewVehicleEntryViewModel viewModel}) {
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
      {BuildContext context, ViewVehicleEntryViewModel viewModel}) {
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

  registrationNumberTextField(ViewVehicleEntryViewModel viewModel) {
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
}
