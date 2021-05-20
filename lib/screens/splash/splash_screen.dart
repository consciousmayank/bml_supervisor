import 'dart:io';

import 'package:bml_supervisor/app_level/colors.dart';
import 'package:bml_supervisor/app_level/configuration.dart';
import 'package:bml_supervisor/app_level/locator.dart';
import 'package:bml_supervisor/app_level/setup_bottomsheet_ui.dart';
import 'package:bml_supervisor/app_level/shared_prefs.dart';
import 'package:bml_supervisor/enums/bottomsheet_type.dart';
import 'package:bml_supervisor/models/login_response.dart';
import 'package:bml_supervisor/routes/routes_constants.dart';
import 'package:bml_supervisor/screens/splash/app_start_apis.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:url_launcher/url_launcher.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final riveFileName = 'assets/animations/new_file_3.riv';
  Artboard _artboard;
  RiveAnimationController _controller;
  @override
  void initState() {
    _loadRiveFile();
    super.initState();
  }

  // loads a Rive file
  void _loadRiveFile() async {
    final bytes = await rootBundle.load(riveFileName);
    final file = RiveFile();
    _controller = SimpleAnimation('Animation 1');

    if (file.import(bytes)) {
      // Select an animation by its name
      setState(() => _artboard = file.mainArtboard
        ..addController(
          _controller,
        ));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_controller != null) {
      _controller.isActiveChanged.addListener(() {
        if (_controller.isActive) {
          print('Animation started playing');
        } else {
          locator<AppStartApiImpl>().getAppVersions().then((response) {
            if (response.major > appVersion) {
              locator<BottomSheetService>()
                  .showCustomSheet(
                customData: ConfirmationBottomSheetInputArgs(
                  title: 'App update required!',
                  description:
                      'It seems you are having an old version of this application. Please click ok and update the application.',
                ),
                barrierDismissible: false,
                isScrollControlled: true,
                variant: BottomSheetType.CONFIRMATION_BOTTOM_SHEET,
              )
                  .then((value) {
                if (value.confirmed) {
                  // StoreRedirect.redirect();
                  if (Platform.isIOS) {
                    launch("apps.apple.com/us/app/appname/1553210309");
                  } else if (Platform.isAndroid) {
                    launch("https://play.google.com/store/apps/details?id=" +
                        'com.mayank.bml_supervisor');
                  }
                } else {
                  Navigator.pop(context);
                }
              });
            } else {
              // Future.delayed(Duration(seconds: 3), () {
              LoginResponse user = MyPreferences().getUserLoggedIn();
              if (user != null && user.isUserLoggedIn) {
                if (MyPreferences().getSelectedClient() != null) {
                  locator<NavigationService>().replaceWith(dashBoardPageRoute);
                } else {
                  locator<NavigationService>()
                      .replaceWith(clientSelectPageRoute);
                }
              } else {
                locator<NavigationService>().replaceWith(logInPageRoute);
              }
              // });
            }
          });
        }
      });
    }

    return Scaffold(
      backgroundColor: AppColors.primaryColorShade5,
      body: Center(
        child: _artboard != null
            ? Rive(
                artboard: _artboard,
                fit: BoxFit.cover,
              )
            : Container(),
      ),
    );
  }
}
