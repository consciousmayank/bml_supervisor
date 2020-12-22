import 'package:bml_supervisor/app_level/themes.dart';
import 'package:flutter/material.dart';

class SearchItemView extends StatelessWidget {
  final String titleLabel;
  final String titleValue;
  final Map<String, String> valueList;

  // final List<String> labelList;

  const SearchItemView({
    Key key,
    @required this.titleLabel,
    @required this.titleValue,
    @required this.valueList,
    // @required this.labelList
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: ThemeConfiguration.primaryBackground,
              borderRadius: BorderRadius.all(
                Radius.circular(4),
              ),
            ),
            // width: 400,
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text(
                  titleLabel,
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
                Text(
                  titleValue,
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
              child: GridView.builder(
                  itemCount: valueList.values.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 1.0,
                      mainAxisSpacing: 1.0),
                  itemBuilder: (BuildContext context, int index) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 1,
                          child: label(
                            valueList.keys.elementAt(index),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: value(
                            valueList.values.elementAt(index),
                          ),
                        ),
                      ],
                    );
                  })

              // GridView.count(
              //   // Create a grid with 2 columns. If you change the scrollDirection to
              //   // horizontal, this produces 2 rows.
              //   crossAxisCount: 3,
              //   // Generate 100 widgets that display their index in the List.
              //   children: List.generate(
              //     valueList.length,
              //     (index) {
              //       return Row(
              //         crossAxisAlignment: CrossAxisAlignment.center,
              //         mainAxisSize: MainAxisSize.min,
              //         mainAxisAlignment: MainAxisAlignment.start,
              //         children: [
              //           Expanded(
              //             flex: 1,
              //             child: label(
              //               valueList.keys.elementAt(index),
              //             ),
              //           ),
              //           Expanded(
              //             flex: 1,
              //             child: value(
              //               valueList.values.elementAt(index),
              //             ),
              //           ),
              //         ],
              //       );
              //     },
              //   ),
              // ),

              )
        ],
      ),
    );
  }

  Widget value(String s) {
    return Card(
      color: Colors.grey,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 4,
        ),
        child: Text(
          s,
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  Widget label(String s) {
    return Card(
      // color: Colors.grey,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 4,
        ),
        child: Text(
          s,
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
