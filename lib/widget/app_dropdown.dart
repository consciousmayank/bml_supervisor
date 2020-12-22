import 'package:bml_supervisor/app_level/themes.dart';
import 'package:flutter/material.dart';

class AppDropDown extends StatefulWidget {
  final List<String> optionList;
  final String selectedValue;
  final String hint;
  final Function onOptionSelect;
  final showUnderLine;
  AppDropDown(
      {@required this.optionList,
      this.selectedValue = '',
      @required this.hint,
      @required this.onOptionSelect,
      this.showUnderLine = true});

  @override
  _AppDropDownState createState() => _AppDropDownState();
}

class _AppDropDownState extends State<AppDropDown> {
  List<DropdownMenuItem<Object>> dropdown = [];

  List<DropdownMenuItem<String>> getDropDownItems() {
    List<DropdownMenuItem<String>> dropdown = List<DropdownMenuItem<String>>();

    for (int i = 0; i < widget.optionList.length; i++) {
      dropdown.add(DropdownMenuItem(
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Text(widget.optionList[i],
              style: TextStyle(
                color: Colors.black54,
              )),
        ),
        value: widget.optionList[i],
      ));
    }
    return dropdown;
  }

  @override
  Widget build(BuildContext context) {
    return widget.optionList.isEmpty
        ? Container()
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(widget.hint ?? ""),
              ),
              Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.only(top: 2, bottom: 4),
                  child: DropdownButton(
                    icon: Padding(
                      padding: const EdgeInsets.only(right: 4),
                      child: Icon(
                        Icons.keyboard_arrow_down,
                        color: ThemeConfiguration.primaryBackground,
                      ),
                    ),
                    underline: Container(),
                    isExpanded: true,
                    style: textFieldStyle(
                        fontSize: 15.0, textColor: Colors.black54),
                    // hint: Padding(
                    //   padding: const EdgeInsets.only(left: 20, right: 20),
                    //   child: Text(
                    //     widget.hint,
                    //     style: TextStyle(color: Colors.black26),
                    //   ),
                    // ),
                    value: widget.selectedValue,
                    items: getDropDownItems(),
                    onChanged: (value) {
                      widget.onOptionSelect(value);
                    },
                  ),
                ),
              ),
            ],
          );
  }

  TextStyle textFieldStyle({double fontSize, Color textColor}) {
    return TextStyle(
        color: textColor,
        fontSize: fontSize,
        fontWeight: FontWeight.bold,
        fontStyle: FontStyle.normal);
  }
}
