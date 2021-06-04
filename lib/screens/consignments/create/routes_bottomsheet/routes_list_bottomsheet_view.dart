import 'package:bml_supervisor/app_level/colors.dart';
import 'package:bml_supervisor/app_level/setup_bottomsheet_ui.dart';
import 'package:bml_supervisor/screens/consignments/create/routes_bottomsheet/route_list_bottomsheet_viewmodel.dart';
import 'package:bml_supervisor/utils/app_text_styles.dart';
import 'package:bml_supervisor/utils/widget_utils.dart';
import 'package:bml_supervisor/widget/clickable_widget.dart';
import 'package:bml_supervisor/widget/dotted_divider.dart';
import 'package:bml_supervisor/widget/shimmer_container.dart';
import 'package:flutter/material.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class RoutesListBottomSheetView extends StatelessWidget {
  final SheetRequest request;
  final Function(SheetResponse) completer;

  const RoutesListBottomSheetView({Key key, this.completer, this.request})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<RoutesListBottomSheetViewModel>.reactive(
      onModelReady: (model) => model.getRoutes(),
      builder: (context, model, child) => BaseBottomSheet(
        bottomSheetTitle: 'Available Routes',
        request: request,
        completer: completer,
        child: Expanded(
          child: model.isBusy
              ? ShimmerContainer(
                  itemCount: 20,
                )
              : model.routeList.length > 0
                  ? makeRouteListView(viewModel: model)
                  : Container(),
        ),
      ),
      viewModelBuilder: () => RoutesListBottomSheetViewModel(),
    );
  }

  makeRouteListView({RoutesListBottomSheetViewModel viewModel}) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          color: AppColors.primaryColorShade5,
          padding: EdgeInsets.all(15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 1,
                child: Text(
                  ('Route No.'),
                  textAlign: TextAlign.left,
                  style: AppTextStyles.whiteRegular,
                ),
              ),
              Expanded(
                flex: 4,
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(
                    ('Route Name'),
                    textAlign: TextAlign.left,
                    style: AppTextStyles.whiteRegular,
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: LazyLoadScrollView(
            onEndOfPage: () {
              viewModel.getRoutes(pageNumber: viewModel.pageIndex);
            },
            child: ListView.builder(
              itemBuilder: (context, index) => Column(
                children: [
                  ClickableWidget(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 10,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            flex: 1,
                            child: Text(
                              '${viewModel.routeList[index].routeId.toString()}.',
                              textAlign: TextAlign.center,
                              style: AppTextStyles().textStyle,
                            ),
                          ),
                          Expanded(
                            flex: 4,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text(
                                viewModel.routeList[index].routeTitle,
                                textAlign: TextAlign.left,
                                style: AppTextStyles().textStyle,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    onTap: () {
                      completer(
                        SheetResponse(
                            confirmed: true,
                            responseData: viewModel.routeList[index]),
                      );
                    },
                    borderRadius: getBorderRadius(borderRadius: 0),
                  ),
                  if (index != viewModel.routeList.length - 1) DottedDivider()
                ],
              ),
              itemCount: viewModel.routeList.length,
            ),
          ),
        ),
      ],
    );
  }
}
