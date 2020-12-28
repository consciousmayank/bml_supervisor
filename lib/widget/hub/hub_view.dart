import 'package:bml_supervisor/models/routes_for_client_id_response.dart';
import 'package:bml_supervisor/widget/hub/hub_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class HubView extends StatefulWidget {
  final Hubs hub;

  HubView({@required this.hub});

  @override
  _HubViewState createState() => _HubViewState();
}

class _HubViewState extends State<HubView> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<HubViewModel>.reactive(
        onModelReady: (viewModel) => viewModel.getHubData(widget.hub),
        builder: (context, viewModel, child) => viewModel.isBusy
            ? Center(
                child: CircularProgressIndicator(),
              )
            : body(context: context, viewModel: viewModel),
        viewModelBuilder: () => HubViewModel());
  }

  body({BuildContext context, HubViewModel viewModel}) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("${viewModel.hubResponse.title},"),
                Text("${viewModel.hubResponse.city},"),
                Text("${widget.hub.kms} kms"),
                Text("${viewModel.hubResponse.mobile}"),
              ],
            ),
            Container(
              padding: const EdgeInsets.all(8),
              child: Column(children: [
                Text("Drop"),
                Text("Pick"),
                Text("Payment"),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}
