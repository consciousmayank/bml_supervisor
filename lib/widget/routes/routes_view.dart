import 'package:bml_supervisor/app_level/colors.dart';
import 'package:bml_supervisor/models/secured_get_clients_response.dart';
import 'package:bml_supervisor/utils/app_text_styles.dart';
import 'package:bml_supervisor/utils/widget_utils.dart';
import 'package:bml_supervisor/widget/routes/route_viewmodel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class RoutesView extends StatefulWidget {
  final GetClientsResponse selectedClient;
  final Function onRoutesPageInView;
  final bool isInDashBoard;

  RoutesView({
    @required this.selectedClient,
    @required this.onRoutesPageInView,
    this.isInDashBoard = true,
  });

  @override
  _RoutesViewState createState() => _RoutesViewState();
}

class _RoutesViewState extends State<RoutesView> {
  PageController _pageViewController;
  ScrollController _listViewController;

  @override
  void initState() {
    _pageViewController = PageController();
    _listViewController = ScrollController();
    super.initState();
  }

  @override
  void dispose() {
    _pageViewController.dispose();
    _listViewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<RoutesViewModel>.reactive(
      onModelReady: (viewModel) =>
          viewModel.getRoutesForClient(widget.selectedClient.clientId),
      builder: (context, viewModel, child) {
        return viewModel.isBusy
            ? SizedBox(
                height: MediaQuery.of(context).size.height / 2,
                width: MediaQuery.of(context).size.width,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
            : viewModel.routesList.length > 0
                ? buildRoutesListView(viewModel)
                : Container();
      },
      viewModelBuilder: () => RoutesViewModel(),
    );
  }

  Widget buildRoutesListView(RoutesViewModel viewModel) {
    return Padding(
      padding: EdgeInsets.only(
          left: 4.0,
          right: 4.0,
          top: 4.0,
          bottom: widget.isInDashBoard ? 4.0 : 0),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // hSizedBox(5),
          Container(
            color: AppColors.primaryColorShade5,
            padding: EdgeInsets.all(15),
            child: Row(
              // mainAxisAlignment: MainAxisAlignment.end,
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
                    ('Title'),
                    textAlign: TextAlign.center,
                    style: AppTextStyles.whiteRegular,
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    'Kilometer',
                    textAlign: TextAlign.end,
                    style: AppTextStyles.whiteRegular,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.separated(
              // physics:
              //     widget.isFullScreen ? null : NeverScrollableScrollPhysics(),
              controller: _listViewController,
              itemBuilder: (BuildContext context, int index) {
                return buildRoutesView(viewModel, index);
              },
              itemCount: widget.isInDashBoard ? 4 : viewModel.routesList.length,
              separatorBuilder: (BuildContext context, int index) {
                return Divider(
                  thickness: 1,
                  color: AppColors.primaryColorShade3,
                );
              },
            ),
          ),
          widget.isInDashBoard
              ? InkWell(
                  onTap: () {
                    // viewModel.takeToViewRoutesPage();
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                      color: AppColors.primaryColorShade5,
                    ),
                    padding:
                        const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                    child: Text(
                      "View More",
                      style: AppTextStyles.whiteRegular,
                    ),
                  ),
                )
              : Container(),
          hSizedBox(5),
        ],
      ),
    );
  }

  Widget buildRoutesView(RoutesViewModel viewModel, int index) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(
            flex: 1,
            child: InkWell(
              onTap: () {
                widget.onRoutesPageInView(viewModel.routesList[index]);
              },
              child: Text(
                'R#${viewModel.routesList[index].routeId.toString()}',
                textAlign: TextAlign.center,
                // style: AppTextStyles.latoMedium14Black.copyWith(color: AppColors.primaryColorShade5),

                style: AppTextStyles.underLinedText.copyWith(
                    color: AppColors.primaryColorShade5, fontSize: 15),
              ),
            ),
          ),
          Expanded(
            child: Text(
              viewModel.routesList[index].routeTitle,
              maxLines: 3,
              textAlign: TextAlign.center,
            ),
            flex: 2,
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
                color: AppColors.primaryColorShade5,
              ),
              padding: EdgeInsets.only(left: 0, right: 0, top: 5, bottom: 5),
              child: Center(
                child: Text(
                  viewModel.routesList[index].kilometers.toString(),
                  // maxLines: 3,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.whiteRegular,
                ),
              ),
            ),
            flex: 1,
          ),
        ],
      ),
    );
  }
}
