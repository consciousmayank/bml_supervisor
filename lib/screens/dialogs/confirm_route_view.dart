import 'package:bml_supervisor/app_level/colors.dart';
import 'package:bml_supervisor/models/create_route_request.dart';
import 'package:bml_supervisor/utils/app_text_styles.dart';
import 'package:bml_supervisor/utils/dimens.dart';
import 'package:bml_supervisor/utils/widget_utils.dart';
import 'package:bml_supervisor/widget/app_button.dart';
import 'package:flutter/material.dart';

class ConfirmRouteView extends StatelessWidget {
  final CreateRouteRequest routeRequest;
  final Function onSubmitClicked;
  final bool isShowSubmitButton;

  ConfirmRouteView({
    @required this.routeRequest,
    this.isShowSubmitButton,
    @required this.onSubmitClicked,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          RichText(
            text: TextSpan(
              children: [
                TextSpan(text: 'Route name '),
                TextSpan(
                    text: '${routeRequest.title}, ', style: AppTextStyles.bold),
                TextSpan(text: 'for '),
                TextSpan(
                    text: '${capitalizeFirstLetter(routeRequest.clientId)}'),

                //
                // TextSpan(
                //     text: '${routeRequest.title}', style: AppTextStyles.bold),
                // hSizedBox(10),
              ],
            ),
          ),
          hSizedBox(5),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(text: 'Creation Date '),
                TextSpan(text: '${getDateString(DateTime.now())}'),
                // hSizedBox(10),
              ],
            ),
          ),
          hSizedBox(5),
          Text(
            'Route Hub Details',
            style:
                AppTextStyles.latoMedium14Black.copyWith(color: Colors.white),
          ),
          Expanded(
            child: ListView.builder(
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8),
                  child: Card(
                      color: AppColors.white,
                      elevation: 4,
                      shape: getCardShape(),
                      child: Column(
                        children: [
                          buildHubDetails(
                            label: "Sequence",
                            value: routeRequest.hubs[index].sequence,
                          ),
                          hSizedBox(10),
                          buildHubDetails(
                            label: "Hub ID",
                            value: routeRequest.hubs[index].hub,
                          ),
                          hSizedBox(10),

                          buildHubDetails(
                            label: "Kms",
                            value: routeRequest.hubs[index].kms,
                          ),
                          hSizedBox(10),
                          buildHubDetails(
                            label: "Flag",
                            value: routeRequest.hubs[index].flag,
                          ),
                          // hSizedBox(10),
                        ],
                      )),
                );
              },
              itemCount: routeRequest.hubs.length,
            ),
          ),
          // RichText(
          //   text: TextSpan(
          //     children: [
          //       TextSpan(text: '${routeRequest.remarks}'),
          //
          //       TextSpan(text: '${routeRequest.srcLocation}'),
          //       TextSpan(text: '${routeRequest.dstLocation}'),
          //       // hSizedBox(10),
          //     ],
          //   ),
          // ),
          rowMaker(
            label: "Remarks",
            value: routeRequest.remarks,
          ),
          rowMaker(
            label: "Src Hub ID",
            value: routeRequest.srcLocation,
          ),
          rowMaker(
            label: "Dst Hub ID",
            value: routeRequest.dstLocation,
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
                    onSubmitClicked(true);
                  },
                  background: AppColors.primaryColorShade5,
                  buttonText: 'SUBMIT'),
            ),
          )
        ],
      ),
    );
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
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          label == null
              ? Container()
              : Text(
                  label,
                  style: AppTextStyles.whiteRegular,
                ),
          value is String
              ? Text('NA', style: AppTextStyles.whiteRegular)
              : Text(value.toString(), style: AppTextStyles.whiteRegular),
        ],
      ),
    );
  }
}
