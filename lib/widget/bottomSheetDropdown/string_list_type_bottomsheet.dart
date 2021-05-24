import 'package:bml_supervisor/app_level/setup_bottomsheet_ui.dart';
import 'package:bml_supervisor/utils/app_text_styles.dart';
import 'package:bml_supervisor/utils/widget_utils.dart';
import 'package:bml_supervisor/widget/bottomSheetDropdown/bottom_sheet_drop_down_view.dart';
import 'package:bml_supervisor/widget/clickable_widget.dart';
import 'package:bml_supervisor/widget/dotted_divider.dart';
import 'package:flutter/material.dart';
import 'package:stacked_services/stacked_services.dart';

class StringListTypeBottomSheet extends StatelessWidget {
  final SheetRequest request;
  final Function(SheetResponse) completer;

  const StringListTypeBottomSheet(
      {Key key, @required this.request, @required this.completer})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    StringListTypeBottomSheetInputArgs args =
        request.customData as StringListTypeBottomSheetInputArgs;
    return BaseHalfScreenBottomSheet(
      completer: completer,
      request: request,
      child: Expanded(
        child: ListView(
          children: List.generate(
            args.allowedValues.length,
            (index) => Column(
              children: [
                index != 0 ? DottedDivider() : Container(),
                ClickableWidget(
                  child: SizedBox(
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        getTitle(
                          inputArgs: args,
                          index: index,
                        ),
                        style: args.preSelectedValue ==
                                args.allowedValues[index]
                            ? AppTextStyles.latoBold18PrimaryShade5
                                .copyWith(fontSize: 14)
                            : AppTextStyles.latoBold18PrimaryShade5.copyWith(
                                fontWeight: FontWeight.normal, fontSize: 14),
                      ),
                    ),
                  ),
                  onTap: () {
                    completer(
                      SheetResponse(
                        confirmed: true,
                        responseData: StringListTypeBottomSheetOutputArgs(
                          selectedTextVale: getTitle(
                            inputArgs: args,
                            index: index,
                          ),
                          selectedValue: args.allowedValues[index],
                          index: index,
                        ),
                      ),
                    );
                  },
                  borderRadius: getBorderRadius(borderRadius: 0),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

String getTitle(
    {@required StringListTypeBottomSheetInputArgs inputArgs,
    @required int index}) {
  switch (inputArgs.bottomSheetDropDownType) {
    case BottomSheetDropDownType.CREATE_CONSIGNMENT_ROUTES_LIST:
      return 'R#${inputArgs.allowedValues[index].routeId}. ${inputArgs.allowedValues[index].routeTitle}';

      break;
    case BottomSheetDropDownType.STRING:
      return '${inputArgs.allowedValues[index]}';
      break;

    default:
      return 'No Value';
  }
}

class StringListTypeBottomSheetInputArgs<T> {
  final List<T> allowedValues;
  final String preSelectedValue;
  final BottomSheetDropDownType bottomSheetDropDownType;

  StringListTypeBottomSheetInputArgs({
    @required this.bottomSheetDropDownType,
    @required this.allowedValues,
    this.preSelectedValue = 'none',
  });
}

class StringListTypeBottomSheetOutputArgs<T> {
  final T selectedValue;
  final int index;
  final String selectedTextVale;
  StringListTypeBottomSheetOutputArgs({
    @required this.selectedValue,
    @required this.index,
    @required this.selectedTextVale,
  });
}
