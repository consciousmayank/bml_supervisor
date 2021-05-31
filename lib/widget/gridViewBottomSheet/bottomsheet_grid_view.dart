import 'package:bml_supervisor/app_level/colors.dart';
import 'package:bml_supervisor/utils/app_text_styles.dart';
import 'package:flutter/material.dart';


class GridViewHelper {
  String label, value;
}

class BottomSheetGridView extends StatelessWidget {
  final List<GridViewHelper> itemList;

  const BottomSheetGridView({Key key, @required this.itemList})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 1.0,
          mainAxisSpacing: 1.0,
          childAspectRatio: 3 / 1,
        ),
        itemBuilder: (BuildContext context, int index) {
          return BottomSheetGridViewItem(
            label: itemList[index].label,
            value: itemList[index].value,
          );
        },
      ),
    );
  }
}

class BottomSheetGridViewItem extends StatelessWidget {
  final String label;
  final String value;
  final onValueClicked;

  const BottomSheetGridViewItem({
    Key key,
    this.label,
    this.value,
    this.onValueClicked,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.bottomSheetGridTileColors,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text(
              label,
              style: AppTextStyles.bsGridViewLabelStyle().textStyle,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: InkWell(
              onTap: onValueClicked == null
                  ? null
                  : () {
                      onValueClicked.call();
                    },
              child: Text(
                value == null ? 'NA' : value,
                textAlign: TextAlign.left,
                style: AppTextStyles.bsGridViewValueStyle().textStyle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
