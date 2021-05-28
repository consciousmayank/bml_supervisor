import 'package:bml_supervisor/app_level/colors.dart';
import 'package:bml_supervisor/app_level/image_config.dart';
import 'package:bml_supervisor/models/secured_get_clients_response.dart';
import 'package:bml_supervisor/utils/app_text_styles.dart';
import 'package:bml_supervisor/utils/dimens.dart';
import 'package:bml_supervisor/utils/widget_utils.dart';
import 'package:bml_supervisor/widget/IconBlueBackground.dart';
import 'package:bml_supervisor/widget/app_textfield.dart';
import 'package:bml_supervisor/widget/clickable_widget.dart';
import 'package:bml_supervisor/widget/dotted_divider.dart';
import 'package:bml_supervisor/widget/no_data_dashboard_widget.dart';
import 'package:bml_supervisor/widget/routes/route_viewmodel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../app_button.dart';

class RoutesView extends StatefulWidget {
  final GetClientsResponse selectedClient;
  final Function onRoutesPageInView;
  final bool isInDashBoard;

  const RoutesView(
      {Key key,
      this.selectedClient,
      this.onRoutesPageInView,
      this.isInDashBoard})
      : super(key: key);

  @override
  _RoutesViewState createState() => _RoutesViewState();
}

class _RoutesViewState extends State<RoutesView> {
  PageController _pageViewController;
  ScrollController _listViewController;

  @override
  void initState() {
    _pageViewController = PageController();
    _listViewController = ScrollController();
    super.initState();
  }

