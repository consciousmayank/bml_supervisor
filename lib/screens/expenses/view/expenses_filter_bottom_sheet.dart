import 'package:bml_supervisor/app_level/colors.dart';
import "package:bml_supervisor/app_level/string_extensions.dart";
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

    return Container(
      // margin: EdgeInsets.all(defaultBorder),
      // padding: EdgeInsets.all(defaultBorder),
      height: MediaQuery.of(context).size.height * 0.84,
      decoration: BoxDecoration(
        color: AppColors.appScaffoldColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(defaultBorder),
          topRight: Radius.circular(defaultBorder),
        ),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              completer(
                SheetResponse(confirmed: false, responseData: null),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Close',
                    style: AppTextStyles.hyperLinkStyle,
                  )
                ],
              ),
            ),
          ),
          Expanded(
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
                          child: Text(
                            '${args.expenseTypes[index]}'
                                .toLowerCase()
                                .capitalizeFirstLetter(),
                            style: args.selectedExpense ==
                                    args.expenseTypes[index]
                                ? AppTextStyles.latoBold18PrimaryShade5
                                    .copyWith(fontSize: 14)
                                : AppTextStyles.latoBold18PrimaryShade5
                                    .copyWith(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 14),
                          ),
                        ),
                      ),
                      onTap: () {
                        completer(
                          SheetResponse(
                            confirmed: true,
                            responseData: ExpensesFilterBottomSheetOutputArgs(
                              selectedExpense: args.expenseTypes[index],
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
              itemCount: args.expenseTypes.length,
            ),
          ),
        ],
      ),
    );
  }
}

class ExpensesFilterBottomSheetInputArgs {
  final List<String> expenseTypes;
  final String selectedExpense;

  ExpensesFilterBottomSheetInputArgs(
      {@required this.expenseTypes, @required this.selectedExpense});
}

class ExpensesFilterBottomSheetOutputArgs {
  final int index;
  final String selectedExpense;

  ExpensesFilterBottomSheetOutputArgs(
      {@required this.index, @required this.selectedExpense});
}