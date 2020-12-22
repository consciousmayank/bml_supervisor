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
  ];

  List<String> optionsTitle = [
    "Add Entry",
    "View Entry",
    "Add Expense",
    "View Expenses",
    "Allot Consignments",
    "View Consignments",
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

  takeToViewConsignmentsPage() {
    navigationService.navigateTo(viewConsignmentsPageRoute);
  }
}
