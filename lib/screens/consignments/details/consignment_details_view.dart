import 'package:bml_supervisor/app_level/colors.dart';
import 'package:bml_supervisor/app_level/image_config.dart';
import 'package:bml_supervisor/screens/consignments/details/consignment_details_arguments.dart';
import 'package:bml_supervisor/utils/app_text_styles.dart';
import 'package:bml_supervisor/utils/dimens.dart';
import 'package:bml_supervisor/utils/widget_utils.dart';
import 'package:bml_supervisor/widget/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'consignment_detials_viewmodel.dart';

class ConsignmentDetailsView extends StatefulWidget {
  final ConsignmentDetailsArgument args;

  const ConsignmentDetailsView({Key key, this.args}) : super(key: key);

  @override
  _ConsignmentDetailsViewState createState() => _ConsignmentDetailsViewState();
}

class _ConsignmentDetailsViewState extends State<ConsignmentDetailsView> {
  final PageController _controller = PageController(
    initialPage: 0,
  );

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ConsignmentDetailsViewModel>.reactive(
      onModelReady: (viewModel) => viewModel.getConsignmentWithId(
        widget.args.consignmentId.toString(),
      ),
      builder: (context, viewModel, child) => SafeArea(
        top: true,
        bottom: true,
        left: true,
        right: true,
        child: Scaffold(
          appBar: AppBar(
            title: Text("Consignment Details",
                style: AppTextStyles.appBarTitleStyle),
            automaticallyImplyLeading: false,
            actions: [
              IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () {
                    Navigator.pop(context);
                  })
            ],
          ),
          body: viewModel.isBusy
              ? Container(
                  width: double.infinity,
                  height: double.infinity,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              : getBody(context: context, viewModel: viewModel),
        ),
      ),
      viewModelBuilder: () => ConsignmentDetailsViewModel(),
    );
  }

  Widget getBody(
      {BuildContext context, ConsignmentDetailsViewModel viewModel}) {
    return Column(
      children: [
        Expanded(
          child: PageView.builder(
            controller: _controller,
            itemBuilder: (BuildContext context, int index) {
              return Card(
                color: AppColors.primaryColorShade3,
                elevation: 4,
                shape: getCardShape(),
                child: Stack(
                  children: [
                    Image.asset(
                      semiCircles,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Expanded(
                            child: Container(
                              width: double.infinity,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Text(
                                    "${viewModel.consignmentDetailResponseNew.items[index].title}",
                                    style: AppTextStyles.latoBold18Black,
                                  ),
                                  InkWell(
                                    child: Image.asset(
                                      locationIcon,
                                      fit: BoxFit.cover,
                                      height: locationIconHeight,
                                      width: locationIconWidth,
                                    ),
                                    onTap: () {
                                      launchMaps(
                                          latitude: viewModel
                                              .consignmentDetailResponseNew
                                              .items[index]
                                              .hubGeoLatitude,
                                          longitude: viewModel
                                              .consignmentDetailResponseNew
                                              .items[index]
                                              .hubGeoLongitude);
                                    },
                                  ),
                                  Text("# ${index + 1}"),
                                  hSizedBox(10),
                                  Text(
                                    viewModel.consignmentDetailResponseNew
                                        .items[index].hubContactPerson
                                        .toUpperCase(),
                                    style: AppTextStyles.latoBold18Black,
                                  ),
                                  hSizedBox(10),
                                  Text(
                                      viewModel.consignmentDetailResponseNew
                                          .items[index].hubCity,
                                      style: AppTextStyles.latoMedium14Black),
                                  // Text(
                                  //     viewModel.consignmentDetailResponseNew
                                  //         .items[index].hub,
                                  //     style: AppTextStyles.latoMedium14Black),
                                ],
                              ),
                            ),
                          ),
                          rowMaker(
                            label: "Collect",
                            value:
                                "${viewModel.consignmentDetailResponseNew.items[index].collect}",
                          ),
                          wSizedBox(10),
                          rowMaker(
                            label: "Drop",
                            value:
                                "${viewModel.consignmentDetailResponseNew.items[index].dropOff}",
                          ),
                          wSizedBox(10),
                          rowMaker(
                            label: "Payment",
                            value:
                                "${viewModel.consignmentDetailResponseNew.items[index].payment}",
                          ),
                          wSizedBox(10),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
            itemCount: viewModel.consignmentDetailResponseNew.items.length,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: DotsIndicator(
            controller: _controller,
            itemCount: viewModel.consignmentDetailResponseNew.items.length,
            color: AppColors.primaryColorShade5,
          ),
        )
      ],
    );
  }

  Widget rowMaker({@required String label, @required String value}) {
    return Container(
      height: buttonHeight,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: AppTextStyles.latoBold12Black.copyWith(fontSize: 16),
            ),
            flex: 1,
          ),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.center,
              style: AppTextStyles.latoMedium14Black.copyWith(fontSize: 14),
            ),
            flex: 1,
          ),
        ],
      ),
    );
  }
}
