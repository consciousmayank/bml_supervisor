import 'dart:convert';

class RoutesForSelectedClientAndDateResponse {
  RoutesForSelectedClientAndDateResponse({
    this.routeId,
    this.routeName,
  });

  final int routeId;
  final String routeName;

  RoutesForSelectedClientAndDateResponse copyWith({
    int routeId,
    String routeName,
  }) =>
      RoutesForSelectedClientAndDateResponse(
        routeId: routeId ?? this.routeId,
        routeName: routeName ?? this.routeName,
      );

  factory RoutesForSelectedClientAndDateResponse.fromJson(String str) =>
      RoutesForSelectedClientAndDateResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory RoutesForSelectedClientAndDateResponse.fromMap(
          Map<String, dynamic> json) =>
      RoutesForSelectedClientAndDateResponse(
        routeId: json["routeId"],
        routeName: json["routeName"],
      );

  Map<String, dynamic> toMap() => {
        "routeId": routeId,
        "routeName": routeName,
      };
}
