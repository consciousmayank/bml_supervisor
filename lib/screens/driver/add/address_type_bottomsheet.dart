import 'package:bml_supervisor/app_level/setup_bottomsheet_ui.dart';
import 'package:bml_supervisor/utils/app_text_styles.dart';
import 'package:bml_supervisor/utils/stringutils.dart';
import 'package:bml_supervisor/utils/widget_utils.dart';
import 'package:bml_supervisor/widget/clickable_widget.dart';
import 'package:bml_supervisor/widget/dotted_divider.dart';
import 'package:flutter/material.dart';
import 'package:stacked_services/stacked_services.dart';

class AddressTypeBottomSheet extends StatelessWidget {
  final SheetRequest request;
  final Function(SheetResponse) completer;

  const AddressTypeBottomSheet(
      {Key key, @required this.request, @required this.completer})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    AddressTypeBottomSheetInputArgs args =
        request.customData as AddressTypeBottomSheetInputArgs;

    return BaseBottomSheet(
      completer: completer,
      request: request,
      child: Expanded(
        child: ListView(
          children: List.generate(
            addressTypes.length,
            (index) => Column(
              children: [
                index != 0 ? DottedDivider() : Container(),
                ClickableWidget(
                  child: SizedBox(
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        '${args.allowedAddressTypes[index]}',
                        style: args.preSelectedAddressTypes ==
                                args.allowedAddressTypes[index]
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
                        responseData: AddressTypeBottomSheetOutputArgs(
                          selectedAddressTypes: args.allowedAddressTypes[index],
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

class AddressTypeBottomSheetInputArgs {
  final List<String> allowedAddressTypes;
  final String preSelectedAddressTypes;
  AddressTypeBottomSheetInputArgs({
    @required this.allowedAddressTypes,
    this.preSelectedAddressTypes = 'none',
  });
}

class AddressTypeBottomSheetOutputArgs {
  final String selectedAddressTypes;
  final int index;
  AddressTypeBottomSheetOutputArgs({
    @required this.selectedAddressTypes,
    @required this.index,
  });
}
