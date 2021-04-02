import 'package:bml_supervisor/screens/addroutes/arrangehubs/arrange_hubs_viewmodel.dart';
import 'package:bml_supervisor/utils/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class ArrangeHubsView extends StatefulWidget {
  @override
  _ArrangeHubsViewState createState() => _ArrangeHubsViewState();
}

class _ArrangeHubsViewState extends State<ArrangeHubsView> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ArrangeHubsViewModel>.reactive(
        builder: (context, viewModel, child) {
          return Scaffold(
            appBar: AppBar(
              title: Text(
                'Arrange Hubs',
                style: AppTextStyles.appBarTitleStyle,
              ),
              centerTitle: true,
            ),
            body: Center(
              child: Text('Arrange Hubs'),
            ),
          );
        },
        viewModelBuilder: () => ArrangeHubsViewModel());
  }
}
