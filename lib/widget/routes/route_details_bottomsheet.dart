import 'package:bml_supervisor/app_level/colors.dart';
import 'package:bml_supervisor/app_level/setup_bottomsheet_ui.dart';
import 'package:bml_supervisor/models/fetch_routes_response.dart';
import 'package:bml_supervisor/models/get_hub_details_response.dart';
import 'package:bml_supervisor/models/get_route_details_response.dart';
import 'package:bml_supervisor/utils/app_text_styles.dart';
import 'package:bml_supervisor/utils/widget_utils.dart';
import 'package:bml_supervisor/widget/app_button.dart';
import 'package:bml_supervisor/widget/routes/route_viewmodel.dart';
import 'package:bml_supervisor/widget/shimmer_container.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class RouteDetailsBottomSheet extends StatefulWidget {
  final SheetRequest request;
  final Function(SheetResponse) completer;

  const RouteDetailsBottomSheet({
    Key key,
    this.request,
    this.completer,
  }) : super(key: key);

  @override
  _RouteDetailsBottomSheetState createState() =>
      _RouteDetailsBottomSheetState();
}

class _RouteDetailsBottomSheetState extends State<RouteDetailsBottomSheet> {
  @override
  Widget build(BuildContext context) {
    RouteDetailsBottomSheetInputArgs args = widget.request.customData;
    return ViewModelBuilder<RoutesViewModel>.reactive(
        onModelReady: (viewModel) {
          viewModel.getRouteDetailsByRouteId(routeId: args.routeId);
        },
        builder: (context, viewModel, child) => BaseBottomSheet(
              bottomSheetTitle: 'Route ID: ${args.routeId}',
              request: widget.request,
              completer: widget.completer,
              child: viewModel.isBusy
                  ? Container(
                      height: 400,
                      child: ShimmerContainer(
                        itemCount: 5,
                      ),
                    )
                  : InfoWidget(
                      routeResponse: viewModel.routeResponse,
                      viewModel: viewModel,
                      route: args.route,
                    ),
            ),
        viewModelBuilder: () => RoutesViewModel());
  }
}

class InfoWidget extends StatelessWidget {
  final GetRouteDetailsResponse routeResponse;
  final RoutesViewModel viewModel;
  final FetchRoutesResponse route;

  const InfoWidget({
    Key key,
    @required this.routeResponse,
    @required this.viewModel,
    @required this.route,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        buildHubTitleItem(
          context: context,
          label: 'Route Title',
          value: routeResponse.title,
          // value: 'We are a really big company name private limited. '.toUpperCase(),
        ),
        // Text(routeResponse.title),
        viewModel.srcHub != null
            ? buildHubDetailsItem(
                label: 'Source',
                context: context,
                hubResponse: viewModel?.srcHub)
            : Container(),
        viewModel.dstHub == null
            ? Container()
            : buildHubDetailsItem(
                label: 'Destination',
                context: context,
                hubResponse: viewModel?.dstHub),
        // Text('Destination: ${viewModel?.dstHub?.title}'),
        buildHubTitleItem(
          context: context,
          label: 'Description',
          value: routeResponse.remarks,
          // value: 'We are a really big company name private limited. '.toUpperCase(),
        ),
        // Text('Description: ${routeResponse.remarks}'),
        hSizedBox(5),
        // InkWell(
        //   onTap: () {
        //     viewModel.takeToHubsView(clickedRoute: route);
        //   },
        //   child: Text(
        //     'View Hubs',
        //     style: AppTextStyles(fontSize: 12).hyperLinkStyleNew,
        //   ),
        // ),
        SizedBox(
          height: 40,
          width: 120,
          child: AppButton(
            borderColor: AppColors.primaryColorShade11,
            onTap: () {
              // viewModel.takeToHubsView(clickedRoute: route);
            },
            background: AppColors.primaryColorShade5,
            fontSize: 14,
            buttonText: ' View Full Route',
          ),
        )
        // InkWell(
        //   onTap: () {
        //     ///
        //     viewModel.takeToHubsView(clickedRoute: route);
        //   },
        //   child: Text('View Hub List'),
        // ),
      ],
    );
  }

  Container buildHubTitleItem({
    @required String label,
    @required String value,
    Function onValueClicked,
    BuildContext context,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.bottomSheetGridTileColors,
        border: Border(
          bottom: BorderSide(color: AppColors.appScaffoldColor, width: 1),
        ),
      ),
      height: 70,
      width: MediaQuery.of(context).size.width,
      // decoration: BoxDecoration(
      // borderRadius: BorderRadius.all(Radius.circular(6)),
      // color: Colors.white,
      // border: Border.all(
      //   color: AppColors.appScaffoldColor,
      // ),
      // ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: AppTextStyles.latoMedium14Black
                  .copyWith(color: AppColors.primaryColorShade4, fontSize: 12),
            ),
            InkWell(
              onTap: onValueClicked == null
                  ? null
                  : () {
                      onValueClicked.call();
                    },
              child: Text(
                value == null ? 'NA' : value,
                textAlign: TextAlign.left,
                style: AppTextStyles.latoMedium16Primary5.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
                // TextStyle(
                //     fontSize: 16,
                //     color: AppColors.primaryColorShade5
                // )
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container buildHubDetailsItem({
    @required String label,
    BuildContext context,
    GetHubDetailsResponse hubResponse,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.bottomSheetGridTileColors,
        border: Border(
          bottom: BorderSide(color: AppColors.appScaffoldColor, width: 1),
        ),
      ),
      height: 70,
      width: MediaQuery.of(context).size.width,
      // decoration: BoxDecoration(
      // borderRadius: BorderRadius.all(Radius.circular(6)),
      // color: Colors.white,
      // border: Border.all(
      //   color: AppColors.appScaffoldColor,
      // ),
      // ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: AppTextStyles.latoMedium14Black
                  .copyWith(color: AppColors.primaryColorShade4, fontSize: 12),
            ),
            RichText(
              textAlign: TextAlign.left,
              text: TextSpan(
                children: [
                  hubResponse.title != null && hubResponse.title != 'NA'
                      ? TextSpan(
                          text: hubResponse.title,
                          style: AppTextStyles.lato20PrimaryShade5.copyWith(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        )
                      : TextSpan(),
                  hubResponse.locality != null && hubResponse.locality != 'NA'
                      ? TextSpan(
                          text: ', ' + hubResponse.locality,
                          style: AppTextStyles.lato20PrimaryShade5.copyWith(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        )
                      : TextSpan(),
                  (hubResponse.city != null && hubResponse.city != 'NA') &&
                          (hubResponse.locality != hubResponse.city)
                      ? TextSpan(
                          text: ', ' + hubResponse.city,
                          style: AppTextStyles.lato20PrimaryShade5.copyWith(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        )
                      : TextSpan(),
                ],
              ),
            ),

            // Text(
            //   value == null ? 'NA' : value,
            //   textAlign: TextAlign.left,
            //   style: AppTextStyles.latoMedium16Primary5.copyWith(
            //     fontSize: 14,
            //     fontWeight: FontWeight.w600,
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}

class RouteDetailsBottomSheetInputArgs {
  final int routeId;
  final FetchRoutesResponse route;

  RouteDetailsBottomSheetInputArgs({
    @required this.routeId,
    @required this.route,
  });
}
