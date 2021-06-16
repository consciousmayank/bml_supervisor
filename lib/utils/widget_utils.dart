import 'dart:convert';
import 'dart:typed_data';

import 'package:bml_supervisor/app_level/colors.dart';
import 'package:bml_supervisor/app_level/shared_prefs.dart';
import 'package:bml_supervisor/app_level/themes.dart';
import 'package:bml_supervisor/utils/datetime_converter.dart';
import 'package:bml_supervisor/widget/IconBlueBackground.dart';
import 'package:bml_supervisor/widget/clickable_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:url_launcher/url_launcher.dart';

import 'app_text_styles.dart';
import 'dimens.dart';

TextStyle topHeaderStyle() {
  return TextStyle(
    fontSize: topHeaderTextFontSize,
  );
}

hSizedBox(double height) {
  return SizedBox(
    height: height,
  );
}

Text buildChartSubTitleNew({String date}) {
  return Text(
    '(' + getChartMonth(date: date) + ', ' + getChartYear(date: date) + ')',
    style: AppTextStyles.latoBold12Black,
  );
}

Widget buildChartBadge({
  String badgeTitle,
}) {
  return Container(
    padding: EdgeInsets.all(3),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(4)),
      color: AppColors.primaryColorShade5,
    ),
    child: Text(
      badgeTitle,
      style: AppTextStyles.latoMedium18White.copyWith(fontSize: 11),
    ),
  );
}

String getChartYear({String date}) {
  return date.split('-').last;
}

String getChartMonth({String date}) {
  return getMonth(int.parse(date.split('-')[1]));
}

getDashboardDistributerTileBgColor() {
  return Color(dashboardDistributerTileBgColor);
}

getDashboardTotalKmTileBgColor() {
  return Color(dashboardTotalKmTileBgColor);
}

getDashboardRoutesTileBgColor() {
  return Color(dashboardRoutesTileBgColor);
}

getDashboardDueKmTileBgColor() {
  return Color(dashboardDueKmTileBgColor);
}

getDashboardTileTextColor() {
  return Colors.white;
}

getDashboradTilesVerticlePadding() {
  return const EdgeInsets.symmetric(vertical: verticlePaddingValue);
}

getPaymentScreenSidePadding() {
  return const EdgeInsets.symmetric(horizontal: 8, vertical: 8);
}

wSizedBox(double width) {
  return SizedBox(
    width: width,
  );
}

wSpacer() {
  return Container(
    margin: EdgeInsets.all(10),
    color: Colors.black,
    height: 1,
  );
}

void hideKeyboard({@required BuildContext context}) {
  FocusScopeNode currentFocus = FocusScope.of(context);
  if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
    currentFocus.focusedChild.unfocus();
  }
}

RoundedRectangleBorder getCardShape() {
  return RoundedRectangleBorder(borderRadius: getBorderRadius());
}

RoundedRectangleBorder getSelectedCardShape({@required Color color}) {
  return RoundedRectangleBorder(
    borderRadius: getBorderRadius(),
    side: new BorderSide(color: color, width: 2.0),
  );
}

BorderRadiusGeometry getBorderRadius({double borderRadius = defaultBorder}) {
  return BorderRadius.circular(borderRadius);
}

LinearProgressIndicator getLinearProgress() {
  return LinearProgressIndicator(
    backgroundColor: ThemeConfiguration.primaryBackground.withAlpha(100),
    valueColor:
        new AlwaysStoppedAnimation<Color>(ThemeConfiguration.primaryBackground),
  );
}

String capitalizeFirstLetter(String title) {
  return title != null && title.length > 0
      ? "${title[0].toUpperCase()}${title.substring(1)}"
      : '';
}

String getDateString(DateTime date) {
  return DateTimeToStringConverter.ddmmyy(date: date).convert();
}

flatButtonTextStyle() {
  return TextStyle(color: ThemeConfiguration.primaryText, fontSize: 16);
}

singleColumnColored(
    {String label,
    String value,
    String valuePrefix = "",
    String valuePostfix = "",
    bool showColor = false,
    bool showGreenColor = false,
    bool showInStart = true}) {
  return Flexible(
    child: Container(
      child: Column(
        crossAxisAlignment:
            showInStart ? CrossAxisAlignment.start : CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Container(
            padding:
                const EdgeInsets.only(left: 8, right: 8, top: 4, bottom: 4),
            decoration: BoxDecoration(
              color: showColor && double.parse(value) < 1
                  ? Colors.red
                  : showGreenColor
                      ? Colors.green
                      : Colors.white,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Text(
              "$valuePrefix$value$valuePostfix",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: showColor && double.parse(value) < 1
                      ? Colors.white
                      : ThemeConfiguration.primaryText),
            ),
          )
        ],
      ),
    ),
  );
}

singleColumn(String label, String value) {
  return Flexible(
    child: Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            textAlign: TextAlign.start,
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
            maxLines: 5,
            overflow: TextOverflow.ellipsis,
          )
        ],
      ),
    ),
  );
}

get12HourTime(String timeIn24Hours) {
  String postFix = "";
  String timeIn12Hours = "";
  List<String> splitTime = timeIn24Hours.split(":");

  if (int.parse(splitTime[0]) < 12) {
    postFix = " AM";
    timeIn12Hours = splitTime.first + " : " + splitTime[1] + postFix;
  } else {
    postFix = " PM";
    timeIn12Hours =
        "${int.parse(splitTime.first) - 12}" + " : " + splitTime[1] + postFix;
  }
  return timeIn12Hours;
}

