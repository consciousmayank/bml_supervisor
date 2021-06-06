import 'package:flutter/material.dart';

class ViewExpensesAggregateHelper {
  ViewExpensesAggregateType expenseEnumType;
  String expenseType;
  int pageNumber;
  int total;
  String vehicleId;
  int clientId, month, year;

  ViewExpensesAggregateHelper.aggregateViewExpensesByClient({
    @required this.month,
    @required this.year,
    this.expenseEnumType = ViewExpensesAggregateType.AGGREGATE_EXPENSE_BY_CLIENT,
    @required this.clientId,
  });

  ViewExpensesAggregateHelper.aggregateViewExpensesByClientAndType({
    @required this.month,
    @required this.year,
    this.expenseEnumType =
        ViewExpensesAggregateType.AGGREGATE_EXPENSE_BY_CLIENT_AND_TYPE,
    @required this.expenseType,
    @required this.clientId,
  });

  ViewExpensesAggregateHelper.aggregateViewExpensesByClientAndVehicle({
    this.expenseEnumType =
        ViewExpensesAggregateType.AGGREGATE_EXPENSE_BY_CLIENT_AND_VEHICLE,
    @required this.clientId,
    @required this.vehicleId,
    @required this.month,
    @required this.year,
  });

  ViewExpensesAggregateHelper.aggregateViewExpensesByClientVehicleAndType({
    this.expenseEnumType =
        ViewExpensesAggregateType.AGGREGATE_EXPENSE_BY_CLIENT_VEHICLE_AND_TYPE,
    @required this.expenseType,
    @required this.clientId,
    @required this.vehicleId,
    @required this.month,
    @required this.year,
  });
}

class ViewExpensesHelper {

  ViewExpensesHelper.viewExpensesByClient({
    @required this.month,
    @required this.year,
    @required this.pageNumber,
    this.expenseEnumType = ViewExpensesType.VIEW_EXPENSE_BY_CLIENT,
    @required this.clientId,
  });
  
  ViewExpensesHelper.viewExpensesByClientAndType({
    @required this.month,
    @required this.year,
    @required this.pageNumber,
    this.expenseEnumType = ViewExpensesType.VIEW_EXPENSE_BY_CLIENT_AND_TYPE,
    @required this.expenseType,
    @required this.clientId,
  });

  ViewExpensesHelper.viewExpensesByClientAndVehicle({
    @required this.pageNumber,
    this.expenseEnumType = ViewExpensesType.VIEW_EXPENSE_BY_CLIENT_AND_VEHICLE,
    @required this.clientId,
    @required this.vehicleId,
    @required this.month,
    @required this.year,
  });

  ViewExpensesHelper.viewExpensesByClientVehicleAndType({
    @required this.pageNumber,
    this.expenseEnumType =
        ViewExpensesType.VIEW_EXPENSE_BY_CLIENT_VEHICLE_AND_TYPE,
    @required this.expenseType,
    @required this.clientId,
    @required this.vehicleId,
    @required this.month,
    @required this.year,
  });

  ViewExpensesType expenseEnumType;
  String expenseType;
  int pageNumber;
  int total;
  String vehicleId;
  int clientId, month, year;
}

enum ViewExpensesType {
  // VIEW_EXPENSES,
  // VIEW_EXPENSE_BY_TYPE,
  VIEW_EXPENSE_BY_CLIENT,
  VIEW_EXPENSE_BY_CLIENT_AND_TYPE,
  // VIEW_EXPENSE_BY_VEHICLE,
  // VIEW_EXPENSE_BY_VEHICLE_AND_TYPE,
  VIEW_EXPENSE_BY_CLIENT_AND_VEHICLE,
  VIEW_EXPENSE_BY_CLIENT_VEHICLE_AND_TYPE,
}

enum ViewExpensesAggregateType {
  // AGGREGATE_EXPENSE,
  // AGGREGATE_EXPENSE_BY_TYPE,
  AGGREGATE_EXPENSE_BY_CLIENT,
  AGGREGATE_EXPENSE_BY_CLIENT_AND_TYPE,
  // AGGREGATE_EXPENSE_BY_VEHICLE,
  // AGGREGATE_EXPENSE_BY_VEHICLE_AND_TYPE,
  AGGREGATE_EXPENSE_BY_CLIENT_AND_VEHICLE,
  AGGREGATE_EXPENSE_BY_CLIENT_VEHICLE_AND_TYPE,
}
