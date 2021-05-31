import 'package:bml_supervisor/app_level/colors.dart';
import 'package:bml_supervisor/utils/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ThemeConfiguration {
  static const Color primaryBackground = AppColors.primaryColorShade5;
  static const Color secondaryBackground = Color.fromARGB(74, 255, 255, 255);
  static const Color ternaryBackground = Color.fromARGB(74, 255, 255, 255);
  static const Color primaryElement = Color.fromARGB(255, 255, 255, 255);
  static const Color secondaryElement = Color.fromARGB(255, 223, 54, 41);
  static const Color accentElement = Color.fromARGB(255, 137, 138, 139);
  static const Color primaryText = Color.fromARGB(255, 255, 255, 255);
  static const Color secondaryText = Color.fromARGB(255, 223, 54, 41);
  TextTheme appTextTheme = GoogleFonts.latoTextTheme();

  static BoxDecoration fieldDecortaion = BoxDecoration(
      borderRadius: BorderRadius.circular(5), color: Colors.grey[200]);

  BoxDecoration disabledFieldDecortaion = BoxDecoration(
      borderRadius: BorderRadius.circular(5), color: Colors.grey[100]);

// Field Variables

  static const double fieldHeight = 55;
  static const double smallFieldHeight = 40;
  static const double inputFieldBottomMargin = 30;
  static const double inputFieldSmallBottomMargin = 0;
  static const EdgeInsets fieldPadding =
      const EdgeInsets.symmetric(horizontal: 15);
  static const EdgeInsets largeFieldPadding =
      const EdgeInsets.symmetric(horizontal: 15, vertical: 15);

