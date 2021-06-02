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
        gridList: args.gridList,
        headerList: args.headerList,
        footerList: args.footerList,
      ),
    );
  }
}

/// # Class to get list of items to be shown in gridview.
///
/// [gridList] The list that will be shown in GridView.
/// The last item will be shown in bottom of the bottomsheet. (Most probably used to show multiline Description.).
/// If the length is odd then one blank item will be added, to make the gridview even.
/// [title] the title to be shown in bottomSheet.
class GridViewBottomSheetInputArgument {
  final List<GridViewHelper> gridList;
  final List<GridViewHelper> headerList;
  final List<GridViewHelper> footerList;
  final String title;

  GridViewBottomSheetInputArgument({
    @required this.gridList,
    @required this.headerList,
    @required this.footerList,
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
  final List<GridViewHelper> gridList;
  final List<GridViewHelper> headerList;
  final List<GridViewHelper> footerList;

  const BottomSheetGridView({
    Key key,
    @required this.gridList,
    @required this.headerList,
    @required this.footerList,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    if (gridList.length % 2 != 0)
      gridList.add(
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
        SliverList(
          delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) => Container(
                    constraints: BoxConstraints(
                      minHeight: 80,
                      minWidth: double.infinity,
                    ),
                    padding: const EdgeInsets.all(1),
                    child: BottomSheetGridViewItem(
                      label: headerList[index].label,
                      value: headerList[index].value,
                      onValueClicked: headerList[index].onValueClick,
                    ),
                  ),
              childCount: headerList.length),
        ),
        SliverGrid(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 1.0,
            mainAxisSpacing: 1.0,
            childAspectRatio: 3 / 1,
          ),
          delegate: SliverChildListDelegate(
            gridList
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
        SliverList(
          delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) => Container(
                    constraints: BoxConstraints(
                      minHeight: 80,
                      minWidth: double.infinity,
                    ),
                    padding: const EdgeInsets.all(1),
                    child: BottomSheetGridViewItem(
                      label: footerList[index].label,
                      value: footerList[index].value,
                      onValueClicked: footerList[index].onValueClick,
                    ),
                  ),
              childCount: footerList.length),
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
