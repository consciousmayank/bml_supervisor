import 'package:bml_supervisor/app_level/colors.dart';
import 'package:bml_supervisor/app_level/setup_bottomsheet_ui.dart';
import 'package:bml_supervisor/utils/app_text_styles.dart';
import 'package:bml_supervisor/utils/dimens.dart';
import 'package:bml_supervisor/utils/widget_utils.dart';
import 'package:bml_supervisor/widget/clickable_widget.dart';
import 'package:bml_supervisor/widget/dotted_divider.dart';
import 'package:flutter/material.dart';
import 'package:stacked_services/stacked_services.dart';

class DailyKmsBottomSheet extends StatelessWidget {
  final SheetRequest request;
  final Function(SheetResponse) completer;

  const DailyKmsBottomSheet({
    Key key,
    this.request,
    this.completer,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DailyKmPeriodBottomSheetInputArgs args = request.customData;

    return BaseBottomSheet(
      bottomSheetTitle: args.sheetTitle,
      request: request,
      completer: completer,
      child: Expanded(
        child: ListView.builder(
          itemBuilder: (context, index) {
            return Column(
              children: [
                index != 0 ? DottedDivider() : Container(),
                ClickableWidget(
                  child: SizedBox(
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(args.options[index]),
                    ),
                  ),
                  onTap: () {
                    completer(
                      SheetResponse(
                          confirmed: true, responseData: args.options[index]),
                    );
                  },
                  borderRadius: getBorderRadius(borderRadius: 0),
                )
              ],
            );
          },
          itemCount: args.options.length,
        ),
      ),
    );
  }
}

class DailyKmPeriodBottomSheetInputArgs<T> {
  final List<T> options;
  final T selectedOption;
  final String sheetTitle;

  DailyKmPeriodBottomSheetInputArgs({
    @required this.options,
    @required this.selectedOption,
    @required this.sheetTitle,
  });
}
