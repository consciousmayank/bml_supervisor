// To parse this JSON data, do
//
//     final consignmentsForSelectedDateAndClientResponse = consignmentsForSelectedDateAndClientResponseFromMap(jsonString);

//
// List<ConsignmentsForSelectedDateAndClientResponse>
//     consignmentsForSelectedDateAndClientResponseFromMap(String str) =>
//         List<ConsignmentsForSelectedDateAndClientResponse>.from(json
//             .decode(str)
//             .map((x) =>
//                 ConsignmentsForSelectedDateAndClientResponse.fromMap(x)));
//
// String consignmentsForSelectedDateAndClientResponseToMap(
//         List<ConsignmentsForSelectedDateAndClientResponse> data) =>
//     json.encode(List<dynamic>.from(data.map((x) => x.toMap())));

class ConsignmentsForSelectedDateAndClientResponse {
  ConsignmentsForSelectedDateAndClientResponse({
    this.entryDate,
    this.dropOff,
    this.collect,
    this.payment,
    this.routeTitle,
    this.consigmentId,
    this.routeId,
    this.vehicleId,
  });

  final String routeTitle, entryDate;
  final int consigmentId;
  final int routeId, dropOff, collect;
  final double payment;
  final String vehicleId;

  factory ConsignmentsForSelectedDateAndClientResponse.fromMap(
          Map<String, dynamic> json) =>
      ConsignmentsForSelectedDateAndClientResponse(
        routeTitle: json["routeTitle"],
        consigmentId: json["consigmentId"],
        routeId: json["routeId"],
        vehicleId: json["vehicleId"],
        entryDate: json["entryDate"],
        dropOff: json["dropOff"],
        collect: json["collect"],
        payment: json["payment"],
      );

  Map<String, dynamic> toMap() => {
        "routeTitle": routeTitle,
        "consigmentId": consigmentId,
        "routeId": routeId,
        "vehicleId": vehicleId,
        "entryDate": entryDate,
        "dropOff": dropOff,
        "collect": collect,
        "payment": payment,
      };
}
