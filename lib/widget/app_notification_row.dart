import 'package:bml_supervisor/app_level/colors.dart';
import 'package:bml_supervisor/app_level/image_config.dart';
import 'package:bml_supervisor/utils/app_text_styles.dart';
import 'package:bml_supervisor/utils/widget_utils.dart';
import 'package:flutter/material.dart';

class NotificationTile extends StatefulWidget {
  final String iconName;
  final String notificationTitle;
  final taskNumber;
  final Function onTap;

  const NotificationTile({
    @required this.iconName,
    @required this.notificationTitle,
    @required this.taskNumber,
    this.onTap,
    Key key,
  }) : super(key: key);

  @override
  _NotificationTileState createState() => _NotificationTileState();
}

class _NotificationTileState extends State<NotificationTile> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: widget.onTap,
        splashColor: AppColors.primaryColorShade5,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                // mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Image.asset(
                    widget.iconName,
                    height: 20,
                    width: 20,
                  ),
                  wSizedBox(8),
                  Text(
                    widget.notificationTitle,
                    style: AppTextStyles.latoMedium12Black,
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.taskNumber.toString(),
                    style: AppTextStyles.latoMedium12Black
                        .copyWith(color: AppColors.primaryColorShade5),
                  ),
                  wSizedBox(8),
                  Image.asset(
                    forwardArrowIcon,
                    height: 10,
                    width: 10,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
