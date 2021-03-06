import 'package:bml_supervisor/app_level/colors.dart';
import 'package:bml_supervisor/app_level/shared_prefs.dart';
import 'package:bml_supervisor/utils/app_text_styles.dart';
import 'package:bml_supervisor/utils/dimens.dart';
import 'package:bml_supervisor/utils/form_validators.dart';
import 'package:bml_supervisor/utils/stringutils.dart';
import 'package:bml_supervisor/utils/widget_utils.dart';
import 'package:bml_supervisor/widget/app_button.dart';
import 'package:bml_supervisor/widget/app_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stacked/stacked.dart';

import 'add_routes_arguments.dart';
import 'add_routes_viewmodel.dart';

class AddRoutesView extends StatefulWidget {
  final AddRoutesArguments args;

  AddRoutesView({this.args});

  // List<GetDistributorsResponse> newHubsList;
  // AddRoutesView({this.newHubsList});

  @override
  _AddRoutesViewState createState() => _AddRoutesViewState();
}

class _AddRoutesViewState extends State<AddRoutesView> {
  final ScrollController _scrollController = ScrollController();
  TextEditingController routeTitleController = TextEditingController();
  FocusNode routeTitleFocusNode = FocusNode();

  TextEditingController remarkController = TextEditingController();
  FocusNode remarkFocusNode = FocusNode();
  bool checkBoxCheck = false;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<AddRoutesViewModel>.reactive(
        onModelReady: (viewModel) {
          viewModel.getClients();
          // viewModel.newHubsList = widget.args.newHubsList;
          // viewModel.getCities();
        },
        builder: (context, viewModel, child) => Scaffold(
              appBar: AppBar(
                title: setAppBarTitle(title: 'Add Route'),
                centerTitle: true,
              ),
              body: Padding(
                padding: getSidePadding(context: context),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      buildRouteTitleTextFormField(),
                      buildRemarksTextFormField(),
                      buildNextButton(viewModel: viewModel, context: context),
                      // Text('asdf')
                    ],
                  ),
                ),
              ),
            ),
        viewModelBuilder: () => AddRoutesViewModel());
  }

  Widget buildRemarksTextFormField() {
    return appTextFormField(
      maxLines: 3,
      enabled: true,
      textCapitalization: TextCapitalization.words,
      formatter: <TextInputFormatter>[
        TextFieldInputFormatter()
            .alphaNumericWithSpaceSlashHyphenUnderScoreFormatter,
      ],
      controller: remarkController,
      focusNode: remarkFocusNode,
      hintText: addDriverRemarksHint,
      keyboardType: TextInputType.name,
      onTextChange: (String value) {},
      onFieldSubmitted: (_) {
        remarkFocusNode.unfocus();
      },
    );
  }

  Widget buildRouteTitleTextFormField() {
    return appTextFormField(
      enabled: true,
      controller: routeTitleController,
      focusNode: routeTitleFocusNode,
      hintText: addRouteRouteNameHint,
      keyboardType: TextInputType.text,
      onTextChange: (String value) {},
      onFieldSubmitted: (_) {
        fieldFocusChange(context, routeTitleFocusNode, remarkFocusNode);
      },
      validator: (value) {
        if (value.isEmpty) {
          return textRequired;
        } else {
          return null;
        }
      },
    );
  }

  Widget buildNextButton({BuildContext context, AddRoutesViewModel viewModel}) {
    return SizedBox(
      height: buttonHeight,
      child: AppButton(
          fontSize: 14,
          borderRadius: defaultBorder,
          borderColor: AppColors.primaryColorShade1,
          onTap: () {
            if (routeTitleController.text.length > 0) {
              if (routeTitleController.text.length >= 6) {
                viewModel
                    .getHubsForSelectedClient(
                        selectedClient: MyPreferences().getSelectedClient())
                    .then((value) => viewModel.takeToPickHubsPage(
                          remarks: remarkController.text,
                          routeTitle: routeTitleController.text,
                        ));
              } else {
                viewModel.snackBarService.showSnackbar(
                    message:
                        'Please enter route title with at least 6 characters');
              }
            } else {
              viewModel.snackBarService
                  .showSnackbar(message: 'Please enter route title');
            }
          },
          background: AppColors.primaryColorShade5,
          buttonText: 'NEXT'),
    );
  }

  void showHubsList(BuildContext context, AddRoutesViewModel viewModel) {
    showModalBottomSheet(
        backgroundColor: AppColors.appScaffoldColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(defaultBorder),
            topRight: Radius.circular(defaultBorder),
          ),
        ),
        // isScrollControlled: true,
        context: context,
        builder: (_) {
          /// read about it later
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter state) {
            return Container(
              // height: MediaQuery.of(context).size.height,
              child: Column(
                children: [
                  Container(
                    color: AppColors.primaryColorShade5,
                    padding: EdgeInsets.all(15),
                    child: Row(
                      // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Text(
                            ('Hub Id'),
                            textAlign: TextAlign.center,
                            style: AppTextStyles.whiteRegular,
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            ('Title'),
                            textAlign: TextAlign.center,
                            style: AppTextStyles.whiteRegular,
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            ('City'),
                            textAlign: TextAlign.left,
                            style: AppTextStyles.whiteRegular,
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Text(
                            'Action',
                            textAlign: TextAlign.end,
                            style: AppTextStyles.whiteRegular,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView.separated(
                      controller: _scrollController,
                      itemBuilder: (context, index) {
                        return buildHubsList(
                          viewModel: viewModel,
                          index: index,
                          state: state,
                        );
                      },
                      itemCount: viewModel.hubsList.length,
                      separatorBuilder: (BuildContext context, int index) {
                        return Divider(
                          thickness: 1,
                          color: AppColors.primaryColorShade3,
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          });
        });
  }

  Widget buildHubsList(
      {AddRoutesViewModel viewModel, int index, StateSetter state}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(viewModel.hubsList[index].id.toString()),
          Text(viewModel.hubsList[index].title),
          Text(viewModel.hubsList[index].city),
          Checkbox(
            value: viewModel.hubsList[index].isCheck,
            onChanged: (value) {
              state(() {
                viewModel.hubsList[index].isCheck = value;
              });
            },
          ),
          // CheckboxListTile(
          //   // dense: true,
          //   // isThreeLine: false,
          //   secondary:  Text(viewModel.hubsList[index].id.toString()),
          //   contentPadding: EdgeInsets.all(0),
          //   subtitle: Text(viewModel.hubsList[index].title),
          //   title: Text(viewModel.hubsList[index].city),
          //   value: viewModel.hubsList[index].isCheck,
          //   onChanged: (value) {
          //     state(() {
          //       viewModel.hubsList[index].isCheck = value;
          //     });
          //   },
          // ),
        ],
      ),
    );
  }

  Widget buildCreateRouteButton({AddRoutesViewModel viewModel}) {
    return SizedBox(
      height: buttonHeight,
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 4.0),
        child: ElevatedButton(
          child: Text("CREATE"),
          onPressed: () {},
        ),
      ),
    );
  }
}

