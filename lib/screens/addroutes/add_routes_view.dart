import 'package:bml_supervisor/screens/addroutes/add_routes_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../../models/secured_get_clients_response.dart';
import '../../utils/app_text_styles.dart';
import '../../utils/widget_utils.dart';
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
