import 'package:bml_supervisor/app_level/colors.dart';
import 'package:bml_supervisor/app_level/themes.dart';
import 'package:bml_supervisor/utils/app_text_styles.dart';
import 'package:bml_supervisor/utils/dimens.dart';
import 'package:bml_supervisor/utils/widget_utils.dart';
import 'package:flutter/material.dart';

class AppRow extends StatelessWidget {
  final String headerTitle, headerValue;

  const AppRow({
    Key key,
    @required this.headerTitle,
    @required this.headerValue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: getBorderRadius(),
      child: Card(
        color: AppColors.appScaffoldColor,
        elevation: defaultElevation,
        shape: getCardShape(),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: ThemeConfiguration.primaryBackground,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(5), topRight: Radius.circular(5)),
              ),
              height: 50.0,
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              alignment: Alignment.centerLeft,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    headerTitle,
                    style: AppTextStyles.latoBold16White,
                  ),
                  Text(
                    headerValue,
                    style: AppTextStyles.latoBold16White,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
