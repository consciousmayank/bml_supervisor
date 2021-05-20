import 'package:bml_supervisor/app_level/image_config.dart';
import 'package:bml_supervisor/app_level/shared_prefs.dart';
import 'package:bml_supervisor/models/secured_get_clients_response.dart';
import 'package:bml_supervisor/utils/app_text_styles.dart';
import 'package:bml_supervisor/utils/dimens.dart';
import 'package:bml_supervisor/utils/widget_utils.dart';
import 'package:bml_supervisor/widget/app_textfield.dart';
import 'package:bml_supervisor/widget/shimmer_container.dart';
import 'package:flutter/material.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:stacked/stacked.dart';

import 'client_select_viewmodel.dart';

class ClientSelectView extends StatefulWidget {
  final Function onClientSelected;
  final isCalledFromBottomSheet;
  final GetClientsResponse preSelectedClient;

  const ClientSelectView({
    Key key,
    this.preSelectedClient,
    this.onClientSelected,
    this.isCalledFromBottomSheet = false,
  }) : super(key: key);

  @override
  _ClientSelectViewState createState() => _ClientSelectViewState();
}

class _ClientSelectViewState extends State<ClientSelectView> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ClientSelectViewModel>.reactive(
        onModelReady: (viewModel) {
          viewModel.getClientList(showLoading: true);
          viewModel.preSelectedClient = widget.preSelectedClient;
        },
        builder: (context, viewModel, child) => Scaffold(
              appBar: widget.isCalledFromBottomSheet
                  ? null
                  : AppBar(
                      centerTitle: true,
                      title: Text(
                        'Select Client',
                        style: AppTextStyles.appBarTitleStyle,
                      ),
                      automaticallyImplyLeading: false,
                    ),
              body: viewModel.isBusy
                  ? ShimmerContainer(
                      itemCount: 5,
                    )
                  : BodyWidget(
                      viewModel: viewModel,
                      onClientSelected: widget.onClientSelected,
                      isCalledFromBottomSheet: widget.isCalledFromBottomSheet,
                    ),
            ),
        viewModelBuilder: () => ClientSelectViewModel());
  }
}

class BodyWidget extends StatelessWidget {
  final ClientSelectViewModel viewModel;
  final Function onClientSelected;
  final isCalledFromBottomSheet;

  const BodyWidget({
    Key key,
    @required this.viewModel,
    @required this.onClientSelected,
    @required this.isCalledFromBottomSheet,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        appTextFormField(
          enabled: true,
          inputDecoration: InputDecoration(
              contentPadding:
                  EdgeInsets.only(left: 16, top: 4, bottom: 4, right: 16),
              hintStyle: TextStyle(fontSize: 14, color: Colors.black45),
              hintText: 'Enter Client Name'),
          keyboardType: TextInputType.text,
        ),
        Expanded(
          child: LazyLoadScrollView(
            scrollOffset: (MediaQuery.of(context).size.height ~/ 2),
            onEndOfPage: () => viewModel.getClientList(showLoading: false),
            child: GridView.count(
              // Create a grid with 2 columns. If you change the scrollDirection to
              // horizontal, this produces 2 rows.
              crossAxisCount: 2,
              // Generate 100 widgets that display their index in the List.
              children: List.generate(viewModel.clientsList.length, (index) {
                return Card(
                  shape: getCardShape(),
                  elevation: defaultElevation,
                  child: InkWell(
                    onTap: () {
                      Future.delayed(Duration(milliseconds: 500), () {
                        print(
                            'saveSelectedClient :: ${viewModel.clientsList[index].clientId}');
                        print('index :: $index');
                        MyPreferences()
                            .saveSelectedClient(viewModel.clientsList[index]);
                        if (isCalledFromBottomSheet) {
                          onClientSelected(viewModel.clientsList[index]);
                        } else {
                          viewModel.takeToDashBoard();
                        }
                      });
                      viewModel.preSelectedClient =
                          viewModel.clientsList[index];
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Stack(
                        alignment: Alignment.topRight,
                        children: [
                          viewModel.preSelectedClient != null
                              ? Radio<GetClientsResponse>(
                                  value: viewModel.preSelectedClient.clientId ==
                                          viewModel.clientsList[index].clientId
                                      ? viewModel.preSelectedClient
                                      : viewModel.clientsList[index],
                                  onChanged: (GetClientsResponse value) {
                                    viewModel.preSelectedClient = value;
                                  },
                                  groupValue: viewModel.preSelectedClient,
                                )
                              : Container(),
                          Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Image.asset(loginIconIcon),
                              Text(viewModel.clientsList[index].businessName),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ],
    );
  }
}
