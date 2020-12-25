// Added by Vikas
// Subject to change
import 'package:meta/meta.dart';
import 'dart:convert';

class ViewExpensesResponse {
  ViewExpensesResponse({
    @required this.id,
    @required this.vehicleId,
    @required this.entryDate,
    @required this.expenseType,
    @required this.expenseAmount,
    @required this.expenseDesc,
    @required this.status,
    @required this.creationdate,
    @required this.lastupdated,
  });

  final int id;
  final String vehicleId;
  final String entryDate;
  final String expenseType;
  final double expenseAmount;
  final String expenseDesc;
  final bool status;
  final String creationdate;
  final String lastupdated;

  ViewExpensesResponse copyWith({
    int id,
    String vehicleId,
    String entryDate,
    String expenseType,
    int expenseAmount,
    String expenseDesc,
    bool status,
    String creationdate,
    String lastupdated,
  }) =>
      ViewExpensesResponse(
        id: id ?? this.id,
        vehicleId: vehicleId ?? this.vehicleId,
        entryDate: entryDate ?? this.entryDate,
        expenseType: expenseType ?? this.expenseType,
        expenseAmount: expenseAmount ?? this.expenseAmount,
        expenseDesc: expenseDesc ?? this.expenseDesc,
        status: status ?? this.status,
        creationdate: creationdate ?? this.creationdate,
        lastupdated: lastupdated ?? this.lastupdated,
      );

  factory ViewExpensesResponse.fromJson(String str) =>
      ViewExpensesResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ViewExpensesResponse.fromMap(Map<String, dynamic> json) =>
      ViewExpensesResponse(
        id: json["id"],
        vehicleId: json["vehicleId"],
        entryDate: json["entryDate"],
        expenseType: json["expenseType"],
        expenseAmount: json["expenseAmount"],
        expenseDesc: json["expenseDesc"],
        status: json["status"],
        creationdate: json["creationdate"],
        lastupdated: json["lastupdated"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "vehicleId": vehicleId,
        "entryDate": entryDate,
        "expenseType": expenseType,
        "expenseAmount": expenseAmount,
        "expenseDesc": expenseDesc,
        "status": status,
        "creationdate": creationdate,
        "lastupdated": lastupdated,
      };
}
