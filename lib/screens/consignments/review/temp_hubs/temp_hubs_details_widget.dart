import 'package:bml_supervisor/app_level/colors.dart';
import 'package:bml_supervisor/models/single_temp_hub.dart';
import 'package:bml_supervisor/utils/app_text_styles.dart';
import 'package:bml_supervisor/utils/widget_utils.dart';
import 'package:bml_supervisor/widget/dotted_divider.dart';
import 'package:flutter/material.dart';

class TempHubsDetailsView extends StatelessWidget {
  final SingleTempHub singleHub;
  const TempHubsDetailsView({
    Key key,
    @required this.singleHub,
  })  : assert(
          singleHub != null,
        ),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Text(
              singleHub.title,
              style: AppTextStyles(
                textColor: AppColors.black,
              ).textStyle,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            flex: 2,
          ),
          Expanded(
            child: Text(
              '${singleHub.collect.toString()}\n(${singleHub.itemUnit})',
              style: AppTextStyles(
                textColor: AppColors.black,
              ).textStyle,
              textAlign: TextAlign.center,
            ),
            flex: 1,
          ),
          Expanded(
            child: Text(
              "${singleHub.dropOff.toString()}\n(${singleHub.itemUnit})",
              style: AppTextStyles(
                textColor: AppColors.black,
              ).textStyle,
              textAlign: TextAlign.center,
            ),
            flex: 1,
          ),
        ],
      ),
    );
  }
}
