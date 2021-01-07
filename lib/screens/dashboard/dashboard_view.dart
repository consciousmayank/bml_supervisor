import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'dashboard_viewmodel.dart';

class DashBoardScreenView extends StatefulWidget {
  @override
  _DashBoardScreenViewState createState() => _DashBoardScreenViewState();
}

class _DashBoardScreenViewState extends State<DashBoardScreenView> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<DashBoardScreenViewModel>.reactive(
        builder: (context, viewModel, child) => Scaffold(
              appBar: AppBar(
                title: Text("Welcome, Rahul Rautela"),
                centerTitle: true,
              ),
              // bottomNavigationBar: BottomNavigationBar(
              //   type: BottomNavigationBarType.fixed,
              //   backgroundColor: ThemeConfiguration.primaryBackground,
              //   selectedItemColor: Colors.white,
              //   currentIndex: viewModel.currentIndex,
              //   onTap: viewModel.setIndex,
              //   items: [
              //     BottomNavigationBarItem(
              //       label: 'Entry',
              //       icon: Icon(Icons.add),
              //     ),
              //     BottomNavigationBarItem(
              //       label: 'Expenses',
              //       icon: Icon(Icons.list),
              //     ),
              //   ],
              // ),
              // body: getViewForIndex(viewModel.currentIndex),
              body: GridView.count(
                crossAxisCount: 2,
                children: List.generate(6, (index) {
                  return getOptions(
                      context: context, position: index, viewModel: viewModel);
                }),
              ),
            ),
        viewModelBuilder: () => DashBoardScreenViewModel());
  }

  Widget getOptions(
      {BuildContext context,
      int position,
      DashBoardScreenViewModel viewModel}) {
    return Container(
      child: InkWell(
        onTap: () => handleOptionClick(
            context: context, position: position, viewModel: viewModel),
        child: Card(
          elevation: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            mainAxisSize: MainAxisSize.max,
            children: [
              Icon(
                viewModel.optionsIcons[position],
                size: 48,
              ),
              Text(viewModel.optionsTitle[position]),
            ],
          ),
        ),
      ),
    );
  }

  handleOptionClick(
      {BuildContext context,
      int position,
      DashBoardScreenViewModel viewModel}) {
    switch (position) {
      case 0:
        return viewModel.takeToAddEntryPage();
        break;
      case 1:
        return viewModel.takeToViewEntryPage();
        break;
      case 2:
        return viewModel.takeToAddExpensePage();
        break;
      case 3:
        return viewModel.takeToViewExpensePage();
        break;
      case 4:
        return viewModel.takeToAllotConsignmentsPage();
        break;
      case 5:
        return viewModel.takeToViewConsignmentsPage();
        break;
      // case 6:
      //   return viewModel.takeToAddEntry2PointOPage();
      //   break;
      // case 7:
      //   return viewModel.takeToViewEntry2PointOPage();
      //   break;
      default:
        return viewModel.takeToAddEntryPage();
    }
  }
}
