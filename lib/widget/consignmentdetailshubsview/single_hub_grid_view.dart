import 'package:bml/bml.dart';
import 'package:bml_supervisor/models/consignment_detail_response_new.dart';
import 'package:bml_supervisor/widget/consignmentdetailshubsview/single_hub_list_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class SingleHubGridView extends StatelessWidget {
  final ItemForCard singleHub;
  const SingleHubGridView({
    @required this.singleHub,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SingleHubListViewModel>.reactive(
        onModelReady: (viewModel) {
          // viewModel.getHubDate(singleHub.hubId);
        },
        builder: (context, viewModel, child) => Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: AppColors.primaryColorShade5,
                      borderRadius: BorderRadius.all(Radius.circular(25)),
                    ),
                    child: Text(
                      "#${singleHub.sequence}",
                      style: AppTextStyles.latoMedium14Black
                          .copyWith(fontSize: 14, color: AppColors.white),
                    ),
                  ),
                  Utils().hSizedBox(5),
                  Text(
                    singleHub?.hubTitle,
                    style: AppTextStyles.latoMedium14Black.copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryColorShade5,
                    ),
                    maxLines: 3,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Utils().hSizedBox(10),
                  Text(
                    singleHub.hubCity ?? '',
                    style: AppTextStyles.latoMedium14Black.copyWith(
                        fontSize: 14, color: AppColors.primaryColorShade5),
                  ),
                  Utils().hSizedBox(10),
                  AppTextView(
                    hintText: 'Collect',
                    value: singleHub.collect.toString(),
                  ),
                  Utils().hSizedBox(10),
                  AppTextView(
                    hintText: 'Drop',
                    value: singleHub?.dropOff?.toString(),
                  ),
                  Utils().hSizedBox(10),
                  AppTextView(
                    hintText: 'Payment',
                    value: singleHub?.payment?.toString(),
                  )
                ],
              ),
            ),
        viewModelBuilder: () => SingleHubListViewModel());
  }
}
