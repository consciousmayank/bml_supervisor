import 'package:bml_supervisor/app_level/colors.dart';
import 'package:bml_supervisor/utils/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';

class NetworkSensitive extends StatelessWidget {
  final Widget child;
  final double opacity;

  NetworkSensitive({
    @required this.child,
    this.opacity = 1.0,
  });

  Widget build(BuildContext context) {
    return OfflineBuilder(
      connectivityBuilder: (
        BuildContext context,
        ConnectivityResult connectivity,
        Widget child,
      ) {
        if (connectivity == ConnectivityResult.none) {
          return Scaffold(
            body: new Container(
              color: AppColors.primaryColorShade1,
              padding: const EdgeInsets.all(20),
              child: Center(
                child: Text(
                  "It seems you are offline. Please check your internet connection.",
                  textAlign: TextAlign.center,
                  style: AppTextStyles.latoBold18Black.copyWith(
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
            ),
          );
        } else {
          return child;
        }
      },
      builder: (BuildContext context) {
        return child;
      },
    );
  }
}