  @override
  void dispose() {
    _pageViewController.dispose();
    _listViewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<RoutesViewModel>.reactive(
      onModelReady: (viewModel) =>
          viewModel.getRoutesForClient(widget.selectedClient.clientId),
      builder: (context, viewModel, child) {
        return viewModel.isBusy
            ? SizedBox(
                height: MediaQuery.of(context).size.height / 2,
                width: MediaQuery.of(context).size.width,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
            : buildRoutesListView(viewModel);
      },
      viewModelBuilder: () => RoutesViewModel(),
    );
  }

  Widget buildRoutesListView(RoutesViewModel viewModel) {
    return Padding(
      padding: EdgeInsets.only(
          left: 4.0,
          right: 4.0,
          top: 4.0,
          bottom: widget.isInDashBoard ? 4.0 : 0),
      child: widget.isInDashBoard
          ? getColumnList(
              viewModel: viewModel,
            )
          : getListViewList(
              viewModel: viewModel,
            ),
    );
  }

  Widget buildRoutesView(RoutesViewModel viewModel, int index) {

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(
            flex: 1,
            child: InkWell(
              onTap: () {
                widget.onRoutesPageInView(viewModel.routesList[index]);
              },
              child: Text(
                'R#${viewModel.routesList[index].routeId.toString()}',
                textAlign: TextAlign.center,
                // style: AppTextStyles.latoMedium14Black.copyWith(color: AppColors.primaryColorShade5),

                style: AppTextStyles.underLinedText.copyWith(
                    color: AppColors.primaryColorShade5, fontSize: 15),
              ),
            ),
          ),
          Expanded(
            child: Tooltip(
              // preferBelow: false,
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primaryColorShade11,
                borderRadius: BorderRadius.all(Radius.circular(defaultBorder)),
              ),
              // message: viewModel.routesList[index].routeTitle,
              message: 'Route desc/remarks not coming from api',
              textStyle: AppTextStyles.latoMedium12Black
                  .copyWith(color: AppColors.white),
              child: Text(
                viewModel.routesList[index].routeTitle,
                maxLines: 3,
                textAlign: TextAlign.center,
              ),
            ),
            flex: 2,
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
                color: AppColors.primaryColorShade5,
              ),
              padding: EdgeInsets.only(left: 0, right: 0, top: 5, bottom: 5),
              child: Center(
                child: Text(
                  viewModel.routesList[index].kilometers.toString(),
                  // maxLines: 3,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.whiteRegular,
                ),
              ),
            ),
            flex: 1,
          ),
        ],
      ),
    );
  }

  List<Widget> getRoutesList(
      {@required int listLength, @required RoutesViewModel viewModel}) {
    return List.generate(
      widget.isInDashBoard ? listLength + 1 : listLength,
      (index) => index == listLength
          ? Padding(
              padding: const EdgeInsets.only(
                top: 10,
                bottom: 5,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 35,
                    width: 100,
                    child: AppButton(
                      borderColor: Colors.transparent,
                      borderRadius: 20,
                      onTap: () {
                        viewModel.takeToViewRoutesPage();
                      },
                      background: AppColors.primaryColorShade5,
                      fontSize: 12,
                      buttonText: 'View More',
                    ),
                  ),
                ],
              ),
            )
          : Column(
              children: [
                buildRoutesView(viewModel, index),
                DottedDivider(),
              ],
            ),
    ).toList();
  }

  getListLength({RoutesViewModel viewModel}) {
    return widget.isInDashBoard
        ? viewModel.routesList.length < 6
            ? viewModel.routesList.length
            : 6
        : viewModel.routesList.length;
  }

  ///Show a 5 routes only
  getColumnList({@required RoutesViewModel viewModel}) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: Align(
            child: buildChartTitle(title: 'Route List'),
            alignment: Alignment.centerLeft,
          ),
        ),
        if (viewModel.routesList.length > 0)
          Container(
            color: AppColors.primaryColorShade5,
            padding: EdgeInsets.all(15),
            child: getTitle(viewModel: viewModel),
          ),
        viewModel.routesList.length > 0
            ? Column(
                children: getRoutesList(
                  viewModel: viewModel,
                  listLength: getListLength(
                    viewModel: viewModel,
                  ),
                ),
              )
            : NoDataWidget()
      ],
    );
  }

  getListViewList({@required RoutesViewModel viewModel}) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        addDriverView(
          iconName: addIcon,
          text: "Add New Route",
          onTap: () {
            viewModel.onAddRouteClicked();
          },
        ),
        hSizedBox(5),
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: Text(
            'Routes List',
            style: AppTextStyles.latoBold14primaryColorShade6,
          ),
        ),
        buildSearchDriverTextFormField(viewModel: viewModel),
        hSizedBox(5),
        if (viewModel.routesList.length > 0)
          Container(
            color: AppColors.primaryColorShade5,
            padding: EdgeInsets.all(15),
            child: getTitle(viewModel: viewModel),
          ),
        viewModel.routesList.length > 0
            ? Expanded(
                child: ListView(
                  children: getRoutesList(
                    viewModel: viewModel,
                    listLength: getListLength(
                      viewModel: viewModel,
                    ),
                  ),
                ),
              )
            : Expanded(
                child: NoDataWidget(),
              ),
      ],
    );
  }

  buildSearchDriverTextFormField({RoutesViewModel viewModel}) {
    return RawAutocomplete<String>(
      optionsBuilder: (TextEditingValue textEditingValue) {
        return viewModel
            .getRouteTitleForAutoComplete(viewModel.routesList)
            .where((String option) {
          return option.contains(textEditingValue.text.toUpperCase());
        }).toList();
      },
      onSelected: (String selection) {
        /// Add the selected Item into the list

        // CitiesResponse temp;
        // viewModel.cityList.forEach((element) {
        //   if (element.city == selection) {
        //     temp = element;
        //   }
        // });
        // viewModel.selectedCity = temp;
      },
      fieldViewBuilder: (BuildContext context,
          TextEditingController textEditingController,
          FocusNode focusNode,
          VoidCallback onFieldSubmitted) {
        return appTextFormField(
          // hintText: "Hubs",
          inputDecoration: InputDecoration(
            icon: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  color: AppColors.drawerIconsBackgroundColor,
                  borderRadius: getBorderRadius(),
                ),
                child: Center(
                  child: Image.asset(
                    searchBlueIcon,
                    height: 20,
                    width: 20,
                    // color: AppColors.primaryColorShade5,
                  ),
                ),
              ),
            ),
            hintText: 'Search for route',
            hintStyle: TextStyle(
              color: Colors.grey,
            ),
          ),
          controller: textEditingController,
          focusNode: focusNode,
          onFieldSubmitted: (String value) {
            onFieldSubmitted();
          },
          validator: (String value) {
            if (!viewModel
                .getRouteTitleForAutoComplete(viewModel.routesList)
                .contains(value)) {
              return 'Nothing selected.';
            }
            return null;
          },
        );
      },
      optionsViewBuilder: (BuildContext context,
          AutocompleteOnSelected<String> onSelected, Iterable<String> options) {
        return Align(
          alignment: Alignment.topLeft,
          child: Material(
            elevation: 4.0,
            child: SizedBox(
              height: 200.0,
              child: ListView(
                padding: EdgeInsets.all(8.0),
                children: options
                    .map((String option) => GestureDetector(
                  onTap: () {
                    onSelected(option);
                  },
                  child: ListTile(
                    title: Text(option),
                  ),
                ))
                    .toList(),
              ),
            ),
          ),
        );
      },
    );
  }
  Widget addDriverView({String text, String iconName, Function onTap}) {
    return Padding(
      padding: const EdgeInsets.only(top: 2, bottom: 2),
      child: ClickableWidget(
        childColor: AppColors.white,
        borderRadius: getBorderRadius(),
        onTap: () {
          onTap.call();
        },
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    iconName == null
                        ? Container()
                        : Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: IconBlueBackground(
                        iconName: iconName,
                      ),
                    ),
                    iconName == null ? Container() : wSizedBox(20),
                    Expanded(
                      child: Text(
                        text,
                        style: AppTextStyles.latoMedium12Black.copyWith(
                            color: AppColors.primaryColorShade5, fontSize: 14),
                      ),
                    ),
                  ],
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
      ),
    );
  }

  Row getTitle({RoutesViewModel viewModel}) {
    return Row(
      // mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Expanded(
          flex: 1,
          child: Text(
            ('#'),
            textAlign: TextAlign.center,
            style: AppTextStyles.whiteRegular,
          ),
        ),
        Expanded(
          flex: 2,
          child: Text(
            ('Title'),
            textAlign: TextAlign.center,
            style: AppTextStyles.whiteRegular,
          ),
        ),
        Expanded(
          flex: 1,
          child: Text(
            'Kilometer',
            textAlign: TextAlign.end,
            style: AppTextStyles.whiteRegular,
          ),
        ),
      ],
    );
  }
}
