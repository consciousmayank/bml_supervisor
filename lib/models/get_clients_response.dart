import 'dart:convert';

GetClientsResponse getClientsResponseFromJson(String str) =>
    GetClientsResponse.fromJson(json.decode(str));

String getClientsResponseToJson(GetClientsResponse data) =>
    json.encode(data.toJson());

class GetClientsResponse {
  GetClientsResponse({
    this.id,
    this.title,
  });

  int id;
  String title;

  factory GetClientsResponse.fromJson(String str) =>
      GetClientsResponse.fromMap(json.decode(str));

  factory GetClientsResponse.fromMap(Map<String, dynamic> json) =>
      GetClientsResponse(
        id: json["id"],
        title: json["title"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
      };
}
