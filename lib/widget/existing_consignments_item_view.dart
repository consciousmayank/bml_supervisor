import 'package:bml_supervisor/app_level/colors.dart';
import 'package:bml_supervisor/utils/app_text_styles.dart';
import 'package:bml_supervisor/utils/dimens.dart';
import 'package:bml_supervisor/utils/widget_utils.dart';
import 'package:bml_supervisor/widget/app_text_view.dart';
import 'package:flutter/material.dart';

import 'clickable_widget.dart';

class ExistingConsignmentItem extends StatelessWidget {
  final ExistingConsignmentItemArguments args;

  const ExistingConsignmentItem({Key key, @required this.args})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: defaultElevation,
      shape: getCardShape(),
      child: ClickableWidget(
        borderRadius: getBorderRadius(),
        elevation: defaultElevation,
        onTap: null,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Chip(
                    label: Text(
                      "C#${args.consignmentId}",
                      style: AppTextStyles.latoMedium14Black
                          .copyWith(fontSize: 14, color: AppColors.white),
                    ),
                    backgroundColor: AppColors.primaryColorShade5,
                  ),
                  Text(
                    "(R# ${args.routeId} ${args.routeTitle})",
                    style: AppTextStyles.latoMedium14Black.copyWith(
                        fontSize: 14, color: AppColors.primaryColorShade5),
                  )
                ],
              ),
              hSizedBox(14),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: [
              //     Expanded(
              //       child: AppTextView(
              //         hintText: 'Route Id',
              //         value: args.routeId.toString(),
              //       ),
              //     ),
              //     wSizedBox(6),
              //     Expanded(
              //       child: AppTextView(
              //         hintText: 'Vehicle Id',
              //         value: args.vehicleId,
              //       ),
              //     ),
              //   ],
              // ),
              // hSizedBox(14),
              AppTextView(
                textAlign: TextAlign.center,
                hintText: 'Vehicle Id',
                value: args.vehicleId,
              )
            ],
          ),
        ),
      ),
    );
  }
}

class ExistingConsignmentItemArguments {
  final String routeTitle;
  final int consignmentId;
  final int routeId;
  final String vehicleId;

  ExistingConsignmentItemArguments({
    @required this.routeTitle,
    @required this.consignmentId,
    @required this.routeId,
    @required this.vehicleId,
  });
}
