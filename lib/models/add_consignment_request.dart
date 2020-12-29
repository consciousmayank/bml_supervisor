import 'dart:convert';

class AddConsignmentRequest {
  AddConsignmentRequest({
    this.routeId,
    this.hubId,
    this.entryDate,
    this.title,
    this.dropOff,
    this.collect,
    this.payment,
    this.tag,
  });

  final int routeId;
  final int hubId;
  final String entryDate;
  final String title;
  final int dropOff;
  final int collect;
  final double payment;
  final int tag;

  AddConsignmentRequest copyWith({
    int routeId,
    int hubId,
    String entryDate,
    String title,
    int dropOff,
    int collect,
    int payment,
    int tag,
  }) =>
      AddConsignmentRequest(
        routeId: routeId ?? this.routeId,
        hubId: hubId ?? this.hubId,
        entryDate: entryDate ?? this.entryDate,
        title: title ?? this.title,
        dropOff: dropOff ?? this.dropOff,
        collect: collect ?? this.collect,
        payment: payment ?? this.payment,
        tag: tag ?? this.tag,
      );

  factory AddConsignmentRequest.fromJson(String str) =>
      AddConsignmentRequest.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory AddConsignmentRequest.fromMap(Map<String, dynamic> json) =>
      AddConsignmentRequest(
        routeId: json["routeId"],
        hubId: json["hubId"],
        entryDate: json["entryDate"],
        title: json["title"],
        dropOff: json["dropOff"],
        collect: json["collect"],
        payment: json["payment"],
        tag: json["tag"],
      );

  Map<String, dynamic> toMap() => {
        "routeId": routeId,
        "hubId": hubId,
        "entryDate": entryDate,
        "title": title,
        "dropOff": dropOff,
        "collect": collect,
        "payment": payment,
        "tag": tag,
      };
}
