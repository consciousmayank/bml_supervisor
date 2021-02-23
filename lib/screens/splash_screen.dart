import 'package:bml_supervisor/app_level/colors.dart';
import 'package:bml_supervisor/app_level/locator.dart';
import 'package:bml_supervisor/app_level/shared_prefs.dart';
import 'package:bml_supervisor/routes/routes_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart';
import 'package:stacked_services/stacked_services.dart';

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
          Future.delayed(Duration(seconds: 3), () {
            PreferencesSavedUser user = MyPreferences().getUserLoggedIn();
            if (user != null && user.isUserLoggedIn) {
              locator<NavigationService>().replaceWith(dashBoardPageRoute);
            } else {
              locator<NavigationService>().replaceWith(logInPageRoute);
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
