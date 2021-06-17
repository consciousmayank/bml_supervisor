import 'package:bml_supervisor/enums/bottomsheet_type.dart';
import 'package:bml_supervisor/screens/consignments/create/create_consignment_params.dart';
import 'package:bml_supervisor/screens/consignments/create/existing_consignment_bottom_sheet.dart';
import 'package:bml_supervisor/screens/consignments/create/routes_bottomsheet/routes_list_bottomsheet_view.dart';
import 'package:bml_supervisor/screens/dailykms/view/view_daily_kms_bottom_sheet.dart';
import 'package:bml_supervisor/screens/dashboard/select_client_bottom_sheet.dart';
import 'package:bml_supervisor/screens/delivery_route/add/add_route_bottomsheet.dart';
import 'package:bml_supervisor/screens/dialogs/confirm_consignment_view.dart';
import 'package:bml_supervisor/screens/driver/add/address_type_bottomsheet.dart';
import 'package:bml_supervisor/screens/driver/view/driver_details_botomsheet.dart';
import 'package:bml_supervisor/screens/expenses/view/expenses_filter_bottom_sheet.dart';
import 'package:bml_supervisor/screens/hub/view/hubs_list_details_botomsheet.dart';
import 'package:bml_supervisor/screens/temp_hubs/search_for_hubs/search_for_hubs_values_bottomSheet.dart';
import 'package:bml_supervisor/screens/trips/reviewcompleted/review_reject_bottom_sheet.dart';
import 'package:bml_supervisor/screens/trips/reviewcompleted/review_remarks_bottom_sheet.dart';
import 'package:bml_supervisor/screens/trips/reviewcompleted/review_warning_bottom_sheet.dart';
import 'package:bml_supervisor/screens/vehicle/view/vehicle_details_botomsheet.dart';
import 'package:bml_supervisor/utils/app_text_styles.dart';
import 'package:bml_supervisor/utils/dimens.dart';
import 'package:bml_supervisor/utils/widget_utils.dart';
import 'package:bml_supervisor/widget/app_button.dart';
import 'package:bml_supervisor/widget/bottomSheetDropdown/string_list_type_bottomsheet.dart';
import 'package:bml_supervisor/widget/routes/route_details_bottomsheet.dart';
import 'package:bml_supervisor/widget/gridViewBottomSheet/grid_view_bottomSheet.dart';
import 'package:flutter/material.dart';
import 'package:stacked_services/stacked_services.dart';

import 'colors.dart';
import 'locator.dart';

void setupBottomSheetUi() {
  final bottomSheetService = locator<BottomSheetService>();

  final builders = {
    BottomSheetType.CONFIRMATION_BOTTOM_SHEET: (context, sheetRequest,
            completer) =>
        _ConfirmationBottomSheet(request: sheetRequest, completer: completer),
    BottomSheetType.VIEW_ENTRY_PERIOD: (context, sheetRequest, completer) =>
        DailyKmsBottomSheet(request: sheetRequest, completer: completer),
    BottomSheetType.consignmentList: (context, sheetRequest, completer) =>
        ExistingConsignmentBottomSheet(
            request: sheetRequest, completer: completer),
    BottomSheetType.createConsignmentSummary: (context, sheetRequest,
            completer) =>
        _CreateConsignmentDialog(request: sheetRequest, completer: completer),
    BottomSheetType.expenseFilters: (context, sheetRequest, completer) =>
        ExpensesFilterBottomSheet(request: sheetRequest, completer: completer),
    BottomSheetType.clientSelect: (context, sheetRequest, completer) =>
        SelectClientBottomSheet(request: sheetRequest, completer: completer),
    // BottomSheetType.upcomingTrips: (context, sheetRequest, completer) =>
    //     DetailedTripsBottomSheet(request: sheetRequest, completer: completer),
    BottomSheetType.REJECT_DRIVER_TRIP: (context, sheetRequest, completer) =>
        ReviewRejectConfirmationBottomSheet(
            request: sheetRequest, completer: completer),
    BottomSheetType.COMPLETED_TRIP_REVIEW_REMARKS: (context, sheetRequest,
            completer) =>
        ReviewRemarksBottomSheet(request: sheetRequest, completer: completer),
    BottomSheetType.DRIVER_DETAILS: (context, sheetRequest, completer) =>
        DriverDetailsBottomSheet(request: sheetRequest, completer: completer),
    BottomSheetType.VEHICLE_DETAILS: (context, sheetRequest, completer) =>
        VehicleDetailsBottomSheet(request: sheetRequest, completer: completer),
    BottomSheetType.REVIEW_TRIPS_WARNING: (context, sheetRequest, completer) =>
        RevieWarningBottomSheet(request: sheetRequest, completer: completer),
    BottomSheetType.HUBS_DETAILS: (context, sheetRequest, completer) =>
        HubsListDetailsBottomSheet(request: sheetRequest, completer: completer),
    BottomSheetType.CREATE_ROUTE: (context, sheetRequest, completer) =>
        AddRouteSummaryBottomSheet(request: sheetRequest, completer: completer),
    BottomSheetType.ADDRESS_TYPE: (context, sheetRequest, completer) =>
        AddressTypeBottomSheet(request: sheetRequest, completer: completer),
    BottomSheetType.STRING_LIST: (context, sheetRequest, completer) =>
        StringListTypeBottomSheet(request: sheetRequest, completer: completer),
    BottomSheetType.ROUTE_DETAILS: (context, sheetRequest, completer) =>
        RouteDetailsBottomSheet(request: sheetRequest, completer: completer),

    BottomSheetType.EXPENSE_DETIALS: (context, sheetRequest, completer) =>
        GridViewBottomSheet(request: sheetRequest, completer: completer),
    BottomSheetType.VIEW_ENTRY_DETAILS: (context, sheetRequest, completer) =>
        GridViewBottomSheet(request: sheetRequest, completer: completer),

    BottomSheetType.UPCOMING_TRIPS: (context, sheetRequest, completer) =>
        GridViewBottomSheet(request: sheetRequest, completer: completer),

    BottomSheetType.ROUTES_BOTTOM_SHEET: (context, sheetRequest, completer) =>
        RoutesListBottomSheetView(request: sheetRequest, completer: completer),

    BottomSheetType.TEMP_SEARCH_HUBS_ENTER_VALUES: (context, sheetRequest,
            completer) =>
        SeachForHubsBottomSheet(request: sheetRequest, completer: completer),
  };

  bottomSheetService.setCustomSheetBuilders(builders);
}