// Text Variables
  static const TextStyle buttonTitleTextStyle =
      const TextStyle(fontWeight: FontWeight.w700, color: Colors.white);

  //also bottom navigation color
  static const Color appCanvasColor = AppColors.white;
  static const Color appScaffoldBackgroundColor = AppColors.appScaffoldColor;

  ThemeData getAppThemeComplete() {
    return ThemeData(
      appBarTheme: AppBarTheme(
        centerTitle: true,
        iconTheme: IconThemeData(color: AppColors.white),
        elevation: 0.8,
        color: AppColors.primaryColorShade5,
        textTheme: appTextTheme,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          primary: AppColors.primaryColorShade5,
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: AppColors.primaryColorShade11,
          splashColor: AppColors.primaryColorShade3),
      primaryIconTheme: IconThemeData(color: secondaryBackground),
      brightness: Brightness.dark,
      primaryColor: primaryBackground,
      primaryColorBrightness: Brightness.dark,
      primaryColorLight: secondaryBackground,
      primaryColorDark: secondaryBackground,
      accentColor: accentElement,
      accentColorBrightness: Brightness.dark,
      canvasColor: appCanvasColor,
      scaffoldBackgroundColor: appScaffoldBackgroundColor,
//      bottomAppBarColor: Color(0xffffffff), we don't hve this as of now
      cardColor: Colors.white,
      dividerColor: Colors.white10,
      highlightColor: Color(0x66bcbcbc),
      splashColor: Color(0x66c8c8c8),
      selectedRowColor: Color(0xfff5f5f5),
      unselectedWidgetColor: Colors.black12,
      disabledColor: Colors.black26,
      buttonColor: primaryElement,
      toggleableActiveColor: primaryBackground,
      secondaryHeaderColor: Color(0xfffff3e0),
      backgroundColor: secondaryBackground,
      dialogBackgroundColor: Colors.white,
      indicatorColor: primaryBackground.withAlpha(150),
      hintColor: Colors.black38,
      errorColor: Colors.red,
      buttonTheme: ButtonThemeData(
        textTheme: ButtonTextTheme.primary,
        minWidth: 88.0,
        height: 36.0,
        padding:
            EdgeInsets.only(top: 0.0, bottom: 0.0, left: 16.0, right: 16.0),
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: Color(0xff000000),
            width: 10.0,
            style: BorderStyle.none,
          ),
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
        alignedDropdown: false,
        buttonColor: primaryBackground,
        disabledColor: Color(0x61000000),
        highlightColor: Color(0x29000000),
        splashColor: Color(0x1f000000),
        colorScheme: ColorScheme(
          primary: primaryBackground,
          primaryVariant: primaryBackground,
          secondary: secondaryBackground,
          secondaryVariant: secondaryBackground,
          surface: Color(0xffffffff),
          background: primaryBackground.withAlpha(100),
          error: primaryBackground,
          onPrimary: Color(0xff000000),
          onSecondary: Color(0xff000000),
          onSurface: Color(0xff000000),
          onBackground: Color(0xff000000),
          onError: Color(0xffffffff),
          brightness: Brightness.dark,
        ),
      ),
      textTheme: appTextTheme,
      inputDecorationTheme: InputDecorationTheme(
        labelStyle: TextStyle(
          color: primaryBackground,
          fontSize: 16.0,
          fontWeight: FontWeight.w400,
          fontStyle: FontStyle.normal,
        ),
        helperStyle: TextStyle(
          color: ternaryBackground,
          fontSize: 16.0,
          fontWeight: FontWeight.w400,
          fontStyle: FontStyle.normal,
        ),
        hintStyle: TextStyle(
          color: ternaryBackground,
          fontSize: 16.0,
          fontWeight: FontWeight.w400,
          fontStyle: FontStyle.normal,
        ),
        errorStyle: TextStyle(
          color: Colors.red,
          fontSize: 16.0,
          fontWeight: FontWeight.w400,
          fontStyle: FontStyle.normal,
        ),
        errorMaxLines: 5,
        isDense: false,
        contentPadding: EdgeInsets.only(left: 20, right: 20),
        isCollapsed: true,
        prefixStyle: TextStyle(
          color: primaryText,
          fontSize: 16.0,
          fontWeight: FontWeight.w400,
          fontStyle: FontStyle.normal,
        ),
        suffixStyle: TextStyle(
          color: primaryText,
          fontSize: 16.0,
          fontWeight: FontWeight.w400,
          fontStyle: FontStyle.normal,
        ),
        counterStyle: TextStyle(
          color: primaryText,
          fontSize: 16.0,
          fontWeight: FontWeight.w400,
          fontStyle: FontStyle.normal,
        ),
        filled: true,
        fillColor: Colors.white,
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.red,
            width: 2.0,
            style: BorderStyle.none,
          ),
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
        errorBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.red,
            width: 6.0,
            style: BorderStyle.none,
          ),
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
        focusedErrorBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.red[100],
            width: 6.0,
            style: BorderStyle.none,
          ),
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
        disabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Color(0xff000000),
            width: 2.0,
            style: BorderStyle.none,
          ),
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.red,
            width: 1.0,
            style: BorderStyle.none,
          ),
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
      ),
      iconTheme: IconThemeData(
        color: primaryBackground,
        opacity: 1.0,
        size: 24.0,
      ),
      accentIconTheme: IconThemeData(
        color: Color(0xff000000),
        opacity: 1.0,
        size: 24.0,
      ),

      // sliderTheme: SliderThemeData(
      //   activeTrackColor: primaryBackground,
      //   inactiveTrackColor: primaryBackground.withAlpha(130),
      //   disabledActiveTrackColor: primaryBackground.withAlpha(130),
      //   disabledInactiveTrackColor: primaryBackground.withAlpha(130),
      //   activeTickMarkColor: primaryBackground.withAlpha(130),
      //   inactiveTickMarkColor: primaryBackground.withAlpha(180),
      //   disabledActiveTickMarkColor: Colors.black45,
      //   disabledInactiveTickMarkColor: Colors.black45,
      //   thumbColor: primaryBackground.withAlpha(170),
      //   disabledThumbColor: Color(0x52f57c00),
      //   thumbShape: RoundSliderThumbShape(),
      //   overlayColor: Color(0x29ff9800),
      //   valueIndicatorColor: primaryBackground,
      //   valueIndicatorShape: PaddleSliderValueIndicatorShape(),
      //   showValueIndicator: ShowValueIndicator.onlyForDiscrete,
      //   valueIndicatorTextStyle: TextStyle(
      //     color: Color(0xdd000000),
      //     fontSize: 14.0,
      //     fontWeight: FontWeight.w400,
      //     fontStyle: FontStyle.normal,
      //   ),
      // ),
      // tabBarTheme: TabBarTheme(
      //   indicatorSize: TabBarIndicatorSize.tab,
      //   labelColor: Color(0xdd000000),
      //   unselectedLabelColor: Color(0xb2000000),
      // ),
      // chipTheme: ChipThemeData(
      //   backgroundColor: primaryBackground,
      //   brightness: Brightness.dark,
      //   deleteIconColor: Color(0xde000000),
      //   disabledColor: Color(0x0c000000),
      //   labelPadding:
      //       EdgeInsets.only(top: 0.0, bottom: 0.0, left: 8.0, right: 8.0),
      //   labelStyle: TextStyle(
      //     color: Color(0xde000000),
      //     fontSize: 14.0,
      //     fontWeight: FontWeight.w400,
      //     fontStyle: FontStyle.normal,
      //   ),
      //   padding: EdgeInsets.only(top: 4.0, bottom: 4.0, left: 4.0, right: 4.0),
      //   secondaryLabelStyle: TextStyle(
      //     color: Color(0x3d000000),
      //     fontSize: 14.0,
      //     fontWeight: FontWeight.w400,
      //     fontStyle: FontStyle.normal,
      //   ),
      //   secondarySelectedColor: Color(0x3dff9800),
      //   selectedColor: Color(0x3d000000),
      //   shape: StadiumBorder(
      //       side: BorderSide(
      //     color: Color(0xff000000),
      //     width: 0.0,
      //     style: BorderStyle.none,
      //   )),
      // ),
      timePickerTheme: TimePickerThemeData(
        hourMinuteColor: AppColors.primaryColorShade5,
        dialBackgroundColor: AppColors.primaryColorShade5,
        dialHandColor: AppColors.black,
        dialTextColor: AppColors.white,
        // dayPeriodColor: AppColors.primaryColorShade5,
        dayPeriodTextStyle: AppTextStyles.latoBold12Black,
        // dayPeriodBorderSide: BorderSide(
        //   color: Colors.red,
        // ),
        dayPeriodShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(4.0)),
          side: BorderSide(
            color: AppColors.black,
          ),
        ),
        dayPeriodTextColor: Colors.black,
        backgroundColor: AppColors.appScaffoldColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
        hourMinuteShape: CircleBorder(),
      ),
      dialogTheme: DialogTheme(
          shape: RoundedRectangleBorder(
        side: BorderSide(
          color: Color(0xff000000),
          width: 0.0,
          style: BorderStyle.none,
        ),
        borderRadius: BorderRadius.all(Radius.circular(4.0)),
      )),
    );
  }

  CircularProgressIndicator getProgressIndicator() {
    return CircularProgressIndicator(
      strokeWidth: 2.0,
    );
  }
}
