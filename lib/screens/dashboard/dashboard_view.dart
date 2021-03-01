import 'package:bml_supervisor/app_level/shared_prefs.dart';
import 'package:bml_supervisor/app_level/themes.dart';
import 'package:bml_supervisor/models/fetch_routes_response.dart';
import 'package:bml_supervisor/models/secured_get_clients_response.dart';
import 'package:bml_supervisor/screens/charts/barchart/bar_chart_view.dart';
import 'package:bml_supervisor/screens/charts/linechart/line_chart_view.dart';
import 'package:bml_supervisor/screens/charts/piechart/pie_chart_view.dart';
import 'package:bml_supervisor/utils/dimens.dart';
import 'package:bml_supervisor/utils/stringutils.dart';
import 'package:bml_supervisor/utils/widget_utils.dart';
import 'package:bml_supervisor/widget/app_dropdown.dart';
import 'package:bml_supervisor/widget/client_dropdown.dart';
import 'package:bml_supervisor/widget/routes/routes_view.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'dashboard_viewmodel.dart';

class DashBoardScreenView extends StatefulWidget {
  @override
  _DashBoardScreenViewState createState() => _DashBoardScreenViewState();
}

class _DashBoardScreenViewState extends State<DashBoardScreenView> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<DashBoardScreenViewModel>.reactive(
        onModelReady: (viewModel) async {
          GetClientsResponse savedSelectedClient =
              MyPreferences().getSelectedClient();
          viewModel.selectedDuration = MyPreferences().getSelectedDuration();

          viewModel.getClients();
          viewModel.getSavedUser();
          // if (savedSelectedClient != null) {
          //   viewModel.selectedClient = savedSelectedClient;
          //   viewModel.getClientDashboardStats();
          // }
        },
        builder: (context, viewModel, child) {
          return Scaffold(
            appBar: AppBar(
              title: viewModel.savedUser != null
                  ? Text('Welcome, ${viewModel.savedUser.userName}')
                  : Text('DashBoard'),
              centerTitle: true,
            ),
            body: SingleChildScrollView(
                child: viewModel.isBusy
                    ? Container(
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      )
                    : Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: selectClientForDashboardStats(
                                    viewModel: viewModel),
                                flex: 1,
                              ),
                              Expanded(
                                child: selectDuration(viewModel: viewModel),
                                flex: 1,
                              ),
                            ],
                          ),
                          viewModel.singleClientTileData != null
                              ? Row(
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: buildDashboradTileCard(
                                          title: 'DISTRIBUTERS',
                                          value: viewModel
                                              .singleClientTileData.hubCount
                                              .toString(),
                                          viewModel: viewModel,
                                          color:
                                              getDashboardDistributerTileBgColor()),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: buildDashboradTileCard(
                                        title: 'TOTAL KILOMETER',
                                        value: viewModel
                                            .singleClientTileData.kmCount
                                            .toString(),
                                        viewModel: viewModel,
                                        color: getDashboardTotalKmTileBgColor(),
                                      ),
                                    ),
                                  ],
                                )
                              : Container(),
                          viewModel.singleClientTileData != null
                              ? Row(
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: buildDashboradTileCard(
                                        title: 'ROUTES',
                                        value: viewModel
                                            .singleClientTileData.routeCount
                                            .toString(),
                                        viewModel: viewModel,
                                        color: getDashboardRoutesTileBgColor(),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: buildDashboradTileCard(
                                        title: 'DUE (KM)',
                                        value: viewModel
                                            .singleClientTileData.dueCount
                                            .toString(),
                                        viewModel: viewModel,
                                        color: getDashboardDueKmTileBgColor(),
                                      ),
                                    ),
                                  ],
                                )
                              : Container(),

                          viewModel.selectedClient != null &&
                                  viewModel.selectedDuration != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: Card(
                                    elevation: defaultElevation,
                                    child: RoutesView(
                                      selectedClient: viewModel.selectedClient,
                                      onRoutesPageInView:
                                          (FetchRoutesResponse clickedRoute) {},
                                    ),
                                  ),
                                )
                              : Container(),

                          viewModel.selectedClient != null &&
                                  viewModel.selectedDuration != null
                              ? BarChartView(
                                  clientId: viewModel.selectedClient.clientId,
                                  selectedDuration: viewModel.selectedDuration,
                                )
                              : Container(),
                          viewModel.selectedClient != null &&
                                  viewModel.selectedDuration != null
                              ? LineChartView(
                                  clientId: viewModel.selectedClient.clientId,
                                  selectedDuration: viewModel.selectedDuration,
                                )
                              : Container(),
                          viewModel.selectedClient != null &&
                                  viewModel.selectedDuration != null
                              ? PieChartView(
                                  clientId: viewModel.selectedClient.clientId,
                                  selectedDuration: viewModel.selectedDuration,
                                )
                              : Container(),
                          // viewModel.selectedClient == null
                          //     ? Container()
                          //     : Column(
                          //         crossAxisAlignment: CrossAxisAlignment.start,
                          //         mainAxisSize: MainAxisSize.max,
                          //         children: [
                          //           Padding(
                          //             padding: const EdgeInsets.all(8.0),
                          //             child: Text("Routes"),
                          //           ),
                          //           Padding(
                          //             padding: const EdgeInsets.only(
                          //                 top: 8, bottom: 8),
                          //             child: SizedBox(
                          //               height:
                          //                   MediaQuery.of(context).size.height *
                          //                       0.30,
                          //               child: RoutesView(
                          //                 selectedClient:
                          //                     viewModel.selectedClient,
                          //                 onRoutesPageInView: (clickedRoute) {
                          //                   // FetchRoutesResponse route = clickedRoute;
                          //                   // viewModel.selectedRoute = route;
                          //                 },
                          //               ),
                          //             ),
                          //           ),
                          //         ],
                          //       ),
                        ],
                      )),
            drawer: Container(
              color: ThemeConfiguration.appScaffoldBackgroundColor,
              width: MediaQuery.of(context).size.width * 0.65,
              child: ListView.builder(
                itemBuilder: (context, index) {
                  return getOptions(
                      context: context, position: index, viewModel: viewModel);
                },
                itemCount: 8,
              ),
            ),
          );
        },
        viewModelBuilder: () => DashBoardScreenViewModel());
  }

  Widget selectDuration({DashBoardScreenViewModel viewModel}) {
    return AppDropDown(
      optionList: selectDurationList,
      hint: "Select Duration",
      onOptionSelect: (selectedValue) {
        viewModel.selectedDuration = selectedValue;
        //!call recent consignment api here
        // viewModel.getRecentConsignments(
        //   clientId: viewModel.selectedClient.clientId,
        //   period: viewModel.selectedDuration,
        // );

        MyPreferences().saveSelectedDuration(selectedValue);
      },
      selectedValue: viewModel.selectedDuration.isEmpty
          ? null
          : viewModel.selectedDuration,
    );
  }

  Widget buildDashboradTileCard({
    String title,
    String value,
    DashBoardScreenViewModel viewModel,
    Color color,
  }) {
    return Card(
      color: color,
      elevation: 6,
      child: Padding(
        padding: getDashboradTilesVerticlePadding(),
        child: Column(
          children: [
            Text(
              title,
              style:
                  TextStyle(color: getDashboardTileTextColor(), fontSize: 14),
            ),
            Text(
              value,
              style:
                  TextStyle(color: getDashboardTileTextColor(), fontSize: 20),
            ), //! make it dynamic
          ],
        ),
      ),
    );
  }

  Widget selectClientForDashboardStats({DashBoardScreenViewModel viewModel}) {
    return ClientsDropDown(
      optionList: viewModel.clientsList,
      hint: "Select Client",
      onOptionSelect: (GetClientsResponse selectedValue) {
        viewModel.selectedClient = selectedValue;
        MyPreferences().saveSelectedClient(selectedValue);

        //* call client tiles data
        viewModel.getClientDashboardStats();
        // viewModel.getRecentConsignments(
        //   clientId: viewModel.selectedClient.clientId,
        //   period: viewModel.selectedDuration,
        // );
      },
      selectedClient:
          viewModel.selectedClient == null ? null : viewModel.selectedClient,
    );
  }

  Widget getOptions(
      {BuildContext context,
      int position,
      DashBoardScreenViewModel viewModel}) {
    return Container(
      height: buttonHeight,
      child: InkWell(
        onTap: () => handleOptionClick(
            context: context, position: position, viewModel: viewModel),
        child: Card(
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              mainAxisSize: MainAxisSize.max,
              children: [
                Icon(
                  viewModel.optionsIcons[position],
                ),
                wSizedBox(20),
                Expanded(
                  child: Text(viewModel.optionsTitle[position]),
                  flex: 1,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  handleOptionClick(
      {BuildContext context,
      int position,
      DashBoardScreenViewModel viewModel}) {
    Navigator.pop(context);
    switch (position) {
      case 0:
        return viewModel.takeToAddEntryPage();
        break;
      case 1:
        return viewModel.takeToViewEntryPage();
        break;
      case 2:
        return viewModel.takeToAddExpensePage();
        break;
      case 3:
        return viewModel.takeToViewExpensePage();
        break;
      case 4:
        return viewModel.takeToAllotConsignmentsPage();
        break;
      case 5:
        return viewModel.takeToViewRoutesPage();
        break;
      case 6:
        return viewModel.takeToViewConsignmentsPage();
        break;
      case 7:
        return viewModel.takeToPaymentsPage();
        break;
      default:
        return viewModel.takeToBlankPage();
    }
  }
}

// class ClientsDropDown extends StatefulWidget {
//   final List<GetClientsResponse> optionList;
//   final GetClientsResponse selectedValue;
//   final String hint;
//   final Function onOptionSelect;
//   final showUnderLine;
//
//   ClientsDropDown({
//     @required this.optionList,
//     this.selectedValue,
//     @required this.hint,
//     @required this.onOptionSelect,
//     this.showUnderLine = true,
//   });
//
//   @override
//   _ClientsDropDownState createState() => _ClientsDropDownState();
// }
//
// class _ClientsDropDownState extends State<ClientsDropDown> {
//   List<DropdownMenuItem<GetClientsResponse>> dropdown = [];
//
//   List<DropdownMenuItem<GetClientsResponse>> getDropDownItems() {
//     List<DropdownMenuItem<GetClientsResponse>> dropdown =
//         List<DropdownMenuItem<GetClientsResponse>>();
//
//     for (int i = 0; i < widget.optionList.length; i++) {
//       dropdown.add(DropdownMenuItem(
//         child: Padding(
//           padding: const EdgeInsets.only(left: 20, right: 20),
//           child: Text(
//             "${widget.optionList[i].clientId}",
//             style: TextStyle(
//               color: Colors.black54,
//             ),
//           ),
//         ),
//         value: widget.optionList[i],
//       ));
//     }
//     return dropdown;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return widget.optionList.isEmpty
//         ? Container()
//         : Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             mainAxisAlignment: MainAxisAlignment.start,
//             children: [
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Text(widget.hint ?? ""),
//               ),
//               Card(
//                 elevation: 2,
//                 child: Padding(
//                   padding: const EdgeInsets.only(top: 2, bottom: 4),
//                   child: DropdownButton(
//                     icon: Padding(
//                       padding: const EdgeInsets.only(right: 4),
//                       child: Icon(
//                         Icons.keyboard_arrow_down,
//                         color: ThemeConfiguration.primaryBackground,
//                       ),
//                     ),
//                     underline: Container(),
//                     isExpanded: true,
//                     style: textFieldStyle(
//                         fontSize: 15.0, textColor: Colors.black54),
//                     value: widget.selectedValue,
//                     items: getDropDownItems(),
//                     onChanged: (value) {
//                       widget.onOptionSelect(value);
//                     },
//                   ),
//                 ),
//               ),
//             ],
//           );
//   }
//
//   TextStyle textFieldStyle({double fontSize, Color textColor}) {
//     return TextStyle(
//         color: textColor,
//         fontSize: fontSize,
//         fontWeight: FontWeight.bold,
//         fontStyle: FontStyle.normal);
//   }
// }
