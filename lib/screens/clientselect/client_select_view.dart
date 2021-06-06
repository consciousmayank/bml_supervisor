import 'package:bml_supervisor/app_level/image_config.dart';
import 'package:bml_supervisor/app_level/shared_prefs.dart';
import 'package:bml_supervisor/models/secured_get_clients_response.dart';
import 'package:bml_supervisor/utils/app_text_styles.dart';
import 'package:bml_supervisor/utils/dimens.dart';
import 'package:bml_supervisor/utils/form_validators.dart';
import 'package:bml_supervisor/utils/widget_utils.dart';
import 'package:bml_supervisor/widget/new_search_widget.dart';
import 'package:bml_supervisor/widget/no_data_dashboard_widget.dart';
import 'package:bml_supervisor/widget/shimmer_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:stacked/stacked.dart';

import 'client_select_viewmodel.dart';

class ClientSelectView extends StatefulWidget {
  final Function onClientSelected;
  final isCalledFromBottomSheet;
  final GetClientsResponse preSelectedClient;

  const ClientSelectView({
    Key key,
    this.preSelectedClient,
    this.onClientSelected,
    this.isCalledFromBottomSheet = false,
  }) : super(key: key);

  @override
  _ClientSelectViewState createState() => _ClientSelectViewState();
}

class _ClientSelectViewState extends State<ClientSelectView> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ClientSelectViewModel>.reactive(
        onModelReady: (viewModel) {
          viewModel.getClientList(showLoading: true);
          viewModel.preSelectedClient = widget.preSelectedClient;
        },
        builder: (context, viewModel, child) => Scaffold(
              appBar: widget.isCalledFromBottomSheet
                  ? null
                  : AppBar(
                      centerTitle: true,
                      title: Text(
                        'Select Client',
                        style: AppTextStyles.appBarTitleStyle,
                      ),
                      automaticallyImplyLeading: false,
                    ),
              body: viewModel.isBusy
                  ? ShimmerContainer(
                      itemCount: 5,
                    )
                  : BodyWidget(
                      viewModel: viewModel,
                      onClientSelected: widget.onClientSelected,
                      isCalledFromBottomSheet: widget.isCalledFromBottomSheet,
                    ),
            ),
        viewModelBuilder: () => ClientSelectViewModel());
  }
}

class BodyWidget extends StatelessWidget {
  final ClientSelectViewModel viewModel;
  final Function onClientSelected;
  final isCalledFromBottomSheet;

