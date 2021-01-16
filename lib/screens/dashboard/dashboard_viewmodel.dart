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
    Icons.access_alarm,
    Icons.access_time,
  ];

  List<String> optionsTitle = [
    "Add Entry",
    "View Entry",
    "Add Expense",
    "View Expenses",
    "Allot Consignments",
    "View Routes",
    "View Consignments",
  ];

  takeToAddEntryPage() {
    navigationService.navigateTo(addEntryLogPageRoute);
  }

  takeToBlankPage() {
    navigationService.navigateTo(blankPageRoute);
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

  takeToViewRoutesPage() {
    navigationService.navigateTo(viewRoutesPageRoute);
  }

  takeToViewConsignmentsPage() {
    navigationService.navigateTo(viewConsignmentsPageRoute);
  }
}
