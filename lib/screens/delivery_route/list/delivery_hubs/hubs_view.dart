import 'package:bml_supervisor/app_level/colors.dart';
import 'package:bml_supervisor/app_level/image_config.dart';
import 'package:bml_supervisor/models/fetch_routes_response.dart';
import 'package:bml_supervisor/utils/app_text_styles.dart';
import 'package:bml_supervisor/utils/dimens.dart';
import 'package:bml_supervisor/utils/widget_utils.dart';
import 'package:bml_supervisor/widget/app_text_view.dart';
import 'package:bml_supervisor/widget/no_data_dashboard_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:url_launcher/url_launcher.dart';

import 'hubs_viewmodel.dart';

class HubsView extends StatefulWidget {
  final FetchRoutesResponse selectedRoute;
  final Key key;

  HubsView({@required this.selectedRoute, this.key}) : super(key: key);

  @override
  _HubsViewState createState() => _HubsViewState();
}

class _HubsViewState extends State<HubsView> {
  PageController _controller = PageController(
    initialPage: 0,
  );

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<HubsViewModel>.reactive(
        onModelReady: (viewModel) {
          // Future.delayed(Duration(seconds: 1),(){
          //   viewModel.setBusy(true);
          viewModel.getHubs(widget.selectedRoute);
          // });
        },
        builder: (context, viewModel, child) => Scaffold(
              appBar: AppBar(
                title: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '#${widget.selectedRoute.routeId}-${widget.selectedRoute.routeTitle}',
                      style: AppTextStyles.appBarTitleStyle,
                    ),
                    Text(
                      '${widget.selectedRoute.kilometers} kms',
                      style: AppTextStyles.appBarTitleStyle,
                    )
                  ],
                ),
                centerTitle: true,
              ),
              body: viewModel.isBusy
                  ? SizedBox(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : viewModel.hubsList.length > 0
                      ? Scrollbar(
                          child: ListView.builder(
                            controller: _controller,
                            itemBuilder: (BuildContext context, int index) {
                              return viewModel.hubsList[index].flag == 'S' ||
                                      viewModel.hubsList[index].flag == 'D'
                                  ? Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 2),
                                      child:
                                          buildSingleHubView(viewModel, index),
                                    )
                                  : Container();
                            },
                            itemCount: viewModel.hubsList.length,
                          ),
                        )
                      : Center(child: NoDataWidget()),
            ),
        viewModelBuilder: () => HubsViewModel());
  }

  Card buildSingleHubView(HubsViewModel viewModel, int index) {
    return Card(
      color: AppColors.routesCardColor,
      elevation: 4,
      shape: getCardShape(),
      child: Container(
        padding: EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Chip(
              // padding: EdgeInsets.all(1),
              labelPadding: EdgeInsets.symmetric(horizontal: 8),
              backgroundColor: AppColors.primaryColorShade5,
              label: (Text(
                  "#${viewModel.hubsList[index].sequence}  ${viewModel.hubsList[index].city}")),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  hubTitleIcon,
                  height: distributorIconHeight,
                  width: distributorIconWidth,
                ),
                wSizedBox(5),
                Text(
                  viewModel.hubsList[index].title,
                  style: AppTextStyles.latoBold18PrimaryShade5,
                ),
              ],
            ),
            hSizedBox(6),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  userIcon,
                  height: distributorIconHeight,
                  width: distributorIconWidth,
                  color: AppColors.primaryColorShade5,
                ),
                wSizedBox(5),
                Text("${viewModel.hubsList[index].contactPerson.toUpperCase()}",
                    style: AppTextStyles.latoMedium16Primary5),
              ],
            ),
            InkWell(
              onTap: () {
                launch("tel://${viewModel.hubsList[index].mobile}");
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Image.asset(
                  //   profileIcon,
                  //   height: 25,
                  //   width: 25,
                  // ),
                  Icon(
                    Icons.call,
                  ),
                  Text("${viewModel.hubsList[index].mobile}",
                      style: AppTextStyles.latoMedium16Primary5),
                ],
              ),
            ),
            InkWell(
              onTap: () {
                launchMaps(
                    latitude: viewModel.hubsList[index].geoLatitude,
                    longitude: viewModel.hubsList[index].geoLongitude);
              },
              child: Column(
                children: [
                  Image.asset(
                    locationIcon,
                    height: 50,
                    width: 50,
                    color: AppColors.primaryColorShade5,
                  ),
                  Text(
                    "Get Direction",
                    style: AppTextStyles.latoBold12Black
                        .copyWith(color: AppColors.primaryColorShade5),
                  )
                ],
              ),
            ),
            hSizedBox(10),
            SizedBox(
              width: 180,
              child: Padding(
                padding: const EdgeInsets.only(left: 8, right: 8),
                child: AppTextView(
                  textAlign: TextAlign.center,
                  isUnderLined: false,
                  underLinedTextFontSize: 22,
                  hintText: 'KMS',
                  value: viewModel.hubsList[index].kilometer.toString(),
                  // value: '8888888888888.8888',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
