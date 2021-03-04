import 'package:bml_supervisor/app_level/colors.dart';
import 'package:bml_supervisor/utils/app_text_styles.dart';
import 'package:bml_supervisor/utils/dimens.dart';
import 'package:bml_supervisor/utils/widget_utils.dart';
import 'package:flutter/material.dart';

class AppTiles extends StatefulWidget {
  final Function onTap;
  final String title, value, iconName;
  final double percentage;

  const AppTiles({
    Key key,
    this.onTap,
    @required this.title,
    @required this.value,
    @required this.iconName,
    this.percentage,
  }) : super(key: key);

  @override
  _AppTilesState createState() => _AppTilesState();
}

class _AppTilesState extends State<AppTiles> {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: Card(
        color: AppColors.white,
        // color: color,
        elevation: defaultElevation,
        shape: Border(
          left: BorderSide(color: AppColors.primaryColorShade5, width: 4),
        ),
        child: InkWell(
          splashColor: AppColors.primaryColorShade5,
          onTap: widget.onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 13,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.title,
                        style: TextStyle(
                          color: AppColors.primaryColorShade5,
                          fontSize: 13,
                        ),
                      ),
                      Row(
                        // mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        children: [
                          Text(
                            widget.value,
                            style: TextStyle(
                              color: AppColors.primaryColorShade5,
                              fontSize: 18,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          wSizedBox(5),
                          widget.percentage != null
                              ? Container(
                                  decoration: BoxDecoration(
                                    color: widget.percentage > 0
                                        ? Colors.green
                                        : Colors.red,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(4)),
                                  ),
                                  padding: EdgeInsets.all(2),
                                  child: Text(
                                    widget.percentage.toString() + '%',
                                    style: AppTextStyles.latoMedium12Black
                                        .copyWith(
                                      fontSize: 10,
                                      color: Colors.white,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                )
                              : Container(),
                        ],
                      ), //! make it dynamic
                    ],
                  ),
                ),
                widget.iconName.length > 0
                    ? Image.asset(
                        widget.iconName,
                        height: distributorIconHeight,
                        width: distributorIconWidth,
                      )
                    : Container(),
              ],
            ),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: [
            //     Column(
            //       crossAxisAlignment: CrossAxisAlignment.start,
            //       children: [
            //         Text(
            //           widget.title,
            //           style: TextStyle(
            //             color: AppColors.primaryColorShade5,
            //             fontSize: 14,
            //           ),
            //         ),
            //         Text(
            //           widget.value,
            //           style: TextStyle(
            //             color: AppColors.primaryColorShade5,
            //             fontSize: 20,
            //           ),
            //         ), //! make it dynamic
            //       ],
            //     ),
            //     // Text('logo'),
            //     widget.iconName.length > 0
            //         ? Image.asset(
            //             widget.iconName,
            //             height: distributorIconHeight,
            //             width: distributorIconWidth,
            //           )
            //         : Container(),
            //   ],
            // ),
          ),
        ),
      ),
    );
  }
}
