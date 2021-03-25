import 'package:bml_supervisor/app_level/colors.dart';
import 'package:bml_supervisor/app_level/shared_prefs.dart';
import 'package:bml_supervisor/utils/dimens.dart';
import 'package:bml_supervisor/utils/stringutils.dart';
import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:flutter/material.dart';

class SelectDurationTabWidget extends StatelessWidget {
  final List<String> optionsList = selectDurationList;
  final Function onTabSelected;
  final String initiallySelectedDuration;
  final String title;

  const SelectDurationTabWidget({
    Key key,
    @required this.onTabSelected,
    @required this.initiallySelectedDuration,
    @required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title != null ? title : selectDurationTabWidgetTitle),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: SizedBox(
              height: 50,
              width: MediaQuery.of(context).size.width,
              child: DefaultTabController(
                length: optionsList.length, // length of tabs
                initialIndex: initiallySelectedDuration == null
                    ? 1
                    : initiallySelectedDuration == optionsList.first
                        ? 0
                        : 1,
                child: TabBar(
                  onTap: (index) {
                    String selectedValue = optionsList[index];
                    MyPreferences().saveSelectedDuration(selectedValue);
                    onTabSelected(selectedValue);
                  },
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicator: BubbleTabIndicator(
                    indicatorHeight: 25.0,
                    indicatorColor: AppColors.primaryColorShade5,
                    tabBarIndicatorSize: TabBarIndicatorSize.label,
                    indicatorRadius: defaultBorder,
                  ),
                  labelColor: Colors.white,
                  unselectedLabelColor: AppColors.primaryColorShade5,
                  tabs: [
                    Tab(text: optionsList.first),
                    Tab(text: optionsList.last),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