class _ConfirmationBottomSheet extends StatelessWidget {
  final SheetRequest request;
  final Function(SheetResponse) completer;

  const _ConfirmationBottomSheet({
    Key key,
    this.request,
    this.completer,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //Calling method should pass custom data, and should be received here
    ConfirmationBottomSheetInputArgs customData =
        request.customData as ConfirmationBottomSheetInputArgs;

    return Container(
      margin: EdgeInsets.all(8),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(defaultBorder)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (customData.title != null)
            Padding(
              padding: const EdgeInsets.only(left: 32, right: 32, bottom: 16),
              child: Text(
                customData.title,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[900],
                ),
                textAlign: TextAlign.center,
              ),
            ),
          if (customData.description != null)
            Padding(
              padding: const EdgeInsets.only(
                left: 16,
                right: 16,
                top: 4,
                bottom: 16,
              ),
              child: Text(
                customData.description,
                style: TextStyle(color: Colors.black),
                textAlign: TextAlign.center,
              ),
            ),
          getConfirmationButtons(customData)
        ],
      ),
    );
  }

  Widget getConfirmationButtons(ConfirmationBottomSheetInputArgs customData) {
    if (customData.negativeButtonTitle == null &&
        customData.positiveButtonTitle == null) {
      return SizedBox(
        height: buttonHeight,
        child: AppButton(
            borderColor: AppColors.primaryColorShade5,
            onTap: () => completer(SheetResponse(confirmed: true)),
            background: AppColors.primaryColorShade5,
            buttonText: 'Ok'),
      );
    } else {
      return Row(
        children: [
          if (customData.negativeButtonTitle != null)
            Expanded(
              child: SizedBox(
                height: buttonHeight,
                child: AppButton(
                    borderColor: AppColors.primaryColorShade5,
                    onTap: () => completer(SheetResponse(confirmed: false)),
                    background: AppColors.primaryColorShade5,
                    buttonText: 'No'),
              ),
              flex: 1,
            ),
          wSizedBox(10),
          if (customData.positiveButtonTitle != null)
            Expanded(
              child: SizedBox(
                height: buttonHeight,
                child: AppButton(
                    borderColor: AppColors.primaryColorShade5,
                    onTap: () => completer(SheetResponse(confirmed: true)),
                    background: AppColors.primaryColorShade5,
                    buttonText: 'Yes'),
              ),
              flex: 1,
            ),
        ],
      );
    }
  }
}

class ConfirmationBottomSheetInputArgs {
  final String title, description;
  final String positiveButtonTitle, negativeButtonTitle;
  ConfirmationBottomSheetInputArgs({
    @required this.title,
    this.description,
    this.positiveButtonTitle,
    this.negativeButtonTitle,
  });
}

