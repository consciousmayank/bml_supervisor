import 'dart:convert';

import 'package:bml_supervisor/app_level/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:url_launcher/url_launcher.dart';

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

RoundedRectangleBorder getCardShape() {
  return RoundedRectangleBorder(borderRadius: getBorderRadius());
}

RoundedRectangleBorder getSelectedCardShape({@required Color color}) {
  return RoundedRectangleBorder(
    borderRadius: getBorderRadius(),
    side: new BorderSide(color: color, width: 2.0),
  );
}

BorderRadiusGeometry getBorderRadius() {
  return BorderRadius.circular(defaultBorder);
}

LinearProgressIndicator getLinearProgress() {
  return LinearProgressIndicator(
    backgroundColor: ThemeConfiguration.primaryBackground.withAlpha(100),
    valueColor:
        new AlwaysStoppedAnimation<Color>(ThemeConfiguration.primaryBackground),
  );
}

String getDateString(DateTime date) {
  return DateFormat('dd-MM-yyyy').format(date);
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
  return DateFormat('dd-MM-yyyy').format(DateTime.now()).toLowerCase();
}

String getConvertedDate(DateTime date) {
  return DateFormat('dd-MM-yyyy').format(date).toLowerCase();
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

//DateFormat.yMd().add_jm()

launchMaps(double latitude, double longitude) async {
  String googleUrl = 'comgooglemaps://?center=$latitude,$longitude}';
  String appleUrl = 'https://maps.apple.com/?sll=$latitude,$longitude';
  if (await canLaunch("comgooglemaps://")) {
    print('launching com googleUrl');
    await launch(googleUrl);
  } else if (await canLaunch(appleUrl)) {
    print('launching apple url');
    await launch(appleUrl);
  } else {
    throw 'Could not launch url';
  }
}

FilteringTextInputFormatter twoDigitDecimalPointFormatter() =>
    FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'));

String getBase64String({@required String value}) {
  var bytes = utf8.encode(value);
  return base64.encode(bytes);
}
