import 'package:bml_supervisor/app_level/themes.dart';
import 'package:bml_supervisor/models/add_consignment_request.dart';
import 'package:bml_supervisor/models/routes_for_client_id_response.dart';
import 'package:bml_supervisor/utils/dimens.dart';
import 'package:bml_supervisor/utils/stringutils.dart';
import 'package:bml_supervisor/utils/widget_utils.dart';
import 'package:bml_supervisor/widget/hub/hub_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:stacked/stacked.dart';

import '../app_textfield.dart';

class HubView extends StatefulWidget {
  final Hubs hub;
  final int routeId;
  final String title;

  HubView({@required this.hub, @required this.routeId, @required this.title});

  @override
  _HubViewState createState() => _HubViewState();
}

class _HubViewState extends State<HubView> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController dropTextEditingController = TextEditingController();
  FocusNode dropFocusNode = FocusNode();

  TextEditingController pickTextEditingController = TextEditingController();
  FocusNode pickFocusNode = FocusNode();

  TextEditingController paymentTextEditingController = TextEditingController();
  FocusNode paymentFocusNode = FocusNode();

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
    return InkWell(
      onTap: () =>
          showAddEditConsignment(context: context, viewModel: viewModel),
      child: Card(
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("${viewModel.hubResponse.title},"),
                  Text("${viewModel.hubResponse.mobile}"),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "${viewModel.hubResponse.landmark}",
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
              Text("${viewModel.hubResponse.city},"),
              hSizedBox(10),
              Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: getConsignmentDropValue(
                          context: context, viewModel: viewModel),
                      flex: 1,
                    ),
                    wSizedBox(10),
                    Expanded(
                      child: getConsignmentPickValue(
                          context: context, viewModel: viewModel),
                      flex: 1,
                    ),
                    wSizedBox(10),
                    Expanded(
                      child: getConsignmentPaymentValue(
                          context: context, viewModel: viewModel),
                      flex: 1,
                    ),
                  ]),
            ],
          ),
        ),
      ),
    );
  }

  Widget getConsignmentDropValue(
      {@required BuildContext context, @required HubViewModel viewModel}) {
    return Container(
      padding: const EdgeInsets.all(4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text("Drop"),
          hSizedBox(5),
          viewModel.addConsignmentRequest.dropOff == null
              ? Container()
              : Text(viewModel.addConsignmentRequest.dropOff.toString()),
        ],
      ),
      decoration: BoxDecoration(
        border: Border.all(width: 1.0, color: Colors.black38),
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }

  Widget getConsignmentPickValue(
      {@required BuildContext context, @required HubViewModel viewModel}) {
    return Container(
      padding: const EdgeInsets.all(4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text("Pick"),
          hSizedBox(5),
          viewModel.addConsignmentRequest.collect == null
              ? Container()
              : Text(viewModel.addConsignmentRequest.collect.toString()),
        ],
      ),
      decoration: BoxDecoration(
        border: Border.all(width: 1.0, color: Colors.black38),
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }

  Widget getConsignmentPaymentValue(
      {@required BuildContext context, @required HubViewModel viewModel}) {
    return Container(
      padding: const EdgeInsets.all(4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text("Payment"),
          hSizedBox(5),
          viewModel.addConsignmentRequest.payment == null
              ? Container()
              : Text(viewModel.addConsignmentRequest.payment.toString()),
        ],
      ),
      decoration: BoxDecoration(
        border: Border.all(width: 1.0, color: Colors.black38),
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }

  showAddEditConsignment(
      {@required BuildContext context, @required HubViewModel viewModel}) {
    var bottomSheetController = showModalBottomSheet(
      context: context,
      builder: (context) => Scaffold(
        appBar: AppBar(
          title: Text("Choose"),
          actions: [
            IconButton(
                icon: Icon(Icons.cancel_outlined),
                onPressed: () => viewModel.navigationService.back())
          ],
        ),
        body: Container(
          color: ThemeConfiguration.ternaryBackground,
          child: Padding(
            padding:
                const EdgeInsets.only(top: 8, right: 4, left: 4, bottom: 8),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  appTextFormField(
                    focusNode: dropFocusNode,
                    hintText: "Enter Drop Value",
                    formatter: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                      LengthLimitingTextInputFormatter(7)
                    ],
                    validator: (value) {
                      if (value.isEmpty) {
                        return textRequired;
                      } else {
                        return null;
                      }
                    },
                    onFieldSubmitted: (_) {
                      fieldFocusChange(context, dropFocusNode, pickFocusNode);
                    },
                    controller: dropTextEditingController,
                  ),
                  appTextFormField(
                    focusNode: pickFocusNode,
                    hintText: "Enter Pick Value",
                    formatter: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                      LengthLimitingTextInputFormatter(7)
                    ],
                    validator: (value) {
                      if (value.isEmpty) {
                        return textRequired;
                      } else {
                        return null;
                      }
                    },
                    onFieldSubmitted: (_) {
                      fieldFocusChange(
                          context, pickFocusNode, paymentFocusNode);
                    },
                    controller: pickTextEditingController,
                  ),
                  Expanded(
                    child: appTextFormField(
                      focusNode: paymentFocusNode,
                      hintText: "Enter Payment Value",
                      formatter: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                        LengthLimitingTextInputFormatter(7)
                      ],
                      validator: (value) {
                        if (value.isEmpty) {
                          return textRequired;
                        } else {
                          return null;
                        }
                      },
                      onFieldSubmitted: (_) {
                        paymentFocusNode.unfocus();
                      },
                      controller: paymentTextEditingController,
                    ),
                  ),
                  SizedBox(
                    height: buttonHeight,
                    child: RaisedButton(
                      child: Text("Submit"),
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          AddConsignmentRequest request = AddConsignmentRequest(
                              dropOff:
                                  int.parse(dropTextEditingController.text),
                              collect:
                                  int.parse(pickTextEditingController.text),
                              payment:
                                  int.parse(paymentTextEditingController.text),
                              routeId: widget.routeId,
                              hubId: widget.hub.hub,
                              title: widget.title,
                              tag: widget.hub.tag,
                              entryDate: DateFormat('dd-MM-yyyy')
                                  .format(DateTime.now())
                                  .toLowerCase());

                          viewModel.navigationService
                              .back(result: request.toMap());
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    bottomSheetController.then((value) {
      if (value != null) {
        viewModel.addConsignmentRequest = AddConsignmentRequest.fromMap(value);
      }
    });
  }
}
