import 'package:flutter/material.dart';
import 'package:bml/bml.dart';

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
    List customData = request.customData as List;

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
          Expanded(
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
                          child: Text(customData[index]),
                        ),
                      ),
                      onTap: () {
                        completer(
                          SheetResponse(
                              confirmed: true, responseData: customData[index]),
                        );
                      },
                      borderRadius: Utils().getBorderRadius(borderRadius: 0),
                    )
                  ],
                );
              },
              itemCount: customData.length,
            ),
          ),
        ],
      ),
    );
  }
}
