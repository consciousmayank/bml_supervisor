import 'package:bml_supervisor/screens/viewconsignments/view_consignment_viewmodel.dart';
import 'package:bml_supervisor/utils/widget_utils.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class ViewConsignmentView extends StatefulWidget {
  @override
  _ViewConsignmentViewState createState() => _ViewConsignmentViewState();
}

class _ViewConsignmentViewState extends State<ViewConsignmentView> {
  final PageController _controller = PageController(
    initialPage: 0,
  );

  ScrollController _scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ViewConsignmentViewModel>.reactive(
        onModelReady: (viewModel) => viewModel.getClientIds(),
        builder: (context, viewModel, child) => SafeArea(
              left: false,
              right: false,
              child: Scaffold(
                appBar: AppBar(
                  automaticallyImplyLeading: true,
                  title: Text("View Consignments"),
                ),
                body: viewModel.isBusy
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : Padding(
                        padding: getSidePadding(context: context),
                        child: Container(
                          child: Center(
                            child: Text("Coming Soon"),
                          ),
                        ),
                      ),
              ),
            ),
        viewModelBuilder: () => ViewConsignmentViewModel());
  }

  // Widget body(BuildContext context, ViewConsignmentViewModel viewModel) {
  //   return SingleChildScrollView(
  //     controller: _scrollController,
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.stretch,
  //       mainAxisAlignment: MainAxisAlignment.start,
  //       children: [
  //         dateSelector(context: context, viewModel: viewModel),
  //
  //         ClientsDropDown(
  //           optionList: viewModel.clientsList,
  //           hint: "Select Client",
  //           onOptionSelect: (GetClientsResponse selectedValue) {
  //             viewModel.selectedClient = selectedValue;
  //             viewModel.getRoutes(selectedValue.id);
  //           },
  //           selectedClient: viewModel.selectedClient == null
  //               ? null
  //               : viewModel.selectedClient,
  //         ),
  //
  //         RoutesDropDown(
  //           optionList: viewModel.routesList,
  //           hint: "Select Routes",
  //           onOptionSelect: (GetRoutesResponse selectedValue) {
  //             viewModel.selectedRoute = selectedValue;
  //             viewModel.getConsignments();
  //           },
  //           selectedValue: viewModel.selectedRoute == null
  //               ? null
  //               : viewModel.selectedRoute,
  //         ),
  //
  //         // getConsignments
  //
  //         viewModel.entryDate == null
  //             ? Container()
  //             : registrationSelector(context: context, viewModel: viewModel),
  //
  //         viewModel.entryDate == null
  //             ? Container()
  //             : consignmentTextField(viewModel: viewModel),
  //
  //         viewModel.validatedRegistrationNumber == null
  //             ? Container()
  //             : Container(
  //                 padding: const EdgeInsets.all(16),
  //                 child: Text(
  //                     "${viewModel.validatedRegistrationNumber.ownerName}, ${viewModel.validatedRegistrationNumber.model}"),
  //               ),
  //
  //         viewModel.validatedRegistrationNumber == null
  //             ? Container()
  //             : SizedBox(
  //                 height: 650,
  //                 child: Stack(
  //                   children: [
  //                     PageView.builder(
  //                       onPageChanged: (index) {},
  //                       controller: _controller,
  //                       itemBuilder: (BuildContext context, int index) {
  //                         return Card(
  //                           elevation: 4,
  //                           shape: getCardShape(),
  //                           child: Container(),
  //                         );
  //                       },
  //                       itemCount: viewModel.hubsList.length,
  //                     ),
  //                     Positioned(
  //                       bottom: 5,
  //                       left: 2,
  //                       right: 2,
  //                       child: DotsIndicator(
  //                         onPageSelected: (int index) {
  //                           print("aaaaaaa" + viewModel.hubsList[index].title);
  //                         },
  //                         controller: _controller,
  //                         itemCount: viewModel.hubsList.length,
  //                         color: ThemeConfiguration.primaryBackground,
  //                       ),
  //                     )
  //                   ],
  //                 ),
  //               ),
  //
  //         viewModel.validatedRegistrationNumber == null
  //             ? Container()
  //             : createConsignmentButton(viewModel: viewModel)
  //       ],
  //     ),
  //   );
  // }
  //
  // dateSelector(
  //     {BuildContext context, ConsignmentAllotmentViewModel viewModel}) {
  //   return Stack(
  //     alignment: Alignment.bottomRight,
  //     children: [
  //       selectedDateTextField(viewModel),
  //       selectDateButton(context, viewModel),
  //     ],
  //   );
  // }
  //
  // selectedDateTextField(ConsignmentAllotmentViewModel viewModel) {
  //   return appTextFormField(
  //     enabled: false,
  //     controller: selectedDateController,
  //     focusNode: selectedDateFocusNode,
  //     hintText: "Entry Date",
  //     labelText: "Entry Date",
  //     keyboardType: TextInputType.text,
  //   );
  // }
  //
  // selectDateButton(
  //     BuildContext context, ConsignmentAllotmentViewModel viewModel) {
  //   return Padding(
  //     padding: const EdgeInsets.only(bottom: 2.0, right: 4),
  //     child: appSuffixIconButton(
  //       icon: Icon(Icons.calendar_today_outlined),
  //       onPressed: (() async {
  //         DateTime selectedDate = await selectDate();
  //         if (selectedDate != null) {
  //           selectedDateController.text =
  //               DateFormat('dd-MM-yyyy').format(selectedDate).toLowerCase();
  //           viewModel.entryDate = selectedDate;
  //         }
  //       }),
  //     ),
  //   );
  // }
  //
  // Future<DateTime> selectDate() async {
  //   DateTime picked = await showDatePicker(
  //     builder: (BuildContext context, Widget child) {
  //       return Theme(
  //         data: ThemeData.light().copyWith(
  //           colorScheme: ColorScheme.light().copyWith(
  //             primary: ThemeConfiguration.primaryBackground,
  //           ),
  //         ),
  //         child: child,
  //       );
  //     },
  //     helpText: 'Registration Expires on',
  //     errorFormatText: 'Enter valid date',
  //     errorInvalidText: 'Enter date in valid range',
  //     fieldLabelText: 'Expiration Date',
  //     fieldHintText: 'Month/Date/Year',
  //     context: context,
  //     initialDate: DateTime.now(),
  //     firstDate: new DateTime(1990),
  //     lastDate: DateTime.now(),
  //   );
  //
  //   return picked;
  // }
}
