import 'package:bml_supervisor/routes/routes.dart';
import 'package:bml_supervisor/routes/routes_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:stacked_services/stacked_services.dart';

import 'app_level/locator.dart';
import 'app_level/setup_bottomsheet_ui.dart';
import 'app_level/setup_dialogs_ui.dart';
import 'app_level/shared_prefs.dart';
import 'app_level/themes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MyPreferences().init();
  declareDependencies();
  setupDialogUi();
  setupBottomSheetUi();
  ResponsiveSizingConfig.instance.setCustomBreakpoints(
    ScreenBreakpoints(
      desktop: 800,
      tablet: 550,
      watch: 200,
    ),
  );
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  AppRouter _router = AppRouter();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus &&
            currentFocus.focusedChild != null) {
          currentFocus.focusedChild.unfocus();
        }
      },
      child: MaterialApp(
        theme: ThemeConfiguration().getAppThemeComplete(),
        debugShowCheckedModeBanner: false,
        navigatorKey: StackedService.navigatorKey,
        onGenerateRoute: _router.generateRoute,
        initialRoute: mainViewRoute,
      ),
    );
  }
}
