import 'package:bml_supervisor/app_level/colors.dart';
import 'package:bml_supervisor/utils/app_text_styles.dart';
import 'package:bml_supervisor/utils/dimens.dart';
import 'package:bml_supervisor/utils/widget_utils.dart';
import 'package:bml_supervisor/widget/app_text_view.dart';
import 'package:flutter/material.dart';

import 'clickable_widget.dart';

class SingleConsignmentItem extends StatelessWidget {
  final SingleConsignmentItemArguments args;

  const SingleConsignmentItem({Key key, @required this.args}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: defaultElevation,
      shape: getCardShape(),
      child: ClickableWidget(
        borderRadius: getBorderRadius(),
        elevation: defaultElevation,
        onTap: () {
          args.onTap.call();
        },
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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        "(R# ${args.routeId} ${args.routeTitle})",
                        style: AppTextStyles.latoMedium14Black.copyWith(
                            fontSize: 14, color: AppColors.primaryColorShade5),
                      ),
                      Text(
                        "${args.vehicleId}",
                        style: AppTextStyles.latoMedium14Black.copyWith(
                            fontSize: 12, color: AppColors.primaryColorShade5),
                      ),
                    ],
                  )
                ],
              ),
              hSizedBox(14),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: AppTextView(
                      hintText: 'Collect',
                      value: args.collect,
                    ),
                  ),
                  wSizedBox(6),
                  Expanded(
                    child: AppTextView(
                      hintText: 'Drop',
                      value: args.drop,
                    ),
                  ),
                ],
              ),
              hSizedBox(14),
              AppTextView(
                hintText: 'Payment',
                value: args.payment,
              )
            ],
          ),
        ),
      ),
    );
  }
}

class SingleConsignmentItemArguments {
  final String consignmentId,
      routeId,
      routeTitle,
      collect,
      drop,
      payment,
      vehicleId;
  final Function onTap;

  SingleConsignmentItemArguments({
    @required this.onTap,
    @required this.consignmentId,
    @required this.routeId,
    @required this.routeTitle,
    @required this.collect,
    @required this.drop,
    @required this.payment,
    @required this.vehicleId,
  });
}
