import 'package:bezier_chart/bezier_chart.dart';
import 'package:bml_supervisor/app_level/generalised_base_view_model.dart';
import 'package:bml_supervisor/models/routes_driven_km.dart';
import 'package:bml_supervisor/utils/widget_utils.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class LineChartViewModel extends GeneralisedBaseViewModel {
  List<RoutesDrivenKm> routesDrivenKmList = [];
  List uniqueRoutes = [];
  List<DateTime> uniqueDates = [];
  List<List<RoutesDrivenKm>> data = [];
  List<charts.Series<RoutesDrivenKm, int>> seriesLineData = [];
  List<BezierLine> bezierLineList = [];

  List<Color> lineChartColorArray = [
    Color(0xff68cfc6),
    Color(0xffd89cb8),
    Color(0xfffcce5e),
    Color(0xfffc8685),
    Color(0xffaa66cc),
    Color(0xff28a745),
    Color(0xffc3e6cb),
    Color(0xffdc3545),
  ];

  void getRoutesDrivenKm({
    int clientId,
    String selectedDuration,
  }) async {
    //line chart/graph api
    routesDrivenKmList.clear();

    int selectedDurationValue = selectedDuration == 'THIS MONTH' ? 1 : 2;

    setBusy(true);
    notifyListeners();
    try {
      var res = await apiService.getRoutesDrivenKm(
        clientId: clientId,
        period: selectedDurationValue,
      );
      if (res.data is List) {
        var list = res.data as List;
        int colorArrayIndex = 0;
        if (list.length > 0) {
          for (Map value in list) {
            RoutesDrivenKm routesDrivenKmResponse =
                RoutesDrivenKm.fromJson(value);
            routesDrivenKmList.add(routesDrivenKmResponse);
          }
          // add distinct routes and dates to uniqueRoutes and uniqueDates
          routesDrivenKmList.forEach(
            (routesDrivenKmObject) {
              if (!uniqueRoutes.contains(routesDrivenKmObject.routeId)) {
                uniqueRoutes.add(routesDrivenKmObject.routeId);
              }
              if (!uniqueDates.contains(routesDrivenKmObject.entryDate)) {
                uniqueDates.add(routesDrivenKmObject.entryDateTime);
              }
            },
          );

          // for (int r = 0; r < uniqueRoutes.length; r++) {
          //   int flag = 0;
          //   for (int d = 0; d < uniqueDates.length; d++) {
          //     for (int i = 0; i < routesDrivenKmList.length; i++) {
          //       if (!(routesDrivenKmList[i].routeId == uniqueRoutes[r] &&
          //           routesDrivenKmList[i].entryDate == uniqueDates[d])) {
          //         routesDrivenKmList.add(RoutesDrivenKm(
          //           drivenKm: 0,
          //           entryDate: uniqueDates[d],
          //           routeId: uniqueRoutes[r],
          //         ));
          //         // flag = 1;
          //         // break;
          //       }
          //       // else {
          //       //   flag = 0;
          //       //   print('missing object ${routesDrivenKmList[i]}');
          //       // }
          //     }
          //     // if (flag == 0) {
          //     //   print('********************************************');
          //     //   print('date missing: ${uniqueDates[d]}');
          //     //   print('route missing: ${uniqueRoutes[r]}');
          //     //   print('********************************************');
          //     //   // routesDrivenKmList.add(RoutesDrivenKm(
          //     //   //   drivenKm: 0,
          //     //   //   entryDate: uniqueDates[d],
          //     //   //   routeId: uniqueRoutes[r],
          //     //   // ));
          //     // }
          //   }
          // }
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%% WORKING %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%//
//           for (int r = 0; r < uniqueRoutes.length; r++) {
//             int flag = 0;
//             for (int d = 0; d < uniqueDates.length; d++) {
//               for (int i = 0; i < routesDrivenKmList.length; i++) {
//                 if (routesDrivenKmList[i].routeId == uniqueRoutes[r] &&
//                     routesDrivenKmList[i].entryDate == uniqueDates[d]) {
//                   flag = 1;
//                   break;
//                 } else {
//                   flag = 0;
//                 }
//               }
//               if (flag == 0) {
//                 print('********************************************');
//                 print('date missing: ${uniqueDates[d]}');
//                 print('route missing: ${uniqueRoutes[r]}');
//                 print('********************************************');
//                 routesDrivenKmList.add(RoutesDrivenKm(
//                   drivenKm: 0,
//                   entryDate: getDateString(uniqueDates[d]),
//                   routeId: uniqueRoutes[r],
//                 ));
//               }
//             }
//           }
//
//           routesDrivenKmList
//               .sort((a, b) => a.entryDateTime.compareTo(b.entryDateTime));
//%%%%%%%%%%%%%%%%%%%%%%%%%%% WORKING %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%//


          uniqueRoutes.forEach(
            (singleRouteElement) {
              data.add(
                routesDrivenKmList
                    .where((routeDrivenKmObject) =>
                        routeDrivenKmObject.routeId == singleRouteElement)
                    .toList(),
              );
            },
          );

          // print('routes length ${uniqueRoutes.length}');
          // print('data length ${data.length}');

          // ! For printing line chart data, coming from api
          // int i = 1;
          // print('data length: ${routesDrivenKmList.length}');
          // data.forEach((element) {
          //   print('*****************Route R $i**********************');
          //
          //   //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%//
          //   // for(int i)
          //   //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%//
          //   print('nested list size - ${element.length}');
          //   print('no. of dates - ${uniqueDates.length}');
          //   // element.forEach((element2) {
          //   //   print("route id :: ${element2.routeId.toString()}");
          //   //   print("driven km :: ${element2.drivenKm.toString()}");
          //   //   print("Entry Date :: ${element2.entryDate.toString()}");
          //   // });
          //   print('*****************************************************');
          //   i++;
          // });

          // data.forEach((singleDataElement) {
          //   uniqueDates.forEach((singleDateElement) {
          //
          //     List datesNotInRoutes = singleDataElement.where((element) => element.entryDate == singleDateElement).toList();
          //     List<RoutesDrivenKm> tempList =[];
          //     datesNotInRoutes.forEach((element) {
          //       tempList.add(RoutesDrivenKm(drivenKm: 0, drivenKmG: 0, routeId: singleDataElement.first.routeId, vehicleId: "", title: "", entryDate: element.entryDate),);
          //     });
          //     singleDataElement.addAll(tempList);
          //   });
          // });

          // data.forEach((singleLineData) {
          //   seriesLineData.add(
          //     charts.Series(
          //       domainFn: (RoutesDrivenKm sales, _) =>
          //           int.parse(sales.entryDate.split('-')[0]),
          //       measureFn: (RoutesDrivenKm sales, _) => sales.drivenKm,
          //       id: 'Line chart',
          //       colorFn: (__, _) => charts.ColorUtil.fromDartColor(
          //           lineChartColorArray[data.indexOf(singleLineData)]),
          //       data: singleLineData,
          //     ),
          //   );
          // });
        }
      }
    } on DioError catch (e) {
      snackBarService.showSnackbar(message: e.message);
      setBusy(false);
    }
    notifyListeners();
    setBusy(false);
  }

  getBezierData() {

    data.forEach((singleLineData) {
      List<DataPoint<DateTime>> dataList = [];
      print("Colors :: ${data.indexOf(singleLineData)}");
      singleLineData.forEach((element) {
        dataList.add(DataPoint<DateTime>(
            value: element.drivenKm.toDouble(), xAxis: element.entryDateTime));
      });

      bezierLineList.add(
          BezierLine(
            lineColor: lineChartColorArray[data.indexOf(singleLineData)],
            label: "Route# ${data.indexOf(singleLineData)}",
            onMissingValue: (dateTime) {
              return 0;
            },
            data: dataList,
          )
      );

    });

    return bezierLineList;
  }
}

// class UniqueRoutes{
//   final int routeId;
//   final String entryDate;
//
//   UniqueRoutes(this.routeId, this.entryDate);
// }
