import 'package:bml_supervisor/app_level/colors.dart';
import 'package:bml_supervisor/app_level/image_config.dart';
import 'package:bml_supervisor/utils/widget_utils.dart';
import 'package:bml_supervisor/widget/IconBlueBackground.dart';
import 'package:bml_supervisor/widget/clickable_widget.dart';
import 'package:flutter/material.dart';

class CreateNewButtonWidget extends StatelessWidget {
  final Function onTap;
  final String title;
  const CreateNewButtonWidget({
    Key key,
    @required this.title,
    @required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClickableWidget(
      childColor: AppColors.white,
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            IconBlueBackground(
              iconName: addIcon,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 16, right: 16),
                child: Text(title),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(
                forwardArrowIcon,
                height: 10,
                width: 10,
              ),
            ),
          ],
        ),
      ),
      onTap: () => onTap.call(),
      borderRadius: getBorderRadius(),
    );
  }
}
