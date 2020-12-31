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
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;

import '../app_textfield.dart';

class HubView extends StatefulWidget {
  final Hubs hub;
  final int routeId;
  final String title;
  final bool isStart, isDestination, isLast;

  HubView({
    @required Key key,
    @required this.hub,
    @required this.routeId,
    @required this.title,
    @required this.isStart,
    @required this.isDestination,
    @required this.isLast,
  }) : super(key: key);

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
        onModelReady: (viewModel) {
          viewModel.addConsignmentRequest = AddConsignmentRequest(
              routeId: widget.routeId,
              hubId: widget.hub.hub,
              entryDate: getCurrentDate(),
              title: widget.title,
              dropOff: 0,
              collect: 0,
              payment: 0,
              tag: widget.hub.tag);
          viewModel.getHubData(widget.hub, widget.routeId);
        },
        builder: (context, viewModel, child) => viewModel.isBusy
            ? Center(
                child: CircularProgressIndicator(),
              )
            : body(context: context, viewModel: viewModel),
        viewModelBuilder: () => HubViewModel());
  }

  body({BuildContext context, HubViewModel viewModel}) {
    return InkWell(
      onTap: () {
        if (widget.isStart) {
          addConsignmentStart(parentContext: context, viewModel: viewModel);
        } else if (widget.isLast) {
          addConsignmentLast(parentContext: context, viewModel: viewModel);
        } else if (widget.isDestination) {
          addConsignmentDestination(
              parentContext: context, viewModel: viewModel);
        } else {
          addConsignmentAll(parentContext: context, viewModel: viewModel);
        }
      },

      // showAddEditConsignment(parentContext: context, viewModel: viewModel),
      child: Card(
        color: Colors.white,
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                      flex: 2,
                      child: Text(
                          "${viewModel.hubResponse.title},(${viewModel.hubResponse.id})")),
                  Expanded(
                      flex: 1,
                      child: GestureDetector(
                        onTap: () {
                          UrlLauncher.launch(
                              "tel://${viewModel.hubResponse.mobile}");

                          // UrlLauncher.launch("tel://9611886339");
                        },
                        child: Text(
                          "${viewModel.hubResponse.mobile}",
                          textAlign: TextAlign.end,
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      )),
                ],
              ),
              Text(
                "${viewModel.hubResponse.landmark}",
                overflow: TextOverflow.ellipsis,
              ),
              Text("${viewModel.hubResponse.city}(${widget.hub.kms} km),"),
              hSizedBox(10),
              viewModel.consignmentList.length > 0
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                          Expanded(
                            child: getConsignmentPickValue(
                                context: context, viewModel: viewModel),
                            flex: 1,
                          ),
                          wSizedBox(10),
                          Expanded(
                            child: getConsignmentDropValue(
                                context: context, viewModel: viewModel),
                            flex: 1,
                          ),
                          wSizedBox(10),
                          Expanded(
                            child: getConsignmentPaymentValue(
                                context: context, viewModel: viewModel),
                            flex: 1,
                          ),
                        ])
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }

  Widget getConsignmentDropValue(
      {@required BuildContext context, @required HubViewModel viewModel}) {
    return viewModel.addConsignmentRequest.dropOff != null
        ? Container(
            padding: const EdgeInsets.all(4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("Drop"),
                hSizedBox(5),
                Text(viewModel.addConsignmentRequest.dropOff.toString()),
              ],
            ),
            decoration: BoxDecoration(
              border: Border.all(width: 1.0, color: Colors.black38),
              borderRadius: BorderRadius.circular(8),
            ),
          )
        : Container();
  }

  Widget getConsignmentPickValue(
      {@required BuildContext context, @required HubViewModel viewModel}) {
    return viewModel.addConsignmentRequest.collect != null
        ? Container(
            padding: const EdgeInsets.all(4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("Collect"),
                hSizedBox(5),
                Text(viewModel.addConsignmentRequest.collect.toString()),
              ],
            ),
            decoration: BoxDecoration(
              border: Border.all(width: 1.0, color: Colors.black38),
              borderRadius: BorderRadius.circular(8),
            ),
          )
        : Container();
  }

  Widget getConsignmentPaymentValue(
      {@required BuildContext context, @required HubViewModel viewModel}) {
    return viewModel.addConsignmentRequest.payment != null
        ? Container(
            padding: const EdgeInsets.all(4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("Payment"),
                hSizedBox(5),
                Text(viewModel.addConsignmentRequest.payment.toString()),
              ],
            ),
            decoration: BoxDecoration(
              border: Border.all(width: 1.0, color: Colors.black38),
              borderRadius: BorderRadius.circular(8),
            ),
          )
        : Container();
  }

  addConsignmentAll(
      {@required BuildContext parentContext,
      @required HubViewModel viewModel}) {
    var bottomSheetController = showModalBottomSheet(
      context: context,
      builder: (context) => Scaffold(
        appBar: AppBar(
          title: Text("Fill Details"),
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
            child: viewModel.isBusy
                ? Container(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                : Form(
                    key: _formKey,
                    child: ListView(
                      children: [
                        //drop
                        appTextFormField(
                          focusNode: dropFocusNode,
                          hintText: "Drop",
                          keyboardType: TextInputType.number,
                          formatter: <TextInputFormatter>[
                            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                            LengthLimitingTextInputFormatter(7)
                          ],
                          onFieldSubmitted: (_) {
                            fieldFocusChange(
                                context, dropFocusNode, pickFocusNode);
                          },
                          controller: dropTextEditingController,
                        ),
                        hSizedBox(20),
                        //collect
                        appTextFormField(
                          focusNode: pickFocusNode,
                          hintText: "Collect",
                          keyboardType: TextInputType.number,
                          formatter: <TextInputFormatter>[
                            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                            LengthLimitingTextInputFormatter(7)
                          ],
                          onFieldSubmitted: (_) {
                            fieldFocusChange(
                                context, pickFocusNode, paymentFocusNode);
                          },
                          controller: pickTextEditingController,
                        ),
                        hSizedBox(20),
                        //payment
                        appTextFormField(
                          focusNode: paymentFocusNode,
                          hintText: "Payment",
                          keyboardType: TextInputType.number,
                          formatter: <TextInputFormatter>[
                            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                            LengthLimitingTextInputFormatter(7)
                          ],
                          onFieldSubmitted: (_) {
                            paymentFocusNode.unfocus();
                          },
                          controller: paymentTextEditingController,
                        ),
                        hSizedBox(20),
                        SizedBox(
                          height: buttonHeight,
                          child: RaisedButton(
                            child: Text("Submit"),
                            onPressed: () {
                              // if (_formKey.currentState.validate()) {
                              AddConsignmentRequest request = AddConsignmentRequest(
                                  dropOff:
                                      dropTextEditingController.text.length == 0
                                          ? null
                                          : int.parse(
                                              dropTextEditingController.text),
                                  collect:
                                      pickTextEditingController.text.length == 0
                                          ? null
                                          : int.parse(
                                              pickTextEditingController.text),
                                  payment: paymentTextEditingController
                                              .text.length ==
                                          0
                                      ? null
                                      : double.parse(
                                          paymentTextEditingController.text),
                                  routeId: widget.routeId,
                                  hubId: widget.hub.hub,
                                  title: widget.title,
                                  tag: widget.hub.tag,
                                  entryDate: DateFormat('dd-MM-yyyy')
                                      .format(DateTime.now())
                                      .toLowerCase());

                              viewModel.navigationService
                                  .back(result: request.toMap());
                              // }
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
        viewModel
            .saveConsignment(request: AddConsignmentRequest.fromMap(value))
            .then((value) {
          if (value is AddConsignmentRequest) {
            // viewModel.getConsignmentList(
            //     routeId: widget.routeId, hubId: widget.hub.hub.toString());

            AddConsignmentRequest request = value;

            viewModel.addConsignmentRequest = request;
          }
        });
      }
    });
  }

  void addConsignmentStart(
      {BuildContext parentContext, HubViewModel viewModel}) {
    var bottomSheetController = showModalBottomSheet(
      context: context,
      builder: (context) => Scaffold(
        appBar: AppBar(
          title: Text("Add Collect"),
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
            child: viewModel.isBusy
                ? Container(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                : Form(
                    key: _formKey,
                    child: ListView(
                      children: [
                        //collect
                        appTextFormField(
                          focusNode: pickFocusNode,
                          hintText: "Collect",
                          keyboardType: TextInputType.number,
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
                        hSizedBox(20),
                        //payment
                        SizedBox(
                          height: buttonHeight,
                          child: RaisedButton(
                            child: Text("Submit"),
                            onPressed: () {
                              if (_formKey.currentState.validate()) {
                                AddConsignmentRequest request =
                                    AddConsignmentRequest(
                                        dropOff: null,
                                        collect: int.parse(
                                            pickTextEditingController.text),
                                        payment: null,
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
        viewModel
            .saveConsignment(request: AddConsignmentRequest.fromMap(value))
            .then((value) {
          if (value is AddConsignmentRequest) {
            AddConsignmentRequest request = value;

            viewModel.addConsignmentRequest = request;
          }
        });
      }
    });
  }

  void addConsignmentDestination(
      {BuildContext parentContext, HubViewModel viewModel}) {
    var bottomSheetController = showModalBottomSheet(
      context: context,
      builder: (context) => Scaffold(
        appBar: AppBar(
          title: Text("Fill Details"),
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
            child: viewModel.isBusy
                ? Container(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                : Form(
                    key: _formKey,
                    child: ListView(
                      children: [
                        //drop
                        appTextFormField(
                          focusNode: dropFocusNode,
                          hintText: "Drop",
                          keyboardType: TextInputType.number,
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
                                context, dropFocusNode, pickFocusNode);
                          },
                          controller: dropTextEditingController,
                        ),
                        hSizedBox(20),
                        //collect
                        appTextFormField(
                          focusNode: pickFocusNode,
                          hintText: "Collect",
                          keyboardType: TextInputType.number,
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
                        hSizedBox(20),
                        //payment
                        appTextFormField(
                          focusNode: paymentFocusNode,
                          hintText: "Payment",
                          keyboardType: TextInputType.number,
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
                        hSizedBox(20),
                        SizedBox(
                          height: buttonHeight,
                          child: RaisedButton(
                            child: Text("Submit"),
                            onPressed: () {
                              if (_formKey.currentState.validate()) {
                                AddConsignmentRequest request =
                                    AddConsignmentRequest(
                                        dropOff: int.parse(
                                            dropTextEditingController.text),
                                        collect: int.parse(
                                            pickTextEditingController.text),
                                        payment: double.parse(
                                            paymentTextEditingController.text),
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
        viewModel
            .saveConsignment(request: AddConsignmentRequest.fromMap(value))
            .then((value) {
          if (value is AddConsignmentRequest) {
            AddConsignmentRequest request = value;

            viewModel.addConsignmentRequest = request;
          }
        });
      }
    });
  }

  void addConsignmentLast(
      {BuildContext parentContext, HubViewModel viewModel}) {
    var bottomSheetController = showModalBottomSheet(
      context: context,
      builder: (context) => Scaffold(
        appBar: AppBar(
          title: Text("addConsignmentAll"),
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
            child: viewModel.isBusy
                ? Container(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                : Form(
                    key: _formKey,
                    child: ListView(
                      children: [
                        //drop
                        appTextFormField(
                          focusNode: dropFocusNode,
                          hintText: "Drop",
                          keyboardType: TextInputType.number,
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
                                context, dropFocusNode, pickFocusNode);
                          },
                          controller: dropTextEditingController,
                        ),
                        hSizedBox(20),
                        //payment
                        appTextFormField(
                          focusNode: paymentFocusNode,
                          hintText: "Payment",
                          keyboardType: TextInputType.number,
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
                        hSizedBox(20),
                        SizedBox(
                          height: buttonHeight,
                          child: RaisedButton(
                            child: Text("Submit"),
                            onPressed: () {
                              if (_formKey.currentState.validate()) {
                                AddConsignmentRequest request =
                                    AddConsignmentRequest(
                                        dropOff: int.parse(
                                            dropTextEditingController.text),
                                        collect: null,
                                        payment: double.parse(
                                            paymentTextEditingController.text),
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
        viewModel
            .saveConsignment(request: AddConsignmentRequest.fromMap(value))
            .then((value) {
          if (value is AddConsignmentRequest) {
            AddConsignmentRequest request = value;

            viewModel.addConsignmentRequest = request;
          }
        });
      }
    });
  }
}