  const BodyWidget({
    Key key,
    @required this.viewModel,
    @required this.onClientSelected,
    @required this.isCalledFromBottomSheet,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return viewModel.clientsList.length == 0
        ? Center(child: NoDataWidget())
        :Padding(
      padding: const EdgeInsets.all(4.0),
      child: Column(
        children: [
          SearchWidget(
            onClearTextClicked: () {
              // selectedRegNoController.clear();
              // viewModel.selectedVehicleId = '';
              // viewModel.getExpenses(
              //   showLoader: false,
              // );
              hideKeyboard(context: context);
            },
            hintTitle: 'Search for client',
            onTextChange: (String value) {
              // viewModel.selectedVehicleId = value;
              // viewModel.notifyListeners();
            },
            onEditingComplete: () {
              // viewModel.getExpenses(
              //   showLoader: true,
              // );
            },
            formatter: <TextInputFormatter>[
              TextFieldInputFormatter().alphaNumericFormatter,
            ],
            controller: TextEditingController(),
            // focusNode: selectedRegNoFocusNode,
            keyboardType: TextInputType.text,
            onFieldSubmitted: (String value) {
              // viewModel.getExpenses(
              //   showLoader: true,
              // );
            },
          ),
          hSizedBox(5),
          // appTextFormField(
          //   enabled: true,
          //   inputDecoration: InputDecoration(
          //       contentPadding:
          //           EdgeInsets.only(left: 16, top: 4, bottom: 4, right: 16),
          //       hintStyle: TextStyle(fontSize: 14, color: Colors.black45),
          //       hintText: 'Search '),
          //   keyboardType: TextInputType.text,
          // ),
          Expanded(
            child: LazyLoadScrollView(
              scrollOffset: (MediaQuery.of(context).size.height ~/ 2),
              onEndOfPage: () => viewModel.getClientList(showLoading: false),
              child: GridView.count(
                // Create a grid with 2 columns. If you change the scrollDirection to
                // horizontal, this produces 2 rows.
                crossAxisCount: 2,
                // Generate 100 widgets that display their index in the List.
                children: List.generate(viewModel.clientsList.length, (index) {
                  return Card(
                    shape: getCardShape(),
                    elevation: defaultElevation,
                    child: InkWell(
                      onTap: () {
                        Future.delayed(Duration(milliseconds: 500), () {
                          print(
                              'saveSelectedClient :: ${viewModel.clientsList[index].clientId}');
                          print('index :: $index');
                          MyPreferences()
                              .saveSelectedClient(viewModel.clientsList[index]);
                          if (isCalledFromBottomSheet) {
                            onClientSelected(viewModel.clientsList[index]);
                          } else {
                            viewModel.takeToDashBoard();
                          }
                        });
                        viewModel.preSelectedClient =
                            viewModel.clientsList[index];
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: Stack(
                          alignment: Alignment.topRight,
                          children: [
                            Align(
                              alignment: Alignment.center,
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment:
                                CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      // color: Colors.lightBlueAccent
                                      // border: Border.all(
                                      //     color: AppColors.primaryColorShade5,
                                      //     width: 2),
                                      // borderRadius:
                                      //     BorderRadius.circular(100),
                                      // color: AppColors.appScaffoldColor,
                                    ),
                                    child: ClipRRect(
                                      // borderRadius:
                                      //     BorderRadius.circular(100),
                                      child: viewModel.clientsList[index]
                                          .photo ==
                                          null
                                          ? Image.asset(
                                        loginIconIcon,
                                        // color: AppColors.primaryColorShade5,
                                        fit: BoxFit.cover,
                                        // height: 140,
                                        // width: 140,
                                      )
                                          : Image.memory(
                                        viewModel.clientsList[index]
                                            .getClientPhoto(),
                                        fit: BoxFit.cover,
                                        height: 140,
                                        width: 140,
                                      ),
                                    ),
                                  ),
                                  // ProfileImageWidget(
                                  //   // image: employeeInfo?.getEmployeePhoto(),
                                  //   image: viewModel.clientsList[index].photo != null
                                  //       ? viewModel.clientsList[index]
                                  //           .getClientPhoto()
                                  //       : null,
                                  //   circularBorderRadius: 100,
                                  //   height: 80,
                                  //   width: 80,
                                  // ),
                                  // Image.asset(loginIconIcon),
                                  Text(capitalizeFirstLetter(viewModel
                                      .clientsList[index].businessName)),
                                  hSizedBox(10)
                                ],
                              ),
                            ),
                            viewModel.preSelectedClient != null
                                ? Align(
                              alignment: Alignment.topRight,
                              child: Radio<GetClientsResponse>(
                                value: viewModel.preSelectedClient
                                    .businessName ==
                                    viewModel.clientsList[index]
                                        .businessName
                                    ? viewModel.preSelectedClient
                                    : viewModel.clientsList[index],
                                onChanged:
                                    (GetClientsResponse value) {
                                  viewModel.preSelectedClient = value;
                                },
                                groupValue:
                                viewModel.preSelectedClient,
                              ),
                            )
                                : Container(),
                          ],
                        ),
                        // Stack(
                        //   alignment: Alignment.topRight,
                        //   children: [
                        //     viewModel.preSelectedClient != null
                        //         ? Radio<GetClientsResponse>(
                        //             value: viewModel.preSelectedClient.clientId ==
                        //                     viewModel.clientsList[index].clientId
                        //                 ? viewModel.preSelectedClient
                        //                 : viewModel.clientsList[index],
                        //             onChanged: (GetClientsResponse value) {
                        //               viewModel.preSelectedClient = value;
                        //             },
                        //             groupValue: viewModel.preSelectedClient,
                        //           )
                        //         : Container(),
                        //     Column(
                        //       mainAxisSize: MainAxisSize.max,
                        //       crossAxisAlignment: CrossAxisAlignment.center,
                        //       mainAxisAlignment: MainAxisAlignment.spaceAround,
                        //       children: [
                        //         Image.asset(loginIconIcon),
                        //         Text(viewModel.clientsList[index].businessName),
                        //       ],
                        //     )
                        //   ],
                        // ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
