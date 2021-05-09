import 'package:bml_supervisor/app_level/colors.dart';
import 'package:bml_supervisor/app_level/image_config.dart';
import 'package:bml_supervisor/app_level/shared_prefs.dart';
import 'package:bml_supervisor/models/secured_get_clients_response.dart';
import 'package:bml_supervisor/screens/distributors/distributors_viewmodel.dart';
import 'package:bml_supervisor/utils/app_text_styles.dart';
import 'package:bml_supervisor/utils/widget_utils.dart';
import 'package:bml_supervisor/widget/client_dropdown.dart';
import 'package:bml_supervisor/widget/shimmer_container.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:url_launcher/url_launcher.dart';

class DistributorsScreenView extends StatefulWidget {
  @override
  _DistributorsScreenViewState createState() => _DistributorsScreenViewState();
}

class _DistributorsScreenViewState extends State<DistributorsScreenView> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<DistributorsScreenViewModel>.reactive(
      onModelReady: (viewModel) async {
        viewModel.selectedClient = preferences.getSelectedClient();
        viewModel.getDistributors(selectedClient: viewModel.selectedClient);
      },
      builder: (context, viewModel, child) => Scaffold(
        appBar: AppBar(
          title: Text('Distributors', style: AppTextStyles.appBarTitleStyle),
          centerTitle: true,
        ),
        body: viewModel.isBusy
            ? SizedBox(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: ShimmerContainer(
                  itemCount: 20,
                ),
              )
            : Padding(
                padding: const EdgeInsets.all(4.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // selectClientForDashboardStats(viewModel: viewModel),
                    viewModel.distributorsResponseList.length > 0
                        ? Container(
                            color: AppColors.primaryColorShade5,
                            padding: EdgeInsets.all(15),
                            child: Row(
                              // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    ('#'),
                                    textAlign: TextAlign.center,
                                    style: AppTextStyles.whiteRegular,
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    ('Distributor'),
                                    textAlign: TextAlign.center,
                                    style: AppTextStyles.whiteRegular,
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 15),
                                    child: Text(
                                      ('Contact Person'),
                                      textAlign: TextAlign.left,
                                      style: AppTextStyles.whiteRegular,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    'Call',
                                    textAlign: TextAlign.end,
                                    style: AppTextStyles.whiteRegular,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : Container(),
                    Utils().hSizedBox(8),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListView.separated(
                          // physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    '${index + 1}',
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    viewModel
                                        .distributorsResponseList[index].title,
                                    maxLines: 3,
                                    textAlign: TextAlign.center,
                                  ),
                                  flex: 2,
                                ),
                                Expanded(
                                  child: Text(
                                    viewModel.distributorsResponseList[index]
                                        .contactPerson,
                                    maxLines: 3,
                                    textAlign: TextAlign.center,
                                  ),
                                  flex: 2,
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.only(right: 10),
                                    child: Align(
                                      child: InkWell(
                                        onTap: () {
                                          if (double.parse(viewModel
                                                  .distributorsResponseList[
                                                      index]
                                                  .mobile) >
                                              0) {
                                            launch(
                                                "tel://${viewModel.distributorsResponseList[index].mobile}");
                                          }
                                        },
                                        child: Image.asset(
                                          callIcon,
                                          height: 20,
                                          width: 20,
                                        ),
                                      ),
                                      alignment: Alignment.centerRight,
                                    ),
                                  ),
                                  flex: 1,
                                ),
                              ],
                            );
                          },
                          itemCount: viewModel.distributorsResponseList.length,
                          separatorBuilder: (BuildContext context, int index) {
                            return Divider(
                              thickness: 1,
                              color: AppColors.primaryColorShade3,
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      ),
      viewModelBuilder: () => DistributorsScreenViewModel(),
    );
  }

  Widget selectClientForDashboardStats(
      {DistributorsScreenViewModel viewModel}) {
    return ClientsDropDown(
      optionList: viewModel.clientsList,
      hint: "Select Client",
      onOptionSelect: (GetClientsResponse selectedValue) {
        viewModel.selectedClient = selectedValue;
        viewModel.getDistributors(selectedClient: selectedValue);
      },
      selectedClient:
          viewModel.selectedClient == null ? null : viewModel.selectedClient,
    );
  }
}
