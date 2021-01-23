import 'dart:convert';

GetClientsResponse getClientsResponseFromJson(String str) =>
    GetClientsResponse.fromJson(json.decode(str));

String getClientsResponseToJson(GetClientsResponse data) =>
    json.encode(data.toJson());

class GetClientsResponse {
  GetClientsResponse({
    this.id,
    this.title,
    this.vehicleId,
  });

  int id;
  String title;
  String vehicleId;

  factory GetClientsResponse.fromJson(String str) =>
      GetClientsResponse.fromMap(json.decode(str));

  factory GetClientsResponse.fromMap(Map<dynamic, dynamic> json) =>
      GetClientsResponse(
        id: json["id"],
        title: json["title"],
        vehicleId: json["vehicleId"],
      );

  Map<dynamic, dynamic> toJson() => {
        "id": id,
        "title": title,
        "vehicleId": vehicleId,
      };
}
