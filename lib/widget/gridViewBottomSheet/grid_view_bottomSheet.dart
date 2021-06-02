import 'package:bml_supervisor/app_level/colors.dart';
import 'package:bml_supervisor/app_level/setup_bottomsheet_ui.dart';
import 'package:bml_supervisor/utils/app_text_styles.dart';
import 'package:bml_supervisor/utils/widget_utils.dart';
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
    return BaseBottomSheet(
      bottomSheetTitle: args.title,
      request: request,
      completer: completer,
      child: BottomSheetGridView(
        itemList: args.helperList,
      ),
    );
  }
}

/// # Class to get list of items to be shown in gridview.
/// 
/// [helperList] The list that will be shown in GridView.
/// The last item will be shown in bottom of the bottomsheet. (Most probably used to show multiline Description.).
/// If the length is odd then one blank item will be added, to make the gridview even.
/// [title] the title to be shown in bottomSheet.
class GridViewBottomSheetInputArgument {
  final List<GridViewHelper> helperList;
  final String title;
  GridViewBottomSheetInputArgument({
    @required this.helperList,
    @required this.title,
  });
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
    GridViewHelper lastItem = itemList.removeLast();

    if (itemList.length % 2 != 0)
      itemList.add(
        GridViewHelper(
          label: '',
          value: '',
          onValueClick: null,
        ),
      );

    return Flexible(
      flex: 1,
      fit: FlexFit.loose,
      child: CustomScrollView(slivers: <Widget>[
        SliverGrid(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 1.0,
            mainAxisSpacing: 1.0,
            childAspectRatio: 3 / 1,
          ),
          delegate: SliverChildListDelegate(
            itemList
                .map(
                  (singleItem) => BottomSheetGridViewItem(
                    label: singleItem.label,
                    value: singleItem.value,
                    onValueClicked: singleItem.onValueClick,
                  ),
                )
                .toList(),
          ),
        ),
        SliverToBoxAdapter(
          child: Container(
            constraints: BoxConstraints(
              minHeight: 80,
              minWidth: double.infinity,
            ),
            padding: const EdgeInsets.all(1),
            child: BottomSheetGridViewItem(
              label: lastItem.label,
              value: lastItem.value,
              onValueClicked: lastItem.onValueClick,
            ),
          ),
        ),
      ]),
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
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding:
                const EdgeInsets.only(left: 8, right: 8, top: 4, bottom: 4),
            child: Text(
              label.trim(),
              style: AppTextStyles.bsGridViewLabelStyle().textStyle,
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.only(left: 8, right: 8, top: 4, bottom: 4),
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
