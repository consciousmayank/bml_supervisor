import 'package:bml_supervisor/app_level/colors.dart';
import 'package:bml_supervisor/app_level/setup_bottomsheet_ui.dart';
import 'package:bml_supervisor/utils/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:stacked_services/stacked_services.dart';

///For showing information in a gridView in bottomSheet
class GridViewBottomSheet extends StatelessWidget {
  final SheetRequest request;
  final Function(SheetResponse) completer;

  const GridViewBottomSheet({
    Key key,
    @required this.request,
    @required this.completer,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    GridViewBottomSheetInputArgument args = request.customData;
    if (args.helperList.length % 2 != 0)
      args.helperList.add(
        GridViewHelper(
          label: '',
          value: '',
          onValueClick: null,
        ),
      );
    return BaseHalfScreenBottomSheet(
      bottomSheetTitle: args.title,
      request: request,
      completer: completer,
      child: BottomSheetGridView(
        itemList: args.helperList,
      ),
    );
  }
}

class GridViewBottomSheetInputArgument {
  final List<GridViewHelper> helperList;
  final String title;
  GridViewBottomSheetInputArgument(
      {@required this.helperList, @required this.title});
}

class GridViewBottomSheetOutputArguments {}

class GridViewHelper {
  final String label, value;
  final Function onValueClick;

  GridViewHelper({
    @required this.label,
    @required this.value,
    @required this.onValueClick,
  });
}

class BottomSheetGridView extends StatelessWidget {
  final List<GridViewHelper> itemList;

  const BottomSheetGridView({Key key, @required this.itemList})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GridView.builder(
        itemCount: itemList.length,
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
            onValueClicked: itemList[index].onValueClick,
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
              label.trim(),
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
                value == null ? 'NA' : value.trim(),
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
