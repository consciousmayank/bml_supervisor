import 'dart:convert';

GetClientsResponse getClientsResponseFromJson(String str) =>
    GetClientsResponse.fromJson(json.decode(str));

String getClientsResponseToJson(GetClientsResponse data) =>
    json.encode(data.toJson());

class GetClientsResponse {
  GetClientsResponse({
    this.clientId,
    this.title,
    this.vehicleId,
  });

  String clientId;
  String title;
  String vehicleId;

  factory GetClientsResponse.fromJson(String str) =>
      GetClientsResponse.fromMap(json.decode(str));

  factory GetClientsResponse.fromMap(Map<dynamic, dynamic> json) =>
      GetClientsResponse(
        clientId: json["clientId"],
        title: json["title"],
        vehicleId: json["vehicleId"],
      );

  Map<dynamic, dynamic> toJson() => {
        "clientId": clientId,
        "title": title,
        "vehicleId": vehicleId,
      };
}
