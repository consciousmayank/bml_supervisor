import 'package:bml_supervisor/app_level/setup_bottomsheet_ui.dart';
import 'package:flutter/material.dart';
import 'package:bml/bml.dart';

class ReviewRejectConfirmationBottomSheet extends StatelessWidget {
  final SheetRequest request;
  final Function(SheetResponse) completer;

  ReviewRejectConfirmationBottomSheet({
    Key key,
    this.request,
    this.completer,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseHalfScreenBottomSheet(
      margin: const EdgeInsets.all(defaultBorder),
      height: 250,
      request: request,
      completer: completer,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Utils().hSizedBox(10),
            Text(
              'Are you sure to reject this Consignment ?',
              style: AppTextStyles.latoBold18PrimaryShade5,
            ),
            Utils().hSizedBox(30),
            Text(
              'You cannot undo this decision.',
              style:
                  AppTextStyles.latoBold18PrimaryShade5.copyWith(fontSize: 14),
            ),
            Utils().hSizedBox(30),
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  flex: 1,
                  child: SizedBox(
                    height: buttonHeight,
                    child: AppButton(
                      borderWidth: 0,
                      borderColor: Colors.transparent,
                      onTap: () {
                        completer(
                          SheetResponse(
                            confirmed: false,
                          ),
                        );
                      },
                      background: AppColors.primaryColorShade5,
                      buttonText: 'Cancel',
                    ),
                  ),
                ),
                Utils().wSizedBox(10),
                Expanded(
                  child: SizedBox(
                    height: buttonHeight,
                    child: AppButton(
                      borderWidth: 0,
                      borderColor: Colors.transparent,
                      onTap: () {
                        completer(
                          SheetResponse(
                            confirmed: true,
                          ),
                        );
                      },
                      background: AppColors.primaryColorShade5,
                      buttonText: 'Confirm',
                    ),
                  ),
                  flex: 1,
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
