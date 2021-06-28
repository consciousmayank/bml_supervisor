import 'package:bml_supervisor/app_level/colors.dart';
import 'package:bml_supervisor/screens/driver/view/drivers_list_viewmodel.dart';
import 'package:bml_supervisor/utils/app_text_styles.dart';
import 'package:bml_supervisor/utils/form_validators.dart';
import 'package:bml_supervisor/utils/widget_utils.dart';
import 'package:bml_supervisor/widget/clickable_widget.dart';
import 'package:bml_supervisor/widget/dotted_divider.dart';
import 'package:bml_supervisor/widget/new_search_widget.dart';
import 'package:bml_supervisor/widget/no_data_dashboard_widget.dart';
import 'package:bml_supervisor/widget/shimmer_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:stacked/stacked.dart';

class DriverListBottomSheetView extends StatefulWidget {
  final DriverListBottomSheetViewArguments arguments;
  final Function onDriverSelected;
  const DriverListBottomSheetView(
      {Key key, @required this.arguments, @required this.onDriverSelected})
      : super(key: key);
  @override
  _DriverListBottomSheetViewState createState() =>
      _DriverListBottomSheetViewState();
}

class _DriverListBottomSheetViewState extends State<DriverListBottomSheetView> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<DriversListViewModel>.reactive(
      onModelReady: (model) => model.getDriversList(showLoading: true),
      builder: (context, model, child) => model.isBusy
          ? Flexible(
              flex: 1,
              fit: FlexFit.loose,
              child: ShimmerContainer(
                itemCount: 20,
              ),
            )
          : DriverListBottomSheetViewBody(
              onDriverSelected: widget.onDriverSelected,
              model: model,
            ),
      viewModelBuilder: () => DriversListViewModel(),
    );
  }
}

class DriverListBottomSheetViewBody extends StatefulWidget {
  final DriversListViewModel model;
  final Function onDriverSelected;
  const DriverListBottomSheetViewBody({
    Key key,
    @required this.model,
    @required this.onDriverSelected,
  }) : super(key: key);

  @override
  _DriverListBottomSheetViewBodyState createState() =>
      _DriverListBottomSheetViewBodyState();
}

class _DriverListBottomSheetViewBodyState
    extends State<DriverListBottomSheetViewBody> {
  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: NotificationListener(
        onNotification: (scrollNotification) {
          if (NotificationListener is ScrollEndNotification) {
            widget.model.getDriversList(showLoading: false);
          }
          return false;
        },
        child: CustomScrollView(
          slivers: [
            if (widget.model.driversList.length == 0)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: NoDataWidget(
                    label: 'No drivers yet',
                  ),
                ),
              ),
            if (widget.model.driversList.length > 0)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: SearchWidget(
                    focusNode: FocusNode(),
                    onClearTextClicked: () {
                      hideKeyboard(context: context);
                    },
                    hintTitle: 'Search for driver',
                    onTextChange: (String value) {},
                    onEditingComplete: () {},
                    formatter: <TextInputFormatter>[
                      TextFieldInputFormatter().alphaNumericFormatter,
                    ],
                    controller: TextEditingController(),
                    keyboardType: TextInputType.text,
                    onFieldSubmitted: (String value) {},
                  ),
                ),
              ),
            if (widget.model.driversList.length > 0)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Container(
                    color: AppColors.primaryColorShade5,
                    padding: EdgeInsets.all(15),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 2,
                          child: Text(
                            ('VEHICLE NO.'),
                            textAlign: TextAlign.left,
                            style: AppTextStyles.whiteRegular,
                          ),
                        ),
                        Expanded(
                          flex: 4,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: Text(
                              ('DRIVER NAME'),
                              textAlign: TextAlign.left,
                              style: AppTextStyles.whiteRegular,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            'EXP(YRS)',
                            textAlign: TextAlign.right,
                            style: AppTextStyles.whiteRegular,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            if (widget.model.driversList.length > 0)
              SliverList(
                delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) =>
                        buildSingleDriverItem(context, index),
                    childCount: widget.model.driversList.length),
              ),
          ],
        ),
      ),
      flex: 1,
      fit: FlexFit.loose,
    );
  }

  Widget buildSingleDriverItem(BuildContext context, int index) {
    String driverName =
        '${widget.model.driversList[index].firstName.toUpperCase()} ${widget.model.driversList[index].lastName.toUpperCase()}';

    if (driverName.length > 15) {
      driverName = driverName.characters.take(15).toString() + '...';
    }
    return Column(
      children: [
        ClickableWidget(
          borderRadius: getBorderRadius(borderRadius: 0),
          onTap: () {
            widget.onDriverSelected(
              widget.model.driversList.elementAt(index),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    '${widget.model.driversList[index].vehicleId.toUpperCase()}',
                    textAlign: TextAlign.left,
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: Text(
                    driverName,
                    maxLines: 1,
                    textAlign: TextAlign.left,
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 12.0),
                    child: Container(
                      padding:
                          EdgeInsets.only(top: 5, bottom: 5, left: 8, right: 8),
                      decoration: BoxDecoration(
                        color: AppColors.primaryColorShade5,
                        borderRadius: getBorderRadius(),
                      ),
                      child: Text(
                        widget.model.driversList[index].workExperienceYr
                            .toString(),
                        style: AppTextStyles.whiteRegular,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        DottedDivider()
      ],
    );
  }
}

class DriverListBottomSheetViewArguments {}
