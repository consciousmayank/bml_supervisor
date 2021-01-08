import 'package:bml_supervisor/app_level/generalised_indextracking_view_model.dart';
import 'package:bml_supervisor/routes/routes_constants.dart';
import 'package:flutter/material.dart';

class DashBoardScreenViewModel extends GeneralisedIndexTrackingViewModel {
  List<IconData> optionsIcons = [
    Icons.phone,
    Icons.clear,
    Icons.label,
    Icons.search,
    Icons.date_range,
    Icons.list,
    Icons.title,
    Icons.access_alarm,
    Icons.access_time,
  ];

  List<String> optionsTitle = [
    "Add Entry",
    "View Entry",
    "Add Expense",
    "View Expenses",
    "Allot Consignments",
    "View Consignments",
    // "Add Entry 2.0",
    // "View Entry 2.0",
  ];

  takeToAddEntryPage() {
    navigationService.navigateTo(addEntryLogPageRoute);
  }

  takeToAddExpensePage() {
    navigationService.navigateTo(addExpensesPageRoute);
  }

  takeToViewEntryPage() {
    navigationService.navigateTo(viewEntryLogPageRoute);
  }

  takeToViewExpensePage() {
    navigationService.navigateTo(viewExpensesPageRoute);
  }

  takeToAllotConsignmentsPage() {
    navigationService.navigateTo(allotConsignmentsPageRoute);
  }

  // takeToViewConsignmentsPage() {
  //   navigationService.navigateTo(viewConsignmentsPageRoute);
  // }

  //! For testing purpose it is navigating to searchPageRoute otherwise the above one is correct
  takeToViewConsignmentsPage() {
    navigationService.navigateTo(searchPageRoute);
  }

  // takeToAddEntry2PointOPage() {
  //   navigationService.navigateTo(addEntry2PointOLogPageRoute);
  // }

  // takeToViewEntry2PointOPage() {
  //   navigationService.navigateTo(viewEntry2PointOLogPageRoute);
  // }
}
