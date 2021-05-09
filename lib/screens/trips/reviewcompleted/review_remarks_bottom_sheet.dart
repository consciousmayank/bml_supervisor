import 'package:bml_supervisor/app_level/colors.dart';
import 'package:bml_supervisor/app_level/setup_bottomsheet_ui.dart';
import 'package:bml_supervisor/app_level/shared_prefs.dart';
import 'package:bml_supervisor/models/consignment_tracking_statusresponse.dart';
import 'package:bml_supervisor/utils/dimens.dart';
import 'package:bml_supervisor/widget/app_button.dart';
import 'package:bml_supervisor/widget/app_textfield.dart';
import 'package:flutter/material.dart';
import 'package:stacked_services/stacked_services.dart';

class ReviewRemarksBottomSheet extends StatelessWidget {
  final SheetRequest request;
  final Function(SheetResponse) completer;

  TextEditingController controller = TextEditingController();

  ReviewRemarksBottomSheet({
    Key key,
    this.request,
    this.completer,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseBottomSheet(
      request: request,
      completer: completer,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            appTextFormField(
              hintText: 'Remarks',
              enabled: true,
              maxLines: 5,
              controller: controller,
              keyboardType: TextInputType.text,
            ),
            SizedBox(
              height: buttonHeight,
              child: AppButton(
                borderWidth: 0,
                borderColor: Colors.transparent,
                onTap: () {
                  completer(
                    SheetResponse(
                      confirmed: true,
                      responseData: ReviewRemarksBottomSheetOutputArgs(
                        remarks:
                            '${controller.text.trim()} Verified By: ${preferences.getUserLoggedIn().userName}',
                      ),
                    ),
                  );
                },
                background: AppColors.primaryColorShade5,
                buttonText: 'Submit',
              ),
            )
          ],
        ),
      ),
    );
  }
}

class ReviewRemarksBottomSheetInputArgs {
  final ConsignmentTrackingStatusResponse clickedTrip;

  ReviewRemarksBottomSheetInputArgs({
    @required this.clickedTrip,
  });
}

class ReviewRemarksBottomSheetOutputArgs {
  final String remarks;

  ReviewRemarksBottomSheetOutputArgs({@required this.remarks});
}
