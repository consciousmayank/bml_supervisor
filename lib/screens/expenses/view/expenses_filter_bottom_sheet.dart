import 'package:bml_supervisor/app_level/colors.dart';
import 'package:bml_supervisor/app_level/setup_bottomsheet_ui.dart';
import "package:bml_supervisor/app_level/string_extensions.dart";
import 'package:bml_supervisor/models/expense_period_response.dart';
import 'package:bml_supervisor/utils/app_text_styles.dart';
import 'package:bml_supervisor/utils/dimens.dart';
import 'package:bml_supervisor/utils/widget_utils.dart';
import 'package:bml_supervisor/widget/clickable_widget.dart';
import 'package:bml_supervisor/widget/dotted_divider.dart';
import 'package:flutter/material.dart';
import 'package:stacked_services/stacked_services.dart';

class ExpensesFilterBottomSheet extends StatelessWidget {
  final SheetRequest request;
  final Function(SheetResponse) completer;

  const ExpensesFilterBottomSheet({
    Key key,
    this.request,
    this.completer,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ExpensesFilterBottomSheetInputArgs args = request.customData;

    return BaseBottomSheet(
      bottomSheetTitle: getBottomSheetTitle(
        args: args,
      ),
      request: request,
      completer: completer,
      child: Expanded(
        child: ListView.builder(
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return Column(
              children: [
                index != 0 ? DottedDivider() : Container(),
                ClickableWidget(
                  child: SizedBox(
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: getItemRowText(
                        args: args,
                        index: index,
                      ),
                    ),
                  ),
                  onTap: () {
                    completer(
                      SheetResponse(
                        confirmed: true,
                        responseData: ExpensesFilterBottomSheetOutputArgs(
                          selectedExpense: args.options[index],
                          index: index,
                        ),
                      ),
                    );
                  },
                  borderRadius: getBorderRadius(borderRadius: 0),
                ),
              ],
            );
          },
          itemCount: args.options.length,
        ),
      ),
    );
  }

  Text getItemRowText(
      {@required ExpensesFilterBottomSheetInputArgs args,
      @required int index}) {
    if (args.selectedOption is String) {
      return Text(
        '${args.options[index]}'.toLowerCase().capitalizeFirstLetter(),
        style: args.selectedOption == args.options[index]
            ? AppTextStyles.latoBold18PrimaryShade5.copyWith(fontSize: 14)
            : AppTextStyles.latoBold18PrimaryShade5
                .copyWith(fontWeight: FontWeight.normal, fontSize: 14),
      );
    } else if (args.selectedOption is ExpensePeriodResponse) {
      ExpensePeriodResponse _selectedOption = args.selectedOption;
      List<ExpensePeriodResponse> _options = args.options;
      return Text(
          '${getMonth(_options[index].month)}, ${_options[index].year}'
              .toLowerCase()
              .capitalizeFirstLetter(),
          style: _selectedOption == _options[index]
              ? AppTextStyles.latoBold18PrimaryShade5.copyWith(fontSize: 14)
              : AppTextStyles.latoBold18PrimaryShade5
                  .copyWith(fontWeight: FontWeight.normal, fontSize: 14));
    } else {
      return Text('${args.selectedOption.toString()}');
    }
  }
}

String getBottomSheetTitle({
  @required ExpensesFilterBottomSheetInputArgs args,
}) {
  if (args.selectedOption is String) {
    return 'Expense Types';
  } else if (args.selectedOption is ExpensePeriodResponse) {
    return 'Expense Period';
  } else {
    return 'Normal';
  }
}

class ExpensesFilterBottomSheetInputArgs<T> {
  final List<T> options;
  final T selectedOption;

  ExpensesFilterBottomSheetInputArgs(
      {@required this.options, @required this.selectedOption});
}

class ExpensesFilterBottomSheetOutputArgs<T> {
  final int index;
  final T selectedExpense;

  ExpensesFilterBottomSheetOutputArgs(
      {@required this.index, @required this.selectedExpense});
}
