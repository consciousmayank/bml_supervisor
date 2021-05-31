import 'package:bml_supervisor/app_level/setup_bottomsheet_ui.dart';
import 'package:bml_supervisor/models/get_route_details_response.dart';
import 'package:bml_supervisor/widget/routes/route_viewmodel.dart';
import 'package:bml_supervisor/widget/shimmer_container.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
          print('on botoom sheet model ready: ${args.routeId}');
          viewModel.getRouteDetailsByRouteId(routeId: args.routeId);
        },
        builder: (context, viewModel, child) => BaseBottomSheet(
              bottomSheetTitle: 'Route ID: ${args.routeId}',
              request: widget.request,
              completer: widget.completer,
              child: viewModel.isBusy
                  ? Container(
                      height: 100,
                      child: ShimmerContainer(
                        itemCount: 2,
                      ),
                    )
                  : InfoWidget(
                      routeResponse: viewModel.routeResponse,
                    ),
            ),
        viewModelBuilder: () => RoutesViewModel());
  }
}

class InfoWidget extends StatelessWidget {
  final GetRouteDetailsResponse routeResponse;

  const InfoWidget({
    Key key,
    @required this.routeResponse,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(top: 10.0),
        child: Column(
          children: [
            Text(routeResponse.title),
            Text('Source: ${routeResponse.srcLocation}'),
            Text('Destination: ${routeResponse.dstLocation}'),
            Text('Description: ${routeResponse.remarks}'),
            InkWell(
              onTap: () {
                ///
                // viewModel.onRoutesPageInView(viewModel.routesList[index]);
              },
              child: Text('View Hub List'),
            ),
          ],
        ),
      ),
    );
  }

// Container buildGridItem({
//   @required String label,
//   @required String value,
//   Function onValueClicked,
// }) {
//   return Container(
//     color: AppColors.bottomSheetGridTileColors,
//     // decoration: BoxDecoration(
//     // borderRadius: BorderRadius.all(Radius.circular(6)),
//     // color: Colors.white,
//     // border: Border.all(
//     //   color: AppColors.appScaffoldColor,
//     // ),
//     // ),
//     child: Column(
//       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Padding(
//           padding: const EdgeInsets.only(left: 8.0),
//           child: Text(
//             label,
//             style: AppTextStyles.latoMedium14Black
//                 .copyWith(color: AppColors.primaryColorShade4, fontSize: 12),
//           ),
//         ),
//         Padding(
//           padding: const EdgeInsets.only(left: 8.0),
//           child: InkWell(
//             onTap: onValueClicked == null
//                 ? null
//                 : () {
//                     onValueClicked.call();
//                   },
//             child: Text(
//               value == null ? 'NA' : value,
//               textAlign: TextAlign.left,
//               style: AppTextStyles.latoMedium16Primary5
//                   .copyWith(fontSize: 14, fontWeight: FontWeight.w600),
//               // TextStyle(
//               //     fontSize: 16,
//               //     color: AppColors.primaryColorShade5
//               // )
//             ),
//           ),
//         ),
//       ],
//     ),
//   );
// }
}

class RouteDetailsBottomSheetInputArgs {
  final int routeId;

  RouteDetailsBottomSheetInputArgs({@required this.routeId});
}
