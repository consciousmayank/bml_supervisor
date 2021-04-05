import 'package:bml_supervisor/app_level/colors.dart';
import 'package:bml_supervisor/models/create_route_request.dart';
import 'package:bml_supervisor/utils/widget_utils.dart';
import 'package:flutter/material.dart';

class ConfirmRouteView extends StatelessWidget {
  final CreateRouteRequest request;
  final Function onSubmitClicked;
  final bool isShowSubmitButton;

  ConfirmRouteView({
    this.request,
    this.isShowSubmitButton,
    this.onSubmitClicked,
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
                TextSpan(text: '${request.title}'),
                TextSpan(text: '${request.clientId}'),
                TextSpan(text: '${request.remarks}'),
                TextSpan(text: '${request.srcLocation}'),
                TextSpan(text: '${request.dstLocation}'),
                hSizedBox(10),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8),
                  child: Card(
                    color: AppColors.primaryColorShade3,
                    elevation: 4,
                    shape: getCardShape(),
                    child: Stack(
                      children: [
                        Image.asset(semiCircles),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              rowMaker(
                                  label: "Articles",
                                  value: consignmentRequest.items[index].title),
                              hSizedBox(10),
                              rowMaker(
                                  label: "Hub",
                                  value: consignmentRequest.items[index].hubId
                                      .toString()),
                              hSizedBox(10),
                              rowMaker(
                                  label: "Crates to Collect",
                                  value: consignmentRequest.items[index].collect
                                      .toString()),
                              hSizedBox(10),
                              rowMaker(
                                  label: "Crates to Drop",
                                  value: consignmentRequest.items[index].dropOff
                                      .toString()),
                              hSizedBox(10),
                              rowMaker(
                                  label: "Payment to receive",
                                  value: consignmentRequest.items[index].payment
                                      .toString()),
                              hSizedBox(10),
                              rowMaker(
                                  label: "Remarks",
                                  value:
                                  consignmentRequest.items[index].remarks),
                              hSizedBox(10),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
              itemCount: request.hubs.length,
            ),
          )
        ],
      ),
    );
  }
}
