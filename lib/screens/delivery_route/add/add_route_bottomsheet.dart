import 'package:bml_supervisor/app_level/colors.dart';
import 'package:bml_supervisor/app_level/setup_bottomsheet_ui.dart';
import 'package:bml_supervisor/models/create_route_request.dart';
import 'package:bml_supervisor/utils/app_text_styles.dart';
import 'package:bml_supervisor/utils/dimens.dart';
import 'package:bml_supervisor/utils/widget_utils.dart';
import 'package:bml_supervisor/widget/app_button.dart';
import 'package:flutter/material.dart';
import 'package:stacked_services/stacked_services.dart';

class AddRouteSummaryBottomSheet extends StatelessWidget {
  final SheetRequest request;
  final Function(SheetResponse) completer;

  const AddRouteSummaryBottomSheet({
    Key key,
    this.request,
    this.completer,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AddRouteSummaryBottomSheetInputArgs args = request.customData;

    return Container(
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
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'Route name ',
                  style: AppTextStyles.latoMedium14Black
                      .copyWith(color: AppColors.primaryColorShade5),
                ),
                TextSpan(
                  text: '${args.request.title}, ',
                  style: AppTextStyles.latoBold14Black
                      .copyWith(color: AppColors.primaryColorShade5),
                ),
                TextSpan(
                    text: 'for ',
                    style: AppTextStyles.latoMedium14Black
                        .copyWith(color: AppColors.primaryColorShade5)),
                TextSpan(
                    text:
                        '${capitalizeFirstLetter(args.request.clientId.toString())}',
                    style: AppTextStyles.latoMedium14Black
                        .copyWith(color: AppColors.primaryColorShade5)),
              ],
            ),
          ),
          hSizedBox(5),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                    text: 'Creation Date ',
                    style: AppTextStyles.latoMedium14Black
                        .copyWith(color: AppColors.primaryColorShade5)),
                TextSpan(
                    text: '${getDateString(DateTime.now())}',
                    style: AppTextStyles.latoBold14Black
                        .copyWith(color: AppColors.primaryColorShade5)),
              ],
            ),
          ),
          hSizedBox(5),
          Text(
            'Route Hub Details',
            style: AppTextStyles.latoMedium14Black
                .copyWith(color: AppColors.primaryColorShade5),
          ),
          Expanded(
            child: ListView.builder(
              itemBuilder: (context, index) => Card(
                color: AppColors.white,
                elevation: 4,
                shape: getCardShape(),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      buildHubDetails(
                        label: "Sequence",
                        value: args.request.hubs[index].sequence,
                      ),
                      hSizedBox(5),
                      buildHubDetails(
                        label: "Hub ID",
                        value: args.request.hubs[index].hub,
                      ),
                      hSizedBox(5),

                      buildHubDetails(
                        label: "Kms",
                        value: args.request.hubs[index].kms,
                      ),
                      hSizedBox(5),
                      buildHubDetails(
                        label: "Flag",
                        value: args.request.hubs[index].flag,
                      ),
                      // hSizedBox(10),
                    ],
                  ),
                ),
              ),
              itemCount: args.request.hubs.length,
            ),
          ),
          rowMaker(
            label: "Remarks",
            value: args.request.remarks,
          ),
          rowMaker(
            label: "Src Hub ID",
            value: args.request.srcLocation,
          ),
          rowMaker(
            label: "Dst Hub ID",
            value: args.request.dstLocation,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              height: buttonHeight,
              child: AppButton(
                  fontSize: 14,
                  borderRadius: defaultBorder,
                  borderColor: AppColors.primaryColorShade1,
                  onTap: () {
                    completer(
                      SheetResponse(
                        confirmed: true,
                        responseData: AddRouteSummaryBottomSheetOutputArgs(
                            request: args.request),
                      ),
                    );
                  },
                  background: AppColors.primaryColorShade5,
                  buttonText: 'SUBMIT'),
            ),
          )
        ],
      ),
    );
  }
}

class AddRouteSummaryBottomSheetInputArgs {
  final CreateRouteRequest request;

  AddRouteSummaryBottomSheetInputArgs({@required this.request});
}

class AddRouteSummaryBottomSheetOutputArgs {
  final CreateRouteRequest request;

  AddRouteSummaryBottomSheetOutputArgs({@required this.request});
}

Widget buildHubDetails({@required String label, @required Object value}) {
  return Padding(
    padding: const EdgeInsets.all(3.0),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        label == null ? Container() : Text(label),
        Text(value.toString()),
      ],
    ),
  );
}

Widget rowMaker({@required String label, @required Object value}) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: [
        label == null
            ? Container()
            : Expanded(
                flex: 1,
                child: Text(
                  label,
                  style: AppTextStyles.lato20PrimaryShade5.copyWith(
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.start,
                ),
              ),
        value == null
            ? Expanded(
                flex: 3,
                child: Text(
                  'NA',
                  style: AppTextStyles.lato20PrimaryShade5.copyWith(
                    fontSize: 14,
                  ),
                  maxLines: 3,
                  textAlign: TextAlign.right,
                ),
              )
            : Expanded(
                flex: 3,
                child: Text(
                  value.toString(),
                  style: AppTextStyles.lato20PrimaryShade5.copyWith(
                    fontSize: 14,
                  ),
                  maxLines: 3,
                  textAlign: TextAlign.end,
                ),
              ),
      ],
    ),
  );
}
