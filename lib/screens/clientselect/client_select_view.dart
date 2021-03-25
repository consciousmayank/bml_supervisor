import 'package:bml_supervisor/app_level/image_config.dart';
import 'package:bml_supervisor/app_level/shared_prefs.dart';
import 'package:bml_supervisor/utils/app_text_styles.dart';
import 'package:bml_supervisor/utils/dimens.dart';
import 'package:bml_supervisor/utils/widget_utils.dart';
import 'package:bml_supervisor/widget/shimmer_container.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'client_select_viewmodel.dart';

class ClientSelectView extends StatefulWidget {
  @override
  _ClientSelectViewState createState() => _ClientSelectViewState();
}

class _ClientSelectViewState extends State<ClientSelectView> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ClientSelectViewModel>.reactive(
        onModelReady: (viewModel) => viewModel.getClientList(),
        builder: (context, viewModel, child) => Scaffold(
              appBar: AppBar(
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
                  : BodyWidget(viewModel: viewModel),
            ),
        viewModelBuilder: () => ClientSelectViewModel());
  }
}

class BodyWidget extends StatelessWidget {
  final ClientSelectViewModel viewModel;

  const BodyWidget({Key key, @required this.viewModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      // Create a grid with 2 columns. If you change the scrollDirection to
      // horizontal, this produces 2 rows.
      crossAxisCount: 2,
      // Generate 100 widgets that display their index in the List.
      children: List.generate(viewModel.clientsList.length, (index) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            shape: getCardShape(),
            elevation: defaultElevation,
            child: InkWell(
              onTap: () {
                MyPreferences()
                    .saveSelectedClient(viewModel.clientsList[index]);
                viewModel.takeToDashBoard();
              },
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Image.asset(loginIconIcon),
                    Text(viewModel.clientsList[index].clientId),
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