getFormatedDate({String dateString}) {
  List<String> splitDate = dateString.split("-");
  return splitDate.first +
      " " +
      getMonth(int.parse(splitDate[1])) +
      " " +
      splitDate.last;
}

String getMonth(int monthNumber) {
  switch (monthNumber) {
    case 1:
      return 'Jan';
    case 2:
      return 'Feb';
    case 3:
      return 'Mar';
    case 4:
      return 'Apr';
    case 5:
      return 'May';
    case 6:
      return 'Jun';
    case 7:
      return 'Jul';
    case 8:
      return 'Aug';
    case 9:
      return 'Sep';
    case 10:
      return 'Oct';
    case 11:
      return 'Nov';
    case 12:
      return 'Dec';

    default:
      return "";
  }
}

TextStyle appBarTextStyle() {
  return TextStyle(color: Colors.white, letterSpacing: 2, fontSize: 20);
}

EdgeInsets getSidePadding({@required BuildContext context}) {
  return EdgeInsets.only(
    top: getValueForScreenType(
        context: context, mobile: 4, tablet: 10, desktop: 10, watch: 0),
    bottom: getValueForScreenType(
        context: context, mobile: 4, tablet: 10, desktop: 10, watch: 0),
    right: getValueForScreenType(
        context: context, mobile: 4, tablet: 50, desktop: 150, watch: 5),
    left: getValueForScreenType(
        context: context, mobile: 4, tablet: 50, desktop: 150, watch: 5),
  );
}

Text headerText(String title) {
  return Text(
    title,
    style: topHeaderStyle(),
  );
}

String getCurrentDate() {
  return DateTimeToStringConverter.ddmmyy(date: DateTime.now()).convert();
}

String getConvertedDate(DateTime date) {
  return DateTimeToStringConverter.ddmmyy(date: date).convert();
}

String getConvertedDateWithTime(DateTime date) {
  return DateFormat('dd-MM-yyyy').add_jms().format(date).toLowerCase();
}

String convertFrom24HoursTime(String timeString) {
  if (timeString.length == 0) {
    return ' ';
  }
  String hours = timeString.split(':')[0];
  String minutes = timeString.split(':')[1];

  if (int.parse(hours) >= 12) {
    int hour = 12 - int.parse(hours);
    return '$hour:$minutes PM';
  } else {
    return '$hours:$minutes AM';
  }
}

FilteringTextInputFormatter twoDigitDecimalPointFormatter() =>
    FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'));

String getBase64String({@required String value}) {
  var bytes = utf8.encode(value);
  return base64.encode(bytes);
}

String getUserName({@required String value}) {
  return utf8.decode(base64.decode(value));
}

Map<String, String> getAuthHeader({@required String base64String}) {
  return {"Authorization": "Basic $base64String"};
}

int collectionLength(Iterable iterable) {
  return iterable == null ? 0 : iterable.length;
}

Uint8List getImageFromBase64String({@required String base64String}) {
  return base64String == null
      ? null
      : Base64Codec()
          .decode((base64String.split(',')[1]).replaceAll("\\n", "").trim());
}

List<T> copyList<T>(List<T> items) {
  var newItems = <T>[];
  if (items != null) {
    newItems.addAll(items);
  }
  return newItems;
}

launchMaps({@required double latitude, @required double longitude}) async {
  String googleUrl =
      'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
  // String appleUrl = 'https://maps.apple.com/?sll=$latitude,$longitude';
  if (await canLaunch(googleUrl)) {
    await launch(googleUrl);
  } else {
    throw 'Could not launch url';
  }
}

Text buildChartTitle({@required String title}) {
  return Text(
    title,
    style: AppTextStyles.latoBold16Black,
  );
}

Text buildChartSubTitle({@required DateTime time}) {
  return Text(
    '(' + getDateStringCharts(time) + ')',
    style: AppTextStyles.latoBold12Black,
  );
}

String getDateStringCharts(DateTime date) {
  return DateFormat('MMMM, yyyy').format(date);
}

Row buildChartDateLabel() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(
        "Dates",
        style: AppTextStyles.latoBold12Black
            .copyWith(color: AppColors.primaryColorShade5),
        textAlign: TextAlign.center,
      ),
    ],
  );
}

Widget drawerList(
    {String text,
    String imageName,
    Function onTap,
    bool isSubMenu = false,
    String trailingText}) {
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
          children: [
            imageName == null
                ? Container()
                : IconBlueBackground(
                    iconName: imageName,
                    isSubMenu: isSubMenu,
                  ),
            imageName == null ? Container() : wSizedBox(20),
            Expanded(
              child: Text(
                text,
                style: AppTextStyles.latoMedium12Black.copyWith(
                    color: AppColors.primaryColorShade5, fontSize: 14),
              ),
            ),
            trailingText != null
                ? Text(
                    trailingText,
                    style: AppTextStyles.latoMedium12Black.copyWith(
                        color: AppColors.primaryColorShade5, fontSize: 14),
                  )
                : Container()
          ],
        ),
      ),
    ),
  );
}

Text setAppBarTitle({
  @required String title,
}) {
  return Text(
    '$title - ${capitalizeFirstLetter(
      MyPreferences()?.getSelectedClient()?.businessName?.substring(
            0,
            14,
          ),
    )}',
    style: AppTextStyles.whiteRegular,
  );
}