//
// class CitiesDropDown extends StatefulWidget {
//   final List<CitiesResponse> optionList;
//   final CitiesResponse selectedCity;
//   final String hint;
//   final Function onOptionSelect;
//   final showUnderLine;
//
//   CitiesDropDown(
//       {@required this.optionList,
//       this.selectedCity,
//       @required this.hint,
//       @required this.onOptionSelect,
//       this.showUnderLine = true});
//
//   @override
//   _CitiesDropDownState createState() => _CitiesDropDownState();
// }
//
// class _CitiesDropDownState extends State<CitiesDropDown> {
//   List<DropdownMenuItem<CitiesResponse>> dropdown = [];
//
//   List<DropdownMenuItem<CitiesResponse>> getDropDownItems() {
//     List<DropdownMenuItem<CitiesResponse>> dropdown =
//         <DropdownMenuItem<CitiesResponse>>[];
//
//     for (int i = 0; i < widget.optionList.length; i++) {
//       dropdown.add(DropdownMenuItem(
//         child: Padding(
//           padding: const EdgeInsets.only(left: 20, right: 20),
//           child: Text(
//             "${widget.optionList[i].city}",
//             style: TextStyle(
//               color: Colors.black54,
//             ),
//           ),
//         ),
//         value: widget.optionList[i],
//       ));
//     }
//     return dropdown;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return widget.optionList.isEmpty
//         ? Container()
//         : Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             mainAxisAlignment: MainAxisAlignment.start,
//             children: [
//               Padding(
//                 padding: const EdgeInsets.only(left: 8, right: 8),
//                 child: Text(widget.hint ?? ""),
//               ),
//               Card(
//                 elevation: 2,
//                 child: Padding(
//                   padding: const EdgeInsets.only(top: 2, bottom: 2),
//                   child: DropdownButton(
//                     icon: Padding(
//                       padding: const EdgeInsets.only(right: 4),
//                       child: Icon(
//                         Icons.keyboard_arrow_down,
//                         color: ThemeConfiguration.primaryBackground,
//                       ),
//                     ),
//                     underline: Container(),
//                     isExpanded: true,
//                     style: textFieldStyle(
//                         fontSize: 15.0, textColor: Colors.black54),
//                     value: widget.selectedCity,
//                     items: getDropDownItems(),
//                     onChanged: (value) {
//                       widget.onOptionSelect(value);
//                     },
//                   ),
//                 ),
//               ),
//             ],
//           );
//   }
//
//   TextStyle textFieldStyle({double fontSize, Color textColor}) {
//     return TextStyle(
//         color: textColor,
//         fontSize: fontSize,
//         fontWeight: FontWeight.bold,
//         fontStyle: FontStyle.normal);
//   }
// }
