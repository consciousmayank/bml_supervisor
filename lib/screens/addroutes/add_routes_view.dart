import 'package:bml_supervisor/screens/addroutes/add_routes_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../../app_level/themes.dart';
import '../../models/cities_response.dart';
import '../../models/secured_get_clients_response.dart';
import '../../utils/app_text_styles.dart';
import '../../utils/widget_utils.dart';
import '../../widget/app_dropdown.dart';
import '../../widget/client_dropdown.dart';

class AddRoutesView extends StatefulWidget {
  @override
  _AddRoutesViewState createState() => _AddRoutesViewState();
}

class _AddRoutesViewState extends State<AddRoutesView> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<AddRoutesViewModel>.reactive(
        onModelReady: (viewModel) {
          viewModel.getClients();
          viewModel.getCities();
        },
        builder: (context, viewModel, child) => Scaffold(
              appBar: AppBar(
                title: Text(
                  'Add Routes',
                  style: AppTextStyles.appBarTitleStyle,
                ),
                centerTitle: true,
              ),
              body: Padding(
                padding: getSidePadding(context: context),
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        selectClientForDashboardStats(viewModel: viewModel),
                        // CitiesDropDown(
                        //   optionList: viewModel.cityList,
                        //   hint: 'Select City',
                        //   selectedValue: widget.viewModel.selectedGender.isEmpty
                        //       ? null
                        //       : widget.viewModel.selectedGender,
                        //   onOptionSelect: (CitiesResponse selectedValue) {
                        //     viewModel.selectedCity = selectedValue;
                        //     //todo: bring focus to the next widget
                        //     // viewModel.getDistributors(selectedClient: selectedValue);
                        //   },
                        // )
                      ],
                    ),
                  ),
                ),
              ),
            ),
        viewModelBuilder: () => AddRoutesViewModel());
  }

  Widget selectClientForDashboardStats({AddRoutesViewModel viewModel}) {
    return ClientsDropDown(
      optionList: viewModel.clientsList,
      hint: "Select Client",
      onOptionSelect: (GetClientsResponse selectedValue) {
        viewModel.selectedClient = selectedValue;
        // viewModel.getDistributors(selectedClient: selectedValue);
      },
      selectedClient:
          viewModel.selectedClient == null ? null : viewModel.selectedClient,
    );
  }
}

class CitiesDropDown extends StatefulWidget {
  final List<CitiesResponse> optionList;
  final CitiesResponse selectedCity;
  final String hint;
  final Function onOptionSelect;
  final showUnderLine;

  CitiesDropDown(
      {@required this.optionList,
      this.selectedCity,
      @required this.hint,
      @required this.onOptionSelect,
      this.showUnderLine = true});

  @override
  _CitiesDropDownState createState() => _CitiesDropDownState();
}

class _CitiesDropDownState extends State<CitiesDropDown> {
  List<DropdownMenuItem<CitiesResponse>> dropdown = [];

  List<DropdownMenuItem<CitiesResponse>> getDropDownItems() {
    List<DropdownMenuItem<CitiesResponse>> dropdown =
        <DropdownMenuItem<CitiesResponse>>[];

    for (int i = 0; i < widget.optionList.length; i++) {
      dropdown.add(DropdownMenuItem(
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Text(
            "${widget.optionList[i].city}",
            style: TextStyle(
              color: Colors.black54,
            ),
          ),
        ),
        value: widget.optionList[i],
      ));
    }
    return dropdown;
  }

  @override
  Widget build(BuildContext context) {
    return widget.optionList.isEmpty
        ? Container()
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8, right: 8),
                child: Text(widget.hint ?? ""),
              ),
              Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.only(top: 2, bottom: 2),
                  child: DropdownButton(
                    icon: Padding(
                      padding: const EdgeInsets.only(right: 4),
                      child: Icon(
                        Icons.keyboard_arrow_down,
                        color: ThemeConfiguration.primaryBackground,
                      ),
                    ),
                    underline: Container(),
                    isExpanded: true,
                    style: textFieldStyle(
                        fontSize: 15.0, textColor: Colors.black54),
                    value: widget.selectedCity,
                    items: getDropDownItems(),
                    onChanged: (value) {
                      widget.onOptionSelect(value);
                    },
                  ),
                ),
              ),
            ],
          );
  }

  TextStyle textFieldStyle({double fontSize, Color textColor}) {
    return TextStyle(
        color: textColor,
        fontSize: fontSize,
        fontWeight: FontWeight.bold,
        fontStyle: FontStyle.normal);
  }
}
