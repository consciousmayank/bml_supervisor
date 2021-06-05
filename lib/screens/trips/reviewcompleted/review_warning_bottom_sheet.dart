import 'package:bml_supervisor/app_level/colors.dart';
import 'package:bml_supervisor/app_level/setup_bottomsheet_ui.dart';
import 'package:bml_supervisor/app_level/shared_prefs.dart';
import 'package:bml_supervisor/utils/app_text_styles.dart';
import 'package:bml_supervisor/utils/dimens.dart';
import 'package:bml_supervisor/utils/widget_utils.dart';
import 'package:bml_supervisor/widget/app_button.dart';
import 'package:flutter/material.dart';
import 'package:stacked_services/stacked_services.dart';

class RevieWarningBottomSheet extends StatelessWidget {
  final SheetRequest request;
  final Function(SheetResponse) completer;

  const RevieWarningBottomSheet({
    Key key,
    this.request,
    this.completer,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseBottomSheet(
      // margin: const EdgeInsets.all(defaultBorder),
      request: request,
      completer: completer,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Card(
              elevation: defaultElevation,
              shape: getCardShape(),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      top: 8,
                      bottom: 8,
                      right: 16,
                      left: 16,
                    ),
                    child: Text(
                      'Hey ${MyPreferences().getUserLoggedIn().userName.split(' ')[0]}',
                      style: AppTextStyles.latoBold18PrimaryShade5,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(32),
                    color: AppColors.routesCardColor,
                    child: Center(
                      child: Column(
                        children: [
                          Text(
                            'There exists a consignment which needs to be reviewed before the one which you are about to review. Please review that one. It will be in the top of the completed trips list. \n If you go ahead with this one, then you will not be able to review the older. For that you have to contact the Admin. \n\nDo you want to continue reviewing this one.',
                            style: AppTextStyles.latoMedium12Black
                                .copyWith(fontSize: 16),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: SizedBox(
                      height: buttonHeight,
                      child: AppButton(
                          borderWidth: 0,
                          borderColor: AppColors.primaryColorShade5,
                          onTap: () {
                            completer(
                              SheetResponse(
                                confirmed: true,
                                responseData: RevieWarningBottomSheetOutputArgs(
                                  continueAnyHow: true,
                                ),
                              ),
                            );
                          },
                          background: AppColors.primaryColorShade5,
                          buttonText: 'Yes Continue.'),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: SizedBox(
                      height: buttonHeight,
                      child: AppButton(
                          borderWidth: 0,
                          borderColor: AppColors.primaryColorShade5,
                          onTap: () {
                            completer(
                              SheetResponse(
                                confirmed: false,
                              ),
                            );
                          },
                          background: AppColors.primaryColorShade5,
                          buttonText: 'No, Take me back'),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class RevieWarningBottomSheetOutputArgs {
  final bool continueAnyHow;

  RevieWarningBottomSheetOutputArgs({
    @required this.continueAnyHow,
  });
}