class _CreateConsignmentDialog extends StatelessWidget {
  final SheetRequest request;
  final Function(SheetResponse) completer;

  // CreateConsignmentDialogParams args;

  _CreateConsignmentDialog({
    Key key,
    this.request,
    this.completer,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    CreateConsignmentDialogParams args = request.customData;

    return BaseBottomSheet(
      bottomSheetTitle: 'Consignment Summary',
      request: request,
      completer: completer,
      child: ConfirmConsignmentView(
        selectedClient: args.selectedClient,
        consignmentRequest: args.consignmentRequest,
        selectedRoute: args.selectedRoute,
        itemUnit: args.itemUnit,
        validatedRegistrationNumber: args.validatedRegistrationNumber,
        onSubmitClicked: (bool value) {
          completer(SheetResponse(confirmed: value));
        },
      ),
    );
  }
}

class BaseBottomSheet extends StatelessWidget {
  final SheetRequest request;
  final Function(SheetResponse) completer;
  final Widget child;
  final double height;
  final String bottomSheetTitle;

  const BaseBottomSheet({
    Key key,
    @required this.request,
    @required this.completer,
    @required this.child,
    this.height,
    this.bottomSheetTitle,
  }) : super(key: key);

  const BaseBottomSheet.percent({
    Key key,
    @required this.request,
    @required this.completer,
    @required this.child,
    @required this.height,
    this.bottomSheetTitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // margin: margin ?? EdgeInsets.all(0),
      // padding: margin ?? EdgeInsets.all(0),
      height: height ?? MediaQuery.of(context).size.height * 0.84,
      decoration: BoxDecoration(
        color: AppColors.appScaffoldColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(defaultBorder),
          topRight: Radius.circular(defaultBorder),
          // bottomLeft: margin != null
          //     ? Radius.circular(defaultBorder)
          //     : Radius.circular(0),
          // bottomRight: margin != null
          //     ? Radius.circular(defaultBorder)
          //     : Radius.circular(0),
        ),
      ),
      child: Column(
        children: [
          BottomSheetTitleBar(
            title: bottomSheetTitle,
            onCloseTextClicked: () {
              completer(
                SheetResponse(confirmed: false, responseData: null),
              );
            },
          ),
          child,
        ],
      ),
    );
  }
}

class BottomSheetTitleBar extends StatelessWidget {
  final Function onCloseTextClicked;
  final String title;

  const BottomSheetTitleBar({
    @required this.onCloseTextClicked,
    Key key,
    @required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 52,
        ),
        Container(
          height: 50,
          decoration: BoxDecoration(
            color: AppColors.offWhite,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(defaultBorder),
              topRight: Radius.circular(defaultBorder),
            ),
            boxShadow: [
              BoxShadow(
                blurRadius: 2.0, //
              )
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(14.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    title ?? '',
                    style: AppTextStyles.hyperLinkStyle
                        .copyWith(decoration: TextDecoration.none),
                    textAlign: TextAlign.left,
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(),
                ),
                Expanded(
                  flex: 1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: onCloseTextClicked != null
                            ? onCloseTextClicked.call
                            : null,
                        child: Icon(Icons.close),
                        // Text(
                        //   'Close',
                        //   style: AppTextStyles.hyperLinkStyle,
                        //   textAlign: TextAlign.end,
                        // ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}

// class BaseHalfScreenBottomSheet extends StatelessWidget {
//   final SheetRequest request;
//   final Function(SheetResponse) completer;
//   final Widget child;
//   final double height;
//   final EdgeInsets margin;
//   final String bottomSheetTitle;

//   const BaseHalfScreenBottomSheet({
//     Key key,
//     @required this.request,
//     @required this.completer,
//     this.height,
//     this.margin,
//     @required this.child,
//     this.bottomSheetTitle = '',
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: margin ?? EdgeInsets.all(0),
//       padding: margin ?? EdgeInsets.all(0),
//       height: height,
//       decoration: BoxDecoration(
//         color: AppColors.appScaffoldColor,
//         borderRadius: BorderRadius.only(
//           topLeft: Radius.circular(defaultBorder),
//           topRight: Radius.circular(defaultBorder),
//           bottomLeft: margin != null
//               ? Radius.circular(defaultBorder)
//               : Radius.circular(0),
//           bottomRight: margin != null
//               ? Radius.circular(defaultBorder)
//               : Radius.circular(0),
//         ),
//       ),
//       child: Column(
//         children: [
//           BottomSheetTitleBar(
//             title: bottomSheetTitle,
//             onCloseTextClicked: () {
//               completer(
//                 SheetResponse(confirmed: false, responseData: null),
//               );
//             },
//           ),
//           child,
//         ],
//       ),
//     );
//   }
// }
