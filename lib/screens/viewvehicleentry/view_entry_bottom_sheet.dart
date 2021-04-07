import 'package:bml_supervisor/utils/dimens.dart';
import 'package:flutter/material.dart';
import 'package:stacked_services/stacked_services.dart';

class ViewEntryBottomSheet extends StatelessWidget {
  final SheetRequest request;
  final Function(SheetResponse) completer;

  const ViewEntryBottomSheet({
    Key key,
    this.request,
    this.completer,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List customData = request.customData as List;

    return Container(
      // margin: EdgeInsets.all(defaultBorder),
      // padding: EdgeInsets.all(defaultBorder),
      height: 900,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(defaultBorder),
          topRight: Radius.circular(defaultBorder),
        ),
      ),
      child: ListView.builder(
        itemBuilder: (context, index) {
          return ListTile(
            onTap: () {
              completer(
                SheetResponse(confirmed: true, responseData: customData[index]),
              );
            },
            title: Text(customData[index]),
          );
        },
        itemCount: customData.length,
      ),
    );
  }
}
